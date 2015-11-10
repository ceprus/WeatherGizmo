//
//  PrimaryController.m
//  WeatherGizmo
//
//  Created by Sergey Sergeyev on 04.10.15.
//  Copyright (c) 2015 rsbw. All rights reserved.
//

#import "PrimaryController.h"

// Controller
#import "BaseViewController.h"
#import "OptionsViewController.h"

// Model
#import "WGConfig.h"
#import "WGWeatherMap.h"
#import "WGIconFactory.h"
#import "WGLocationManager.h"


/// 10 мин
static CGFloat const kWeatherUpdateInterval = 600.0;
static CGFloat const kWeatherRequestInterval = 15.0;

@interface PrimaryController () 
{
    NSTimer *_timeTimer;
    NSTimer *_weatherTimer;
    BOOL isConnection;
    NSInteger updateInterval;
    
    // View
    NSStoryboard *_mainStoryboard;
    
    // Controller
    MainWindowController *_mainWindowController;
    OptionsWindowController *_optionsWindowController;
    
    // Model
    WGConfig *_config;
    WGWeatherMap *_weatherMap;
    WGIconFactory *_iconFactory;
    WGLocationManager *_locationManager;
    
    // Entities
    LocationEntity *_location;
}

@end





@implementation PrimaryController


- (instancetype)init {
    self = [super init];
    if (self)
    {
        _timeTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target: self selector: @selector(wg_tickTimeTimer) userInfo: nil repeats: YES];
        _weatherTimer = [NSTimer scheduledTimerWithTimeInterval: kWeatherRequestInterval target: self selector: @selector(wg_tickWeatherTimer) userInfo: nil repeats: YES];
        
        // View
        _mainStoryboard = [NSStoryboard storyboardWithName: @"Main" bundle: nil];
        
        // Controller
        _mainWindowController = [_mainStoryboard instantiateControllerWithIdentifier: @"MainWindow"];
        _optionsWindowController = [_mainStoryboard instantiateControllerWithIdentifier: @"OptionsWindow"];
        
        // Model
        _config = [[WGConfig alloc] init];
        _weatherMap = [[WGWeatherMap alloc] init];
        _iconFactory = [[WGIconFactory alloc] init];
        _locationManager = [[WGLocationManager alloc] init];
        
        if (!(_mainStoryboard && _mainWindowController && _optionsWindowController)) {
            [NSException raise:@"ErrorPrimaryController" format:@"PrimaryController not initialized in %s", __func__ ];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(wg_applicationWillTeminate:)
                                                     name: NSApplicationWillTerminateNotification
                                                   object: [NSApplication sharedApplication]];
    
    }
    return self;
}



// Saving window position before exit
- (void)wg_applicationWillTeminate:(NSNotification *)notification
{
    _config.posX = @(_mainWindowController.window.frame.origin.x);
    _config.posY = @(_mainWindowController.window.frame.origin.y);
}



#pragma mark - Public:

- (void)showMainWindow
{
    WGSkinStyle skinStyle = [[_config skinStyle] integerValue];
    WGViewDetails viewDetails = [[_config viewDetails] integerValue];
    WGWindowLevel windowLevel = [[_config windowLevel] integerValue];
    CGFloat transparency = [[_config transparency] floatValue];

    [_mainWindowController showWindowWithSkin: skinStyle
                                  viewDetails: viewDetails
                                  windowLevel: windowLevel
                                   alphaValue: transparency
                                andController: self];
    
    [self wg_getLocationAndUpdateWeatherInfo];
      
}


- (void)showOptionsWindow {
    [_optionsWindowController showWindow: self];
}



#pragma mark - Private:

- (void)wg_updateWeather {
    if (_location) {
        [self wg_updateWeatherInfoWithLocation: _location];
    } else {
        [self wg_getLocationAndUpdateWeatherInfo];
    }    
}


- (void)wg_tickTimeTimer {
    WGTimeFormat timeFormat = [[_config timeFormat] integerValue];
    #warning binding to current timezone!!!
    [_mainWindowController.viewController updateDateTime: [NSDate date] withFormat: timeFormat];
}

- (void)wg_tickWeatherTimer {
    
    if (isConnection) {
        updateInterval += kWeatherRequestInterval;
        if (updateInterval < kWeatherUpdateInterval)
            return;
    }
    
    updateInterval = 0;
    [self wg_updateWeather];
}



// Получаем Location из настроек или по текущему ip-адресу
// и вызываем функцию обновления данных о погоде
- (void)wg_getLocationAndUpdateWeatherInfo
{
    // Общий блок для callback'a LocationManager'a
    void (^myResultBlock)() = ^(LocationEntity *location, NSError *error) {
        if (error) {
            [self wg_errorHandler: error];
        } else {
            _location = location;
            [self wg_updateWeatherInfoWithLocation: location]; // Success
        }
    };
    
    long cityId = [[_config locationId] longValue];
    
    if (cityId != 0) {
        [_locationManager getLocationById: cityId withResultBlock: myResultBlock];
    } else {
        [_locationManager getCurrentLocationWithResultBlock: myResultBlock];
    }
}




// Запрос погоды через WGWeatherMap объект и отображение результата на view
- (void)wg_updateWeatherInfoWithLocation:(LocationEntity *)location
{
    // Reset request interval to default
    isConnection = YES;
    
    
    NSDictionary *lc = [self wg_dictionaryFromLocationEntity: location];
    [_mainWindowController.viewController updateLocation: lc];
    
    WGWeatherFormat wformat = [[_config weatherFormat] integerValue];
    
    // Погода на сегодня
    [_weatherMap getTodayWeatherForLocation: location withResultBlock:^(WeatherEntity *weather, NSError *error) {
        if (error) {
            [self wg_errorHandler: error];
        } else {
            
            NSDictionary *wg = [self wg_dictionaryFromWeatherEntity: weather];
            [_mainWindowController.viewController updateWeatherToday: wg withFormat: wformat];
            
            // Ежели нет cityId то получаем его из WeatherEntity
            if (location.cityId == 0 && weather.cityId > 0) {
                if (_config.locationId == 0) {
                    _config.locationId = @(weather.cityId);
                    _location = nil;                    
                }
            }
        }
    }];
    
    
    WGViewDetails viewDetails = [[_config viewDetails] integerValue];
    
    if (viewDetails == WGViewDetailsFull) {
        
        // Детальные прогнозы погоды
        [_weatherMap getForecastWeatherForLocation: location withResultBlock:^(NSArray *weathers, NSError *error) {
            if (error) {
                [self wg_errorHandler: error];
            } else {
                
                NSMutableArray *forecasts = [NSMutableArray new];
                NSCalendar *cal = [NSCalendar currentCalendar];
                //[cal setTimeZone: [NSTimeZone timeZoneWithName:@"UTC"]];
                #warning binding to current timezone!!!
                NSInteger today = [[cal components: NSCalendarUnitDay fromDate: [NSDate date]] day];
                NSInteger prevday = 0;
                
                NSInteger loc = 0;
                NSInteger len = 0;
                
                for (WeatherEntity *weather in weathers) {
                    
                    NSInteger day = [[cal components: NSCalendarUnitDay fromDate: weather.datetime] day];
                    
                    if (day == prevday) {
                        
                        len++;
                        
                    } else {
                        
                        if (prevday != today && day != today) {
                            NSRange range = NSMakeRange(loc, len);
                            NSDictionary *df = [self wg_dictionaryWithOneDayWeatherForecast: [weathers subarrayWithRange: range]];
                            [forecasts addObject: df];
                        }
                        
                        loc+=len;
                        len = 1;
                    }

                    prevday = day;
                }
                
                //if (forecasts.count > 3) {
                    [_mainWindowController.viewController updateWeatherFarecast: [forecasts copy] withFormat: wformat];
                //} else {
                //    NSLog(@"Error!!! Array forecast contains objects count < 4 (%s)\n%@", __func__, forecasts);
                //}
            }
        }];
    }
}



- (void)wg_errorHandler:(NSError *)error
{
    
    switch (error.code) {
        case NSURLErrorNotConnectedToInternet: //-1009
        case kCFURLErrorTimedOut: //-1001
            
            [_mainWindowController.viewController resetViewToDefaults: YES];
            
            // Set check more frequently
            isConnection = NO;
            return;

        case WGLocationManagerErrorEmptyOrNilData: //-77791
        case WGWeatherMapErrorNotFoundCity: //-4461
        case NSURLErrorCannotFindHost: //-1003
        case NSURLErrorBadServerResponse: //-1011 (not found (404))
        case NSURLErrorCancelled: //-999
        default:
            //
            break;
    }
    
    NSLog(@"Central Error Handler (CODE %ld)\n%@\n\n", error.code, error);
    
}



#pragma mark - Convertion:


// Weather today. Format for view
- (NSDictionary *)wg_dictionaryFromWeatherEntity:(WeatherEntity *)weather
{
    #warning fix this!!!
    WGWeatherIconStyle iconStyle = WGWeatherIconStyleGray;

    return @{@"date": weather.datetime,
             @"text": weather.text,
             @"icon": [_iconFactory imageWithWeatherId: weather.weatherId
                                              withDate: weather.datetime
                                              andStyle: iconStyle],
             @"d_temp": @(weather.temperature),
             @"n_temp": @(-9999) // unnecessary
             };
}


// Weather forecast for one day to View formatted dictionary
- (NSDictionary *)wg_dictionaryWithOneDayWeatherForecast:(NSArray *)forecasts
{
    #warning fix this!!!
    WGWeatherIconStyle iconStyle = WGWeatherIconStyleGray;
    NSCalendar *cal = [NSCalendar currentCalendar];

    NSDate *dayDate = [NSDate date];
    CGFloat dayTemp = FLT_MIN;
    CGFloat nightTemp = FLT_MAX;
    long weatherId = WGWeatherIconSkyIsClear;
    
    for (WeatherEntity *weather in forecasts) {
        
        
        NSInteger hour = [[cal components: NSCalendarUnitHour fromDate: weather.datetime] hour];
        if (hour < 9) { // Night
            
            if (weather.temperature < nightTemp) nightTemp = weather.temperature;
            
        } else { // Is day
            
            if (weather.temperature > dayTemp) dayTemp = weather.temperature;
            if (weather.weatherId != WGWeatherIconSkyIsClear) weatherId = weather.weatherId;
            if (hour > 6 && hour < 22) dayDate = weather.datetime; // Only daytime
        }
        
        
    }
    
#warning Delete this
    if (dayDate == nil) {
        NSLog(@"ERROR!!! Date is nil (%s)", __func__);
        dayDate = [NSDate date]; // Crunch!
    }
    
    NSImage *icon = [_iconFactory imageWithWeatherId: weatherId withDate: dayDate andStyle: iconStyle];
    
    return @{@"date": dayDate,
             @"text": @"foo", // unnecessary
             @"icon": icon,
             @"d_temp": @(dayTemp),
             @"n_temp": @(nightTemp)
             };
}


// To separate models and views
- (NSDictionary *)wg_dictionaryFromLocationEntity:(LocationEntity *)location {
    
    return @{@"city": location.city,
             @"country": location.country
             };
}



#pragma mark - WGOptionsWindowProtocol:

- (void)findLocationsByStringWithCallback:(NSString *)text;
{
    _locationManager.stopFind = YES;
    
    [_locationManager getLocationByName: text withResultBlock:^(NSArray *locations, NSError *error) {
        
        NSMutableArray *locs = [NSMutableArray new];
        
        for (LocationEntity *location in locations) {
            [locs addObject: @{@"cityId":    @(location.cityId),
                               @"city":      location.city,
                               @"country":   location.country,
                               @"latitude":  @(location.latitude),
                               @"longitude": @(location.longitude)
                               }];
        }
        
        [_optionsWindowController.viewController updateLocationsList: [locs copy]];
        
    }];
}


@end



#pragma mark - Options category:

/**
 * Category wrapper for settings
 */
@implementation PrimaryController (Options)

- (NSString *)cityName {
    return _config.cityName;
}

- (NSNumber *)viewDetails {
    return _config.viewDetails;
}

- (NSNumber *)locationId {
    return _config.locationId;
}

- (NSNumber *)timeFormat {
    return _config.timeFormat;
}

- (NSNumber *)weatherFormat {
    return _config.weatherFormat;
}

- (NSNumber *)transparency {
    return _config.transparency;
}

- (NSNumber *)windowLevel {
    return _config.windowLevel;
}

- (NSNumber *)skinStyle {
    return _config.skinStyle;
}

- (NSNumber *)posX {
    return _config.posX;
}

- (NSNumber *)posY {
    return _config.posY;
}


// Setters:

- (void)setCityName:(NSString *)cityName {
    _config.cityName = cityName;
}

- (void)setViewDetails:(NSNumber *)viewDetails {
    _config.viewDetails = viewDetails;
    if ([viewDetails integerValue] == WGViewDetailsFull) {
        [self wg_getLocationAndUpdateWeatherInfo];
    } else {
        [_mainWindowController.viewController resetViewToDefaults: NO];
    }
}

- (void)setLocationId:(NSNumber *)locationId {
    _config.locationId = locationId;
    [self wg_getLocationAndUpdateWeatherInfo];
}

- (void)setTimeFormat:(NSNumber *)timeFormat {
    _config.timeFormat = timeFormat;
    [self wg_tickTimeTimer];
}

- (void)setWeatherFormat:(NSNumber *)weatherFormat {
    _config.weatherFormat = weatherFormat;
    [self wg_updateWeather];
}

- (void)setTransparency:(NSNumber *)transparency {
    _mainWindowController.window.alphaValue = 1.0 - [transparency doubleValue];
    _config.transparency = transparency;
}

- (void)setWindowLevel:(NSNumber *)windowLevel {
    _mainWindowController.windowLevel = [windowLevel integerValue];
    _config.windowLevel = windowLevel;
}

-(void)setSkinStyle:(NSNumber *)skinStyle {
    _config.skinStyle = skinStyle;
}

- (void)setPosX:(NSNumber *)x {
    _config.posX = x;
}

- (void)setPosY:(NSNumber *)y {
    _config.posY = y;
}

@end






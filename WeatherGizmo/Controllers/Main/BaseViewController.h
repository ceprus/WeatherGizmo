//
//  InterfaceController.h
//  WeatherGizmo
//
//  Created by Sergey Sergeyev on 30.10.15.
//  Copyright (c) 2015 rsbw. All rights reserved.
//

#import "MainWindowController.h"
#import "NSTextField+Animation.h"
#import "WGOptionsProtocol.h" // +/-


@protocol WGBaseViewController
@required

/**
 * Return size of view for viewDetails
 */
- (NSSize)sizeFromViewDetails:(WGViewDetails)viewDetails;

/**
 * Set default values to all elements on view or only forecast block
 */
- (void)resetViewToDefaults:(BOOL)all;

/**
 * Show date and time with format
 */
- (void)updateDateTime:(NSDate *)datetime withFormat:(WGTimeFormat)format;

/**
 * Show current location label with NSDictionary format:
 * "city": NSString,
 * "country": NSString
 */
- (void)updateLocation:(NSDictionary *)location;

/**
 * Show weather today with NSDictionary format:
 * "date": NSDate,
 * "text": NSString,
 * "icon": NSImage,
 * "d_temp": NSNumber,
 * "n_temp": NSNumber (unnecessary)
 */
- (void)updateWeatherToday:(NSDictionary *)weather withFormat:(WGWeatherFormat)format;

/**
 * Show weather forecast with array NSDictionary's:
 * "date": NSDate,
 * "text": NSString (unnecessary),
 * "icon": NSImage,
 * "d_temp": NSNumber,
 * "n_temp": NSNumber
 */
- (void)updateWeatherFarecast:(NSArray *)weathers withFormat:(WGWeatherFormat)format;


@end




/**
 * Parent class for ViewController's. Сontains Common Logic
 */
@interface BaseViewController : NSViewController <WGBaseViewController>

@property (weak) IBOutlet NSButton *buttonMenu;

// Date Time
@property (weak) IBOutlet NSTextField *labelTime;
@property (weak) IBOutlet NSTextField *labelAmPm;

// City
@property (weak) IBOutlet NSTextField *labelCityCountry;

// Today weather
@property (weak) IBOutlet NSTextField *labelTemperature;
@property (weak) IBOutlet NSTextField *labelWeatherText;

// Progress
@property (weak) IBOutlet NSProgressIndicator *progressLoading;

// Forecast
@property (weak) IBOutlet NSTextField *labelWeekday1;
@property (weak) IBOutlet NSTextField *labelWeekday2;
@property (weak) IBOutlet NSTextField *labelWeekday3;
@property (weak) IBOutlet NSTextField *labelWeekday4;

@property (weak) IBOutlet NSImageView *imageForecast1;
@property (weak) IBOutlet NSImageView *imageForecast2;
@property (weak) IBOutlet NSImageView *imageForecast3;
@property (weak) IBOutlet NSImageView *imageForecast4;

@property (weak) IBOutlet NSTextField *labelTempDay1;
@property (weak) IBOutlet NSTextField *labelTempDay2;
@property (weak) IBOutlet NSTextField *labelTempDay3;
@property (weak) IBOutlet NSTextField *labelTempDay4;

@property (weak) IBOutlet NSTextField *labelTempNight1;
@property (weak) IBOutlet NSTextField *labelTempNight2;
@property (weak) IBOutlet NSTextField *labelTempNight3;
@property (weak) IBOutlet NSTextField *labelTempNight4;

// Link to window controller
@property (weak, nonatomic, readonly) MainWindowController *windowController;

/**
 * Convert temperature of kelvin value to cesius or farenheit (WGWeatherFormat)
 */
- (CGFloat)convertTemperature:(CGFloat)temp toFormat:(WGWeatherFormat)format;

@end

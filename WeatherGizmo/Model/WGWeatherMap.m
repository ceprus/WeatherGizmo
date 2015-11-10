//
//  WGWeatherMap.m
//  WeatherGizmo
//
//  Created by Sergey Sergeyev on 17.10.15.
//  Copyright (c) 2015 rsbw. All rights reserved.
//

#import "WGWeatherMap.h"
#import "AFNetworking.h"
#import "WGLocationManager.h"


typedef NS_ENUM(NSInteger, WGWeatherMapRequest) {
    WGWeatherNow = 0,
    WGWeatherForecast = 1
};

// Public
NSString *const WGWeatherMapErrorDomain = @"WGWeatherMapErrorDomain";

// Private
static NSString *const kOpenWeatherMapApiKey = @"2b5571aa99907b945a086cd1d171b921";
static NSString *const kOpenWeatherMapBaseUrl = @"http://api.openweathermap.org/data/2.5/";


@implementation WGWeatherMap


- (void)wg_weatherWithLocation:(LocationEntity *)location andType:(WGWeatherMapRequest)type andResultBlock:(void (^)())block {
    
    NSMutableString *requestString = [NSMutableString stringWithString: kOpenWeatherMapBaseUrl];
    
    NSArray *pages = @[@"weather", @"forecast"];
    [requestString appendFormat: @"%@?", pages[type]];
    
    if (location.cityId > 0) {
        [requestString appendFormat: @"id=%ld", location.cityId];
    } else {
        [requestString appendFormat: @"lat=%f&lon=%f", location.latitude, location.longitude];
    }
    
    if (kOpenWeatherMapApiKey) {
        [requestString appendFormat: @"&APPID=%@", kOpenWeatherMapApiKey];
    }
    

    NSURL *destinationUrl = [NSURL URLWithString: requestString];
    NSURLRequest *request = [NSURLRequest requestWithURL: destinationUrl];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest: request];
    
    [op setResponseSerializer: [AFJSONResponseSerializer serializer]];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"RESPONSE: %@", responseObject);
        
        NSError *err;
        NSArray *forecasts;
        WeatherEntity *weather;
        NSMutableArray *weathers;
        NSString *msg;
        
        // Error checking
        int code = [responseObject[@"cod"] intValue];
        switch (code) {
            case 404: // CityId not found
                msg = responseObject[@"message"];
                err = [NSError errorWithDomain: WGWeatherMapErrorDomain code: WGWeatherMapErrorNotFoundCity
                                      userInfo: @{@"message": msg ? msg : @"Unknown error"}];
                block(nil, err);
                return; // Exit
        }

        
        switch (type) {
            case WGWeatherNow:
                
                weather = [[WeatherEntity alloc] initWithJson: responseObject];
                block(weather, err);
                break;
                
            case WGWeatherForecast:
                
                weathers = [NSMutableArray new];
                forecasts = ((NSDictionary *)responseObject)[@"list"];
                
                for (NSDictionary *fc in forecasts) {
                    weather = [[WeatherEntity alloc] initWithJson: fc];
                    [weathers addObject: weather];
                }
                
                if (forecasts.count < 32) {
                    err = [NSError errorWithDomain: WGWeatherMapErrorDomain code: WGWeatherMapErrorForecastCount userInfo:@{@"info": @"Forecast count must be >= 32",
                                                                                                                    @"Forecast_count": @(forecasts.count)}];
                }
                
                block([NSArray arrayWithArray: weathers], err);
                break;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        block(nil, error);
        
    }];
    
    [[NSOperationQueue mainQueue] addOperation: op];
}


- (void)getTodayWeatherForLocation:(LocationEntity *)location withResultBlock:(WGWeatherMapTodayBlock)block
{
    [self wg_weatherWithLocation: location andType: WGWeatherNow andResultBlock: [block copy]];
}


- (void)getForecastWeatherForLocation:(LocationEntity *)location withResultBlock:(WGWeatherMapForecastBlock)block
{
    [self wg_weatherWithLocation: location andType: WGWeatherForecast andResultBlock: [block copy]];
}


@end

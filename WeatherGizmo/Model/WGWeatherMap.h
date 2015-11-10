//
//  WGWeatherMap.h
//  WeatherGizmo
//
//  Created by Sergey Sergeyev on 17.10.15.
//  Copyright (c) 2015 rsbw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherEntity.h"
#import "LocationEntity.h"

/// Result handler WeatherEntity
typedef void (^WGWeatherMapTodayBlock)(WeatherEntity *weather, NSError *error);

/// Result handler array of WeatherEntity objects
typedef void (^WGWeatherMapForecastBlock)(NSArray *weathers, NSError *error);

/// Enumeration all errors of WGWeatherMap object
typedef NS_ENUM(NSInteger, WGWeatherMapError) {
    /// Returned when the server not found city (id)
    WGWeatherMapErrorNotFoundCity = -4461,
    WGWeatherMapErrorForecastCount = -6545
};

/// WGWeatherMap object
extern NSString *const WGWeatherMapErrorDomain;


@interface WGWeatherMap : NSObject

/**
 * Weather now transfer to block
 */
- (void)getTodayWeatherForLocation:(LocationEntity *)location withResultBlock:(WGWeatherMapTodayBlock)block;

/**
 Weather forecast transfer to block
 @param weathers contains a array of WeaterEntity
 */
- (void)getForecastWeatherForLocation:(LocationEntity *)location withResultBlock:(WGWeatherMapForecastBlock)block;

@end

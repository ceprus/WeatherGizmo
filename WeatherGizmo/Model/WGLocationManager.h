//
//  WGLocation.h
//  WeatherGizmo
//
//  Created by Sergey Sergeyev on 24.10.15.
//  Copyright (c) 2015 rsbw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationEntity.h"

/// Result handler LocationEntity
typedef void(^WGLocationManagerLocationHandler)(LocationEntity *location, NSError *error);

/// Result handler array of LocationEntity objects
typedef void(^WGLocationManagerFindHandler)(NSArray *locations, NSError *error);

/// Enumeration all errors of WGLocationManager object
typedef NS_ENUM(NSInteger, WGLocationManagerError) {
    /// Returned when the LocationEntity is null or empty location data
    WGLocationManagerErrorEmptyOrNilData = -77791
};

/// WGLocationManager object
extern NSString *const WGLocationManagerErrorDomain;


@interface WGLocationManager : NSObject
@property (assign, atomic) BOOL stopFind;

/**
 * Location by current ip address with open api of freegeoip.net
 */
- (void)getCurrentLocationWithResultBlock:(WGLocationManagerLocationHandler)block;

/**
 * Location by city id of local file copy "city.list.json"
 */
- (void)getLocationById:(long)cityId withResultBlock:(WGLocationManagerLocationHandler)block;

/**
 * Locations list by city name of local file copy "city.list.json"
 * (orig: http://bulk.openweathermap.org/sample/city.list.json.gz )
 */
- (void)getLocationByName:(NSString *)name withResultBlock:(WGLocationManagerFindHandler)block;

@end

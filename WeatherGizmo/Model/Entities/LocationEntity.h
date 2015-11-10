//
//  LocationEntity.h
//  WeatherGizmo
//
//  Created by Sergey Sergeyev on 21.10.15.
//  Copyright (c) 2015 rsbw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationEntity : NSObject
@property (assign, nonatomic, readonly) long      cityId;  // 0 if initWithFreeGeoIpJson
@property (strong, nonatomic, readonly) NSString* city;
@property (strong, nonatomic, readonly) NSString* country;
@property (assign, nonatomic, readonly) CGFloat   latitude;
@property (assign, nonatomic, readonly) CGFloat   longitude;

/**
 * freegeoip.net Format Json
 */
- (instancetype)initWithFreeGeoIpJson:(NSDictionary *)json;

/**
 * bulk.openweathermap.org/sample/city.list.json.gz Format Json
 */
- (instancetype)initWithOpenWeatherMapJson:(NSDictionary *)json;

@end



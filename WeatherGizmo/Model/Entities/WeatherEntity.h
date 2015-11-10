//
//  WeatherEntity.h
//  WeatherGizmo
//
//  Created by Sergey Sergeyev on 21.10.15.
//  Copyright (c) 2015 rsbw. All rights reserved.
//  http://bulk.openweathermap.org/sample/
//

#import <Foundation/Foundation.h>

@interface WeatherEntity : NSObject

@property (assign, nonatomic, readonly) long      cityId;
@property (assign, nonatomic, readonly) long      weatherId;
@property (assign, nonatomic, readonly) CGFloat   temperature;
@property (assign, nonatomic, readonly) CGFloat   windSpeed;
@property (assign, nonatomic, readonly) CGFloat   clouds;
@property (strong, nonatomic, readonly) NSString* icon;
@property (strong, nonatomic, readonly) NSString* text;
@property (strong, nonatomic, readonly) NSDate*   datetime;

/**
 * Json of OpenWeatherMap.org
 */
- (instancetype)initWithJson:(NSDictionary *)json;

@end

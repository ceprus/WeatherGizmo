//
//  WGIconFactory.h
//  WeatherGizmo
//
//  Created by Sergey Sergeyev on 18.09.15.
//  Copyright (c) 2015 rsbw. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/// Icon color style for any skins
typedef NS_ENUM(NSInteger, WGWeatherIconStyle) {
    /// Gray color
    WGWeatherIconStyleGray,
    /// White color
    WGWeatherIconStyleLight
};


extern long const WGWeatherIconSkyIsClear;

@interface WGIconFactory : NSObject

// http://openweathermap.org/weather-conditions


/**
 Gets the icon image from a weatherId code
 @param weatherId Weather identifier
 @param datetime Timestamp of event
 @param style Dark/Light icons for a skin
 */
- (NSImage *)imageWithWeatherId:(long)weatherId
                       withDate:(NSDate *)datetime
                       andStyle:(WGWeatherIconStyle)style;

@end

//
//  WeatherEntity.m
//  WeatherGizmo
//
//  Created by Sergey Sergeyev on 21.10.15.
//  Copyright (c) 2015 rsbw. All rights reserved.
//

#import "WeatherEntity.h"

@implementation WeatherEntity

- (instancetype)initWithJson:(NSDictionary *)json
{
    self = json ? [super init] : nil;
    if (self) {
        
        // weather
        NSArray *weathers = json[@"weather"];
        NSDictionary *weather = weathers.firstObject;
        _weatherId = [weather[@"id"] longValue];
        _text = weather[@"description"];
        _icon = weather[@"icon"];
        
        // main
        NSDictionary *main = json[@"main"];
        _temperature = [main[@"temp"] floatValue];
        
        // wind
        NSDictionary *wind = json[@"wind"];
        _windSpeed = [wind[@"speed"] floatValue];
        
        // clouds
        NSDictionary *clouds = json[@"clouds"];
        _clouds = [clouds[@"all"] floatValue];

        // dt
        _datetime = [NSDate dateWithTimeIntervalSince1970: [json[@"dt"] longValue]];
//        #warning binding to current timezone!!!
//        NSDate *dateInUTC = [NSDate dateWithTimeIntervalSince1970: [json[@"dt"] longValue]];
//        NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
//        _datetime = [dateInUTC dateByAddingTimeInterval: timeZoneSeconds];
        
        // id
        NSNumber *tmpCityId = json[@"id"];
        _cityId = tmpCityId ? tmpCityId.longValue : 0;
    }
        
    return self;
}


-(NSString *)description
{
    return [NSString stringWithFormat:@"%@",
            @{@"cityId":      @(_cityId),
              @"weatherId":   @(_weatherId),
              @"temperature": @(_temperature),
              @"windSpeed":   @(_windSpeed),
              @"clouds":      @(_clouds),
              @"icon":        _icon,
              @"text":        _text,
              @"datetime":    _datetime}];
}


@end









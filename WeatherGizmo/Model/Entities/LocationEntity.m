//
//  LocationEntity.m
//  WeatherGizmo
//
//  Created by Sergey Sergeyev on 21.10.15.
//  Copyright (c) 2015 rsbw. All rights reserved.
//

#import "LocationEntity.h"

@implementation LocationEntity

- (instancetype)initWithFreeGeoIpJson:(NSDictionary *)json
{
    self = json ? [super init] : nil;
    if (self) {
        _cityId = 0; /// -777
        _country = json[@"country_code"];
        _city = json[@"city"];
        _latitude = [json[@"latitude"] floatValue];
        _longitude = [json[@"longitude"] floatValue];
    }
    return self;
}

- (instancetype)initWithOpenWeatherMapJson:(NSDictionary *)json
{
    self = json ? [super init] : nil;
    if (self) {
        _cityId = [json[@"_id"] longValue];
        _country = json[@"country"];
        _city = json[@"name"];
        NSDictionary *coord = json[@"coord"];
        _latitude = [coord[@"lat"] floatValue];
        _longitude = [coord[@"lon"] floatValue];
    }
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@",
            @{@"cityId":   @(_cityId),
             @"country":   _country,
             @"city":      _city,
             @"latitude":  @(_latitude),
             @"longitude": @(_longitude)}];
}

@end

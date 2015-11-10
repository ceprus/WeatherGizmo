//
//  WGLocation.m
//  WeatherGizmo
//
//  Created by Sergey Sergeyev on 24.10.15.
//  Copyright (c) 2015 rsbw. All rights reserved.
//

#import "WGLocationManager.h"
#import "AFNetworking.h"

// Public
NSString *const WGLocationManagerErrorDomain = @"WGLocationManagerErrorDomain";

// Private
static NSString *const kFreeGeoIpUrl = @"http://freegeoip.net/json/";
static NSString *const kOpenWeatherMapCityListFile = @"city.list.json";
static NSStringEncoding const kOpenWeatherMapFileEncoding = NSUTF8StringEncoding;


@implementation WGLocationManager


- (void)getCurrentLocationWithResultBlock:(WGLocationManagerLocationHandler)block;
{
    NSURL *destinationUrl = [NSURL URLWithString: kFreeGeoIpUrl];
    NSMutableURLRequest *multyRequest = [NSMutableURLRequest requestWithURL: destinationUrl];
    multyRequest.allHTTPHeaderFields = @{@"Accept-Language": @"en-US,en;q=1.0"};
    //multyRequest.allHTTPHeaderFields = @{@"X-Forwarded-For": @"192.168.1.1"};
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest: multyRequest];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        LocationEntity *loc = [[LocationEntity alloc] initWithFreeGeoIpJson: responseObject];
        
        if (loc.latitude && loc.longitude) {
            block(loc, nil); // Full Success
        } else {
            NSError *err = [NSError errorWithDomain: WGLocationManagerErrorDomain
                                               code: WGLocationManagerErrorEmptyOrNilData
                                           userInfo: @{@"info": @"LocationEntity Empty Or Null"}];
            block(nil, err);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *connectionErr) {
        
        block(nil, connectionErr);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:op];
}


- (NSString *)wg_openCityListFileWithError:(NSError **)error
{
    NSURL *cityListFileUrl = [[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent: kOpenWeatherMapCityListFile];

    NSError *readErr = nil;
    NSString *cityListData = [NSString stringWithContentsOfURL: cityListFileUrl encoding: kOpenWeatherMapFileEncoding error: &readErr];
    
    if (!readErr && cityListData) {
        error = nil;
        return cityListData;
    }        
    
    *error = readErr;
    return nil;
}


- (void)getLocationById:(long)cityId withResultBlock:(WGLocationManagerLocationHandler)block
{
    NSError *readErr;
    NSString *cityListDataStr = [self wg_openCityListFileWithError: &readErr];
    
    if (!readErr)
    {
        BOOL __block stopped = NO;
        [cityListDataStr enumerateLinesUsingBlock:^(NSString *line, BOOL *stop) {
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData: [line dataUsingEncoding: kOpenWeatherMapFileEncoding] options: 0 error: nil];
            LocationEntity *loc = [[LocationEntity alloc] initWithOpenWeatherMapJson: json];
            
            if (loc) {
                if (loc.cityId == cityId) {
                    
                    // Full Success
                    block(loc, nil);
                    stopped = *stop = YES;
                }
            } else {
                
                NSError *emptyErr = [NSError errorWithDomain: WGLocationManagerErrorDomain
                                                        code: WGLocationManagerErrorEmptyOrNilData
                                                    userInfo: @{@"info": @"LocationEntity is Null"}];
                block(nil, emptyErr);
                stopped = *stop = YES;
            }
        }];
        
        // No matches / not found
        if (!stopped) block(nil, nil);
        
    } else {
        block(nil, readErr);
    }
}


- (void)getLocationByName:(NSString *)name withResultBlock:(WGLocationManagerFindHandler)block
{
    _stopFind = NO;
    
    NSError *readErr;
    NSString *cityListDataStr = [self wg_openCityListFileWithError: &readErr];
    BOOL allCities = [name isEqualToString: @""];
    
    if (!readErr)
    {
        BOOL __block stopped = NO;
        NSMutableArray __block *locs = [[NSMutableArray alloc] init];
        
        [cityListDataStr enumerateLinesUsingBlock:^(NSString *line, BOOL *stop) {
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData: [line dataUsingEncoding: kOpenWeatherMapFileEncoding] options: 0 error: nil];
            LocationEntity *loc = [[LocationEntity alloc] initWithOpenWeatherMapJson: json];
            
            if (loc && !_stopFind) {

                if ([[loc.city lowercaseString] hasPrefix: [name lowercaseString]] || allCities) {
                    [locs addObject: loc];
                }

            } else {
                
                NSError *emptyErr = [NSError errorWithDomain: WGLocationManagerErrorDomain
                                                        code: WGLocationManagerErrorEmptyOrNilData
                                                    userInfo: @{@"info": @"LocationEntity is Null or Find is stopped of user"}];
                block(nil, emptyErr);
                stopped = *stop = YES;
            }
        }];
        
        // Full Success
        if (!stopped) block([locs copy], nil);
        
    } else {
        block(nil, readErr);
    }
}

@end

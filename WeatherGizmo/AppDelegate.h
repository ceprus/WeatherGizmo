//
//  AppDelegate.h
//  WeatherGizmo
//
//  Created by Sergey Sergeyev on 30.10.15.
//  Copyright (c) 2015 rsbw. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PrimaryController;

@interface AppDelegate : NSObject <NSApplicationDelegate>
@property (strong, nonatomic) PrimaryController *primaryController;

@end


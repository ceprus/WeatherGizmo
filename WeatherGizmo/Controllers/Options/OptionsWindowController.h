//
//  OptionsWindowController.h
//  WeatherGizmo
//
//  Created by Sergey Sergeyev on 25.09.15.
//  Copyright © 2015 rsbw. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WGOptionsProtocol.h"


@class OptionsViewController;

// For primary controller
@protocol WGOptionsWindowProtocol <NSObject>
@required
- (void)findLocationsByStringWithCallback:(NSString *)text;
@end


@interface OptionsWindowController : NSWindowController
@property (weak, nonatomic, readonly) id<WGOptionsProtocol, WGOptionsWindowProtocol> primaryController;
@property (weak, nonatomic, readonly) OptionsViewController *viewController;
@end

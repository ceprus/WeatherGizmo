//
//  NSTextField+Animation.m
//  WeatherGizmo
//
//  Created by Sergey Sergeyev on 25.09.15.
//  Copyright © 2015 rsbw. All rights reserved.
//

#import "NSTextField+Animation.h"
#import <QuartzCore/QuartzCore.h>


@implementation NSTextField (AnimatedSetString)

- (void)setAnimatedStringValue:(NSString *)value
{
    if ([[self stringValue] isEqual: value])
    {
        return;
    }
    
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        
        [context setDuration: 0.1];
        [context setTimingFunction: [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut]];
        [self.animator setAlphaValue: 0.0];
    
    } completionHandler:^{
        
        [self setStringValue: value];
        
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            [context setDuration: 0.1];
            [context setTimingFunction: [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn]];
            [self.animator setAlphaValue: 1.0];
        } completionHandler: ^{}];
        
    }];
}

- (NSString *)animatedStringValue {
    return self.stringValue;
}

@end


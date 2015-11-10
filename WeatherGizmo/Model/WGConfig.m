//
//  WGConfig.m
//  WeatherGizmo
//
//  Created by Sergey Sergeyev on 07.10.15.
//  Copyright (c) 2015 rsbw. All rights reserved.
//

#import "WGConfig.h"
#import <objc/runtime.h>

#import "LocationEntity.h"

@interface WGConfig()
@end


@implementation WGConfig

@dynamic cityName;
@dynamic skinStyle;
@dynamic windowLevel;
@dynamic viewDetails;
@dynamic locationId;
@dynamic timeFormat;
@dynamic weatherFormat;
@dynamic transparency;
@dynamic posX;
@dynamic posY;

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    NSString *selString = NSStringFromSelector(sel);

    if ([selString hasPrefix: @"set"]) {
        class_addMethod(self, sel, (IMP)wg_autoPropertySetter, "v@:@");
    } else {
        class_addMethod(self, sel, (IMP)wg_autoPropertyGetter, "@@:");
    }
    
    return YES;
}


id wg_autoPropertyGetter(id self, SEL sel)
{
    NSString *key = NSStringFromSelector(sel);
    return [[NSUserDefaults standardUserDefaults] objectForKey: key];
}


void wg_autoPropertySetter(id self, SEL sel, id value)
{
    if (value)
    {
        NSMutableString *key = [NSStringFromSelector(sel) mutableCopy];
        [key deleteCharactersInRange: NSMakeRange(0, 3)];
        [key deleteCharactersInRange: NSMakeRange(key.length - 1, 1)];
        
        NSString *lowerChar = [[key substringToIndex: 1] lowercaseString];
        [key replaceCharactersInRange: NSMakeRange(0, 1) withString: lowerChar];
        
        [[NSUserDefaults standardUserDefaults] setObject: value forKey: key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    
    } else {
        
        NSLog(@"** [ERROR Null value] %@", NSStringFromSelector(sel));
    }
}


- (NSString *)description
{
    return [NSString stringWithFormat: @"%@",
            @{@"cityName":      self.cityName,
              @"skinStyle":     self.skinStyle,
              @"windowLevel":   self.windowLevel,
              @"viewDetails":   self.viewDetails,
              @"locationId":    self.locationId,
              @"timeFormat":    self.timeFormat,
              @"weatherFormat": self.weatherFormat,
              @"transparency":  self.transparency,
              @"posX":          self.posX,
              @"posY":          self.posY }];
}

@end

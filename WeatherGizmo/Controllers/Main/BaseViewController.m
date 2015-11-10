//
//  InterfaceController.m
//  WeatherGizmo
//
//  Created by Sergey Sergeyev on 30.10.15.
//  Copyright (c) 2015 rsbw. All rights reserved.
//

#import "BaseViewController.h"

#define WG_ABSTRACT_METHOD {\
[self doesNotRecognizeSelector:_cmd]; \
__builtin_unreachable(); \
}


@implementation BaseViewController


- (CGFloat)convertTemperature:(CGFloat)temp toFormat:(WGWeatherFormat)format
{
    CGFloat tmp;
    
    switch (format) {
        case WGWeatherFormatFahrenheit:
            tmp = temp * 1.8 - 459.67;
            break;
        case WGWeatherFormatCelsius:
            tmp = temp - 273.15;
            break;
        default:
            [NSException raise:@"UnknownIdentifier" format:@"Unknown identifier in %s", __func__ ];
    }
    
    return tmp;
}


-(void)viewDidAppear {
    [super viewDidAppear];
    _windowController = [self.view.window windowController];
    
//    self.view.wantsLayer = YES;
//    self.view.layer.cornerRadius = 40.0;
//    self.view.layer.masksToBounds = YES;
    
}


- (IBAction)buttonMenu:(id)sender {
    [self.windowController.mainMenu popUpMenuPositioningItem: nil atLocation: NSMakePoint(20, 0) inView: sender];
}


#pragma mark - protocol WGBaseViewController

- (NSSize)sizeFromViewDetails:(WGViewDetails)viewDetails WG_ABSTRACT_METHOD;
- (void)resetViewToDefaults:(BOOL)all WG_ABSTRACT_METHOD;
- (void)updateDateTime:(NSDate *)datetime withFormat:(WGTimeFormat)format WG_ABSTRACT_METHOD;
- (void)updateLocation:(NSString *)city WG_ABSTRACT_METHOD;
- (void)updateWeatherToday:(NSDictionary *)weather withFormat:(WGWeatherFormat)format WG_ABSTRACT_METHOD;
- (void)updateWeatherFarecast:(NSArray *)weathers withFormat:(WGWeatherFormat)format WG_ABSTRACT_METHOD;

@end

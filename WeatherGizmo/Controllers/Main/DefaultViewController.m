//
//  ViewController.m
//  WeatherGizmo
//
//  Created by Sergey Sergeyev on 30.10.15.
//  Copyright (c) 2015 rsbw. All rights reserved.
//

#import "DefaultViewController.h"



@interface DefaultViewController()

@end


@implementation DefaultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.labelCityCountry.stringValue = @"Loading...";
    self.labelTime.stringValue = @":";
    self.labelAmPm.stringValue = @"";
    self.labelDate.stringValue = @"...";

}


-(void)viewWillAppear {
    [super viewWillAppear];
    
    [self resetViewToDefaults: YES];
}



#pragma mark - protocol WGBaseViewController

- (NSSize)sizeFromViewDetails:(WGViewDetails)viewDetails
{
    switch (viewDetails) {
        case WGViewDetailsMinimal:
            return NSMakeSize(246, 266);
        case WGViewDetailsFull:
            return NSMakeSize(246, 406);
    }
}


- (void)resetViewToDefaults:(BOOL)all
{
    if (all) {
        self.progressLoading.hidden = NO;
        [self.progressLoading startAnimation: self];
        
//        self.labelCityCountry.stringValue = @"Loading...";
//        self.labelTime.stringValue = @":";
//        self.labelAmPm.stringValue = @"";
//        self.labelDate.stringValue = @"...";
        self.labelTemperature.stringValue = @"";
        self.labelWeatherText.stringValue = @"...";
        self.weatherIconToday.animator.image = nil;
        
        [self.windowController.statusItem setTitle: @"--"];
    }
    
    for (int i = 3; i >= 0; i--) {
        NSTextField *labelWeekday = [self valueForKey: [NSString stringWithFormat: @"labelWeekday%d", i + 1]];
        NSImageView *imageForecast = [self valueForKey: [NSString stringWithFormat: @"imageForecast%d", i + 1]];
        NSTextField *labelTempDay = [self valueForKey: [NSString stringWithFormat: @"labelTempDay%d", i + 1]];
        NSTextField *labelTempNight = [self valueForKey: [NSString stringWithFormat: @"labelTempNight%d", i + 1]];
        
        labelWeekday.stringValue = @"loading";
        labelWeekday.toolTip = @"";
        imageForecast.animator.image = nil;
        labelTempDay.stringValue = @"";
        labelTempNight.stringValue = @"";
    }
}


- (void)updateDateTime:(NSDate *)datetime withFormat:(WGTimeFormat)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier: @"en_US"];
    [dateFormatter setLocale: locale];
    
    NSString *timeFormat;
    
    if (format == WGTimeFormat12Hours)
    {
        [dateFormatter setDateFormat: @"a"]; // AM/PM
        self.labelAmPm.hidden = NO;
        self.labelAmPm.animatedStringValue = [dateFormatter stringFromDate: datetime];
        timeFormat =  @"h:mm"; // 12hours
        
    } else {
        
        self.labelAmPm.hidden = YES;
        timeFormat =  @"HH:mm"; // 24hours
    }
    
    [dateFormatter setDateFormat: timeFormat];
    self.labelTime.stringValue = [dateFormatter stringFromDate: datetime];
    
    [dateFormatter setDateFormat: @"EEE, MMM d"];
    self.labelDate.stringValue = [[dateFormatter stringFromDate: datetime] capitalizedString];
    
    NSTextAlignment align = (self.labelTime.stringValue.length > 4) ? NSRightTextAlignment : NSLeftTextAlignment;
    [self.labelAmPm.cell setAlignment: align]; // AM-PM moving
}


- (void)updateLocation:(NSDictionary *)location
{
    NSString *cityName = location[@"city"];
    if ([cityName isEqualToString: @""]) {
        cityName = @"Your city is not defined";
    }
    self.labelCityCountry.animatedStringValue = [NSString stringWithFormat:@"%@", cityName];
}


- (void)updateWeatherToday:(NSDictionary *)weather withFormat:(WGWeatherFormat)format
{
    self.progressLoading.hidden = YES;
    [self.progressLoading stopAnimation: self];
    
    CGFloat temp = [weather[@"d_temp"] floatValue];
    CGFloat convtemp = [self convertTemperature: temp toFormat: format];
    
    NSString *units = (format == WGWeatherFormatFahrenheit) ? @"F" : @"C";
    NSString *str = [NSString stringWithFormat:@"%ld°%@", lroundf(convtemp), units];
    
    self.labelTemperature.stringValue = str;
    self.labelWeatherText.animatedStringValue = weather[@"text"];
    self.weatherIconToday.animator.image = weather[@"icon"];
    
    // Update title of status item
    
    [self.windowController.statusItem setTitle: str];
    
    // Dark color and small font for units
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithAttributedString: self.labelTemperature.attributedStringValue];
    
    NSRange unitsRange = NSMakeRange([attrStr length] - 1, 1);
    NSFont *font = [NSFont fontWithName: self.labelTemperature.font.fontName
                                   size: self.labelTemperature.font.pointSize - 11];
    
    NSColor *newColor = [NSColor colorWithWhite: 0.7 alpha: 1.0];
    
    [attrStr addAttribute: NSForegroundColorAttributeName
                    value: newColor
                    range: unitsRange];
    
    [attrStr addAttribute: NSFontAttributeName
                    value: font
                    range: unitsRange];
    
    self.labelTemperature.attributedStringValue = attrStr;
    
}


- (void)updateWeatherFarecast:(NSArray *)weathers withFormat:(WGWeatherFormat)format
{
    self.progressLoading.hidden = YES;
    [self.progressLoading stopAnimation: self];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier: @"en_US"];
    [dateFormatter setLocale: locale];
    [dateFormatter setDateFormat: @"EEEE"]; // Weekday

    
    long i;
    
    if (weathers.count < 4) {
        i = weathers.count - 1;
        NSLog(@"Error!!! weathers array count are <less 4 (%s)", __func__);
    } else {
        i = 3;
    }
    
    for ( /**/ ; i >= 0; i--) {
        NSTextField *labelWeekday = [self valueForKey: [NSString stringWithFormat: @"labelWeekday%ld", i + 1]];
        NSImageView *imageForecast = [self valueForKey: [NSString stringWithFormat: @"imageForecast%ld", i + 1]];
        NSTextField *labelTempDay = [self valueForKey: [NSString stringWithFormat: @"labelTempDay%ld", i + 1]];
        NSTextField *labelTempNight = [self valueForKey: [NSString stringWithFormat: @"labelTempNight%ld", i + 1]];
    
        NSDictionary *weather = weathers[i];
        CGFloat d_temp = [self convertTemperature: [weather[@"d_temp"] floatValue] toFormat: format];
        CGFloat n_temp = [self convertTemperature: [weather[@"n_temp"] floatValue] toFormat: format];
        
        [dateFormatter setDateFormat: @"EEEE"]; // Weekday
        labelWeekday.stringValue = [dateFormatter stringFromDate: weather[@"date"]];
        imageForecast.animator.image = weather[@"icon"];
        labelTempDay.animatedStringValue = [NSString stringWithFormat:@"%ld°", lroundf(d_temp)];
        labelTempNight.animatedStringValue = [NSString stringWithFormat:@"%ld°", lroundf(n_temp)];
        
        [dateFormatter setDateFormat: @"d MMMM"]; // 6 Oct
        labelWeekday.toolTip = [dateFormatter stringFromDate: weather[@"date"]];
    }
}


@end

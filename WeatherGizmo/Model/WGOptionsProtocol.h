//
//  WGOptionsProtocol.h
//  WeatherGizmo
//
//  Created by Sergey Sergeyev on 05.10.15.
//  Copyright © 2015 rsbw. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/// Window level on desktop
typedef NS_ENUM(NSInteger, WGWindowLevel) {
    /// Window level is back of other windows
    WGWindowLevelMoveable = 0,
    /// Window level sets under desktop icons
    WGWindowLevelDesktopIcon
};

/// Window skin style
typedef NS_ENUM(NSInteger, WGSkinStyle) {
    /// White style
    WGSkinStyleDefault = 0,
    /// Black style
    WGSkinStyleDark,
    /// Blue style
    WGSkinStyleBlue
};

/// View details weather forecast
typedef NS_ENUM(NSInteger, WGViewDetails) {
    /// Window is small
    WGViewDetailsMinimal = 0,
    /// Window with forecast
    WGViewDetailsFull
};


typedef NS_ENUM(NSInteger, WGTimeFormat) {
    WGTimeFormat12Hours = 0,
    WGTimeFormat24Hours
};


typedef NS_ENUM(NSInteger, WGWeatherFormat) {
    WGWeatherFormatFahrenheit = 0,
    WGWeatherFormatCelsius
};


@protocol WGOptionsProtocol <NSObject>
@required
/// deprecated
@property (strong, nonatomic) NSString *cityName;

/// Window skin (type: WGSkinStyle)
@property (strong, nonatomic) NSNumber *skinStyle;

/// Window level on desktop (type: WGWindowLevel)
@property (strong, nonatomic) NSNumber *windowLevel;

/// Window size and details weather (type: WGViewDetails)
@property (strong, nonatomic) NSNumber *viewDetails;

/// Unique identifier of cities at city.list.json (type: long)
@property (strong, nonatomic) NSNumber *locationId;

/// Time format 12|24 hours (type: WGTimeFormat)
@property (strong, nonatomic) NSNumber *timeFormat;

/// The temperature format of Celsius or Fahrenheit (type: WGWeatherFormat)
@property (strong, nonatomic) NSNumber *weatherFormat;

/// Window transparency level (CGFloat)
@property (strong, nonatomic) NSNumber *transparency;

/// Window position X (CGFloat)
@property (strong, nonatomic) NSNumber *posX;

/// Window position Y (CGFloat)
@property (strong, nonatomic) NSNumber *posY;

@end


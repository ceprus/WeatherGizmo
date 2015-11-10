//
//  OptionsViewController.h
//  WeatherGizmo
//
//  Created by Sergey Sergeyev on 25.09.15.
//  Copyright © 2015 rsbw. All rights reserved.
//

#import "OptionsWindowController.h"

@interface OptionsViewController : NSViewController

/// Link to window controller
@property (weak, nonatomic, readonly) OptionsWindowController *windowController;

/**
 * callback of WGOptionsWindowProtocol with NSDictionary's array format:
 * "cityId" : NSNumber (long),
 * "city": NSString
 */
- (void)updateLocationsList:(NSArray *)locations;

@end

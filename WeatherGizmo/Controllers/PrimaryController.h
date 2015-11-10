//
//  PrimaryController.h
//  WeatherGizmo
//
//  Created by Sergey Sergeyev on 04.10.15.
//  Copyright (c) 2015 rsbw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainWindowController.h"
#import "OptionsWindowController.h"
#import "WGOptionsProtocol.h"


/** Папа контроллер */
@interface PrimaryController : NSObject <WGMainWindowProtocol, WGOptionsWindowProtocol>

- (void)showMainWindow;
- (void)showOptionsWindow;
- (void)findLocationsByStringWithCallback:(NSString *)text;

@end


/** Категория для настроек */
@interface PrimaryController (Options) <WGOptionsProtocol>
@end


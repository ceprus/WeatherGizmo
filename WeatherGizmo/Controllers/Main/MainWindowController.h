//
//  MainWindowController.h
//  WeatherGizmo
//
//  Created by Sergey Sergeyev on 03.10.15.
//  Copyright (c) 2015 rsbw. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WGOptionsProtocol.h"

@class BaseViewController;


// For primary controller
@protocol WGMainWindowProtocol <NSObject>
@required
- (void)showOptionsWindow;
@end


@interface MainWindowController : NSWindowController

@property (strong) NSStatusItem *statusItem;
@property (strong) IBOutlet NSMenu *mainMenu;

@property (weak, nonatomic, readonly) id<WGMainWindowProtocol, WGOptionsProtocol> primaryController;
@property (weak, nonatomic, readonly) BaseViewController *viewController;

@property (assign, nonatomic) WGWindowLevel windowLevel;
@property (assign, nonatomic) WGSkinStyle skinStyle;
@property (assign, nonatomic) WGViewDetails viewDetails;

- (void)showWindowWithSkin:(WGSkinStyle)skinStyle
               viewDetails:(WGViewDetails)viewDetails
               windowLevel:(WGWindowLevel)windowLevel
                alphaValue:(CGFloat)alpha
             andController:(id)primaryController;

@end



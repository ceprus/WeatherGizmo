//
//  MainWindowController.m
//  WeatherGizmo
//
//  Created by Sergey Sergeyev on 03.10.15.
//  Copyright (c) 2015 rsbw. All rights reserved.
//

#import "MainWindowController.h"
#import "BaseViewController.h"


@interface MainWindowController()
@property (weak) IBOutlet NSMenuItem *menuSettings;
@property (weak) IBOutlet NSMenuItem *menuMove;
@property (weak) IBOutlet NSMenuItem *menuExpand;
@property (weak) IBOutlet NSMenuItem *menuExit;

@end

@implementation MainWindowController


- (void)showWindow:(id)sender {
    if (!sender) {
        [NSException raise:@"NullPrimaryController" format:@"Null sender in %s", __func__ ];
    }
    _primaryController = sender;
    
    // Set window to all desktops shown
    NSUInteger collectionBehavior = self.window.collectionBehavior;
    collectionBehavior |= NSWindowCollectionBehaviorCanJoinAllSpaces;
    self.window.collectionBehavior = collectionBehavior;

    self.window.opaque = NO;
    self.window.backgroundColor = [NSColor clearColor];
    self.contentViewController.view.layer.cornerRadius = 3.0;
    self.contentViewController.view.layer.masksToBounds = YES;

    self.window.movableByWindowBackground = YES;
    self.window.ignoresMouseEvents = NO;
    
    CGFloat x = [[_primaryController posX] floatValue];
    CGFloat y = [[_primaryController posY] floatValue];
    
    if (x || y) {
        [self.window setFrameOrigin: NSMakePoint(x, y)];
    }
    
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength: NSVariableStatusItemLength];
    [_statusItem setMenu: _mainMenu];
    [_statusItem setHighlightMode: YES];
    [_statusItem setTitle: @"--"];
    
    [_menuSettings.image setTemplate: YES];
    [_menuMove.image setTemplate: YES];
    [_menuExpand.image setTemplate: YES];
    [_menuExit.image setTemplate: YES];
    
    [super showWindow: sender];
}


- (void)showWindowWithSkin:(WGSkinStyle)skinStyle
               viewDetails:(WGViewDetails)viewDetails
               windowLevel:(WGWindowLevel)windowLevel
                alphaValue:(CGFloat)alpha
             andController:(id)primaryController
{
    self.skinStyle = skinStyle;
    self.viewDetails = viewDetails;
    self.windowLevel = windowLevel;
    self.window.alphaValue = 1.0 - alpha;

    [self showWindow: primaryController];
}


- (void)setViewDetails:(WGViewDetails)viewDetails
{
    _viewDetails = viewDetails;

    NSSize size = [self.viewController sizeFromViewDetails: viewDetails];
    CGFloat dif = self.window.frame.size.height - size.height;
    NSRect rect = NSMakeRect(self.window.frame.origin.x,
                             self.window.frame.origin.y + dif,
                             size.width,
                             size.height);
    
    [self.window setFrame: rect display: YES animate: self.window.visible];
    
    BOOL details = (viewDetails == WGViewDetailsFull);
    self.menuExpand.state = details ? NSOnState : NSOffState;
}


- (void)setWindowLevel:(WGWindowLevel)windowLevel
{
    _windowLevel = windowLevel;
    
    switch (windowLevel) {
        case WGWindowLevelDesktopIcon:
            self.window.level = kCGDesktopWindowLevel; //kCGDesktopIconWindowLevel;
            break;
        case WGWindowLevelMoveable:
            self.window.level = kCGFloatingWindowLevel;
            break;
    }
    
    BOOL moveable = (windowLevel == WGWindowLevelMoveable);
    self.viewController.buttonMenu.enabled = moveable;
    self.menuMove.state = moveable ? NSOnState : NSOffState;
    
    [self.window setHasShadow: moveable];
}


- (void)setSkinStyle:(WGSkinStyle)skinStyle
{
    _skinStyle = skinStyle;
     
    NSString *viewControllerID;
    
    switch (skinStyle) {
        case WGSkinStyleDefault:
            viewControllerID = @"Default";
            break;
        case WGSkinStyleDark:
            viewControllerID = @"Dark";
            break;
        case WGSkinStyleBlue:
            viewControllerID = @"Blue";
            break;
    }
    
     _viewController = [[self storyboard] instantiateControllerWithIdentifier: viewControllerID];
     if (_viewController) {
         [self setContentViewController: _viewController];
     } else {
         [NSException raise:@"NullViewController" format:@"View Controller is NULL in %s", __func__ ];
     }
}



- (IBAction)menuSettings:(id)sender {
    [self.primaryController showOptionsWindow];
}

- (IBAction)menuMove:(id)sender {
    WGWindowLevel winLevel;
    
    switch (self.windowLevel) {
        case WGWindowLevelMoveable:
            winLevel = WGWindowLevelDesktopIcon;
            break;
        case WGWindowLevelDesktopIcon:
            winLevel = WGWindowLevelMoveable;
            break;
    }

    [self setWindowLevel: winLevel];
    
    [self.primaryController setWindowLevel: @(self.windowLevel)];
}

- (IBAction)menuExpand:(id)sender {
    switch (self.viewDetails) {
        case WGViewDetailsMinimal:
            self.viewDetails = WGViewDetailsFull;
            break;
        case WGViewDetailsFull:
            self.viewDetails = WGViewDetailsMinimal;
            break;
    }
    
    [self.primaryController setViewDetails: @(self.viewDetails)];
}

- (IBAction)menuExit:(id)sender {
    [NSApp terminate: self];
}




@end


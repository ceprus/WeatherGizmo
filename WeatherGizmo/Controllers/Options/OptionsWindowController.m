//
//  OptionsWindowController.m
//  WeatherGizmo
//
//  Created by Sergey Sergeyev on 25.09.15.
//  Copyright © 2015 rsbw. All rights reserved.
//

#import "OptionsWindowController.h"
#import "OptionsViewController.h"

@interface OptionsWindowController ()

@end

@implementation OptionsWindowController


- (void)showWindow:(id)sender
{
    if (!sender) {
        [NSException raise:@"NullPrimaryController" format:@"Null sender in %s", __func__ ];
    }
    _primaryController = sender;
    
    
    // Set Window width default
    NSRect winRect =  NSMakeRect(self.window.frame.origin.x, self.window.frame.origin.y, 290, 348);
    
    [self.window setFrame: winRect display: YES];
    
    
//    NSButton *closeButton = [self.window standardWindowButton: NSWindowCloseButton];
//    NSView *titleView = [closeButton superview];
//    NSRect frame = [[self.window contentView] frame];
//    
//    [titleView setFrame:NSMakeRect(frame.origin.x, frame.origin.y - 15, frame.size.width, frame.size.height)];
 
    self.window.titlebarAppearsTransparent = YES;
    
    _viewController = (OptionsViewController *)self.contentViewController;
    
    [super showWindow: sender];
}


-(void)windowDidLoad {
    
    self.window.movableByWindowBackground = YES;
    self.window.level = kCGFloatingWindowLevel;
}



@end

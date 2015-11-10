//
//  AppDelegate.m
//  WeatherGizmo
//
//  Created by Sergey Sergeyev on 30.10.15.
//  Copyright (c) 2015 rsbw. All rights reserved.
//

#import "AppDelegate.h"
#import "PrimaryController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self registerFontFile: @"Lato-Light.ttf"];
    [self registerFontFile: @"Lato-Hairline.ttf"];
    
    _primaryController = [[PrimaryController alloc] init];
    [_primaryController showMainWindow];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag {

    [_primaryController showMainWindow];
    return YES;
}


#pragma mark - Private:

- (BOOL)registerFontFile:(NSString *)file
{
    NSString *filename = [file.pathComponents.lastObject stringByDeletingPathExtension];
    NSString *fileext = file.pathExtension;
    NSURL *fontURL = [[NSBundle mainBundle] URLForResource: filename withExtension: fileext];
    
    CFErrorRef error = NULL;
    if (!CTFontManagerRegisterFontsForURL((__bridge CFURLRef)fontURL, kCTFontManagerScopeProcess, &error)) {
        CFShow(error);
        return NO;
    }
    return YES;
}

@end

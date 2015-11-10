//
//  DarkViewController.m
//  WeatherGizmo
//
//  Created by Sergey Sergeyev on 30.10.15.
//  Copyright (c) 2015 rsbw. All rights reserved.
//

#import "DarkViewController.h"

@interface DarkViewController()

@end

@implementation DarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}


- (IBAction)tmpButtom:(id)sender {
   
    [self.windowController setSkinStyle: WGSkinStyleBlue];
}


@end

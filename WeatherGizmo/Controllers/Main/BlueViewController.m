//
//  BlueViewController.m
//  WeatherGizmo
//
//  Created by Sergey Sergeyev on 30.10.15.
//  Copyright (c) 2015 rsbw. All rights reserved.
//

#import "BlueViewController.h"

@interface BlueViewController()

@end

@implementation BlueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (IBAction)tmpButtom:(id)sender {
    //[super tmpButtonClick];

    [self.windowController setSkinStyle: WGSkinStyleDefault];
}

@end

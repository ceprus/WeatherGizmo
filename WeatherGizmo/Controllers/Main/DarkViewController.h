//
//  DarkViewController.h
//  WeatherGizmo
//
//  Created by Sergey Sergeyev on 30.10.15.
//  Copyright (c) 2015 rsbw. All rights reserved.
//

#import "BaseViewController.h"

@interface DarkViewController : BaseViewController <WGBaseViewController>
@property (weak) IBOutlet NSImageView *weatherIconToday;

@end

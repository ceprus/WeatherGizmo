//
//  FormattedComboBox.h
//  WeatherGizmo
//
//  Created by Sergey Sergeyev on 08.10.15.
//  Copyright © 2015 rsbw. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FormattedComboBox : NSComboBox <NSComboBoxDelegate>

@property (assign, nonatomic) NSUInteger maximumValueLength;

@end

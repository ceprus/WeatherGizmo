//
//  FormattedComboBox.m
//  WeatherGizmo
//
//  Created by Sergey Sergeyev on 08.10.15.
//  Copyright © 2015 rsbw. All rights reserved.
//

#import "FormattedComboBox.h"

@implementation FormattedComboBox

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.delegate = self; // :)
        _maximumValueLength = UINT_MAX;
    }
    return self;
}

- (BOOL)textView:(NSTextView *)aTextView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(NSString *)replacementString
{
    if ((self.stringValue.length - affectedCharRange.length) + replacementString.length < _maximumValueLength) {
        
        return YES;
    }
    return NO;
}

@end

//
//  OptionsViewController.m
//  WeatherGizmo
//
//  Created by Sergey Sergeyev on 25.09.15.
//  Copyright © 2015 rsbw. All rights reserved.
//

#import "OptionsViewController.h"

typedef NS_ENUM(NSInteger, WGMyTab) {
    WGMyTabDesktop,
    WGMyTabWeather
};


@interface OptionsViewController () <NSComboBoxDataSource> {
    id<WGOptionsProtocol, WGOptionsWindowProtocol> _primary;
    NSArray *_locationsList; // NSDictionary array
}

// Desktop
@property (weak) IBOutlet NSButton *buttonTabDesktop;
@property (weak) IBOutlet NSView *viewDesktop;
@property (weak) IBOutlet NSSlider *sliderOpacity;
@property (weak) IBOutlet NSImageView *opacityWarning;
@property (weak) IBOutlet NSButton *checkUnderDesktop;
@property (weak) IBOutlet NSPopUpButton *dropdownClockFormat;

// Weather
@property (weak) IBOutlet NSButton *buttonTabWeather;
@property (weak) IBOutlet NSView *viewWeather;
@property (weak) IBOutlet NSComboBox *comboboxCities;
@property (weak) IBOutlet NSProgressIndicator *progressCityFind;
@property (weak) IBOutlet NSButton *checkTempFormat;


@end

@implementation OptionsViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    _comboboxCities.usesDataSource = YES;
    _comboboxCities.dataSource = self;
}


-(void)viewDidAppear {
    [super viewDidAppear];

    _windowController = [self.view.window windowController];
    _primary = self.windowController.primaryController;
    
    
    _sliderOpacity.doubleValue = [[_primary transparency] doubleValue];
    _opacityWarning.hidden = _sliderOpacity.doubleValue < 0.7;
    
    _checkUnderDesktop.state = [[_primary windowLevel] integerValue] == WGWindowLevelMoveable ? NSOffState : NSOnState;
    
    [_dropdownClockFormat selectItemAtIndex: [[_primary timeFormat] integerValue]];
    
    _checkTempFormat.state = [[_primary weatherFormat] integerValue] == WGWeatherFormatFahrenheit ? NSOffState : NSOnState;
    
}


- (void)updateLocationsList:(NSArray *)locations
{
    
    NSSortDescriptor *cityNameDescriptor = [[NSSortDescriptor alloc] initWithKey: @"city" ascending: YES];
    _locationsList = [locations sortedArrayUsingDescriptors: @[cityNameDescriptor]];
//    _locationsList = locations;
    
    [_progressCityFind stopAnimation: self];
    _comboboxCities.cell.editable = YES;
    _comboboxCities.stringValue = @"";
    [_comboboxCities reloadData];
    
    // Open combo box
    [(NSComboBoxCell*)_comboboxCities.cell performSelector: @selector(popUp:)];
}



- (void)wg_showMyTab:(WGMyTab)myTab
{
    switch (myTab) {
        case WGMyTabDesktop:
            _buttonTabDesktop.state = NSOffState;
            _buttonTabWeather.state = NSOnState;
            
            [_viewDesktop.animator setFrameOrigin: NSMakePoint(0, 28)];
            [_viewWeather.animator setFrameOrigin: NSMakePoint(290, 28)];
            
            break;
        
        case WGMyTabWeather:
            _buttonTabDesktop.state = NSOnState;
            _buttonTabWeather.state = NSOffState;
            
            [_viewDesktop.animator setFrameOrigin: NSMakePoint(-290, 28)];
            [_viewWeather.animator setFrameOrigin: NSMakePoint(0, 28)];
            
            break;
    }
}


// Desktop Tab

- (IBAction)buttonTabDesktop:(NSButton *)sender {
    [self wg_showMyTab: WGMyTabDesktop];
}


- (IBAction)sliderSlide:(NSSlider *)sender {
    _opacityWarning.hidden = sender.doubleValue < 0.7;
    [_primary setTransparency: @(sender.doubleValue)];
}


- (IBAction)checkUnderDesktop:(NSButton *)sender {
    [_primary setWindowLevel: @(sender.state == NSOnState ? WGWindowLevelDesktopIcon : WGWindowLevelMoveable)];
}


- (IBAction)dropdownClockFormat:(NSPopUpButton *)sender {
    [_primary setTimeFormat: @(sender.indexOfSelectedItem)];
}


// Weather Tab

- (IBAction)buttonTabWeather:(NSButton *)sender {
    [self wg_showMyTab: WGMyTabWeather];
}


- (IBAction)comboboxCities:(NSComboBox *)sender {
    
    sender.textColor = [NSColor textColor];
    
    // Set to default city (0)
    if (sender.stringValue.length == 0) {
        [_primary setLocationId: @0];
        return;
    }

    NSInteger index = [_comboboxCities indexOfSelectedItem];
    
    if (index >= 0 && index < _locationsList.count) {

        [_primary setLocationId: _locationsList[index][@"cityId"]];
    
    } else {
        
        NSLog(@"Error. Options window > cities list > city index out of range");
    }
}

- (IBAction)buttonLoadCitiesList:(NSButton *)sender
{
    sender.hidden = YES;
    _comboboxCities.stringValue = @"Please wait ...";
    
    [_progressCityFind startAnimation: self];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 9 * USEC_PER_SEC), dispatch_get_main_queue(), ^{
        [_primary findLocationsByStringWithCallback: @""]; //Get all cities And Call updateLocationsList: after complete
    });
}


- (IBAction)checkTempFormat:(NSButton *)sender {
    [_primary setWeatherFormat: @(sender.state == NSOffState ? WGWeatherFormatFahrenheit : WGWeatherFormatCelsius)];
}




#pragma mark - NSComboBoxDataSource

-(NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox {
    return _locationsList.count;
}


- (NSString *)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index {
    NSDictionary *loc = _locationsList[index];
    return [NSString stringWithFormat:@"%@, %@", loc[@"city"], loc[@"country"]];
}


- (NSUInteger)comboBox:(NSComboBox *)aComboBox indexOfItemWithStringValue:(NSString *)string
{
    NSString *lowerString = [string lowercaseString];
    NSString *tmp;
    
    for (int i = 0; i < _locationsList.count; i++)
    {
        tmp = [self comboBox: aComboBox objectValueForItemAtIndex: i];
        
        if ([[tmp lowercaseString] isEqualToString: lowerString]) {
            
            aComboBox.textColor = [NSColor textColor];
            return i;
        }
    }
    return -1;
}


- (nullable NSString *)comboBox:(NSComboBox *)aComboBox completedString:(NSString *)string
{
    NSString *lowerString = [string lowercaseString];
    NSString *tmp;
    
    for (int i = 0; i < _locationsList.count; i++)
    {
        @autoreleasepool {
            tmp = [self comboBox: aComboBox objectValueForItemAtIndex: i];
            
            if ([[tmp lowercaseString] hasPrefix: lowerString])
            {
                aComboBox.textColor = [NSColor textColor];
                return tmp;
            }
        }
    }
    
    aComboBox.textColor = [NSColor redColor];
    return nil;
}

@end

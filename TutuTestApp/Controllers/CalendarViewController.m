//
//  CalendarViewController.m
//  TutuTestApp
//
//  Created by Ekaterina Krasnova on 11/12/2016.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

#import "CalendarViewController.h"
#import "Constants.h"

@interface CalendarViewController () <PDTSimpleCalendarViewDelegate>

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.weekdayTextType = PDTSimpleCalendarViewWeekdayTextTypeVeryShort;
    self.weekdayHeaderEnabled = YES;
    self.delegate = self;
    
    //Set view bounds and status bar
    CGRect bounds = self.view.bounds;
    bounds.origin.y -= 20;
    [self.view setBounds:bounds];
    CGRect statusFrame = CGRectMake(0.0, -20.0, bounds.size.width, 20);
    UIView* statusBar = [[UIView alloc] initWithFrame:statusFrame];
    statusBar.backgroundColor = [UIColor whiteColor];
    [statusBar setAlpha:1.0f];
    [statusBar setOpaque:YES];
    [self.view addSubview:statusBar];
}

#pragma mark - PDTSimpleCalendarViewDelegate
- (void)simpleCalendarViewController:(PDTSimpleCalendarViewController *)controller didSelectDate:(NSDate *)date
{
    //Get picked date and convert it to NSString format
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    //Save picked date for key "pickedDate"
    [[NSUserDefaults standardUserDefaults]setValue:dateString forKey:kPickedDate];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadSegmentedController" object:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

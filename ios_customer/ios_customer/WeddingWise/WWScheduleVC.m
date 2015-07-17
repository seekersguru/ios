//
//  WWScheduleVC.m
//  WeddingWise
//
//  Created by Deepak Sharma on 6/20/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWScheduleVC.h"

@interface WWScheduleVC ()

@end

@implementation WWScheduleVC

- (void)viewDidLoad {
    
    [self.navigationController.navigationBar setHidden:YES];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    _scheduleTimeLabel.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)scheduleVisitAction:(id)sender {
    _scheduleTimeLabel.hidden = NO;
    //call api here
    
    NSDate *selectedDate = [_datePicker date];
    NSDate *selectedTime = [_timePicker date];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *date = [dateFormatter stringFromDate:selectedDate];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *time = [dateFormatter stringFromDate:selectedTime];
    
    [_scheduleTimeLabel setText:[NSString stringWithFormat:@"Visit scheduled at %@ %@",date,time]];
}
@end

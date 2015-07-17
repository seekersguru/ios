//
//  WWCalendarView.m
//  WeddingWise
//
//  Created by Deepak Sharma on 6/5/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWCalendarView.h"
#import "DSLCalendarView.h"
#import "AppDelegate.h"
#import "WWFilterVC.h"     

@interface WWCalendarView ()<DSLCalendarViewDelegate,FilterProtocolDelegate>
{
    NSArray *_pickerData;
}
@property (nonatomic, weak) IBOutlet DSLCalendarView *calendarView;
@end

@implementation WWCalendarView

- (void)viewDidLoad {
    _filterView.frame = CGRectMake(0, self.view.frame.size.height+60, self.view.frame.size.width, self.view.frame.size.height);
    [self.navigationController.navigationBar setHidden:YES];
    _pickerData=[[NSArray alloc]initWithObjects:@"January",
                                                @"February",
                                                @"March",
                                                @"April",
                                                @"May",
                                                @"June",
                                                @"July",
                                                @"August",
                                                @"September",
                                                @"October",
                                                @"November",
                                                @"December",
                                                nil];
    [_pickerView setHidden:YES];
    [_toolBar setHidden:YES];
    [_imgPickerBG setHidden:YES];
    
    _calendarView.showEventsOnCalloutView = YES;
    
    [_calendarView setEventsDictionary:@{@"2015":
                                             @{@"7":
                                                   @{@"1":@"5",
                                                     @"5":@"7"},
                                               @"8":
                                                     @{@"4":@"1",
                                                       @"12":@"2"}
                                               },
                                         @"2016":
                                                 @{@"1":
                                                       @{@"1":@"5",
                                                          @"5":@"7"},
                                                   @"2":
                                                       @{@"2":@"6"}
                                                   }
                                         }];
    [_calendarView showCalender];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)showPackageReadMoreView{
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
- (IBAction)filterButtonPressed:(id)sender {
    [self hidePickerView];
    [self showCustomFilterView];
    
//    CATransition* transition = [CATransition animation];
//    transition.duration = .3;
//    transition.type = kCATransitionReveal;
//    transition.subtype = kCATransitionFromBottom;
//    [self.view.window.layer addAnimation:transition forKey:kCATransition];
//    
//    WWFilterVC *flterVC=[[WWFilterVC alloc]initWithNibName:@"WWFilterVC" bundle:nil];
//    flterVC.delegate= self;
//    [self presentViewController:flterVC animated:NO completion:nil];
}
-(IBAction)submitButtonPressed:(id)sender{
    [self hideView];
}
-(void)showCustomFilterView{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _filterView.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-60);
                     }
                     completion:^(BOOL finished){
                     }];
}
-(void)hideView{
    
    [UIView animateWithDuration:0.3
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _filterView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                     }];

}
-(IBAction)showPicker:(id)sender{
    [self hideView];
    [self showPickerView];
}
-(void)showPickerView{
    [self.view endEditing:YES];
    [self.view addSubview:_pickerView];

    [_toolBar setFrame:CGRectMake(_toolBar.frame.origin.x, self.tabBarController.view.frame.size.height-45, _toolBar.frame.size.width, _toolBar.frame.size.height)];
    
    [_pickerView setFrame:CGRectMake(0, self.tabBarController.view.frame.size.height, _pickerView.frame.size.width, _pickerView.frame.size.height)];
    [_imgPickerBG setFrame:CGRectMake(0, self.tabBarController.view.frame.size.height, _imgPickerBG.frame.size.width, _imgPickerBG.frame.size.height)];

    [UIView animateWithDuration:0.3 animations:
     ^(void){
         [_pickerView setFrame:CGRectMake(0, self.view.frame.size.height - _pickerView.frame.size.height, _pickerView.frame.size.width, _pickerView.frame.size.height)];
         
         [_imgPickerBG setFrame:CGRectMake(0, self.view.frame.size.height - _imgPickerBG.frame.size.height, _imgPickerBG.frame.size.width, _imgPickerBG.frame.size.height)];
         
         [_toolBar setFrame:CGRectMake(_toolBar.frame.origin.x, self.tabBarController.view.frame.size.height - _pickerView.frame.size.height-45, _toolBar.frame.size.width, _toolBar.frame.size.height)];
         
         [_pickerView setHidden:NO];
         [_toolBar setHidden:NO];
         [_imgPickerBG setHidden:NO];
     }
                     completion:^(BOOL finished){
                         
                     }];
}
-(IBAction)btnDonePressed:(id)sender{
    [self hidePickerView];
}
-(void)hidePickerView{
    [UIView animateWithDuration:0.3 animations:
     ^(void){
         [_pickerView setFrame:CGRectMake(0, self.tabBarController.view.frame.size.height, _pickerView.frame.size.width, _pickerView.frame.size.height)];
         [_imgPickerBG setFrame:CGRectMake(0, self.tabBarController.view.frame.size.height, _imgPickerBG.frame.size.width, _imgPickerBG.frame.size.height)];
         [_pickerView setHidden:YES];
         [_toolBar setHidden:YES];
     }
                     completion:^(BOOL finished){
                         
                     }];
}
#pragma mark UIPicker view delegate & datasource methods:
// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
 
}
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{ NSAttributedString *attString ;
    
    attString = [[NSAttributedString alloc] initWithString:[_pickerData[row] uppercaseString] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    
    return attString;
    
}

#pragma mark - DSLCalendarViewDelegate methods
- (void)calendarView:(DSLCalendarView *)calendarView didSelectRange:(DSLCalendarRange *)range {
    if (range != nil) {
        NSLog( @"Selected %ld/%ld - %ld/%ld", (long)range.startDay.day, (long)range.startDay.month, (long)range.endDay.day, (long)range.endDay.month);
    }
    else {
        NSLog( @"No selection" );
    }
}

- (DSLCalendarRange*)calendarView:(DSLCalendarView *)calendarView didDragToDay:(NSDateComponents *)day selectingRange:(DSLCalendarRange *)range {
    if (NO) { // Only select a single day
        return [[DSLCalendarRange alloc] initWithStartDay:day endDay:day];
    }
    else if (NO) { // Don't allow selections before today
        NSDateComponents *today = [[NSDate date] dslCalendarView_dayWithCalendar:calendarView.visibleMonth.calendar];
        
        NSDateComponents *startDate = range.startDay;
        NSDateComponents *endDate = range.endDay;
        
        if ([self day:startDate isBeforeDay:today] && [self day:endDate isBeforeDay:today]) {
            return nil;
        }
        else {
            if ([self day:startDate isBeforeDay:today]) {
                startDate = [today copy];
            }
            if ([self day:endDate isBeforeDay:today]) {
                endDate = [today copy];
            }
            
            return [[DSLCalendarRange alloc] initWithStartDay:startDate endDay:endDate];
        }
    }
    
    return range;
}

- (void)calendarView:(DSLCalendarView *)calendarView willChangeToVisibleMonth:(NSDateComponents *)month duration:(NSTimeInterval)duration {
    NSLog(@"Will show %@ in %.3f seconds", month, duration);
}

- (void)calendarView:(DSLCalendarView *)calendarView didChangeToVisibleMonth:(NSDateComponents *)month {
    NSLog(@"Now showing %@", month);
}

- (BOOL)day:(NSDateComponents*)day1 isBeforeDay:(NSDateComponents*)day2 {
    return ([day1.date compare:day2.date] == NSOrderedAscending);
}

-(IBAction)backButtonPressed:(id)sender{
    AppDelegate *appDelegate=[[UIApplication sharedApplication]delegate];
    [appDelegate.navigation popViewControllerAnimated:YES];
}

- (void)filterDateType:(id)sender{
    
}

- (void)filterEnquiryType:(id)sender{
    
}

- (void)filterTimeType:(id)sender{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

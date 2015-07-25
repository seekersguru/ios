//
//  WWCreateBidVC.m
//  WeddingWise
//
//  Created by Deepak Sharma on 6/17/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWCreateBidVC.h"
#import "WWVendorDetailData.h"
#import "WWWebService.h"

@interface WWCreateBidVC ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
{
    NSMutableArray *packageList;
    NSMutableArray *packageOrder;
    NSMutableArray *currentArray;
    NSMutableArray *packageFinal;
    UIToolbar *doneEventToolbar;
    BOOL isFlexible;
    BOOL isTimeSlotTextField;
}
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *pickerArray;
@end

@implementation WWCreateBidVC

- (void)viewDidLoad {
    [super viewDidLoad];
    currentArray =[NSMutableArray new];
    packageFinal =[NSMutableArray new];
    
    [self.navigationController.navigationBar setHidden:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissDatePicker:)];
    [self.view addGestureRecognizer:tap];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    if (_requestType.length == 0) {
        _requestType = @"bid";
        //TODO:if not come from messagelist then directly assigning it to bid for now
        //it will depend on tab bar icons
    }
    BOOL hideFields = NO;
    if ([_requestType isEqualToString:@"book"]) {
        //set title
        [_headerTitleLabel setTitle:@"Create Booking" forState:UIControlStateNormal];
        [_submitButton setTitle:@"Book IT" forState:UIControlStateNormal];
        hideFields = YES;
        
        //set data
        [_packageLabel setText:[WWVendorBookingData sharedInstance].package[@"value"]];
        [_timeSlotTextField setText:[WWVendorBookingData sharedInstance].time_slot[0]];
        
        _pickerArray = [[WWVendorBookingData sharedInstance] time_slot];
    }
    else{
        //set title
        [_headerTitleLabel setTitle:@"Create Bid" forState:UIControlStateNormal];
        
        //set data
        [_packageLabel setText:[WWVendorBidData sharedInstance].package[@"value"]];
        [_timeSlotTextField setText:[WWVendorBidData sharedInstance].time_slot[0]];
    
        [_eventStaticLabel setText:[NSString stringWithFormat:@"%@",[WWVendorBidData sharedInstance].bidDictionary[@"event_date"]]];
        [_flexibleStaticLabel setText:[NSString stringWithFormat:@"%@",[WWVendorBidData sharedInstance].bidDictionary[@"flexible_date"]]];
        [_timeSlotStaticLabel setText:[NSString stringWithFormat:@"%@",[WWVendorBidData sharedInstance].bidDictionary[@"time_slot"][@"name"]]];
        [_packageStaticLabel setText:[NSString stringWithFormat:@"%@",[WWVendorBidData sharedInstance].bidDictionary[@"package"][@"name"]]];
        [_packageTextField setText:@"Select Package"];
         packageOrder= [[NSMutableArray alloc]initWithArray:[WWVendorBidData sharedInstance].bidDictionary[@"package"][@"package_order"] ];
        
        NSDictionary *dicPackecList=[WWVendorBidData sharedInstance].bidDictionary[@"package"][@"package_list"];
        for (NSString *strKey in packageOrder) {
            [packageFinal addObject:[dicPackecList valueForKey:strKey]];
        }
        [_submitButton setTitle:[NSString stringWithFormat:@"%@",[WWVendorBidData sharedInstance].bidDictionary[@"button"]] forState:UIControlStateNormal];
        _pickerArray = [[WWVendorBidData sharedInstance] time_slot];
    }
    
    [_bidPriceStaticLabel setHidden:hideFields];
    [_perPlateStaticLabel setHidden:hideFields];
    [_minPersonStaticLabel setHidden:hideFields];
    [_minPersonTextField setHidden:hideFields];
    [_bidPriceTextField setHidden:hideFields];
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216, self.view.frame.size.width, 150)];
    _pickerView.delegate = self;
    [_pickerView setBackgroundColor:[UIColor whiteColor]];
    [_datePicker setBackgroundColor:[UIColor whiteColor]];
    [_timeSlotTextField setInputView:_pickerView];
    [_packageTextField setInputView:_pickerView];
    
    UIToolbar *doneToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyboard:)];
    [doneToolbar setItems:@[item]];
    [_timeSlotTextField setInputAccessoryView:doneToolbar];
    [_packageTextField setInputAccessoryView:doneToolbar];
}

- (void)dismissKeyboard:(id)sender{
    [_timeSlotTextField resignFirstResponder];
    [_packageTextField resignFirstResponder];
}
-(IBAction)btnFlexiblePressed:(id)sender{
    if(isFlexible){
        isFlexible = NO;
        //Selec
        [_btnFlexible setImage:[UIImage imageNamed:@"radiobt"] forState:UIControlStateNormal];
    }
    else
    {
        isFlexible= YES;
        [_btnFlexible setImage:[UIImage imageNamed:@"radiobtMark"] forState:UIControlStateNormal];
        //
    }
}
-(IBAction)datePickerBtnAction:(id)sender
{
    _datePicker =[[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-216, self.view.frame.size.width, 100)];
    _datePicker.datePickerMode=UIDatePickerModeDate;
    _datePicker.hidden=NO;
    _datePicker.date=[NSDate date];
    [_datePicker addTarget:self action:@selector(LabelTitle:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_datePicker];
    
    doneEventToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-240, 320, 44)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismissDatePicker:)];
    [doneEventToolbar setItems:@[item]];
    [self.view addSubview:doneEventToolbar];
}
- (void)dismissDatePicker:(id)sender{
    [_datePicker setFrame:CGRectMake(0, 568, self.view.frame.size.width, 150)];
    [doneEventToolbar setFrame:CGRectMake(0, 568, self.view.frame.size.width, 150)];
    
}
-(void)LabelTitle:(id)sender
{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *str=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:_datePicker.date]];
    //_eventDateLabel.text=str;
    [_eventDateButton setTitle:str forState:UIControlStateNormal];
}


#pragma mark - pickerview delegates/datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return currentArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return currentArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(isTimeSlotTextField)
        [_timeSlotTextField setText:currentArray[row]];
    else{
        [_packageTextField setText:currentArray[row]];
        [_packageLabel setText:[packageFinal objectAtIndex:row][@"description"]];
        
    }
    
}

#pragma mark - textfield delegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [currentArray removeAllObjects];
    
    if (textField == _timeSlotTextField){
        [currentArray addObjectsFromArray:_pickerArray];
        isTimeSlotTextField= YES;
    }
    else if(textField == _packageTextField){
        for (NSDictionary *dicValue in packageFinal) {
            [currentArray addObject:[dicValue valueForKey:@"select_val"]];
        }
        isTimeSlotTextField= NO;
    }
    [_pickerView reloadAllComponents];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _timeSlotTextField){
        isTimeSlotTextField= YES;
    }
    else if(textField == _packageTextField) {
        isTimeSlotTextField= NO;
    }
    
    [textField resignFirstResponder];
    return YES;
}
- (void)bidItAction:(id)sender{
    NSString *json_string = nil;
    if ([_requestType isEqualToString:@"bid"]) {
        //check validations for bid price
        NSString *errorMessage = nil;
        if ([_bidPriceTextField.text  floatValue] > [WWVendorBidData sharedInstance].maxItemPerPlate.floatValue || [_bidPriceTextField.text floatValue] < [WWVendorBidData sharedInstance].minItemPerPlate.floatValue) {
            errorMessage = [NSString stringWithFormat:@"Bid Price should be in range of %@-%@",[WWVendorBidData sharedInstance].minItemPerPlate,[WWVendorBidData sharedInstance].maxItemPerPlate];
        }
        else if ([_minPersonTextField.text integerValue] > [WWVendorBidData sharedInstance].maxPerson.integerValue || [_minPersonTextField.text integerValue] < [WWVendorBidData sharedInstance].minPerson.integerValue){
            errorMessage = [NSString stringWithFormat:@"Persons should be in range of %@-%@",[WWVendorBidData sharedInstance].minPerson,[WWVendorBidData sharedInstance].maxPerson];
        }
        if (errorMessage) {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            return;
        }
        NSData *data = [NSJSONSerialization dataWithJSONObject:[WWVendorBidData sharedInstance].bidDictionary options:NSJSONWritingPrettyPrinted error:nil];
        json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    else{
        NSData *data = [NSJSONSerialization dataWithJSONObject:[WWVendorBookingData sharedInstance].bookDictionary options:NSJSONWritingPrettyPrinted error:nil];
        json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    NSDictionary *requestDict = @{@"identifier" : [[NSUserDefaults standardUserDefaults]
                                                   stringForKey:@"identifier"],
                                  @"receiver_email" : [WWVendorDetailData sharedInstance].vendorEmail,
                                  @"message" : @"posting bid",
                                  @"from_to" : @"c2v",
                                  @"action" : @"customer_vendor_message_create",
                                  @"mode" : @"mode",
                                  @"device_id" : @"123123",
                                  @"push_data" : @"posting bid",
                                  @"msg_type" : @"bid",
                                  @"event_date" : _eventDateButton.titleLabel.text,    //TODO:date should be dynamic, Will do later
                                  @"bid_json" : json_string,
                                  @"time_slot" : _timeSlotTextField.text,
                                  @"bid_price" : _bidPriceTextField.text,
                                  @"bid_quantity" : _minPersonTextField.text};
    
    [[WWWebService sharedInstanceAPI] callWebService:requestDict imgData:nil loadThreadWithCompletion:^(NSDictionary *response) {
        if([[response valueForKey:@"result"] isEqualToString:@"error"]){
            [[WWCommon getSharedObject]createAlertView:kAppName :[response valueForKey:@"message"] :nil :000 ];
        }
        else if ([[response valueForKey:@"result"] isEqualToString:@"success"]){
            NSString *successMsg = nil;
            if ([_requestType isEqualToString:@"bid"]) {
                successMsg = @"Bid successfully created";
            }
            else{
                successMsg = @"Booking successfully created";
            }
            [[WWCommon getSharedObject]createAlertView:@"" :successMsg :nil :000 ];
            //go back to vendor detail page
            self.tabBarController.selectedIndex = 0;
        }
    } failure:^(NSString *failureResponse) {
        
    }];
}
-(IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

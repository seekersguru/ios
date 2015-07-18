//
//  WWRegistrationVC.m
//  WeddingWise
//
//  Created by Deepak Sharma on 5/20/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWRegistrationVC.h"
#import "WWCommon.h"
#import "UITextField+ADTextField.h"

@interface WWRegistrationVC ()<MBProgressHUDDelegate>

@property (nonatomic) BOOL isViewPositionOffset;

@end

@implementation WWRegistrationVC

- (void)viewDidLoad {
    //[self setTextFieldPlacehoder];
    [[WWCommon getSharedObject]setCustomFont:11.0 withLabel:lblPolicy withText:lblPolicy.text];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    _bgImage.image= _image;
    
    [_datePicker setHidden:YES];
     [_imgDatePicker setHidden:YES];
    
    if(_fbResponse){
        [self fillFaceBookData];
    }
    
    [super viewDidLoad];
}
-(void)fillFaceBookData{
    [_txtEmailAddress setEnabled:NO];
    _txtEmailAddress.text= [_fbResponse valueForKey:@"email"];
}
-(void)setTextFieldPlacehoder{
    [_txtEmailAddress setTextFieldPlaceholder:@"Email Address" withcolor:[UIColor grayColor] withPadding:_txtEmailAddress];
    [_txtPassword setTextFieldPlaceholder:@"Password" withcolor:[UIColor grayColor] withPadding:_txtPassword];
    [_txtGroomName setTextFieldPlaceholder:@"Groom Name" withcolor:[UIColor grayColor] withPadding:_txtGroomName];
    [_txtBrideName setTextFieldPlaceholder:@"Bride Name" withcolor:[UIColor grayColor] withPadding:_txtBrideName];
    [_txtContactNo setTextFieldPlaceholder:@"Contact number" withcolor:[UIColor grayColor] withPadding:_txtContactNo];
}

#pragma mark: IBAction & utility methods:
-(void)dismissKeyboard {
    [_txtEmailAddress resignFirstResponder];
    [_txtPassword resignFirstResponder];
    [_txtGroomName resignFirstResponder];
    [_txtBrideName resignFirstResponder];
    [_txtContactNo resignFirstResponder];
    [_datePicker setHidden:YES];
    [_imgDatePicker setHidden:YES];
}
-(IBAction)btnSignUpPressed:(id)sender{
    [self dismissKeyboard];
    if([self checkValidations]){
        //Call web service
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        
        // Regiser for HUD callbacks so we can remove it from the window at the right time
        HUD.delegate = self;
        
        // Show the HUD while the provided method executes in a new thread
        [HUD showWhileExecuting:@selector(callRegistrationAPI) onTarget:self withObject:nil animated:YES];
    }
}
-(IBAction)btnTentativeDatePressed:(id)sender{
    [_datePicker setHidden:NO];
    [_imgDatePicker setHidden:NO];
    
    //Show only last 100 years dates in picker:
    NSCalendar * gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    NSDate * currentDate = [NSDate date];
    NSDateComponents * comps = [[NSDateComponents alloc] init];
    [comps setYear: +1];
    NSDate * maxDate = [gregorian dateByAddingComponents: comps toDate: currentDate options: 0];
    [comps setYear: +1];
    _datePicker.minimumDate = currentDate;
    _datePicker.maximumDate = maxDate;
    _datePicker.date = currentDate;
    
    
}
-(void)callRegistrationAPI{
    NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                 _txtEmailAddress.text,@"email",
                                 _txtPassword.text,@"password",
                                 _txtGroomName.text,@"groom_name",
                                 _txtBrideName.text,@"bride_name",
                                 _txtContactNo.text,@"contact_number",
                                 @"customer_registration",@"action",
                                 nil];
    
    [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         if([[responseDics valueForKey:@"result"] isEqualToString:@"error"]){
             [[WWCommon getSharedObject]createAlertView:kAppName :[responseDics valueForKey:@"message"] :nil :000 ];
         }
         else if ([[responseDics valueForKey:@"result"] isEqualToString:@"success"]){
             //Login successfully
             dispatch_async(dispatch_get_main_queue(), ^{
                 UITabBarController *tabVC = [[AppDelegate sharedAppDelegate]setupViewControllers:nil];
                 [self.navigationController pushViewController:tabVC animated:YES];
             });
         }
     }
                                             failure:^(NSString *response)
     {
         DLog(@"%@",response);
     }];
}

-(IBAction)btnBackPressed:(id)sender{
    [self dismissKeyboard];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)checkValidations{
    if (_txtEmailAddress.text && _txtEmailAddress.text.length == 0)
    {
        [[WWCommon getSharedObject]createAlertView:kAppName :kEnterEmail :nil :000 ];
        return NO;
    }
    if (_txtPassword.text && _txtPassword.text.length == 0)
    {
        [[WWCommon getSharedObject]createAlertView:kAppName :kEnterPassword :nil :000 ];
        return NO;
    }
    if (_txtBrideName.text && _txtBrideName.text.length == 0)
    {
        [[WWCommon getSharedObject]createAlertView:kAppName :kEnterBrideName :nil :000 ];
        return NO;
    }
    if (_txtGroomName.text && _txtGroomName.text.length == 0)
    {
        [[WWCommon getSharedObject]createAlertView:kAppName :kGroomName :nil :000 ];
        return NO;
    }
    if (_txtContactNo.text && _txtContactNo.text.length == 0)
    {
        [[WWCommon getSharedObject]createAlertView:kAppName :kEnterPassword :nil :000 ];
        return NO;
    }
    if(_txtEmailAddress.text.length>0){
        if(![[WWCommon getSharedObject] validEmail:_txtEmailAddress.text]){
            [[WWCommon getSharedObject]createAlertView:kAppName :kValidEmail :nil :000 ];
            return NO;
        }
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [self toggleAnimation:textField];
}
- (void)toggleAnimation:(UITextField*)textField {
    int keyboardSize = 216;
    int viewHeight = self.view.frame.size.height;
    if(textField.frame.origin.y > (viewHeight - keyboardSize-50)) {
        int targetYPosition=0;
        if (textField == self.txtPassword){
            targetYPosition = _txtEmailAddress.frame.origin.y;
        }
        else if (textField== _txtBrideName){
            targetYPosition = _txtPassword.frame.origin.y;
        }
        else if(textField== _txtGroomName){
            targetYPosition = _txtBrideName.frame.origin.y;
        }
        else if(textField== _txtContactNo){
            targetYPosition = _txtGroomName.frame.origin.y;
        }
        int diffY = textField.frame.origin.y - targetYPosition;
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = self.view.frame;
            if(self.isViewPositionOffset) {
                self.isViewPositionOffset = NO;
                frame.origin.y += diffY;
            } else {
                self.isViewPositionOffset = YES;
                frame.origin.y -= diffY;
            }
            [self.view setFrame:frame];
        }];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self toggleAnimation:textField];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==_txtEmailAddress){
        [_txtPassword becomeFirstResponder];
    }
    else if(textField==_txtPassword){
        [_txtBrideName becomeFirstResponder];
    }
    else if(textField==_txtBrideName){
        [_txtGroomName becomeFirstResponder];
    }
    else if(textField==_txtGroomName){
        [_txtContactNo becomeFirstResponder];
    }
    else if(textField==_txtContactNo){
        [_txtContactNo resignFirstResponder];
    }
    return YES;
}
@end

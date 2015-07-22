//
//  WWProfileVC.m
//  WeddingWise
//
//  Created by Deepak Sharma on 7/21/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWProfileVC.h"

@interface WWProfileVC ()<MBProgressHUDDelegate>
@property (nonatomic) BOOL isViewPositionOffset;

@end

@implementation WWProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    
    [[WWCommon getSharedObject]setCustomFont:17.0 withLabel:_btnTentativeDate withText:_btnTentativeDate.titleLabel.text];
    [[WWCommon getSharedObject]setCustomFont:17.0 withLabel:_txtEmailAddress withText:_txtEmailAddress.text];
    [[WWCommon getSharedObject]setCustomFont:17.0 withLabel:_txtGroomName withText:_txtGroomName.text];
    [[WWCommon getSharedObject]setCustomFont:17.0 withLabel:_txtBrideName withText:_txtBrideName.text];
    [[WWCommon getSharedObject]setCustomFont:17.0 withLabel:_txtContactNo withText:_txtContactNo.text];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    [_datePicker setHidden:YES];
    [_imgDatePicker setHidden:YES];
    
    [self getUserProfileAPI];
}

#pragma mark: IBAction & utility methods:
-(void)dismissKeyboard {
    [_txtEmailAddress resignFirstResponder];
    [_txtGroomName resignFirstResponder];
    [_txtBrideName resignFirstResponder];
    [_txtContactNo resignFirstResponder];
    [_datePicker setHidden:YES];
    [_imgDatePicker setHidden:YES];
}
-(void)getUserProfileAPI{
    NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                 _txtEmailAddress.text,@"email",
                                 _txtGroomName.text,@"groom_name",
                                 _txtBrideName.text,@"bride_name",
                                 _txtContactNo.text,@"contact_number",
                                 @"get",@"operation",
                                 [AppDelegate sharedAppDelegate].userData.identifier,@"identifier",
                                 @"customer_registration",@"action",
                                 nil];
    
    [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         if([[responseDics valueForKey:@"result"] isEqualToString:@"error"]){
             [[WWCommon getSharedObject]createAlertView:kAppName :[responseDics valueForKey:@"message"] :nil :000 ];
         }
         else if ([[responseDics valueForKey:@"result"] isEqualToString:@"success"]){
             WWLoginUserData *userData=[[WWLoginUserData alloc]setUserData:[responseDics valueForKey:@"json"]];
             [AppDelegate sharedAppDelegate].userData= userData;
         }
     }
                                             failure:^(NSString *response)
     {
         DLog(@"%@",response);
     }];
}

-(IBAction)updateUserProfile:(id)sender{
    
    [self dismissKeyboard];
    if([self checkValidations]){
        //Call web service
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        
        // Regiser for HUD callbacks so we can remove it from the window at the right time
        HUD.delegate = self;
        
        // Show the HUD while the provided method executes in a new thread
        [HUD showWhileExecuting:@selector(updateUserProfile) onTarget:self withObject:nil animated:YES];
    }
}
-(void)updateUserProfile{
    NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                 _txtEmailAddress.text,@"email",
                                 _txtGroomName.text,@"groom_name",
                                 _txtBrideName.text,@"bride_name",
                                 _txtContactNo.text,@"contact_number",
                                 @"update",@"operation",
                                 [AppDelegate sharedAppDelegate].userData.identifier,@"identifier",
                                 @"customer_registration",@"action",
                                 nil];
    
    [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         if([[responseDics valueForKey:@"result"] isEqualToString:@"error"]){
             [[WWCommon getSharedObject]createAlertView:kAppName :[responseDics valueForKey:@"message"] :nil :000 ];
         }
         else if ([[responseDics valueForKey:@"result"] isEqualToString:@"success"]){
             WWLoginUserData *userData=[[WWLoginUserData alloc]setUserData:[responseDics valueForKey:@"json"]];
             [AppDelegate sharedAppDelegate].userData= userData;
         }
     }
                                             failure:^(NSString *response)
     {
         DLog(@"%@",response);
     }];
}
-(BOOL)checkValidations{
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
    if (_btnTentativeDate.titleLabel.text && _btnTentativeDate.titleLabel.text.length == 0)
    {
        [[WWCommon getSharedObject]createAlertView:kAppName :kTentativeDate :nil :000 ];
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

-(IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnTentativeDatePressed:(id)sender{
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self toggleAnimation:textField];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==_txtEmailAddress){
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
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [self toggleAnimation:textField];
}
- (void)toggleAnimation:(UITextField*)textField {
    int keyboardSize = 216;
    int viewHeight = self.view.frame.size.height;
    if(textField.frame.origin.y > (viewHeight - keyboardSize-50)) {
        int targetYPosition=0;
        if (textField== _txtBrideName){
            targetYPosition = _txtEmailAddress.frame.origin.y;
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

//
//  WWRegistrationVC.m
//  WeddingWise
//
//  Created by Deepak Sharma on 5/20/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWRegistrationVC.h"


@interface WWRegistrationVC ()

@property (nonatomic) BOOL isViewPositionOffset;

@end

@implementation WWRegistrationVC

- (void)viewDidLoad {
    
    [self setTextFieldPlacehoder];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    [self.navigationController.navigationBar setHidden:YES];
    
    
    [super viewDidLoad];
}
-(void)setTextFieldPlacehoder{
    [_txtEmailAddress setTextFieldPlaceholder:@"Email Address" withcolor:[UIColor darkGrayColor] withPadding:_txtEmailAddress];
    [_txtPassword setTextFieldPlaceholder:@"Password" withcolor:[UIColor darkGrayColor] withPadding:_txtPassword];
    [_txtGroomName setTextFieldPlaceholder:@"Groom Name" withcolor:[UIColor darkGrayColor] withPadding:_txtGroomName];
    [_txtBrideName setTextFieldPlaceholder:@"Bride Name" withcolor:[UIColor darkGrayColor] withPadding:_txtBrideName];
    [_txtAreaName setTextFieldPlaceholder:@"Area where to looking marry" withcolor:[UIColor darkGrayColor] withPadding:_txtAreaName];
    [_txtContactNumber setTextFieldPlaceholder:@"Contact Number" withcolor:[UIColor darkGrayColor] withPadding:_txtAreaName];
}

#pragma mark: IBAction & utility methods:
-(void)dismissKeyboard {
    [_txtEmailAddress resignFirstResponder];
    [_txtPassword resignFirstResponder];
    [_txtGroomName resignFirstResponder];
    [_txtBrideName resignFirstResponder];
    [_txtAreaName resignFirstResponder];
    [_txtContactNumber resignFirstResponder];
}
-(IBAction)btnSignUpPressed:(id)sender{
    [self dismissKeyboard];
    if([self checkValidations]){
        //Call web service
    }
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
        [[WWCommon getSharedObject]createAlertView:@"Wedding Wise" :@"Please enter email address." :nil :000 ];
        return NO;
    }
    if (_txtPassword.text && _txtPassword.text.length == 0)
    {
        [[WWCommon getSharedObject]createAlertView:@"Wedding Wise" :@"Please enter password." :nil :000 ];
        return NO;
    }
    if (_txtBrideName.text && _txtBrideName.text.length == 0)
    {
        [[WWCommon getSharedObject]createAlertView:@"Wedding Wise" :@"Please enter first name." :nil :000 ];
        return NO;
    }
    if (_txtGroomName.text && _txtGroomName.text.length == 0)
    {
        [[WWCommon getSharedObject]createAlertView:@"Wedding Wise" :@"Please enter last name." :nil :000 ];
        return NO;
    }
    if (_txtContactNumber.text && _txtContactNumber.text.length == 0)
    {
        [[WWCommon getSharedObject]createAlertView:@"Wedding Wise" :@"Please enter contact number." :nil :000 ];
        return NO;
    }
    if(_txtEmailAddress.text.length>0){
        if(![[WWCommon getSharedObject] validEmail:_txtEmailAddress.text]){
            
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
        else if(textField== _txtAreaName){
            targetYPosition = _txtGroomName.frame.origin.y;
        }
        else if(textField== _txtContactNumber){
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
        [_txtAreaName becomeFirstResponder];
    }
    else if(textField==_txtAreaName){
        [_txtContactNumber becomeFirstResponder];
    }
    else if(textField==_txtContactNumber){
        [_txtContactNumber resignFirstResponder];
    }
    return YES;
}
@end

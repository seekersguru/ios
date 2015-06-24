//
//  WWLoginVC.m
//  WeddingWise
//
//  Created by Deepak Sharma on 5/20/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWLoginVC.h"
#import "WWRegistrationVC.h"
#import "UITextField+ADTextField.h"
#import "WWCommon.h"
#import "AppDelegate.h"
#import "MyKnotList.h"
#import "WWForgotPassword.h"
#import "AppDelegate.h"

@interface WWLoginVC ()

@end
//Client secret= r4c6Lvxfq99AGauizFsS-Ffw
//Bundle id: com.weddingwise.app



@implementation WWLoginVC


#pragma mark View life cycle methods:
- (void)viewDidLoad {
    //[self setTextFieldPlacehoder];
   
   // [self.navigationController.navigationBar setHidden:YES];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark IBAction & utility methods:
-(void)dismissKeyboard {
    [_txtEmailAddress resignFirstResponder];
    [_txtPassword resignFirstResponder];
}
-(void)setTextFieldPlacehoder{
    [_txtEmailAddress setTextFieldPlaceholder:@"Email Address" withcolor:[UIColor whiteColor] withPadding:_txtEmailAddress];
    [_txtPassword setTextFieldPlaceholder:@"Password" withcolor:[UIColor whiteColor] withPadding:_txtPassword];
}
-(IBAction)btnSignInPressed:(id)sender{
    [[AppDelegate sharedAppDelegate]setupViewControllers:self.navigationController];
}
-(IBAction)btnBackPressed:(id)sender{
    [self dismissKeyboard];
    [self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)checkValidations{
    if (_txtEmailAddress.text && _txtEmailAddress.text.length == 0)
    {
        [[WWCommon getSharedObject]createAlertView:@"Wedding Wise" :@"Please enter email address" :nil :000 ];
        return YES;
    }
    if (_txtPassword.text && _txtPassword.text.length == 0)
    {
        [[WWCommon getSharedObject]createAlertView:@"Wedding Wise" :@"Please enter password" :nil :000 ];
        return YES;
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [self toggleAnimation:textField];
}
- (void)toggleAnimation:(UITextField*)textField {
    
    
}
-(IBAction)btnGoogleLoginPressed:(id)sender{
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self toggleAnimation:textField];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==_txtEmailAddress){
        [self.txtPassword becomeFirstResponder];
    }
    else if(textField==_txtPassword){
        [_txtPassword resignFirstResponder];
    }
    return YES;
}
-(IBAction)btnForgotPasswordPressed:(id)sender{
    WWForgotPassword *forgotPasowrd=[[WWForgotPassword alloc]initWithNibName:@"WWForgotPassword" bundle:nil];
    [self.navigationController pushViewController:forgotPasowrd animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  WWLoginVC.h
//  WeddingWise
//
//  Created by Deepak Sharma on 5/20/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GooglePlus/GooglePlus.h>
@class GPPSignInButton;

@interface WWDashboardVC : UIViewController<GPPSignInDelegate>
{
    IBOutlet FBSDKLoginButton *loginButton;
    IBOutlet UILabel *lblPolicy;
}

@property (retain, nonatomic) IBOutlet GPPSignInButton *signInButton;
@property(nonatomic, weak)IBOutlet UIButton *btnSignUp;
@property(nonatomic, weak)IBOutlet UIButton *btnLogin;


-(IBAction)googleSignIn:(id)sender;
@end

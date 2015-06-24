//
//  WWRegistrationVC.h
//  WeddingWise
//
//  Created by Deepak Sharma on 5/20/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWRegistrationVC : UIViewController

@property(nonatomic, weak)IBOutlet UITextField *txtEmailAddress;
@property(nonatomic, weak)IBOutlet UITextField *txtPassword;
@property(nonatomic, weak)IBOutlet UITextField *txtGroomName;
@property(nonatomic, weak)IBOutlet UITextField *txtBrideName;
@property(nonatomic, weak)IBOutlet UITextField *txtAreaName;
@property(nonatomic, weak)IBOutlet UITextField *txtContactNumber;

-(IBAction)btnSignUpPressed:(id)sender;
-(IBAction)btnBackPressed:(id)sender;
@end

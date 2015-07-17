//
//  WWRegistrationVC.h
//  WeddingWise
//
//  Created by Deepak Sharma on 5/20/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWRegistrationVC : UIViewController
{
    IBOutlet UILabel *lblPolicy;
}
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIImageView *imgDatePicker;
@property(nonatomic, weak)IBOutlet UITextField *txtEmailAddress;
@property(nonatomic, weak)IBOutlet UITextField *txtPassword;
@property(nonatomic, weak)IBOutlet UITextField *txtGroomName;
@property(nonatomic, weak)IBOutlet UITextField *txtBrideName;
@property(nonatomic, weak)IBOutlet UITextField *txtContactNo;

@property(nonatomic, weak)IBOutlet UIImageView *bgImage;
@property(nonatomic, strong)UIImage *image;

@property(nonatomic, strong)NSDictionary *fbResponse;
-(IBAction)btnSignUpPressed:(id)sender;
-(IBAction)btnBackPressed:(id)sender;
-(IBAction)btnTentativeDatePressed:(id)sender;
@end
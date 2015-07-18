//
//  WWCreateBidVC.h
//  WeddingWise
//
//  Created by Dotsquares on 6/17/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWCreateBidVC : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *headerTitleLabel;
@property (nonatomic, strong) NSString *requestType;    //it will be bid/booking
@property (weak, nonatomic) IBOutlet UITextField *timeSlotTextField;
@property (weak, nonatomic) IBOutlet UILabel *packageLabel;
@property (weak, nonatomic) IBOutlet UILabel *QuotedPriceLabel;
@property (weak, nonatomic) IBOutlet UITextField *bidPriceTextField;
@property (weak, nonatomic) IBOutlet UITextField *minPersonTextField;
@property (weak, nonatomic) IBOutlet UILabel *quotedPriceStaticLabel;
@property (weak, nonatomic) IBOutlet UILabel *bidPriceStaticLabel;
@property (weak, nonatomic) IBOutlet UILabel *perPlateStaticLabel;
@property (weak, nonatomic) IBOutlet UILabel *minPersonStaticLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)bidItAction:(id)sender;
-(IBAction)backButtonPressed:(id)sender;
@end

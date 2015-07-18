//
//  WWDetailScreen.h
//  WeddingWise
//
//  Created by Deepak Sharma on 6/10/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWDetailScreen : UIViewController
@property(nonatomic, weak)IBOutlet UITableView *tblCategory;
@property(nonatomic, strong) NSArray *vendorList;
@property (weak, nonatomic) IBOutlet UIButton *vendorNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *filterTextfield;
@property (weak, nonatomic) IBOutlet UIView *filterView;

- (IBAction)filterTypeSelection:(id)sender;

- (IBAction)filterVendor:(id)sender;
- (IBAction)submitFilterAction:(id)sender;

-(IBAction)backButtonPressed:(id)sender;
@end

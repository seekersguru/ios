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
@property(nonatomic, weak)IBOutlet UITableView *tblContryName;



@property(nonatomic, strong) NSArray *vendorList;
@property (weak, nonatomic) IBOutlet UIButton *vendorNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *filterTextfield;
@property (weak, nonatomic) IBOutlet UITextField *searchTextfield;
@property(nonatomic, weak) IBOutlet UIButton *venueTypeButton;
@property(nonatomic, weak) IBOutlet UIButton *priceRangeButton;
@property(nonatomic, weak) IBOutlet UIButton *searchButton;

@property (weak, nonatomic) IBOutlet UIView *filterView;
@property(weak, nonatomic) IBOutlet UILabel *lblNoDataFound;


-(IBAction)filterTypeSelection:(id)sender;
- (IBAction)filterVendor:(id)sender;
- (IBAction)submitFilterAction:(id)sender;
-(IBAction)backButtonPressed:(id)sender;

-(IBAction)venueTypeClicked:(id)sender;
-(IBAction)pricechangedClicked:(id)sender;

@end

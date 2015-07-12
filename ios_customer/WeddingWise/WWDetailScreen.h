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
@property(nonatomic, strong)NSString *vendorType;



-(IBAction)backButtonPressed:(id)sender;
@end

//
//  wwCategoryFooterCell.h
//  WeddingWise
//
//  Created by Deepak Sharma on 7/14/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FooterCellDelegate <NSObject>
- (void)bidButtonClicked;
- (void)bookButtonClicked;

@required

@end

@interface WWCategoryFooterCell : UITableViewCell
{
    id <FooterCellDelegate> _delegate;
}

@property (nonatomic,strong) id delegate;

@property(nonatomic, weak)IBOutlet UIButton *btnBid;
@property(nonatomic, weak)IBOutlet UIButton *btnBook;

-(IBAction)bidButtonPressed:(id)sender;
-(IBAction)bookButtonPressed:(id)sender;

@end

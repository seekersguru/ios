//
//  WWCategoryListingCell.h
//  WeddingWise
//
//  Created by Dotsquares on 6/16/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FacilityDelegate <NSObject>

@required
- (void)showFacilityReadMoreView;

@end
@interface WWCategoryListingCell : UITableViewCell
{
    id <FacilityDelegate> _delegate;
}
@property(nonatomic, weak)IBOutlet UIButton *btnReadMore;

-(IBAction)readMorePressed:(id)sender;
@property (nonatomic,strong) id delegate;
@end

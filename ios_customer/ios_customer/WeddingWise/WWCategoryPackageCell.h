//
//  WWCategoryPackageCell.h
//  WeddingWise
//
//  Created by Deepak Sharma on 6/22/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PackageDelegate <NSObject>

@required
- (void)showPackageReadMoreView;

@end
@interface WWCategoryPackageCell : UITableViewCell
{
    id <PackageDelegate> _delegate;
}
@property(nonatomic, weak)IBOutlet UIButton *btnReadMore;
-(IBAction)readMorePressed:(id)sender;
@property (nonatomic,strong) id delegate;
@end

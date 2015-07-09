//
//  WWCategoryImageCell.h
//  WeddingWise
//
//  Created by Dotsquares on 6/16/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ImageCellDelegate <NSObject>

@required
- (void)showVideoPlayer;

@end

@interface WWCategoryImageCell : UITableViewCell

{
    id <ImageCellDelegate> _delegate;
}
@property(nonatomic, weak)IBOutlet UIImageView *categoryImage;
@property(nonatomic, weak)IBOutlet UIButton *btnVideoLink;
@property(nonatomic, weak)IBOutlet UIButton *btnImage;

-(IBAction)showVideoPlayerView:(id)sender;
@property (nonatomic,strong) id delegate;

@end

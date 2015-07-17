//
//  WWCategoryImageCell.m
//  WeddingWise
//
//  Created by Dotsquares on 6/16/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWCategoryImageCell.h"

@implementation WWCategoryImageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(IBAction)showVideoPlayerView:(id)sender{
    [self.delegate showVideoPlayer];
}

- (void)showImagesFromArray:(NSArray *)imageLinks{
    for (int i = 0; i < imageLinks.count; i++) {
        NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://wedwise.work%@",imageLinks[i]]];
        
        CGRect frame = CGRectMake(i*self.categoryImageScrollView.frame.size.width, 0, self.categoryImageScrollView.frame.size.width, self.categoryImageScrollView.frame.size.height);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        UIImage *placeholderImage = [UIImage imageNamed:@"your_placeholder"];
        [imageView setImageWithURL:imageUrl placeholderImage:placeholderImage];
        [self.categoryImageScrollView addSubview:imageView];
    }
    [self.categoryImageScrollView setPagingEnabled:YES];
    [self.categoryImageScrollView setContentSize:CGSizeMake(imageLinks.count*self.categoryImageScrollView.frame.size.width, 0)];
}
@end

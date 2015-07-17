//
//  WWCategoryMapCell.m
//  WeddingWise
//
//  Created by Dotsquares on 6/16/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWCategoryMapCell.h"

@implementation WWCategoryMapCell

- (void)awakeFromNib {
    // Initialization code
    
}
-(IBAction)showFullMapView:(id)sender{
    [self.delegate showMapFullView];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

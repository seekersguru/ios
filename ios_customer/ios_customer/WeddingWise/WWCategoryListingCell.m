//
//  WWCategoryListingCell.m
//  WeddingWise
//
//  Created by Dotsquares on 6/16/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWCategoryListingCell.h"

@implementation WWCategoryListingCell

- (void)awakeFromNib {
    // Initialization code
    //[_btnReadMore.layer setBorderColor:[UIColor redColor].CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(IBAction)readMorePressed:(id)sender{
    [self.delegate showFacilityReadMoreView];
}
@end

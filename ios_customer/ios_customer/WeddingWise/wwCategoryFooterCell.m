//
//  wwCategoryFooterCell.m
//  WeddingWise
//
//  Created by Deepak Sharma on 7/14/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWCategoryFooterCell.h"

@implementation WWCategoryFooterCell

- (void)awakeFromNib {
    // Initialization code
}

-(IBAction)bidButtonPressed:(id)sender{
    [self.delegate bidButtonClicked];
}
-(IBAction)bookButtonPressed:(id)sender{
    [self.delegate bookButtonClicked];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

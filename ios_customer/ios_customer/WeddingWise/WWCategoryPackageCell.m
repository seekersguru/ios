//
//  WWCategoryPackageCell.m
//  WeddingWise
//
//  Created by Deepak Sharma on 6/22/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWCategoryPackageCell.h"

@implementation WWCategoryPackageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(IBAction)readMorePressed:(id)sender{
    [self.delegate showPackageReadMoreView];
}
@end

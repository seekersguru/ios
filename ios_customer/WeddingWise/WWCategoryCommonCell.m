//
//  WWCategoryCommonCell.m
//  WeddingWise
//
//  Created by Deepak Sharma on 7/8/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWCategoryCommonCell.h"

@implementation WWCategoryCommonCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setCommonData:(NSDictionary*)dicData withIndexPath:(NSIndexPath*)index{
    _key.text=[NSString stringWithFormat:@"%@",[[dicData allKeys] objectAtIndex:0]];
    _value.text=[NSString stringWithFormat:@"%@",[dicData valueForKey:[[dicData allKeys] objectAtIndex:0]]];
}
@end

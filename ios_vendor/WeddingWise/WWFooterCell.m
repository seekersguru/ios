//
//  WWFooterCell.m
//  WeddingWise
//
//  Created by Deepak Sharma on 6/25/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWFooterCell.h"

@implementation WWFooterCell

- (void)awakeFromNib {
    // Initialization code
    _btnAccept.layer.borderWidth = 1;
    _btnAccept.layer.borderColor = [UIColor redColor].CGColor;
    
    _btnRebid.layer.borderWidth = 1;
    _btnRebid.layer.borderColor = [UIColor redColor].CGColor;
    
    _btnReject.layer.borderWidth = 1;
    _btnReject.layer.borderColor = [UIColor redColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

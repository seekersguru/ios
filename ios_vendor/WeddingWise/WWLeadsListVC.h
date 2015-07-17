//
//  WWLeadsListVC.h
//  WeddingWise
//
//  Created by Deepak Sharma on 6/24/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWLeadsListVC : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UIButton *bidBtn;
    IBOutlet UIButton *bookBtn;
    IBOutlet UIImageView *selectorImage;
}
@property(nonatomic, weak)IBOutlet UITableView *tblBidView;
@end

//
//  WWPrivateMessage.h
//  WeddingWise
//
//  Created by Deepak Sharma on 6/14/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWPrivateMessage : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, weak)IBOutlet UITableView *tblMessage;

@end

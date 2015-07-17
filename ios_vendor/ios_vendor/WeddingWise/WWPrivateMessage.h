//
//  WWPrivateMessage.h
//  WeddingWise
//
//  Created by Deepak Sharma on 6/14/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWPrivateMessage : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>

@property(nonatomic, weak)IBOutlet UITableView *tblMessage;
@property (weak, nonatomic) IBOutlet UIView *toolbar;
@property (weak, nonatomic) IBOutlet UITextView *txtMessage;
@property(weak, nonatomic)IBOutlet UILabel *lblVendorName;

@property(nonatomic, strong)NSDictionary *messageData;
@end

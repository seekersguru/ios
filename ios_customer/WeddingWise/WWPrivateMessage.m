//
//  WWPrivateMessage.m
//  WeddingWise
//
//  Created by Deepak Sharma on 6/14/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWPrivateMessage.h"
#import "SenderMsgCell.h"
#import "ReceiverMsgCell.h"

@interface WWPrivateMessage ()
{
    NSMutableDictionary *offscreenCells;
    
    NSMutableArray *chatArray;
    
    CGFloat maxChatTextWidth;
}
@end

@implementation WWPrivateMessage

- (void)viewDidLoad {
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController.navigationBar setHidden:YES];
    
    
//    UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 100.0f, 30.0f)];
//    [backButton setImage:[UIImage imageNamed:@"back@arrow"] forState:UIControlStateNormal];
//    [backButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [backButton setTitle:@"User Name" forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    [_tblMessage registerNib:[UINib nibWithNibName:@"SenderMsgCell" bundle:nil] forCellReuseIdentifier:@"SenderMsgCell"];
    [_tblMessage registerNib:[UINib nibWithNibName:@"ReceiverMsgCell" bundle:nil] forCellReuseIdentifier:@"ReceiverMsgCell"];
    
   // self.automaticallyAdjustsScrollViewInsets = NO;
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    offscreenCells = [NSMutableDictionary dictionary];
    
    [self fetchChatArray];
    [_tblMessage reloadData];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    //[self.navigationController.navigationBar setHidden:NO];
}
-(IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)fetchChatArray
{
    chatArray = [[NSMutableArray alloc] init];
    
    [chatArray addObject:@{@"message" : @"Looking for decent ambience ",
                           @"read_status" : @(YES),
                           @"sender" : @(YES),
                           @"date" : [NSDate date]}];
    
    [chatArray addObject:@{@"message" : @"We have good one",
                           @"read_status" : @(NO),
                           @"sender" : @(NO),
                           @"date" : [NSDate date]}];
    
    [chatArray addObject:@{@"message" : @"Can you send us some images and plans",
                           @"read_status" : @(NO),
                           @"sender" : @(YES),
                           @"date" : [NSDate date]}];
    
    [chatArray addObject:@{@"message" : @"Yes sure",
                           @"read_status" : @(NO),
                           @"sender" : @(NO),
                           @"date" : [NSDate date]}];
    
    [chatArray addObject:@{@"message" : @"We require rooms for stay",
                           @"read_status" : @(NO),
                           @"sender" : @(YES),
                           @"date" : [NSDate date]}];
    
    [chatArray addObject:@{@"message" : @"Around 25 guests will stay",
                           @"read_status" : @(NO),
                           @"sender" : @(NO),
                           @"date" : [NSDate date]}];
    
    [chatArray addObject:@{@"message" : @"A.C rooms, Parking etc, ",
                           @"read_status" : @(NO),
                           @"sender" : @(YES),
                           @"date" : [NSDate date]}];
    
    [chatArray addObject:@{@"message" : @"It will be great if we can have these services ",
                           @"read_status" : @(NO),
                           @"sender" : @(NO),
                           @"date" : [NSDate date]}];
}
#pragma mark - Tableview delegate/datasource

#pragma mark Tableview delegate/datasource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [chatArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 70.0;
    
    
    NSDictionary *dict = [chatArray objectAtIndex:indexPath.row];
    
    if(![dict[@"sender"] boolValue])
    {
        ReceiverMsgCell *cell = [offscreenCells objectForKey:@"ReceiverMsgCell"];
        if (!cell && cell.tag!=-1)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"ReceiverMsgCell"];
            cell.tag = -1;
            [offscreenCells setObject:cell forKey:@"ReceiverMsgCell"];
        }
        
        //cell.chatMessageLbl.text = chatObj.messageBody;
        //cell.chatMessageLbl.preferredMaxLayoutWidth = tableView.bounds.size.width - 110.0;
        cell.chatMsgTxt.text = dict[@"message"];
        cell.chatMsgTxt.font = [UIFont systemFontOfSize:14.0];
        //cell.chatMessageTxt.selectable = YES;
        
        
        maxChatTextWidth = self.view.bounds.size.width - 54.0;
        
        CGSize sizeThatFitsTextView = [cell.chatMsgTxt sizeThatFits:CGSizeMake(maxChatTextWidth, MAXFLOAT)];
        cell.chatMsgTxtWidthConstraint.constant = sizeThatFitsTextView.width;
        cell.chatMsgTxtHeightConstraint.constant = sizeThatFitsTextView.height;
        
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        
        // Get the actual height required for the cell
        CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        
        // Add an extra point to the height to account for the cell separator, which is added between the bottom
        // of the cell's contentView and the bottom of the table view cell.
        //height += 1;
        
        /*if(height<55.0)
         {
         return 55.0;
         }*/
        
        return height;
    }
    else
    {
        SenderMsgCell *cell = [offscreenCells objectForKey:@"SenderMsgCell"];
        if (!cell && cell.tag!=-1)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"SenderMsgCell"];
            cell.tag = -1;
            [offscreenCells setObject:cell forKey:@"SenderMsgCell"];
        }
        
        /*cell.chatMessageLbl.text = chatObj.messageBody;
         cell.chatMessageLbl.preferredMaxLayoutWidth = tableView.bounds.size.width - 110.0;*/
        
        cell.chatMsgTxt.text = dict[@"message"];
        cell.chatMsgTxt.font = [UIFont systemFontOfSize:14.0];
        //cell.chatMessageTxt.preferredMaxLayoutWidth = tableView.bounds.size.width - 110.0;
        //cell.chatMessageTxt.selectable = YES;
        
        maxChatTextWidth = self.view.bounds.size.width - 54.0;
        
        CGSize sizeThatFitsTextView = [cell.chatMsgTxt sizeThatFits:CGSizeMake(maxChatTextWidth, MAXFLOAT)];
        cell.chatMsgTxtWidthConstraint.constant = sizeThatFitsTextView.width;
        cell.chatMsgTxtHeightConstraint.constant = sizeThatFitsTextView.height;
        
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        
        // Get the actual height required for the cell
        CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        
        // Add an extra point to the height to account for the cell separator, which is added between the bottom
        // of the cell's contentView and the bottom of the table view cell.
        //∂height += 1;
        
        /*if(height<55.0)
         {
         return 55.0;
         }*/
        
        return height;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [chatArray objectAtIndex:indexPath.row];
    
    if(![dict[@"sender"] boolValue])
    {
        ReceiverMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReceiverMsgCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //cell.chatMessageLbl.text = chatObj.messageBody;
        cell.chatMsgTxt.text = dict[@"message"];
        cell.chatMsgTxt.textColor = [UIColor blackColor];
        cell.chatMsgTxt.font = [UIFont systemFontOfSize:14.0];
        
        CGSize sizeThatFitsTextView = [cell.chatMsgTxt sizeThatFits:CGSizeMake(maxChatTextWidth, MAXFLOAT)];
        cell.chatMsgTxtWidthConstraint.constant = sizeThatFitsTextView.width;
        cell.chatMsgTxtHeightConstraint.constant = sizeThatFitsTextView.height;
        
        if([dict[@"read_status"] boolValue])
        {
            cell.readStatusImage.hidden = NO;
        }
        else
        {
            cell.readStatusImage.hidden = YES;
        }
        
        [cell layoutIfNeeded];
        
        return cell;
    }
    else
    {
        SenderMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SenderMsgCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //cell.chatMessageLbl.text = chatObj.messageBody;
        cell.chatMsgTxt.text = dict[@"message"];
        cell.chatMsgTxt.textColor = [UIColor blackColor];
        cell.chatMsgTxt.font = [UIFont systemFontOfSize:14.0];
        
        CGSize sizeThatFitsTextView = [cell.chatMsgTxt sizeThatFits:CGSizeMake(maxChatTextWidth, MAXFLOAT)];
        cell.chatMsgTxtWidthConstraint.constant = sizeThatFitsTextView.width;
        cell.chatMsgTxtHeightConstraint.constant = sizeThatFitsTextView.height;
        
        [cell layoutIfNeeded];
        
        return cell;
    }
    
    return nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

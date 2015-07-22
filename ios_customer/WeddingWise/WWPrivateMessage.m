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
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation WWPrivateMessage

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController.navigationBar setHidden:YES];
    
    [_lblVendorName setFont:[UIFont fontWithName:AppFont size:13.0f]];
    _lblVendorName.text=[_messageData valueForKey:@"receiver_name"];
    [_txtMessage setFont:[UIFont fontWithName:AppFont size:13.0f]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    //set notification for when a key is pressed.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector: @selector(keyPressed:)
                                                 name: UITextViewTextDidChangeNotification
                                               object: nil];

    
    [_tblMessage registerNib:[UINib nibWithNibName:@"SenderMsgCell" bundle:nil] forCellReuseIdentifier:@"SenderMsgCell"];
    [_tblMessage registerNib:[UINib nibWithNibName:@"ReceiverMsgCell" bundle:nil] forCellReuseIdentifier:@"ReceiverMsgCell"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    offscreenCells = [NSMutableDictionary dictionary];
    
    chatArray = [[NSMutableArray alloc] init];
    [self callPrivateChatAPI];
    
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]];
    [_refreshControl setTintColor:[UIColor whiteColor]];
    [_refreshControl addTarget:self action:@selector(loadPrevioudMessages:) forControlEvents:UIControlEventValueChanged];
    [_tblMessage addSubview:_refreshControl];
    // Do any additional setup after loading the view from its nib.
}

- (void)loadPrevioudMessages:(id)sender{
    [self.tblMessage reloadData];
    if (_refreshControl) {
        [_refreshControl endRefreshing];
    }
}
-(void)callPrivateChatAPI{
    NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                 [AppDelegate sharedAppDelegate].userData.identifier,@"identifier",
                                 [_messageData valueForKey:@"receiver_email"],@"receiver_email",
                                 @"1",@"page_no",
                                 @"c2v",@"from_to",
                                 @"customer_vendor_message_detail",@"action",
                                 @"message",@"msg_type",
                                 nil];
    
    [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         if([[responseDics valueForKey:@"result"] isEqualToString:@"error"]){
             [[WWCommon getSharedObject]createAlertView:kAppName :[responseDics valueForKey:@"message"] :nil :000 ];
         }
         else if ([[responseDics valueForKey:@"result"] isEqualToString:@"success"]){
             NSArray *arrData=[responseDics valueForKey:@"json"];
             [chatArray removeAllObjects];
             for (NSDictionary *arrMessages in arrData) {
                 [chatArray addObject:arrMessages];
             }
             [_tblMessage reloadData];
             [self performSelector:@selector(tableScroll) withObject:nil afterDelay:0.03];

         }
     }
                                             failure:^(NSString *response)
     {
         DLog(@"%@",response);
     }];
}
-(void)tableScroll{
    
    if(chatArray.count>0){
        NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:chatArray.count-1
                                                       inSection:0];
        [self.tblMessage scrollToRowAtIndexPath:topIndexPath
                        atScrollPosition:UITableViewScrollPositionBottom
                                animated:NO];
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    //[self.navigationController.navigationBar setHidden:NO];
}
-(IBAction)refreshButtonPressed:(id)sender{
   [self callPrivateChatAPI];
}
-(IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark Tableview delegate/datasource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [chatArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //return 70.0;
    
    
    NSDictionary *dict = [chatArray objectAtIndex:indexPath.row];
    
//    if([dict[@"from_to"] isEqualToString:@"c2v"])
//    {
//        ReceiverMsgCell *cell = [offscreenCells objectForKey:@"ReceiverMsgCell"];
//        if (!cell && cell.tag!=-1)
//        {
//            cell = [tableView dequeueReusableCellWithIdentifier:@"ReceiverMsgCell"];
//            cell.tag = -1;
//            [offscreenCells setObject:cell forKey:@"ReceiverMsgCell"];
//        }
//    
//        cell.chatMsgTxt.text = dict[@"message"];
//        cell.chatMsgTxt.font = [UIFont systemFontOfSize:14.0];
//        
//        maxChatTextWidth = self.view.bounds.size.width - 54.0;
//        
//        CGSize sizeThatFitsTextView = [cell.chatMsgTxt sizeThatFits:CGSizeMake(maxChatTextWidth, MAXFLOAT)];
//        cell.chatMsgTxtWidthConstraint.constant = sizeThatFitsTextView.width;
//        cell.chatMsgTxtHeightConstraint.constant = sizeThatFitsTextView.height;
//        
//        [cell setNeedsLayout];
//        [cell layoutIfNeeded];
//        
//        // Get the actual height required for the cell
//        CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//        return height;
//    }
//    else
//    {
//        SenderMsgCell *cell = [offscreenCells objectForKey:@"SenderMsgCell"];
//        if (!cell && cell.tag!=-1)
//        {
//            cell = [tableView dequeueReusableCellWithIdentifier:@"SenderMsgCell"];
//            cell.tag = -1;
//            [offscreenCells setObject:cell forKey:@"SenderMsgCell"];
//        }
//        
//        cell.chatMsgTxt.text = dict[@"message"];
//        cell.chatMsgTxt.font = [UIFont systemFontOfSize:14.0];
//        maxChatTextWidth = self.view.bounds.size.width - 54.0;
//        
//        CGSize sizeThatFitsTextView = [cell.chatMsgTxt sizeThatFits:CGSizeMake(maxChatTextWidth, MAXFLOAT)];
//        cell.chatMsgTxtWidthConstraint.constant = sizeThatFitsTextView.width;
//        cell.chatMsgTxtHeightConstraint.constant = sizeThatFitsTextView.height;
//        
//        [cell setNeedsLayout];
//        [cell layoutIfNeeded];
//        
//        // Get the actual height required for the cell
//        CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//        return height;
//    }
    
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [chatArray objectAtIndex:indexPath.row];
    
    if([dict[@"from_to"] isEqualToString:@"c2v"])
    {
        ReceiverMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReceiverMsgCell"];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ReceiverMsgCell" owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        
        //cell.chatMessageLbl.text = chatObj.messageBody;
        cell.chatMsgTxt.text = dict[@"message"];
        cell.chatMsgTxt.textColor = [UIColor blackColor];
        [cell.chatMsgTxt setFont:[UIFont fontWithName:AppFont size:14.0f]];
        
        
        cell.dateTimeLbl.text= dict[@"msg_time"];
        [cell.dateTimeLbl setFont:[UIFont fontWithName:AppFont size:8.0f]];
        
        CGSize sizeThatFitsTextView = [cell.chatMsgTxt sizeThatFits:CGSizeMake(maxChatTextWidth, MAXFLOAT)];
        cell.chatMsgTxtWidthConstraint.constant = sizeThatFitsTextView.width;
        cell.chatMsgTxtHeightConstraint.constant = sizeThatFitsTextView.height;
        
        [cell layoutIfNeeded];
        
        return cell;
    }
    else
    {
        
        SenderMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SenderMsgCell"];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SenderMsgCell" owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        //SenderMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SenderMsgCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.chatMsgTxt.text = dict[@"message"];
        cell.chatMsgTxt.textColor = [UIColor blackColor];
        [cell.chatMsgTxt setFont:[UIFont fontWithName:AppFont size:14.0f]];
        
        cell.dateTimeLbl.text= dict[@"msg_time"];
        [cell.dateTimeLbl setFont:[UIFont fontWithName:AppFont size:8.0f]];
        
        
        CGSize sizeThatFitsTextView = [cell.chatMsgTxt sizeThatFits:CGSizeMake(maxChatTextWidth, MAXFLOAT)];
        cell.chatMsgTxtWidthConstraint.constant = sizeThatFitsTextView.width;
        cell.chatMsgTxtHeightConstraint.constant = sizeThatFitsTextView.height;
        
        [cell layoutIfNeeded];
        
        return cell;
    }
    
    return nil;
}

-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loction
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardBoundsUserInfoKey] getValue: &keyboardBounds];
    
    // get the height since this is the main value that we need.
    NSInteger kbSizeH = keyboardBounds.size.height;
    
    // get a rect for the table/main frame
    CGRect tableFrame = self.tblMessage.frame;
    tableFrame.size.height -= kbSizeH-50;
    
    // get a rect for the form frame
    CGRect formFrame = self.toolbar.frame;
    formFrame.origin.y -= kbSizeH-50;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    
    // set views with new info
    self.tblMessage.frame = tableFrame;
    self.toolbar.frame = formFrame;
    
    // commit animations
    [UIView commitAnimations];
    
    [self performSelector:@selector(tableScroll) withObject:nil afterDelay:0.03];
}
-(void) keyboardWillHide:(NSNotification *)note{
    // get keyboard size and loction
    
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardBoundsUserInfoKey] getValue: &keyboardBounds];
    
    // get the height since this is the main value that we need.
    NSInteger kbSizeH = keyboardBounds.size.height;
    
    // get a rect for the table/main frame
    CGRect tableFrame = _tblMessage.frame;
    tableFrame.size.height += kbSizeH;
    
    // get a rect for the form frame
    CGRect formFrame = self.toolbar.frame;
    formFrame.origin.y += kbSizeH-50;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    
    // set views with new info
    _tblMessage.frame = tableFrame;
    self.toolbar.frame = formFrame;
    
    // commit animations
    [UIView commitAnimations];
}

-(void) keyPressed: (NSNotification*) notification{
    // get the size of the text block so we can work our magic
    CGSize newSize = [self.txtMessage.text
                      sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14]
                      constrainedToSize:CGSizeMake(222,9999)
                      lineBreakMode:UILineBreakModeWordWrap];
    NSInteger newSizeH = newSize.height;
    NSInteger newSizeW = newSize.width;
    
    // I output the new dimensions to the console
    // so we can see what is happening
    NSLog(@"NEW SIZE : %ld X %ld", newSizeW, newSizeH);
    if (self.txtMessage.hasText)
    {
        // if the height of our new chatbox is
        // below 90 we can set the height
        if (newSizeH <= 90)
        {
            [self.txtMessage scrollRectToVisible:CGRectMake(0,0,1,1) animated:NO];
            
            // chatbox
//            CGRect chatBoxFrame = self.txtMessage.frame;
//            NSInteger chatBoxH = chatBoxFrame.size.height;
//            NSInteger chatBoxW = chatBoxFrame.size.width;
//            NSLog(@"CHAT BOX SIZE : %ld X %ld", chatBoxW, chatBoxH);
//            chatBoxFrame.size.height = newSizeH + 12;
//            self.txtMessage.frame = chatBoxFrame;
            
            // form view
//            CGRect formFrame = self.toolbar.frame;
//            NSInteger viewFormH = formFrame.size.height;
//            NSLog(@"FORM VIEW HEIGHT : %ld", viewFormH);
//            formFrame.size.height = 30 + newSizeH;
//            formFrame.origin.y = 199 ;//- (newSizeH - 18);
//            self.toolbar.frame = formFrame;
            
            // table view
            CGRect tableFrame = self.tblMessage.frame;
            NSInteger viewTableH = tableFrame.size.height;
            NSLog(@"TABLE VIEW HEIGHT : %ld", viewTableH);
            tableFrame.size.height = 199 - (newSizeH - 18);
            self.tblMessage.frame = tableFrame;
        }
        
        // if our new height is greater than 90
        // sets not set the height or move things
        // around and enable scrolling
        if (newSizeH > 90)
        {
            self.txtMessage.scrollEnabled = YES;
        }
    }
}

- (IBAction)chatButtonClick:(id)sender{
    [self sendMessage];
    
    // hide the keyboard, we are done with it.
    //[self.txtMessage resignFirstResponder];
    self.txtMessage.text = nil;
    
}
-(void)sendMessage{
    
    
    NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                 [AppDelegate sharedAppDelegate].userData.identifier,@"identifier",
                                 [_messageData valueForKey:@"receiver_email"],@"receiver_email",
                                 _txtMessage.text, @"message",
                                 @"c2v",@"from_to",
                                 @"customer_vendor_message_create",@"action",
                                 @"ios",@"mode",
                                 @"123123",@"device_id",
                                 @"'message push'",@"push_data",
                                 @"message", @"msg_type",
                                 nil];
    
    [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         if([[responseDics valueForKey:@"result"] isEqualToString:@"error"]){
             [[WWCommon getSharedObject]createAlertView:kAppName :[responseDics valueForKey:@"message"] :nil :000 ];
         }
         else if ([[responseDics valueForKey:@"result"] isEqualToString:@"success"]){
             NSMutableDictionary *messageData=[[responseDics valueForKey:@"json"] mutableCopy];
             //[messageData seva:@"c2v" forKey:@"from_to"];
             [messageData setValue:@"c2v" forKey:@"from_to"];
             
             [chatArray addObject:messageData];
             [_tblMessage reloadData];
             [self performSelector:@selector(tableScroll) withObject:nil afterDelay:0.03];
         }
     }
                                             failure:^(NSString *response)
     {
         DLog(@"%@",response);
     }];
    
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if([textView.text isEqualToString:@"Type a message"]){
        textView.text=@"";
    }
    return YES;
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

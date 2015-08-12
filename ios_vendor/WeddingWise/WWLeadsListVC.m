//
//  WWLeadsListVC.m
//  WeddingWise
//
//  Created by Deepak Sharma on 6/24/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWLeadsListVC.h"
#import "WWBidListCell.h"
#import "WWInquiryDetailVC.h"
#import "WWBasicDetails.h"

@interface WWLeadsListVC (){
    NSString* max;
    NSString* min;
    NSString *calendarDate;
}
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation WWLeadsListVC
{
    NSMutableArray *arrBidData;
    NSMutableArray *arrBookData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[WWCommon getSharedObject]setCustomFont:13.0 withLabel:_lblSortBy withText:_lblSortBy.text];
    [[WWCommon getSharedObject]setCustomFont:13.0 withLabel:_sortEventButton withText:_sortEventButton.titleLabel.text];
    [[WWCommon getSharedObject]setCustomFont:13.0 withLabel:_sortInquiryButton withText:_sortInquiryButton.titleLabel.text];
    [[WWCommon getSharedObject]setCustomFont:15.0 withLabel:bidBtn withText:bidBtn.titleLabel.text];
    [[WWCommon getSharedObject]setCustomFont:15.0 withLabel:bookBtn withText:bookBtn.titleLabel.text];
    
    _tblBidView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
     [self.navigationController.navigationBar setHidden:YES];
    [_tblBidView registerNib:[UINib nibWithNibName:@"WWBidListCell" bundle:nil] forCellReuseIdentifier:@"WWBidListCell"];
    arrBidData=[[NSMutableArray alloc]init];
    arrBookData=[[NSMutableArray alloc]init];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl setBackgroundColor:[UIColor whiteColor]];
    [_refreshControl setTintColor:[UIColor lightGrayColor]];
    [_refreshControl addTarget:self action:@selector(loadMoreOnTop) forControlEvents:UIControlEventValueChanged];
    [_tblBidView addSubview:_refreshControl];
    
    bidBtn.selected = YES;
    bookBtn.selected = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [arrBidData removeAllObjects];
    [arrBookData removeAllObjects];
    [_tblBidView reloadData];
    max = @"";
    min = @"";
    calendarDate = [[WWBasicDetails sharedInstance] calendarDate];
    [self callCustomerMessageAPIWithType:bidBtn.selected?@"bid":@"book" completionBlock:^(NSArray *messageArray) {
        if (bidBtn.selected) {
            [arrBidData addObjectsFromArray:messageArray];
        }else{
            [arrBookData addObjectsFromArray:messageArray];
        }
        
        [_tblBidView reloadData];
    }];
}

- (void)loadMoreOnTop{
    min = [[arrBidData firstObject] valueForKey:@"id"];
    max = @"";
    [self callCustomerMessageAPIWithType:bidBtn.selected?@"bid":@"book" completionBlock:^(NSArray *messageArray) {
        for (int i = messageArray.count-1; i >= 0; i--) {
            if (bidBtn.selected) {
                [arrBidData insertObject:messageArray[i] atIndex:0];
            }else{
                [arrBookData insertObject:messageArray[i] atIndex:0];
            }
            
        }
        [_tblBidView reloadData];
        if (_refreshControl) {
            [_refreshControl endRefreshing];
        }
    }];
    
}

- (void)loadMoreOnBottom{
    max = [[arrBidData lastObject] valueForKey:@"id"];
    min = @"";
    [self callCustomerMessageAPIWithType:bidBtn.selected?@"bid":@"book" completionBlock:^(NSArray *messageArray) {
        if (bidBtn.selected) {
            [arrBidData addObjectsFromArray:messageArray];
        }else{
            [arrBookData addObjectsFromArray:messageArray];
        }
        
        [_tblBidView reloadData];
        if (arrBidData.count*70 > _tblBidView.frame.size.height) {
            [_tblBidView setContentOffset:CGPointMake(0, (_tblBidView.contentSize.height - _tblBidView.frame.size.height))];
        }
    }];
}
#define DEGREES_RADIANS(angle) ((angle) / 180.0 * M_PI)
- (IBAction)eventDateSorting:(id)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        if(_sortEventButton.selected){
            _imgEvent.transform = CGAffineTransformMakeRotation(DEGREES_RADIANS(360));
            _sortEventButton.selected= NO;
        }
        else{
            _imgEvent.transform = CGAffineTransformMakeRotation(DEGREES_RADIANS(180));
            _sortEventButton.selected= YES;
        }
    }];
    arrBidData = (NSMutableArray*)[[arrBidData reverseObjectEnumerator] allObjects];
    [_tblBidView reloadData];
}
- (IBAction)inquiryDateSorting:(id)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        if(_sortInquiryButton.selected){
            _imgInquiry.transform = CGAffineTransformMakeRotation(DEGREES_RADIANS(360));
            _sortInquiryButton.selected= NO;
        }
        else{
            _imgInquiry.transform = CGAffineTransformMakeRotation(DEGREES_RADIANS(180));
            _sortInquiryButton.selected= YES;
        }
    }];
    arrBidData = (NSMutableArray*)[[arrBidData reverseObjectEnumerator] allObjects];
    [_tblBidView reloadData];
}
-(IBAction)bidBtnClicked:(id)sender
{
    bidBtn.selected = YES;
    bookBtn.selected = NO;
//    [self callBidDetailAPI:@"bid"];
    if (arrBidData.count == 0) {
        [self loadMoreOnBottom];
    }
    [_tblBidView reloadData];
    [self moveImage:selectorImage duration:0.2 curve:UIViewAnimationCurveLinear x:0.0 y:0.0];
}
-(IBAction)bookBtnClicked:(id)sender
{
    bidBtn.selected = NO;
    bookBtn.selected = YES;
    // Move the image
//    [self callBidDetailAPI:@"book"];
    if (arrBookData.count == 0) {
        [self loadMoreOnBottom];
    }
    [_tblBidView reloadData];
    [self moveImage:selectorImage duration:0.2
              curve:UIViewAnimationCurveLinear x:bookBtn.frame.origin.x y:0.0];
}
- (void)moveImage:(UIImageView *)image duration:(NSTimeInterval)duration
            curve:(int)curve x:(CGFloat)x y:(CGFloat)y
{
    // Setup the animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    // The transform matrix
    CGAffineTransform transform = CGAffineTransformMakeTranslation(x, y);
    image.transform = transform;
    
    // Commit the changes
    [UIView commitAnimations];
    
}
-(void)callCustomerMessageAPIWithType:(NSString *)type completionBlock:(void(^)(NSArray *))completion{
    NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                 [[NSUserDefaults standardUserDefaults]
                                  stringForKey:@"identifier"],@"identifier",
                                 @"1",@"page_no",
                                 @"customer_vendor_message_list",@"action",
                                 @"v2c",@"from_to",
                                 type,@"msg_type",
                                 calendarDate?calendarDate:@"",@"date",
                                 min,@"min",
                                 max,@"max",
                                 nil];
    
    [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         if([[responseDics valueForKey:@"result"] isEqualToString:@"error"]){
             [[WWCommon getSharedObject]createAlertView:kAppName :[responseDics valueForKey:@"message"] :nil :000 ];
         }
         else if ([[responseDics valueForKey:@"result"] isEqualToString:@"success"]){
             NSArray *arrData=[responseDics valueForKey:@"json"];
             completion(arrData);
         }
     }
                                             failure:^(NSString *response)
     {
         DLog(@"%@",response);
     }];
}

-(void)callBidDetailAPI:(NSString*)type{
    NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                 [[NSUserDefaults standardUserDefaults]
                                  stringForKey:@"identifier"],@"identifier",
                                 @"1",@"page_no",
                                 @"v2c",@"from_to",
                                 type,@"msg_type",
                                 @"customer_vendor_message_list",@"action",
                                 nil];
    [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         if([[responseDics valueForKey:@"result"] isEqualToString:@"error"]){
             [[WWCommon getSharedObject]createAlertView:kAppName :[responseDics valueForKey:@"message"] :nil :000 ];
         }
         else if ([[responseDics valueForKey:@"result"] isEqualToString:@"success"]){
             [arrBidData removeAllObjects];
             NSArray *arrJson=[responseDics valueForKey:@"json"];
             for (NSDictionary *bidData in arrJson) {
                 [arrBidData addObject:bidData];
             }
             [_tblBidView reloadData];
         }
         
     }
                                             failure:^(NSString *response)
     {
         DLog(@"%@",response);
     }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WWBidListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WWBidListCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (bidBtn.selected) {
        [cell setData:[arrBidData objectAtIndex:indexPath.row]];
    }
    else{
        [cell setData:[arrBookData objectAtIndex:indexPath.row]];
    }
    
    return cell;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (bidBtn.selected) {
        return arrBidData.count;
    }else{
        return arrBookData.count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIButton *loadMoreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
    [loadMoreButton setTitle:@"Load More" forState:UIControlStateNormal];
    [loadMoreButton.titleLabel setTextColor:[UIColor whiteColor]];
    [loadMoreButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [loadMoreButton setBackgroundColor:[UIColor lightGrayColor]];
    [loadMoreButton addTarget:self action:@selector(loadMoreOnBottom) forControlEvents:UIControlEventTouchUpInside];
    return loadMoreButton;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WWInquiryDetailVC *inqDetail=[[WWInquiryDetailVC alloc]initWithNibName:@"WWInquiryDetailVC" bundle:nil];
    if (bidBtn.selected) {
        inqDetail.messageData= [arrBidData objectAtIndex:indexPath.row];
    }
    else{
        inqDetail.messageData= [arrBookData objectAtIndex:indexPath.row];
    }
    
    [self.navigationController pushViewController:inqDetail animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

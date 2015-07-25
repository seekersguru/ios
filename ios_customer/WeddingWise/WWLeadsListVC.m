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

@interface WWLeadsListVC ()

@end

@implementation WWLeadsListVC
{
    NSMutableArray *arrBidData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tblBidView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
     [self.navigationController.navigationBar setHidden:YES];
    [_tblBidView registerNib:[UINib nibWithNibName:@"WWBidListCell" bundle:nil] forCellReuseIdentifier:@"WWBidListCell"];
    arrBidData=[[NSMutableArray alloc]init];
    [self callBidDetailAPI:@"bid"];
    
}
-(IBAction)bidBtnClicked:(id)sender
{
    bidBtn.selected = YES;
    bookBtn.selected = NO;
    [self callBidDetailAPI:@"bid"];
    [self moveImage:selectorImage duration:0.2 curve:UIViewAnimationCurveLinear x:0.0 y:0.0];
}
-(IBAction)bookBtnClicked:(id)sender
{
    bidBtn.selected = NO;
    bookBtn.selected = YES;
    // Move the image
    [self callBidDetailAPI:@"book"];
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
-(void)callBidDetailAPI:(NSString*)type{
    NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                 [[NSUserDefaults standardUserDefaults]
                                  stringForKey:@"identifier"],@"identifier",
                                 @"1",@"page_no",
                                 @"c2v",@"from_to",
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
    [cell setData:[arrBidData objectAtIndex:indexPath.row]];
    return cell;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrBidData.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WWInquiryDetailVC *inqDetail=[[WWInquiryDetailVC alloc]initWithNibName:@"WWInquiryDetailVC" bundle:nil];
    inqDetail.messageData= [arrBidData objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:inqDetail animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

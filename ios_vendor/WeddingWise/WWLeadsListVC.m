//
//  WWLeadsListVC.m
//  WeddingWise
//
//  Created by Deepak Sharma on 6/24/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWLeadsListVC.h"
#import "WWInquiryDetailVC.h"
#import "WWCreateBidVC.h"

@interface WWLeadsListVC ()
{
    NSMutableArray *arrBidData;
}
@end

@implementation WWLeadsListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:YES];
    arrBidData=[[NSMutableArray alloc]init];
    
    [self callBidDetailAPI];
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)callBidDetailAPI{
    NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                 @"vendor@test.com:-1Jwmiucd0MuY9VftiQ_u7XXquw",@"identifier",
                                 @"1",@"page_no",
                                 @"v2c",@"from_to",
                                 @"bid",@"msg_type",
                                 @"customer_vendor_message_list",@"action",
                                 nil];
    [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         //[HUD removeFromSuperview];
         if([[responseDics valueForKey:@"result"] isEqualToString:@"error"]){
             [[WWCommon getSharedObject]createAlertView:kAppName :[responseDics valueForKey:@"message"] :nil :000 ];
         }
         else if ([[responseDics valueForKey:@"result"] isEqualToString:@"success"]){
             NSArray *arrJson=[responseDics valueForKey:@"json"];
             for (NSDictionary *bidData in arrJson) {
                 
                 clientName.text= [bidData valueForKey:@"receiver_name"];
                 eventDate.text= [bidData valueForKey:@"event_date"];
                 lbl1.text= [NSString stringWithFormat:@"%@ %@",[bidData valueForKey:@"line1"],[bidData valueForKey:@"line2"] ];
                 
                 
                 [arrBidData addObject:bidData];
             }
             
         }
         
     }
                                             failure:^(NSString *response)
     {
         DLog(@"%@",response);
     }];
}
-(IBAction)bidBtnClicked:(id)sender
{
    bidBtn.selected = YES;
    bookBtn.selected = NO;
    [self moveImage:selectorImage duration:0.2 curve:UIViewAnimationCurveLinear x:bidBtn.frame.origin.x y:0.0];
}
- (IBAction)addNewInquiry:(id)sender {
    WWCreateBidVC *createBid=[[WWCreateBidVC alloc]initWithNibName:@"WWCreateBidVC" bundle:nil];
    [self.navigationController pushViewController:createBid animated:YES];
}
-(IBAction)bookBtnClicked:(id)sender
{
    bidBtn.selected = NO;
    bookBtn.selected = YES;
    
    // Move the image
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
-(IBAction)openDetailPage:(id)sender{
    WWInquiryDetailVC *detailVC=[[WWInquiryDetailVC alloc]initWithNibName:@"WWInquiryDetailVC" bundle:nil];
    [self.navigationController pushViewController:detailVC animated:YES];
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

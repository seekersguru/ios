//
//  ViewController.m
//  WeddingWise
//
//  Created by Deepak Sharma on 5/11/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "MyKnotList.h"
#import "myKnotCell.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "WWDetailScreen.h"
#import "AppDelegate.h"
#import "WWDashboardVC.h"


@interface MyKnotList ()<MBProgressHUDDelegate>
{
    NSMutableArray *arrCategoryImages;
}
@end

@implementation MyKnotList

- (void)viewDidLoad {
    [super viewDidLoad];
    arrCategoryImages=[[NSMutableArray alloc]init];
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
    
    // Show the HUD while the provided method executes in a new thread
    [HUD showWhileExecuting:@selector(callWebService) onTarget:self withObject:nil animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    //[self.navigationController.navigationBar setHidden:NO];
}
-(void)callWebService{
    NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                 @"ios",@"mode",
                                 @"2x",@"image_type",
                                 @"customer_vendor_category_or_home",@"action",
                                 nil];
    [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         if([[responseDics valueForKey:@"result"] isEqualToString:@"error"]){
             [[WWCommon getSharedObject]createAlertView:kAppName :[responseDics valueForKey:@"message"] :nil :000 ];
         }
         else if ([[responseDics valueForKey:@"result"] isEqualToString:@"success"]){
             NSArray *arrData=[[responseDics valueForKey:@"json"] valueForKey:@"data"];
             for (NSArray *arrImage in arrData) {
                 [arrCategoryImages addObject:arrImage];
             }
             [_tblMyKnotList reloadData];
         }
     }
                                             failure:^(NSString *response)
     {
         DLog(@"%@",response);
     }];
}
#pragma mark - Table view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"myKnotCell";
    myKnotCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.tblMyKnotList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSArray *arrObject=[arrCategoryImages objectAtIndex:indexPath.row];
    
    [cell.leftButton setTitle:[arrObject objectAtIndex:0] forState:UIControlStateNormal];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://wedwise.work%@",[arrObject objectAtIndex:1]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"your_placeholder"];
    
    __weak myKnotCell *weakCell = cell;
    
    [cell.leftImage setImageWithURLRequest:request
                          placeholderImage:placeholderImage
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       weakCell.leftImage.image = image;
                                       [weakCell setNeedsLayout];
                                       
                                   } failure:nil];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 175.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrCategoryImages.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WWDetailScreen *detailScreen=[[WWDetailScreen alloc]initWithNibName:@"WWDetailScreen" bundle:nil];
    NSArray *arrObject=[arrCategoryImages objectAtIndex:indexPath.row];
    detailScreen.vendorType= [arrObject objectAtIndex:0];
    
    [self.navigationController pushViewController:detailScreen animated:YES];
}
-(IBAction)backButtonPressed:(id)sender{
    AppDelegate *appDelegate=[[UIApplication sharedApplication]delegate];
    [appDelegate.navigation popViewControllerAnimated:YES];
}
		

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
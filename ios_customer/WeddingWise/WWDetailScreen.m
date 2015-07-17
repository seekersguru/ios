//
//  WWDetailScreen.m
//  WeddingWise
//
//  Created by Deepak Sharma on 6/10/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWDetailScreen.h"
#import "WWCategoryCell.h"
#import "WWCategoryDetailVC.h"

@interface WWDetailScreen ()<MBProgressHUDDelegate>
{
    NSMutableArray *arrVendorData;
}
@end

@implementation WWDetailScreen

- (void)viewDidLoad {
    [self.navigationController.navigationBar setHidden:YES];
    
    arrVendorData=[[NSMutableArray alloc]init];
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
    
    // Show the HUD while the provided method executes in a new thread
    [HUD showWhileExecuting:@selector(callWebService) onTarget:self withObject:nil animated:YES];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)callWebService{
    
    NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                 @"ios",@"mode",
                                 @"2x",@"image_type",
                                 _vendorType,@"vendor_type",
                                 @"1",@"page_no",
                                 @"2x",@"search_string",
                                 @"customer_vendor_list_and_search",@"action",
                                 nil];
    
    [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         if([[responseDics valueForKey:@"result"] isEqualToString:@"error"]){
             [[WWCommon getSharedObject]createAlertView:kAppName :[responseDics valueForKey:@"message"] :nil :000 ];
         }
         else if ([[responseDics valueForKey:@"result"] isEqualToString:@"success"]){
             NSArray *arrData=[[responseDics valueForKey:@"json"] valueForKey:@"vendor_list"];
             for (NSDictionary *dicVendor in arrData) {
                 [arrVendorData addObject:dicVendor];
             }
             [_tblCategory reloadData];
         }
     }
                                             failure:^(NSString *response)
     {
         DLog(@"%@",response);
     }];
}
#pragma mark - Table view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"WWCategoryCell";
    WWCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSDictionary *dicVendorData=[arrVendorData objectAtIndex:indexPath.row];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://wedwise.work%@",[dicVendorData valueForKey:@"image"]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"your_placeholder"];
    
    __weak WWCategoryCell *weakCell = cell;
    
    [cell.imgCategory setImageWithURLRequest:request
                          placeholderImage:placeholderImage
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       weakCell.imgCategory.image = image;
                                       [weakCell setNeedsLayout];
                                       
                                   } failure:nil];
    
    NSArray *icons=[dicVendorData valueForKey:@"icons"];
    if(icons.count>0){
        for (int i=0; i< icons.count; i++) {
            NSString *iconURL= [icons objectAtIndex:i];
            NSLog(@"iconURL :%@",[NSString stringWithFormat:@"http://wedwise.work%@",iconURL]);
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://wedwise.work%@",iconURL]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            UIImage *placeholderImage = [UIImage imageNamed:@"your_placeholder"];
            
            __weak WWCategoryCell *weakCell = cell;
            switch (i) {
                case 0:
                {
                    [cell.img1 setImageWithURLRequest:request
                                     placeholderImage:placeholderImage
                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                  weakCell.img1.image = image;
                                                  
                                              } failure:nil];
                    break;
                }
                    
                case 1:
                {
                    [cell.img2 setImageWithURLRequest:request
                                     placeholderImage:placeholderImage
                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                  weakCell.img2.image = image;
                                                  
                                              } failure:nil];
                    break;
                }
                case 2:
                {
                    [cell.img3 setImageWithURLRequest:request
                                     placeholderImage:placeholderImage
                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                  weakCell.img3.image = image;
                                                  
                                              } failure:nil];
                    break;
                }
                case 3:
                {
                    [cell.img4 setImageWithURLRequest:request
                                     placeholderImage:placeholderImage
                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                  weakCell.img4.image = image;
                                                  
                                              } failure:nil];
                    break;
                }
                case 4:
                {
                    [cell.img5 setImageWithURLRequest:request
                                     placeholderImage:placeholderImage
                                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                  weakCell.img5.image = image;
                                                  
                                              } failure:nil];
                    break;
                }
                    
                default:
                    break;
            }
        }
    }
    
    
    
//    cell.imgCategory.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://wedwise.work%@",[dicVendorData valueForKey:@"image"]]]]];
    
    cell.lblName.text=[dicVendorData valueForKey:@"name"];
    cell.lblStartingPrice.text=[NSString stringWithFormat:@"%@/-",[dicVendorData valueForKey:@"starting_price"]];
    cell.lblCapacity.text=[[[dicVendorData valueForKey:@"others_two"] objectAtIndex:0] objectAtIndex:1];
    cell.lblVeg.text=[[dicVendorData valueForKey:@"others_one"] objectAtIndex:2];
    
    cell.lblName.font = [UIFont fontWithName:AppFont size:12.0];
    cell.lblStartingPrice.font = [UIFont fontWithName:AppFont size:14.0];
    cell.lblCapacity.font = [UIFont fontWithName:AppFont size:10.0];
    cell.lblVeg.font = [UIFont fontWithName:AppFont size:10.0];
    
    self.tblCategory.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 185.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrVendorData.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WWCategoryDetailVC *detailScreen=[[WWCategoryDetailVC alloc]initWithNibName:@"WWCategoryDetailVC" bundle:nil];
    detailScreen.vendorEmail=[[arrVendorData objectAtIndex:indexPath.row] valueForKey:@"vendor_email"];
    [self.navigationController pushViewController:detailScreen animated:YES];
}
-(IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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

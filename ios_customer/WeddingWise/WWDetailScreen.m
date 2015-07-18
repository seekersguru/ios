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

@interface WWDetailScreen ()<MBProgressHUDDelegate,UITextFieldDelegate>
{
    NSMutableArray *arrVendorData;
    NSString *filterType;
    NSString *filterTime;
    NSString *filterDate;
}
@end

@implementation WWDetailScreen

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setHidden:YES];
    
    arrVendorData=[[NSMutableArray alloc]init];
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
    
    // Show the HUD while the provided method executes in a new thread
    [HUD showWhileExecuting:@selector(callWebService:) onTarget:self withObject:nil animated:YES];
    
    [_filterView setHidden:YES];
    
    [self.vendorNameLabel setTitle:self.vendorList[0] forState:UIControlStateNormal];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
//    [self setHidesBottomBarWhenPushed:NO];
}
- (IBAction)filterTypeSelection:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
            [(UIButton * )[sender.superview viewWithTag:2] setSelected:NO];
            [sender setSelected:YES];
            filterType = @"ENQUIRY";
            break;
        case 2:
            [(UIButton * )[sender.superview viewWithTag:1] setSelected:NO];
            [sender setSelected:YES];
            filterType = @"BOOKING";
            break;
        case 3:
            [(UIButton * )[sender.superview viewWithTag:4] setSelected:NO];
            [(UIButton * )[sender.superview viewWithTag:5] setSelected:NO];
            [sender setSelected:YES];
            filterTime = @"MORNING";
            break;
        case 4:
            [(UIButton * )[sender.superview viewWithTag:3] setSelected:NO];
            [(UIButton * )[sender.superview viewWithTag:5] setSelected:NO];
            [sender setSelected:YES];
            filterTime = @"ALL DAY";
            break;
        case 5:
            [(UIButton * )[sender.superview viewWithTag:3] setSelected:NO];
            [(UIButton * )[sender.superview viewWithTag:4] setSelected:NO];
            [sender setSelected:YES];
            filterTime = @"EVENING";
            break;
        case 6:
            [(UIButton * )[sender.superview viewWithTag:7] setSelected:NO];
            [sender setSelected:YES];
            filterDate = @"EVENT DATE";
            break;
        case 7:
            [(UIButton * )[sender.superview viewWithTag:6] setSelected:NO];
            [sender setSelected:YES];
            filterDate = @"BOOKING DATE";
            break;
        default:
            break;
    }
}

- (void)filterVendor:(id)sender{
    [_filterTextfield resignFirstResponder];
    BOOL isHidden = _filterView.hidden;
    if (_filterView.hidden) {
        [_filterView setHidden:NO];
    }
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         if (isHidden) {
                             _filterView.frame = CGRectMake(0, 58, self.view.frame.size.width, self.view.frame.size.height-60);
                         }
                         else{
                             _filterView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
                         }
                     }
                     completion:^(BOOL finished){
                         if (!isHidden) {
                             [_filterView setHidden:YES];
                         }
                     }];
}

- (IBAction)submitFilterAction:(UIButton *)sender {
    [self filterVendor:sender];
    [_filterTextfield resignFirstResponder];
    NSString *searchString = _filterTextfield.text;
    //call api here
    
    [self callWebService:searchString];
    if ([[searchString stringByReplacingOccurrencesOfString:@" " withString:@""] length] > 0) {
        [_vendorNameLabel setTitle:[NSString stringWithFormat:@"%@..%@",[_vendorList[0] substringWithRange:NSMakeRange(0, 1)],searchString] forState:UIControlStateNormal];
    }
    
    [_vendorNameLabel addTarget:self action:@selector(filterVendor:) forControlEvents:UIControlEventTouchUpInside];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)callWebService:(NSString *)searchString{
    if (!searchString) {
        searchString = @"";
    }
    NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                 @"ios",@"mode",
                                 @"2x",@"image_type",
                                 self.vendorList[0],@"vendor_type",
                                 @"1",@"page_no",
                                 searchString,@"search_string",
                                 @"customer_vendor_list_and_search",@"action",
                                 nil];
    
    [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         if([[responseDics valueForKey:@"result"] isEqualToString:@"error"]){
             [[WWCommon getSharedObject]createAlertView:kAppName :[responseDics valueForKey:@"message"] :nil :000 ];
         }
         else if ([[responseDics valueForKey:@"result"] isEqualToString:@"success"]){
             [arrVendorData removeAllObjects];
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
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImagePrefixUrl,[dicVendorData valueForKey:@"image"]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"your_placeholder"];
    
    __weak WWCategoryCell *weakCell = cell;
    
    [cell.imgCategory setImageWithURLRequest:request
                          placeholderImage:placeholderImage
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       weakCell.imgCategory.image = image;
                                       [weakCell setNeedsLayout];
                                       
                                   } failure:nil];
    
    cell.lblName.text=[dicVendorData valueForKey:@"name"];
    cell.lblStartingPrice.text=[NSString stringWithFormat:@"%@/-",[dicVendorData valueForKey:@"starting_price"]];
    
    cell.lblName.font = [UIFont fontWithName:AppFont size:12.0];
    cell.lblStartingPrice.font = [UIFont fontWithName:AppFont size:14.0];
    cell.lblCapacity.font = [UIFont fontWithName:AppFont size:10.0];
    cell.lblVeg.font = [UIFont fontWithName:AppFont size:10.0];
    cell.lbl3.font = [UIFont fontWithName:AppFont size:10.0];
    cell.lbl4.font = [UIFont fontWithName:AppFont size:10.0];
    
    NSArray *arrLine1=[dicVendorData valueForKey:@"icons_line1"];
    for (int i=0; i<arrLine1.count; i++) {
        NSDictionary *line1= arrLine1[i];
        switch (i) {
            case 0:{
                cell.lblVeg.text=[NSString stringWithFormat:@"%@",[line1 valueForKey:[[line1 allKeys] objectAtIndex:0]]];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImagePrefixUrl,[NSString stringWithFormat:@"%@",[[line1 allKeys] objectAtIndex:0]]]];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                UIImage *placeholderImage = [UIImage imageNamed:@"your_placeholder"];
                
                __weak WWCategoryCell *weakCell = cell;
                
                [cell.img1 setImageWithURLRequest:request
                                        placeholderImage:placeholderImage
                                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                     weakCell.img1.image = image;
                                                     [weakCell setNeedsLayout];
                                                     
                                                 } failure:nil];
            }
                
                
                
                break;
            case 1:
            {
                cell.lblCapacity.text=[NSString stringWithFormat:@"%@",[line1 valueForKey:[[line1 allKeys] objectAtIndex:0]]];
                //cell.lblVeg.text=[NSString stringWithFormat:@"%@",[line1 valueForKey:[[line1 allKeys] objectAtIndex:0]]];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImagePrefixUrl,[NSString stringWithFormat:@"%@",[[line1 allKeys] objectAtIndex:0]]]];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                UIImage *placeholderImage = [UIImage imageNamed:@"your_placeholder"];
                
                __weak WWCategoryCell *weakCell = cell;
                
                [cell.img2 setImageWithURLRequest:request
                                 placeholderImage:placeholderImage
                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                              weakCell.img2.image = image;
                                              [weakCell setNeedsLayout];
                                              
                                          } failure:nil];
            }
                
                break;
            default:
                break;
        }
    }
    NSArray *arrLine2=[dicVendorData valueForKey:@"icons_line2"];
    for (int i=0; i<arrLine2.count; i++) {
        NSDictionary *line1= arrLine2[i];
        switch (i) {
            case 0:
            {
                cell.lbl3.text=[NSString stringWithFormat:@"%@",[line1 valueForKey:[[line1 allKeys] objectAtIndex:0]]];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImagePrefixUrl,[NSString stringWithFormat:@"%@",[[line1 allKeys] objectAtIndex:0]]]];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                UIImage *placeholderImage = [UIImage imageNamed:@"your_placeholder"];
                
                __weak WWCategoryCell *weakCell = cell;
                
                [cell.img3 setImageWithURLRequest:request
                                 placeholderImage:placeholderImage
                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                              weakCell.img3.image = image;
                                              [weakCell setNeedsLayout];
                                              
                                          } failure:nil];
            }
                
                break;
            case 1:
            {
                cell.lbl4.text=[NSString stringWithFormat:@"%@",[line1 valueForKey:[[line1 allKeys] objectAtIndex:0]]];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImagePrefixUrl,[NSString stringWithFormat:@"%@",[[line1 allKeys] objectAtIndex:0]]]];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                UIImage *placeholderImage = [UIImage imageNamed:@"your_placeholder"];
                
                __weak WWCategoryCell *weakCell = cell;
                
                [cell.img4 setImageWithURLRequest:request
                                 placeholderImage:placeholderImage
                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                              weakCell.img4.image = image;
                                              [weakCell setNeedsLayout];
                                              
                                          } failure:nil];
            }
                
                break;
            default:
                break;
        }
    }
        
    
    
        //_key.text=[NSString stringWithFormat:@"%@",[[line1 allKeys] objectAtIndex:0]];
    
    
    
    
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
    
//    [self setHidesBottomBarWhenPushed:YES];
    WWCategoryDetailVC *detailScreen=[[WWCategoryDetailVC alloc]initWithNibName:@"WWCategoryDetailVC" bundle:nil];
    detailScreen.hidesBottomBarWhenPushed = YES;
    detailScreen.vendorEmail=[[arrVendorData objectAtIndex:indexPath.row] valueForKey:@"vendor_email"];
    [self.navigationController pushViewController:detailScreen animated:YES];
    detailScreen.hidesBottomBarWhenPushed = NO;
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

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
#import "WWDashboardVC.h"

@interface WWDetailScreen ()<MBProgressHUDDelegate,UITextFieldDelegate,WWCategoryCellDelegate >
{
    NSMutableArray *arrVendorData;
    NSString *filterType;
    NSString *filterTime;
    NSString *filterDate;
    BOOL isFilterViewPrepared;
    NSArray *filterArray;
    NSMutableArray *filterSelectedArray;
    MBProgressHUD *HUD;
    NSString *tempFavorite;
}
@property (weak, nonatomic) IBOutlet UIView *dynamicFilterView;

@end

@implementation WWDetailScreen

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setHidden:YES];
    
    arrVendorData=[[NSMutableArray alloc]init];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
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

}
- (IBAction)radioTypeSelection:(UIButton *)sender {
    if (!filterSelectedArray) {
        filterSelectedArray = [NSMutableArray new];
    }
    NSMutableDictionary *filterDict = [NSMutableDictionary new];
    
    for (int i = 0; i < filterArray.count; i++) {
        NSDictionary *dict = filterArray[i];
        for (int j = 0; j < [[dict valueForKey:@"values"] count]; j++) {
            NSString *type = [[dict valueForKey:@"values"] objectAtIndex:j];
            [filterDict setObject:[dict valueForKey:@"name"] forKey:type];
        }
    }
    
    NSString *key1 = [[filterDict allValues] objectAtIndex:sender.tag-1];
    NSString *value1 = [[filterDict allKeys] objectAtIndex:sender.tag-1];
    [filterDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isEqualToString:key1] && ![key isEqualToString:key1]) {
            NSMutableArray *filterSelectedArrayCopy = [filterSelectedArray copy];
            for (NSDictionary *dict in filterSelectedArrayCopy) {
                if ([[dict allKeys] containsObject:key1]) {
                    [filterSelectedArray removeObjectAtIndex:[[dict allKeys] indexOfObject:key1]];
                }
            }
            
            NSUInteger indexOfObject = [[filterDict allKeys] indexOfObject:key];
            [(UIButton *)[sender.superview viewWithTag:indexOfObject+1] setSelected:NO];
        }
    }];
    [filterSelectedArray addObject:@{key1:value1}];
    sender.selected = YES;
}

- (IBAction)checkTypeSelection:(UIButton *)sender{
    
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
    
    //Kya hua..kr le ?
    
    
    [self callWebService:searchString];
    if ([[searchString stringByReplacingOccurrencesOfString:@" " withString:@""] length] > 0) {
        [_vendorNameLabel setTitle:[NSString stringWithFormat:@"%@",[searchString capitalizedString]] forState:UIControlStateNormal];
    }
    else{
        [_vendorNameLabel setTitle:[NSString stringWithFormat:@"Banquets"] forState:UIControlStateNormal];
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
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                 @"ios",@"mode",
                                 @"2x",@"image_type",
                                 self.vendorList[0],@"vendor_type",
                                 @"1",@"page_no",
                                 searchString,@"search_string",
                                 [[NSUserDefaults standardUserDefaults]
                                  stringForKey:@"identifier"],@"identifier",
                                 @"customer_vendor_list_and_search",@"action",
                                 nil];
    
    [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         NSLog(@"%lu", responseDics.count);
         [arrVendorData removeAllObjects];
         if(responseDics.count>0){
             if([[responseDics valueForKey:@"result"] isEqualToString:@"error"]){
                 [[WWCommon getSharedObject]createAlertView:kAppName :[responseDics valueForKey:@"message"] :nil :000 ];
             }
             else if ([[responseDics valueForKey:@"result"] isEqualToString:@"success"]){
                 if (!isFilterViewPrepared) {
                     filterArray = [[responseDics valueForKey:@"json"] valueForKey:@"filters"];
                 }
                 NSArray *arrData=[[responseDics valueForKey:@"json"] valueForKey:@"vendor_list"];
                 if(arrData.count>0){
                     [_lblNoDataFound setHidden:YES];
                     for (NSDictionary *dicVendor in arrData) {
                         [arrVendorData addObject:dicVendor];
                     }
                 }
                 else{
                     
                     [_lblNoDataFound setHidden:NO];
                     [_lblNoDataFound setFont:[UIFont fontWithName:AppFont size:17.0]];
                     
//                     UIAlertView *alert=[[UIAlertView alloc]initWithTitle:kAppName message:@"No result found." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//                     [alert show];
                 }
                 
             }
             [HUD removeFromSuperview];
         }
         else{
             [[WWCommon getSharedObject]createAlertView:kAppName :@"No data found." :nil :000 ];
         }
         [_tblCategory reloadData];
     }
                                             failure:^(NSString *response)
     {
         DLog(@"%@",response);
     }];
}

- (void)prepareDynamicFilterView:(NSArray *)filterArray{
    int index = 1;
    int x1 = 20, x2 = 158, y = 66;
    for (NSDictionary *dict in filterArray) {
        NSString *buttonType = [dict valueForKey:@"type"];
        int index1 = 1;
        for (NSString *type in [dict valueForKey:@"values"]) {
            CGRect buttonFrame;
            buttonFrame.size.width = 25;
            buttonFrame.size.height = 25;
            buttonFrame.origin.y = y;
            if (index % 2 != 0) {
                buttonFrame.origin.x = x1;
            }
            else{
                buttonFrame.origin.x = x2;
                if (index1 != [[dict valueForKey:@"values"] count]) {
                    y+=28;
                }
            }
            UIButton *checkBox = [[UIButton alloc] initWithFrame:buttonFrame];
            checkBox.tag = index;
            [checkBox setTitle:buttonType forState:UIControlStateNormal];
            if ([buttonType isEqualToString:@"radio"]) {
                [checkBox setImage:[UIImage imageNamed:@"radiobt"] forState:UIControlStateNormal];
                [checkBox setImage:[UIImage imageNamed:@"radiobtMark"] forState:UIControlStateSelected];
                [checkBox addTarget:self action:@selector(radioTypeSelection:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [checkBox setImage:[UIImage imageNamed:@"checkbt"] forState:UIControlStateNormal];
                [checkBox setImage:[UIImage imageNamed:@"checkbtMark"] forState:UIControlStateSelected];
                [checkBox addTarget:self action:@selector(checkTypeSelection:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            
            buttonFrame.origin.x += 25;
            buttonFrame.origin.y += 6;
            buttonFrame.size.width = 76;
            UILabel *label = [[UILabel alloc] initWithFrame:buttonFrame];
            [label setTextColor:[UIColor lightGrayColor]];
            [label setText:type];
            [label setFont:[UIFont systemFontOfSize:10]];
            [label setNumberOfLines:0];
            [label sizeToFit];
            
            [_dynamicFilterView addSubview:checkBox];
            [_dynamicFilterView addSubview:label];
            index++;
            index1++;
        }
        
        UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(10, y+28, 262, 1)];
        [seperatorView setBackgroundColor:[UIColor lightGrayColor]];
        [_dynamicFilterView addSubview:seperatorView];
        y+=33;
    }
    
    UIButton *submitButton = [[UIButton alloc] initWithFrame:CGRectMake(76, y+3, 131, 25)];
    [submitButton setTitle:@"SUBMIT" forState:UIControlStateNormal];
    [submitButton setBackgroundColor:[UIColor colorWithRed:240/255.0 green:105/255.0 blue:89/255.0 alpha:1.0]];
    [submitButton addTarget:self action:@selector(submitFilterAction:) forControlEvents:UIControlEventTouchUpInside];
    [_dynamicFilterView addSubview:submitButton];
    
    CGRect frame = _dynamicFilterView.frame;
    frame.size.height = submitButton.frame.origin.y + 35;
    [_dynamicFilterView setFrame:frame];
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
    NSDictionary *dicVendorData=[[arrVendorData objectAtIndex:indexPath.row] mutableCopy];
    cell.favoriteDelegate= self;
    cell.btnFavorite.tag= indexPath.row;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kImagePrefixUrl,[dicVendorData valueForKey:@"image"]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"your_placeholder"];
    
    
    if([dicVendorData[@"favorite"] isEqualToString:@"1"]){
        [cell.btnFavorite setImage:[UIImage imageNamed:@"RSelect"] forState:UIControlStateNormal];
    }
    else if ([dicVendorData[@"favorite"] isEqualToString:@"-1"]){
        [cell.btnFavorite setImage:[UIImage imageNamed:@"WSelect"] forState:UIControlStateNormal];
    }
    
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
    detailScreen.vendorName=[[arrVendorData objectAtIndex:indexPath.row] valueForKey:@"name"];
    [self.navigationController pushViewController:detailScreen animated:YES];
    detailScreen.hidesBottomBarWhenPushed = NO;
}

-(IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark: favoriteDelegate methods


-(void)addFavorites:(id)sender{
    tempFavorite = @"";
    NSString *savedGroomName = [[NSUserDefaults standardUserDefaults]
                                stringForKey:@"EmailID"];
    if(savedGroomName.length>0){
        NSDictionary *dicVendorData=[arrVendorData objectAtIndex:[sender tag]];
        if([dicVendorData[@"favorite"] isEqualToString:@"-1"]){
            //[dicVendorData setValue:@"1" forKey:@"favorite"];
            tempFavorite=@"1";
        }
        else if ([dicVendorData[@"favorite"] isEqualToString:@"1"]){
            //[dicVendorData setValue:@"-1" forKey:@"favorite"];
            tempFavorite=@"-1";
        }
        // [_tblCategory reloadData];
        
        
        
        [self callFavoriteApi:dicVendorData withFavorite:tempFavorite];
    }
    else{
        [AppDelegate sharedAppDelegate].isLogOut= YES;
        
        
        WWDashboardVC *dash=[[WWDashboardVC alloc]initWithNibName:@"WWDashboardVC" bundle:nil];
        dash.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:dash animated:YES];
    }
}
-(void)callFavoriteApi:(NSDictionary*)dicVendor withFavorite:(NSString*)isFavorite{
    
    NSDictionary *dicParameters= [[NSDictionary alloc]initWithObjectsAndKeys:
                                  [[NSUserDefaults standardUserDefaults]
                                   stringForKey:@"identifier"],@"identifier",
                                  dicVendor[@"vendor_email"],@"vendor_email",
                                  isFavorite,@"favorite",
                                  @"add_favorite",@"action",nil];
    
    [[WWWebService sharedInstanceAPI] callWebService:dicParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         NSLog(@"responseDics :%@",responseDics);
         HUD = [[MBProgressHUD alloc] initWithView:self.view];
         [self.view addSubview:HUD];
         
         // Regiser for HUD callbacks so we can remove it from the window at the right time
         HUD.delegate = self;
         
         // Show the HUD while the provided method executes in a new thread
         [HUD showWhileExecuting:@selector(callWebService:) onTarget:self withObject:@"" animated:YES];
         
     }
                                             failure:^(NSString *response)
     {
         DLog(@"%@",response);
     }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

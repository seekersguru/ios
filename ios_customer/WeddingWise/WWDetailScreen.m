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
    BOOL isFilterViewPrepared;
    NSArray *filterArray;
    NSMutableArray *filterSelectedArray;
}
@property (weak, nonatomic) IBOutlet UIView *dynamicFilterView;

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
- (IBAction)radioTypeSelection:(UIButton *)sender {
    if (!filterSelectedArray) {
        filterSelectedArray = [NSMutableArray new];
    }
    
    
    
    
    
    
    NSMutableDictionary *filterDict = [NSMutableDictionary new];
    
//    for (NSDictionary *dict in filterArray) {
//        for (NSString *type in [dict valueForKey:@"values"]) {
//            [filterDict setObject:[dict valueForKey:@"name"] forKey:type];
//        }
//    }
    
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
    
//    switch (sender.tag) {
//        case 1:
//            [(UIButton * )[sender.superview viewWithTag:2] setSelected:NO];
//            [sender setSelected:YES];
//            filterType = @"ENQUIRY";
//            break;
//        case 2:
//            [(UIButton * )[sender.superview viewWithTag:1] setSelected:NO];
//            [sender setSelected:YES];
//            filterType = @"BOOKING";
//            break;
//        case 3:
//            [(UIButton * )[sender.superview viewWithTag:4] setSelected:NO];
//            [(UIButton * )[sender.superview viewWithTag:5] setSelected:NO];
//            [sender setSelected:YES];
//            filterTime = @"MORNING";
//            break;
//        case 4:
//            [(UIButton * )[sender.superview viewWithTag:3] setSelected:NO];
//            [(UIButton * )[sender.superview viewWithTag:5] setSelected:NO];
//            [sender setSelected:YES];
//            filterTime = @"ALL DAY";
//            break;
//        case 5:
//            [(UIButton * )[sender.superview viewWithTag:3] setSelected:NO];
//            [(UIButton * )[sender.superview viewWithTag:4] setSelected:NO];
//            [sender setSelected:YES];
//            filterTime = @"EVENING";
//            break;
//        case 6:
//            [(UIButton * )[sender.superview viewWithTag:7] setSelected:NO];
//            [sender setSelected:YES];
//            filterDate = @"EVENT DATE";
//            break;
//        case 7:
//            [(UIButton * )[sender.superview viewWithTag:6] setSelected:NO];
//            [sender setSelected:YES];
//            filterDate = @"BOOKING DATE";
//            break;
//        default:
//            break;
//    }
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
             if (!isFilterViewPrepared) {
                 //prepare dynamic search view
                 filterArray = [[responseDics valueForKey:@"json"] valueForKey:@"filters"];
                 [self prepareDynamicFilterView:[[responseDics valueForKey:@"json"] valueForKey:@"filters"]];
             }
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
    NSDictionary *dicVendorData=[arrVendorData objectAtIndex:indexPath.row];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://52.11.207.26%@",[dicVendorData valueForKey:@"image"]]];
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
            NSLog(@"iconURL :%@",[NSString stringWithFormat:@"http://52.11.207.26%@",iconURL]);
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://52.11.207.26%@",iconURL]];
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
    
    
    
//    cell.imgCategory.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://52.11.207.26%@",[dicVendorData valueForKey:@"image"]]]]];
    
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

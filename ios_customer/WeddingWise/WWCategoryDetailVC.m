//
//  WWCategoryDetailVC.m
//  WeddingWise
//
//  Created by Dotsquares on 6/16/15.
//  Copyright (c) 2015 DS. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "WWCategoryDetailVC.h"

#import "WWCategoryTitleCell.h"
#import "WWCategoryImageCell.h"
#import "WWCategoryDescriptionCell.h"
#import "WWCategoryMapCell.h"
#import "WWCategoryListingCell.h"
#import "WWCategoryPackageCell.h"
#import "WWVendorDetailData.h"

#import "WWCategoryListCell.h"
#import "WWCategoryCommonCell.h"

#define DEGREES_IN_RADIANS(x) (M_PI * x / 180.0)
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)

@interface WWCategoryDetailVC ()<PackageDelegate,FacilityDelegate,DescriptionDelegate, MapCellDelegate,ImageCellDelegate>
{
    NSMutableArray *arrVendorDetailData;
}
@end

@implementation WWCategoryDetailVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    arrVendorDetailData=[[NSMutableArray alloc]init];
    
    [self setUpCustomView];
    [self callWebService];
}
-(void)callWebService{
    
    NSDictionary *reqParameters=[NSDictionary dictionaryWithObjectsAndKeys:
                                 @"ios",@"mode",
                                 @"2x",@"image_type",
                                 _vendorEmail,@"vendor_email",
                                 @"customer_vendor_detail",@"action",
                                 nil];
    
    [[WWWebService sharedInstanceAPI] callWebService:reqParameters imgData:nil loadThreadWithCompletion:^(NSDictionary *responseDics)
     {
         if([[responseDics valueForKey:@"result"] isEqualToString:@"error"]){
             [[WWCommon getSharedObject]createAlertView:kAppName :[responseDics valueForKey:@"message"] :nil :000 ];
         }
         else if ([[responseDics valueForKey:@"result"] isEqualToString:@"success"]){
             WWVendorDetailData *basicInfo=[[WWVendorDetailData alloc]setVendorBasicInfo:[[[responseDics valueForKey:@"json"] valueForKey:@"data"] valueForKey:@"info"]];
             
             [arrVendorDetailData addObject:basicInfo];
             
             NSArray *arrSections= [[[responseDics valueForKey:@"json"] valueForKey:@"data"] valueForKey:@"sections"];
             for (int i=0; i<arrSections.count; i++) {
                 
                 NSDictionary *dataDisplay=[arrSections objectAtIndex:i];
                 NSArray *type=[[dataDisplay valueForKey:@"data_display"] valueForKey:@"type"];
                 
                 if([type objectAtIndex:0] !=(id)[NSNull null]){
                     if([[type objectAtIndex:0] isEqualToString:@"key_value"]){
                         NSLog(@"type: %@", [type objectAtIndex:0]);
                         WWVendorDescription *description=[[WWVendorDescription alloc]setVendorDescrition:dataDisplay];
                         [arrVendorDetailData addObject:description];
                     }
                     else if ([[type objectAtIndex:0] isEqualToString:@"map"]){
                         NSLog(@"type: %@", [type objectAtIndex:0]);
                         WWVendorMap *mapData= [[WWVendorMap alloc]setVendorMap:nil];
                         [arrVendorDetailData addObject:mapData];
                     }
                     else if([[type objectAtIndex:0] isEqualToString:@"para"]){
                         NSLog(@"type: %@", [type objectAtIndex:0]);
                     }
                     else if([[type objectAtIndex:0] isEqualToString:@"packages"]){
                         NSLog(@"type: %@", [type objectAtIndex:0]);
                         WWVendorPackage *description=[[WWVendorPackage alloc]setVendorPackage:dataDisplay];
                         [arrVendorDetailData addObject:description];
                     }
                     
                 }
                 else{
                
                 }
             }
             _tblCategoryDetail.delegate=self;
             _tblCategoryDetail.dataSource= self;
             [_tblCategoryDetail reloadData];
         }
     }
                                             failure:^(NSString *response)
     {
         DLog(@"%@",response);
     }];
}

-(void)setUpCustomView
{
    _packageView.frame = CGRectMake(0, self.view.frame.size.height+60, self.view.frame.size.width, self.view.frame.size.height);
    _descriptionView.frame = CGRectMake(0, self.view.frame.size.height+60, self.view.frame.size.width, self.view.frame.size.height);
    _listingView.frame = CGRectMake(0, self.view.frame.size.height+60, self.view.frame.size.width, self.view.frame.size.height);
    _mapView.frame = CGRectMake(0, self.view.frame.size.height+60, self.view.frame.size.width, self.view.frame.size.height);
    _videoView.frame = CGRectMake(0, self.view.frame.size.height+60, self.view.frame.size.width, self.view.frame.size.height);
    
}-(IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)hideView:(id)sender{
    [UIView animateWithDuration:0.3
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _packageView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
                         _descriptionView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
                         _listingView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
                         _mapView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
                         _videoView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                     }];

}
#pragma mark - Table view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView== _tblReadMore){
        static NSString *CellIdentifier = @"WWCategoryCommonCell";
        WWCategoryCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        
        WWVendorDescription *descData=[arrVendorDetailData objectAtIndex:1];
        NSDictionary *dicData=[[[[descData.descReadMoreData objectAtIndex:0] objectAtIndex:0] objectAtIndex:0] objectAtIndex:indexPath.row];
        [cell setCommonData:dicData withIndexPath:indexPath];
        return cell;
    }
    else{
        switch (indexPath.row) {
            case 0:
            {
                static NSString *CellIdentifier = @"WWCategoryTitleCell";
                WWCategoryTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
                    cell = [topLevelObjects objectAtIndex:0];
                }
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                self.tblCategoryDetail.separatorStyle = UITableViewCellSeparatorStyleNone;
                
                if(arrVendorDetailData.count>0){
                    WWVendorDetailData *basicInfo= [arrVendorDetailData objectAtIndex:indexPath.row];
                    cell.name.text= [NSString stringWithFormat:@"test %@",basicInfo.name];
                    cell.contactNumber.text= [NSString stringWithFormat:@"test %@",basicInfo.contact];
                    cell.address.text= [NSString stringWithFormat:@"test %@",basicInfo.top_address];
                }
                
                return cell;
            }
                
                break;
            case 1:
            {
                static NSString *CellIdentifier = @"WWCategoryImageCell";
                WWCategoryImageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
                    cell = [topLevelObjects objectAtIndex:0];
                }
                cell.delegate= self;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                self.tblCategoryDetail.separatorStyle = UITableViewCellSeparatorStyleNone;
                
                if(arrVendorDetailData.count>0){
                    WWVendorDetailData *basicInfo= [arrVendorDetailData objectAtIndex:0];
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://wedwise.work%@",[basicInfo.heroImages objectAtIndex:0]]];
                    NSURLRequest *request = [NSURLRequest requestWithURL:url];
                    UIImage *placeholderImage = [UIImage imageNamed:@"your_placeholder"];
                    
                    __weak WWCategoryImageCell *weakCell = cell;
                    
                    [cell.categoryImage setImageWithURLRequest:request
                                              placeholderImage:placeholderImage
                                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                           weakCell.categoryImage.image = image;
                                                           [weakCell setNeedsLayout];
                                                           
                                                       } failure:nil];
                }
                
                return cell;
            }
                
                break;
            default:
            {
                if(arrVendorDetailData.count>0){
                    id object= [arrVendorDetailData objectAtIndex:indexPath.row-1];
                    if([object isKindOfClass:[WWVendorDescription class]]){
                        static NSString *CellIdentifier = @"WWCategoryListCell";
                        WWCategoryListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        if (cell == nil) {
                            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
                            cell = [topLevelObjects objectAtIndex:0];
                        }
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                        self.tblCategoryDetail.separatorStyle = UITableViewCellSeparatorStyleNone;
                        cell.delegate= self;
                        WWVendorDescription *descData=[arrVendorDetailData objectAtIndex:1];
                        [cell getDescriptionData:descData.arrDescriptionData];
                        //cell.lblHeading.text= descData.heading;
                        return cell;
                    }
                    else if ([object isKindOfClass:[WWVendorMap class]]){
                        static NSString *CellIdentifier = @"WWCategoryMapCell";
                        WWCategoryMapCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        if (cell == nil) {
                            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
                            cell = [topLevelObjects objectAtIndex:0];
                        }
                        cell.delegate= self;
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                        self.tblCategoryDetail.separatorStyle = UITableViewCellSeparatorStyleNone;
                        return cell;
                    }
                    else if ([object isKindOfClass:[WWVendorPackage class]]){
                        static NSString *CellIdentifier = @"WWCategoryPackageCell";
                        WWCategoryPackageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        if (cell == nil) {
                            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
                            cell = [topLevelObjects objectAtIndex:0];
                        }
                        cell.delegate= self;
                        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                        self.tblCategoryDetail.separatorStyle = UITableViewCellSeparatorStyleNone;
                        return cell;
                    }
                }
            }
                break;
        }
    }
    
    
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView== _tblReadMore){
        return 35.0f;
    }
    else{
        switch (indexPath.row) {
            case 0:
                return 64;
                break;
            case 1:
                return 180;
                break;
            case 2:
                return 224;
                break;
            case 3:
                return 130;
                break;
            case 4:
                return 232;
                break;
            case 5:
                return 185;
                break;
            default:
                break;
        }
    }
    return 0.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView== _tblReadMore){
        return 8;
    }
    else{
        return arrVendorDetailData.count +1;
    }
    
}


#pragma mark: Cell Delegate methods:
-(void)showCategryReadMoreView{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _descriptionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                         _tblReadMore.delegate= self;
                         _tblReadMore.dataSource= self;
                         [_tblReadMore reloadData];
                     }
                     completion:^(BOOL finished){
                     }];
}

-(void)showFacilityReadMoreView{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _listingView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                     }];
}
-(void)showPackageReadMoreView{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _packageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                     }];
}
-(void)showDescriptionReadMoreView{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _descriptionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                     }];
}
-(void)showMapFullView{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _mapView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished){
                     }];
}

-(void)showVideoPlayer{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _videoView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                         [self.playerView loadWithVideoId:@"M7lc1UVf-VE"];
                         NSDictionary *playerVars = @{
                                                      @"playsinline" : @1,
                                                      };
                         [self.playerView loadWithVideoId:@"M7lc1UVf-VE" playerVars:playerVars];
                     }
                     completion:^(BOOL finished){
                     }];
    
}
- (IBAction)playVideo:(id)sender {
    [self.playerView playVideo];
}

- (IBAction)stopVideo:(id)sender {
    [self.playerView stopVideo];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

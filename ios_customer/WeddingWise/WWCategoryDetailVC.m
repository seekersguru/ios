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

#import "WWCreateBidVC.h"
#import "WWMessageList.h"
#import "WWCategoryFooterCell.h"
#import "WWScheduleVC.h"
#import "AnnotationPin.h"

#define DEGREES_IN_RADIANS(x) (M_PI * x / 180.0)
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)

@interface WWCategoryDetailVC ()<PackageDelegate,FacilityDelegate,DescriptionDelegate, MapCellDelegate,ImageCellDelegate, FooterCellDelegate>
{
    NSMutableArray *arrVendorDetailData;
    NSArray *arrReadMoreData;
    
    NSMutableArray *packageSectionsArray;
    NSMutableArray *packageSectionDetailArray;
}
@end

@implementation WWCategoryDetailVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    arrVendorDetailData=[[NSMutableArray alloc]init];
    arrReadMoreData= [[NSArray alloc]init];
    [self setUpCustomView];
    [self callWebService];
    
    packageSectionsArray = [NSMutableArray new];
    packageSectionDetailArray = [NSMutableArray new];
    
    //[[AppDelegate sharedAppDelegate]setUpCustomView:self.navigationController];
    
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
             //setting bid info for this vendor, to use on add bid page
             WWVendorBidData *bidInfo = [WWVendorBidData sharedInstance];
             [bidInfo setVendorBidInfo:responseDics[@"json"][@"data"][@"bid"]];
             //[arrVendorDetailData addObject:bidInfo];
             
             //setting booking info for this vendor, to use on add booking page
             WWVendorBookingData *bookingInfo = [WWVendorBookingData sharedInstance];
             [bookingInfo setVendorBookingInfo:responseDics[@"json"][@"data"][@"book"]];
             
             //[arrVendorDetailData addObject:bookingInfo];
             
             WWVendorDetailData *basicInfo = [WWVendorDetailData sharedInstance];
             [basicInfo setVendorBasicInfo:[[[responseDics valueForKey:@"json"] valueForKey:@"data"] valueForKey:@"info"]];
             [basicInfo setVendorEmail:_vendorEmail];   //setting vendor email for post bid
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
                         WWVendorMap *mapData= [[WWVendorMap alloc]setVendorMap:dataDisplay];
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

        if (isPackage) {
            NSDictionary *data = [[[[packageSectionDetailArray objectAtIndex:indexPath.section] allValues] objectAtIndex:0] objectAtIndex:indexPath.row];
            [cell.key setText:[[data allKeys] objectAtIndex:0]];
            [cell.value setText:[[data allValues] objectAtIndex:0]];
        }
        else{
            
            NSDictionary *dicData=[arrReadMoreData objectAtIndex:indexPath.row];
            [cell setCommonData:dicData withIndexPath:indexPath];
        }
        
        
        NSDictionary *data = [[[[packageSectionDetailArray objectAtIndex:indexPath.section] allValues] objectAtIndex:0] objectAtIndex:indexPath.row];
        
//        NSDictionary *dicData=[arrReadMoreData objectAtIndex:indexPath.row];
//        [cell setCommonData:dicData withIndexPath:indexPath];
        [cell.key setText:[[data allKeys] objectAtIndex:0]];
        [cell.value setText:[[data allValues] objectAtIndex:0]];
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
                    WWVendorDetailData *basicInfo= [arrVendorDetailData objectAtIndex:0];
                    cell.name.text= [NSString stringWithFormat:@"%@",basicInfo.name];
                    cell.contactNumber.text= [NSString stringWithFormat:@"%@",basicInfo.contact];
                    cell.address.text= [NSString stringWithFormat:@"%@",basicInfo.top_address];
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
                    [cell showImagesFromArray:basicInfo.heroImages];
                }
                
                return cell;
            }
                break;
            default:
            {
                if(arrVendorDetailData.count>0){
                    @try {
                        NSLog(@"indexPath :%lu array count :%lu", indexPath.row, arrVendorDetailData.count);
                        if (indexPath.row==arrVendorDetailData.count+1) {
                            static NSString *CellIdentifier = @"WWCategoryFooterCell";
                            WWCategoryFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                            if (cell == nil) {
                                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
                                cell = [topLevelObjects objectAtIndex:0];
                            }
                            cell.delegate= self;
                            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                            self.tblCategoryDetail.separatorStyle = UITableViewCellSeparatorStyleNone;
                            return cell;
                        }
                        else{
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
                                cell.btnReadMore.tag=indexPath.row;
                                
                                WWVendorDescription *descData=(WWVendorDescription*)object;
                                [cell getDescriptionData:descData.arrDescriptionData];
                                cell.lblHeading.text= descData.heading;
                                cell.lblHeading.font = [UIFont fontWithName:AppFont size:12.0];
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
                                [cell showCoordinatesOnMapWithLatitude:[(WWVendorMap *)object latitude] longitude:[(WWVendorMap *)object longitude]];
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
                    @catch (NSException *exception) {
                        NSLog(@"Exception :%@", exception);
                    }
                    @finally {
                        
                    }
                    
                }
            }
                break;
        }
    }
    
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _tblReadMore && isPackage) {
        return tableView.sectionHeaderHeight;
    }
    return 0;
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
            default:
            {
                if (indexPath.row==14) {
                    return 50;
                }
                else
                    return 224;
//                id object= [arrVendorDetailData objectAtIndex:indexPath.row-1];
//                
//                if([object isKindOfClass:[WWVendorDescription class]]){
//                    return 224;
//                    
//                }
//                else if ([object isKindOfClass:[WWVendorMap class]]){
//                    return 130;
//                }
//                else if ([object isKindOfClass:[WWVendorPackage class]]){
//                    return 185;
//                }
            }
                break;
        }
    }
    return 0.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView== _tblReadMore){
        if (isPackage) {
            return [[[[packageSectionDetailArray objectAtIndex:section] allValues] objectAtIndex:0] count];
        }
        else{
            return arrReadMoreData.count;
        }
    }
    else{
        return arrVendorDetailData.count+2;
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if(tableView== _tblReadMore){
        if (isPackage) {
            return [packageSectionDetailArray count];
        }
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _tblReadMore) {
        if (isPackage) {
            UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, tableView.sectionHeaderHeight )];
            [header setBackgroundColor:[UIColor blackColor]];
            [header setAlpha:0.5];
            [header setTextColor:[UIColor whiteColor]];
            [header setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
            [header setTextAlignment:NSTextAlignmentCenter];
            [header setText:[[[packageSectionDetailArray objectAtIndex:section] allKeys] objectAtIndex:0]];
            return header;
        }
    }
    return nil;
}

#pragma mark: Cell Delegate methods:
BOOL isPackage;
-(void)showCategryReadMoreView:(id)sender{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         UIButton *readMore=sender;
                         WWVendorDescription *descData=[arrVendorDetailData objectAtIndex:readMore.tag-1];
                         arrReadMoreData= nil;
                         isPackage = NO;
                         if (descData.descReadMoreData != (id)[NSNull null] && descData.descReadMoreData.count>0) {
                             if ([descData.type isEqualToString:@"packages"]) {
                                 isPackage = YES;
                                 arrReadMoreData=descData.descReadMoreData;
                                 [packageSectionsArray removeAllObjects];
                                 [packageSectionDetailArray removeAllObjects];
                                 [packageSectionsArray addObjectsFromArray:[arrReadMoreData[0] allKeys]];   //last key will be removed
                                 
                                 for (int i =0; i < packageSectionsArray.count-1; i++) {
                                     NSString *type = packageSectionsArray[i];
                                     NSArray* options = [[[[arrReadMoreData[0] valueForKey:type] valueForKey:@"package_values"] objectAtIndex:0] valueForKey:@"options"];
                                     [packageSectionDetailArray addObject:@{type:options}];
                                 }
                                 
                             }
                             else{
                                 arrReadMoreData=descData.descReadMoreData;
                             }
                             _lblReadMoreTitle.text=descData.heading;
                             
                             _descriptionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-49);
//                             _tblReadMore.frame = CGRectMake(0, 69, _descriptionView.frame.size.width, _descriptionView.frame.size.width);
                             _tblReadMore.delegate= self;
                             _tblReadMore.dataSource= self;
                             [_tblReadMore reloadData];
                         }
                         else{
                             [[WWCommon getSharedObject]createAlertView:kAppName :@"No data avalilable" :nil :000 ];
                         }
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
                         WWVendorMap *mapData = nil;
                         for (id object in arrVendorDetailData) {
                             if ([object isKindOfClass:[WWVendorMap class]]) {
                                 mapData = object;
                                 break;
                             }
                         }
                         
                         if (mapData) {
                             CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake([mapData.latitude floatValue], [mapData.longitude floatValue]);
                             AnnotationPin *annotation = [[AnnotationPin alloc] initWithCoordinate:coordinates];
                             [self.map addAnnotation:annotation];
                             
                             MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinates, 500, 500);
                             MKCoordinateRegion adjustedRegion = [self.map regionThatFits:viewRegion];
                             [self.map setRegion:adjustedRegion animated:YES];
                         }
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
-(void)bidButtonClicked{
    WWCreateBidVC *createBid=[[WWCreateBidVC alloc]initWithNibName:@"WWCreateBidVC" bundle:nil];
    [self.navigationController pushViewController:createBid animated:YES];
}
-(void)bookButtonClicked{
    WWCreateBidVC *createBid=[[WWCreateBidVC alloc]initWithNibName:@"WWCreateBidVC" bundle:nil];
    [self.navigationController pushViewController:createBid animated:YES];
}

- (IBAction)selectCustomBottonAction:(UIButton *)sender {
    UIViewController *vc = nil;
    switch (sender.tag) {
        case 1:
            vc=[[WWCreateBidVC alloc]init];
            [(WWCreateBidVC *)vc setRequestType:@"bid"];
            break;
        case 2:
            vc=[[WWCreateBidVC alloc]init];
            [(WWCreateBidVC *)vc setRequestType:@"book"];
            break;
        case 3:
            vc=[[WWMessageList alloc]init];
            break;
        case 4:
            vc=[[WWScheduleVC alloc]init];
            break;
            
        default:
            break;
    }
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

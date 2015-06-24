//
//  WWCategoryDetailVC.m
//  WeddingWise
//
//  Created by Dotsquares on 6/16/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWCategoryDetailVC.h"

#import "WWCategoryTitleCell.h"
#import "WWCategoryImageCell.h"
#import "WWCategoryDescriptionCell.h"
#import "WWCategoryMapCell.h"
#import "WWCategoryListingCell.h"
#import "WWCategoryPackageCell.h"

#import <Foundation/Foundation.h>


#define DEGREES_IN_RADIANS(x) (M_PI * x / 180.0)
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)

@interface WWCategoryDetailVC ()<PackageDelegate,FacilityDelegate,DescriptionDelegate, MapCellDelegate,ImageCellDelegate>

@end

@implementation WWCategoryDetailVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setUpCustomView];
    
    
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
            return cell;
        }
            
            break;
        case 2:
        {
            static NSString *CellIdentifier = @"WWCategoryDescriptionCell";
            WWCategoryDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
                cell = [topLevelObjects objectAtIndex:0];
            }
            cell.delegate= self;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            self.tblCategoryDetail.separatorStyle = UITableViewCellSeparatorStyleNone;
            return cell;
        }
            
            break;
        case 3:
        {
            
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
            
            break;
        case 4:
        {
            static NSString *CellIdentifier = @"WWCategoryListingCell";
            WWCategoryListingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
                cell = [topLevelObjects objectAtIndex:0];
            }
            cell.delegate= self;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            self.tblCategoryDetail.separatorStyle = UITableViewCellSeparatorStyleNone;
            return cell;
        }
            
            break;
        case 5:
        {
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
            
            break;
            
        default:
            break;
    }
    
    
    
    
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
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
    return 0.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}


#pragma mark: Cell Delegate methods:
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

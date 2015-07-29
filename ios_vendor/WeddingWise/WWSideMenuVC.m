//
//  WWSideMenuVC.m
//  WeddingWise
//
//  Created by Deepak Sharma on 7/21/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWSideMenuVC.h"
#import "WWProfileVC.h"
#import "WWDashboardVC.h"
#import "WWChangePasswordVC.h"
#import "WWCreateBidVC.h"

@interface WWSideMenuVC ()
{
    NSArray *menuData;
}
@end

@implementation WWSideMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    menuData =[[NSArray alloc]initWithObjects:@"Create new booking", @"Change Password", @"Logout", nil];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [self.tabBarController.navigationController.navigationBar setHidden:YES];
    [self.navigationController.navigationBar setHidden:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return menuData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.text = [menuData objectAtIndex:indexPath.row];
    [cell.textLabel setFont:[UIFont fontWithName:AppFont size:17.0]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            WWCreateBidVC *changePassword=[[WWCreateBidVC alloc]initWithNibName:@"WWCreateBidVC" bundle:nil];
            [self.navigationController pushViewController:changePassword animated:YES];
        }
            break;
            
        case 1:{
            WWChangePasswordVC *changePassword=[[WWChangePasswordVC alloc]initWithNibName:@"WWChangePasswordVC" bundle:nil];
            [self.navigationController pushViewController:changePassword animated:YES];
        }
            break;
        case 2:{
            WWDashboardVC *dash=[[WWDashboardVC alloc]initWithNibName:@"WWDashboardVC" bundle:nil];
            dash.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:dash animated:YES];
        }
            break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

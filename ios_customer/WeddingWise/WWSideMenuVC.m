//
//  WWSideMenuVC.m
//  WeddingWise
//
//  Created by Deepak Sharma on 7/21/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWSideMenuVC.h"
#import "WWProfileVC.h"

@interface WWSideMenuVC ()
{
    NSArray *menuData;
}
@end

@implementation WWSideMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    menuData =[[NSArray alloc]initWithObjects:@"Favorite",@"Profile",@"Logout", nil];
    // Do any additional setup after loading the view from its nib.
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
        case 0:
        {
            WWProfileVC *profileVC=[[WWProfileVC alloc]initWithNibName:@"WWProfileVC" bundle:nil];
            [self.navigationController pushViewController:profileVC animated:YES];
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

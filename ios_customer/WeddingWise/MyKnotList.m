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

@interface MyKnotList ()

@end

@implementation MyKnotList

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    //[self.navigationController.navigationBar setHidden:NO];
}
#pragma mark - Methods
- (void)configureCell:(myKnotCell *)cell forIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            cell.leftImage.image=[UIImage imageNamed:@"screen1"];
            [cell.leftButton setTitle:@"Photography" forState:UIControlStateNormal];
            break;
        case 1:
            cell.leftImage.image=[UIImage imageNamed:@"screen2"];
            [cell.leftButton setTitle:@"Decoraters" forState:UIControlStateNormal];
            break;
        case 2:
            cell.leftImage.image=[UIImage imageNamed:@"screen3"];
            [cell.leftButton setTitle:@"Caterers" forState:UIControlStateNormal];
            break;
        case 3:
            cell.leftImage.image=[UIImage imageNamed:@"screen4"];
            [cell.leftButton setTitle:@"Holiday Package" forState:UIControlStateNormal];
            break;
        case 4:
            cell.leftImage.image=[UIImage imageNamed:@"screen5"];
            [cell.leftButton setTitle:@"Hair & Makeup" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
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
    
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 175.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WWDetailScreen *detailScreen=[[WWDetailScreen alloc]initWithNibName:@"WWDetailScreen" bundle:nil];
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

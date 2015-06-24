//
//  WWInquiryDetailVC.m
//  WeddingWise
//
//  Created by Deepak Sharma on 6/24/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWInquiryDetailVC.h"
#import "WWInquiryCell.h"
#import "WWHistoryCell.h"
#import "WWFooterCell.h"
#import "WWCreateBidVC.h"

@interface WWInquiryDetailVC ()
{
    NSArray *arrTitle;
    NSArray *arrValue;
}
@end

@implementation WWInquiryDetailVC
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)addNewInquiry:(id)sender {
    WWCreateBidVC *createBid=[[WWCreateBidVC alloc]initWithNibName:@"WWCreateBidVC" bundle:nil];
    [self.navigationController pushViewController:createBid animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setHidden:YES];
    
    arrTitle=[[NSArray alloc]initWithObjects:@"Event Date",
                    @"Event Type",
                       @"Inquiry Date",
                       @"Bride's Name",
                       @"Groom's Name",
                       @"Package Selected",
                       @"Faxe",
                       @"Our last offer",
                       @"Revenue Potential",
                       @"Client's last offer",
                       @"Revenue potential",
                       nil];
    arrValue=[[NSArray alloc]initWithObjects:@"25-Nov-15 Evening",
                        @"Cocktail",
                        @"20 June 15",
                        @"Anushka Sharma",
                        @"Virat Kohli",
                        @"NV 2",
                        @"550",
                        @"1800 ++",
                        @"6.3 ++",
                        @"1500 ++",
                        @"5.25 ++",
                        nil];
    
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - Table view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row==11){
        static NSString *CellIdentifier = @"WWHistoryCell";
        WWHistoryCell *historyCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (historyCell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            historyCell = [topLevelObjects objectAtIndex:0];
        }
        [historyCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return historyCell;
    }
    else if (indexPath.row==12){
        
        static NSString *CellIdentifier = @"WWFooterCell";
        WWFooterCell *historyCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (historyCell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            historyCell = [topLevelObjects objectAtIndex:0];
        }
        [historyCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return historyCell;
    }
    else{
        static NSString *CellIdentifier = @"WWInquiryCell";
        WWInquiryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.lblTitle.text=[arrTitle objectAtIndex:indexPath.row];
        cell.lblValue.text  =[arrValue objectAtIndex:indexPath.row];
        return cell;
    }
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;{
    if(indexPath.row==11){
        return 200.0f;
    }
    return 42.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrTitle count] + 1 +1;
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

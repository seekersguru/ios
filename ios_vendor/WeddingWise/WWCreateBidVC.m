//
//  WWCreateBidVC.m
//  WeddingWise
//
//  Created by Dotsquares on 6/17/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWCreateBidVC.h"

@interface WWCreateBidVC ()

@end

@implementation WWCreateBidVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setHidden:YES];
    
    // Do any additional setup after loading the view from its nib.
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

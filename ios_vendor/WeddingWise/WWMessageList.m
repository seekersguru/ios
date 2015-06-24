//
//  WWMessageList.m
//  WeddingWise
//
//  Created by Dotsquares on 6/11/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWMessageList.h"
#import "MessageListCell.h"
#import "WWPrivateMessage.h"

@interface WWMessageList ()

@end

@implementation WWMessageList

- (void)viewDidLoad {
    
    [self.navigationController.navigationBar setHidden:YES];
    [messageTable registerNib:[UINib nibWithNibName:@"MessageListCell" bundle:nil] forCellReuseIdentifier:@"MessageListCell"];
    bidBtn.selected = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)moveImage:(UIImageView *)image duration:(NSTimeInterval)duration
            curve:(int)curve x:(CGFloat)x y:(CGFloat)y
{
    // Setup the animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    // The transform matrix
    CGAffineTransform transform = CGAffineTransformMakeTranslation(x, y);
    image.transform = transform;
    
    // Commit the changes
    [UIView commitAnimations];
    
}

-(IBAction)bidBtnClicked:(id)sender
{
    bidBtn.selected = YES;
    bookBtn.selected = NO;
    messageBtn.selected = NO;
    
    
    
    [self moveImage:selectorImage duration:0.2 curve:UIViewAnimationCurveLinear x:bidBtn.frame.origin.x y:0.0];
}
-(IBAction)bookBtnClicked:(id)sender
{
    bidBtn.selected = NO;
    bookBtn.selected = YES;
    messageBtn.selected = NO;
    
    // Move the image
    [self moveImage:selectorImage duration:0.2
              curve:UIViewAnimationCurveLinear x:bookBtn.frame.origin.x y:0.0];
}

-(IBAction)messageBtnClicked:(id)sender
{
    bidBtn.selected = NO;
    bookBtn.selected = NO;
    messageBtn.selected = YES;
    
    [self moveImage:selectorImage duration:0.2
              curve:UIViewAnimationCurveLinear x:messageBtn.frame.origin.x y:0.0];
}

#pragma mark - Tableview delegate/datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==messageTable)
    {
        MessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageListCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WWPrivateMessage *messageVc = [[WWPrivateMessage alloc] initWithNibName:@"WWPrivateMessage" bundle:nil];
    
    [self.navigationController pushViewController:messageVc animated:YES];
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

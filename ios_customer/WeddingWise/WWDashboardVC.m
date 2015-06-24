//
//  WWLoginVC.m
//  WeddingWise
//
//  Created by Deepak Sharma on 5/20/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWDashboardVC.h"
#import "WWLoginVC.h"
#import "WWRegistrationVC.h"
#import "FacebookManager.h"
#import <GoogleOpenSource/GoogleOpenSource.h>

@interface WWDashboardVC ()

@end


@implementation WWDashboardVC

#import <GooglePlus/GooglePlus.h>
- (void)viewDidLoad {
    
    //lblPolicy.font = [UIFont fontWithName:AppFont size:14];
    
    [self.navigationController.navigationBar setHidden:YES];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)refreshInterfaceBasedOnSignIn {
    if ([[GPPSignIn sharedInstance] authentication]) {
        // The user is signed in.
        self.signInButton.hidden = YES;
        // Perform other actions here, such as showing a sign-out button
    } else {
        self.signInButton.hidden = NO;
        // Perform other actions here
    }
}
- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
    NSLog(@"Received error %@ and auth object %@",error, auth);
    if (error) {
        // Do some error handling here.
    } else {
        [self refreshInterfaceBasedOnSignIn];
        
        GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
        
        NSLog(@"email %@ ", [NSString stringWithFormat:@"Email: %@",[GPPSignIn sharedInstance].authentication.userEmail]);
        NSLog(@"Received error %@ and auth object %@",error, auth);
        
        // 1. Create a |GTLServicePlus| instance to send a request to Google+.
        GTLServicePlus* plusService = [[GTLServicePlus alloc] init] ;
        plusService.retryEnabled = YES;
        
        // 2. Set a valid |GTMOAuth2Authentication| object as the authorizer.
        [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];
        
        // 3. Use the "v1" version of the Google+ API.*
        plusService.apiVersion = @"v1";
        [plusService executeQuery:query
                completionHandler:^(GTLServiceTicket *ticket,
                                    GTLPlusPerson *person,
                                    NSError *error) {
                    if (error) {
                        //Handle Error
                    } else {
                        NSLog(@"Email= %@", [GPPSignIn sharedInstance].authentication.userEmail);
                        NSLog(@"GoogleID=%@", person.identifier);
                        NSLog(@"User Name=%@", [person.name.givenName stringByAppendingFormat:@" %@", person.name.familyName]);
                        NSLog(@"Gender=%@", person.gender);
                    }
                }];
        
    }
}
-(IBAction)googleSignIn:(id)sender{
    [self signInGoogle];
}
-(void)signInGoogle{
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.delegate = self;
    signIn.shouldFetchGoogleUserEmail = YES;
    signIn.clientID = kGPClientID;
    signIn.scopes = [NSArray arrayWithObjects:kGTLAuthScopePlusLogin,nil];
    signIn.actions = [NSArray arrayWithObjects:@"http://schemas.google.com/ListenActivity",nil];
    [signIn authenticate];

}
- (void)signOut {
    [[GPPSignIn sharedInstance] signOut];
}
- (void)disconnect {
    [[GPPSignIn sharedInstance] disconnect];
}

- (void)didDisconnectWithError:(NSError *)error {
    if (error) {
        NSLog(@"Received error %@", error);
    } else {
        // The user is signed out and disconnected.
        // Clean up user data as specified by the Google+ terms.
    }
}
-(IBAction)btnLoginPressed:(id)sender{
    WWLoginVC *loginVC=[[WWLoginVC alloc]initWithNibName:@"WWLoginVC" bundle:nil];
    [self.navigationController pushViewController:loginVC animated:YES];
}
-(IBAction)btnRegistrationPressed:(id)sender{
    WWRegistrationVC *registrationVC=[[WWRegistrationVC alloc]initWithNibName:@"WWRegistrationVC" bundle:nil];
    [self.navigationController pushViewController:registrationVC animated:YES];
}
-(IBAction)btnShowMorePressed:(id)sender{

}
-(IBAction)btnFBLoginPressed:(id)sender{
    [[FacebookManager sharedManager]facebookLogin];
}
-(IBAction)btnGooglePressed:(id)sender{

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

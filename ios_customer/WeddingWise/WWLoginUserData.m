//
//  WWLoginUserData.m
//  WeddingWise
//
//  Created by Deepak Sharma on 7/13/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWLoginUserData.h"

@implementation WWLoginUserData
-(instancetype)setUserData:(NSDictionary*)userData{
    [self setIdentifier:[userData valueForKey:@"identifier"]];
    [self setEmailID:[userData valueForKey:@"email"]];
    [self setBrideName:[userData valueForKey:@"bride_name"]];
    [self setGroomName:[userData valueForKey:@"groom_name"]];
    [self setContactNumber:[userData valueForKey:@"contact_number"]];
    [self setTentativeDate:[userData valueForKey:@"tentative_wedding_date"]];
    return self;
}
@end

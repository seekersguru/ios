//
//  WWVendorDetailData.m
//  WeddingWise
//
//  Created by Deepak Sharma on 7/8/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import "WWVendorDetailData.h"

@implementation WWVendorDetailData

+ (instancetype)sharedInstance
{
    static WWVendorDetailData *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WWVendorDetailData alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

-(void)setVendorBasicInfo:(NSDictionary*)basicInfo{
    
    [self setTopName:[basicInfo valueForKey:@"top_name"]];
    [self setName:[basicInfo valueForKey:@"name"]];
    [self setTop_address:[basicInfo valueForKey:@"top_address"]];
    [self setContact:[basicInfo valueForKey:@"contact"]];
    [self setStartingPrice:[basicInfo valueForKey:@"starting_price"]];
    [self setHeroImages:[basicInfo valueForKey:@"hero_imgs"]];
    [self setVideoLinks:[basicInfo valueForKey:@"video_links"]];
    [self setPanormaImages:[basicInfo valueForKey:@"360_imgs"]];
}
@end

@implementation WWVendorBidData

+ (instancetype)sharedInstance{
    static WWVendorBidData *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WWVendorBidData alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (void)setVendorBidInfo:(NSDictionary *)bidInfo{
    NSMutableArray *timeSlotArray = [NSMutableArray new];
    for (NSArray *obj in bidInfo[@"time_slot"][@"value"]) {
        [timeSlotArray addObject:[obj firstObject]];
    }
    [self setTime_slot:timeSlotArray];
    [self setPackage:bidInfo[@"package"]];
    [self setQuoted:bidInfo[@"quoted"]];
    [self setMaxItemPerPlate:[NSNumber numberWithInteger:[bidInfo[@"bid_options"][@"item"][@"max"] integerValue]]];
    [self setMinItemPerPlate:[NSNumber numberWithInteger:[bidInfo[@"bid_options"][@"item"][@"min"] integerValue]]];
    [self setMaxPerson:[NSNumber numberWithInteger:[bidInfo[@"bid_options"][@"quantity"][@"max"] integerValue]]];
    [self setMinPerson:[NSNumber numberWithInteger:[bidInfo[@"bid_options"][@"quantity"][@"min"][@"value"] integerValue]]];
    [self setBidDictionary:bidInfo];
}
@end

@implementation WWVendorBookingData

+ (instancetype)sharedInstance{
    static WWVendorBookingData *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WWVendorBookingData alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (void)setVendorBookingInfo:(NSDictionary *)bookingInfo{
    NSMutableArray *timeSlotArray = [NSMutableArray new];
    for (NSArray *obj in bookingInfo[@"time_slot"][@"value"]) {
        [timeSlotArray addObject:[obj firstObject]];
    }
    [self setTime_slot:timeSlotArray];
    [self setPackage:bookingInfo[@"package"]];
    [self setBookDictionary:bookingInfo];
}
@end

@implementation WWVendorDescription
-(WWVendorDescription*)setVendorDescrition:(NSDictionary*)descriptionInfo{

    [self setArrDescriptionData:[[descriptionInfo valueForKey:@"data_display"] valueForKey:@"key_values"]];
    [self setDescReadMoreData:[[[[descriptionInfo valueForKey:@"data_display"] valueForKey:@"read_more"] valueForKey:@"data_display"] valueForKey:@"key_values"]];
    
    NSArray *strHeading=[[[descriptionInfo valueForKey:@"data_display"] valueForKey:@"read_more"] valueForKey:@"heading"];
    [self setHeading:[strHeading objectAtIndex:0]];
    
    return self;
}
@end

@implementation WWVendorFacility
-(WWVendorFacility*)setVendorFacility:(NSDictionary*)descriptionInfo{
    
    [self setArrFacilityData:[[descriptionInfo valueForKey:@"data_display"] valueForKey:@"key_values"]];
    [self setFacilityReadMoreData:[[[[descriptionInfo valueForKey:@"data_display"] valueForKey:@"read_more"] valueForKey:@"data_display"] valueForKey:@"key_values"]];
    
    NSArray *strHeading=[[[descriptionInfo valueForKey:@"data_display"] valueForKey:@"read_more"] valueForKey:@"heading"];
    [self setHeading:[strHeading objectAtIndex:0]];
    
    return self;
}

@end

@implementation WWVendorPackage

-(WWVendorPackage*)setVendorPackage:(NSDictionary*)packageInfo{
    
    [self setArrPackageData:[[packageInfo valueForKey:@"data_display"] valueForKey:@"key_values"]];
    [self setPackageReadMoreData:[[[[packageInfo valueForKey:@"data_display"] valueForKey:@"read_more"] valueForKey:@"data_display"] valueForKey:@"key_values"]];
    
    NSArray *strHeading=[[[packageInfo valueForKey:@"data_display"] valueForKey:@"read_more"] valueForKey:@"heading"];
    [self setHeading:[strHeading objectAtIndex:0]];
    
    return self;
}
@end

@implementation WWVendorMap : NSObject
-(WWVendorMap*)setVendorMap:(NSDictionary*)mapInfo{
    
    return self;
}
@end

//
//  WWCategoryCell.h
//  WeddingWise
//
//  Created by Dotsquares on 6/16/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWCategoryCell : UITableViewCell

@property(nonatomic, weak)IBOutlet UIImageView *imgCategory;
@property(nonatomic, weak)IBOutlet UILabel *lblName;
@property(nonatomic, weak)IBOutlet UILabel *lblVeg;
@property(nonatomic, weak)IBOutlet UILabel *lblCapacity;
@property(nonatomic, weak)IBOutlet UILabel *lblStartingPrice;

/*
 {
 icons =                 (
 );
 id = "vendor_id";
 image = "/media/apps/ios/2x/category/caterers.jpg";
 "in_favourites" = 3;
 name = "Name of the vendor";
 "others_one" =                 (
 Alcohol,
 "Jain Only",
 "Veg Only"
 );
 "others_two" =                 (
 (
 Capacity,
 "200 - 500 peoples"
 )
 );
 "starting_price" = 500;
 "starting_rice_labe" = Person;
 "years_in_business" = "2 years";
 },
 
 */



@end

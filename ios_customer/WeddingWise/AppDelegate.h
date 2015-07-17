//
//  AppDelegate.h
//  WeddingWise
//
//  Created by Deepak Sharma on 5/11/15.
//  Copyright (c) 2015 DS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "WWLoginUserData.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *viewController;

@property(nonatomic, strong)UITabBarController *tabBarController;
@property(nonatomic, strong)UINavigationController *navigation;

@property(nonatomic, assign)BOOL isFBLogin;


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@property(nonatomic, strong)WWLoginUserData *userData;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
+(instancetype)sharedAppDelegate;

- (void)setupViewControllers:(UINavigationController*)navigationView;

@end


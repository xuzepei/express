//
//  FoodAppDelegate.h
//  Food
//
//  Created by xuzepei on 9/27/11.
//  Copyright 2011 Rumtel Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "GADBannerView.h"

@class WRSysTabBarController;
@class FDUnfitViewController;
@class FDFitViewController;
@class FDSearchViewController;
@class FDPictureViewController;
@class FDFavoriteViewController;
@interface FoodAppDelegate : NSObject <UIApplicationDelegate,GADBannerViewDelegate> {
    
    UIWindow *window;
    WRSysTabBarController* _tabBarController;
	
	FDUnfitViewController* _unfitViewController;
	UINavigationController* _unfitNavigationController;
	
	FDFitViewController* _fitViewController;
	UINavigationController* _fitNavigationController;
	
	FDSearchViewController* _searchViewController;
	UINavigationController* _searchNavigationController;
	
	FDPictureViewController* _pictureViewController;
	UINavigationController* _pictureNavigationController;
	
	FDFavoriteViewController* _favoriteViewController;
	UINavigationController* _favoriteNavigationController;
	
	GADBannerView *adMobAd;

@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) WRSysTabBarController *_tabBarController;

@property (nonatomic, retain) FDUnfitViewController* _unfitViewController;
@property (nonatomic, retain) UINavigationController* _unfitNavigationController;

@property (nonatomic, retain) FDFitViewController* _fitViewController;
@property (nonatomic, retain) UINavigationController* _fitNavigationController;

@property (nonatomic, retain) FDSearchViewController* _searchViewController;
@property (nonatomic, retain) UINavigationController* _searchNavigationController;

@property (nonatomic, retain) FDPictureViewController* _pictureViewController;
@property (nonatomic, retain) UINavigationController* _pictureNavigationController;

@property (nonatomic, retain) FDFavoriteViewController* _favoriteViewController;
@property (nonatomic, retain) UINavigationController* _favoriteNavigationController;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) GADBannerView *adMobAd;

- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;

@end


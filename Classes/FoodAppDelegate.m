//
//  FoodAppDelegate.m
//  Food
//
//  Created by xuzepei on 9/27/11.
//  Copyright 2011 Rumtel Co.,Ltd. All rights reserved.
//

#import "FoodAppDelegate.h"
#import "WRSysTabBarController.h"
#import "FDUnfitViewController.h"
#import "FDFitViewController.h"
#import "FDPictureViewController.h"
#import "FDFavoriteViewController.h"
#import "RCTool.h"
#import "GADBannerView.h"

@implementation FoodAppDelegate

@synthesize window;
@synthesize _tabBarController;

@synthesize _unfitViewController;
@synthesize _unfitNavigationController;

@synthesize _fitViewController;
@synthesize _fitNavigationController;

@synthesize _searchViewController;
@synthesize _searchNavigationController;

@synthesize _pictureViewController;
@synthesize _pictureNavigationController;

@synthesize _favoriteViewController;
@synthesize _favoriteNavigationController;

@synthesize adMobAd;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	[RCTool importLocalData];
	
	
	//快递列表
	_unfitViewController = [[FDUnfitViewController alloc] initWithNibName:nil
																		bundle:nil];

	_unfitNavigationController = [[UINavigationController alloc] 
									initWithRootViewController:_unfitViewController];
	
	_unfitNavigationController.navigationBar.tintColor = NAVIGATION_BAR_COLOR;
    
    
    //常用快递
    _fitViewController = [[FDFitViewController alloc] initWithNibName:@"FDFitViewController"
                                                               bundle:nil];
	
	_fitNavigationController = [[UINavigationController alloc]
                                initWithRootViewController:_fitViewController];
    
	_fitNavigationController.navigationBar.tintColor = NAVIGATION_BAR_COLOR;

	
	//快递查询
	_pictureViewController = [[FDPictureViewController alloc] initWithNibName:@"FDPictureViewController" 
																	 bundle:nil];
	
	_pictureNavigationController = [[UINavigationController alloc] 
								   initWithRootViewController:_pictureViewController];

	_pictureNavigationController.navigationBar.tintColor = NAVIGATION_BAR_COLOR;
	


	//历史查询
	_favoriteViewController = [[FDFavoriteViewController alloc] initWithNibName:@"FDFavoriteViewController" 
																	   bundle:nil];
	
	_favoriteNavigationController = [[UINavigationController alloc] 
									initWithRootViewController:_favoriteViewController];
	
	_favoriteNavigationController.navigationBar.tintColor = NAVIGATION_BAR_COLOR;
	
	_tabBarController = [[WRSysTabBarController alloc] initWithNibName:@"WRSysTabBarController" 
																bundle:nil];
	
	
	[_tabBarController setViewControllers:[NSArray arrayWithObjects:
										   _unfitNavigationController,
										   _fitNavigationController,
										   _pictureNavigationController,
										   _favoriteNavigationController,nil] animated:YES];
	
	[_unfitNavigationController release];
	[_fitNavigationController release];
	[_pictureNavigationController release];
	[_favoriteNavigationController release];
	
    [window addSubview:_tabBarController.view];
    [window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    [self saveContext];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    [self getAD:nil];
}


/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveContext];
}


- (void)saveContext {
    
    NSError *error = nil;
	NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}    


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    
    if (managedObjectContext_ != nil) {
        return managedObjectContext_;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext_ = [[NSManagedObjectContext alloc] init];
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext_;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel_ != nil) {
        return managedObjectModel_;
    }
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"Food" ofType:@"momd"];
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return managedObjectModel_;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator_ != nil) {
        return persistentStoreCoordinator_;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Food.sqlite"];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
							 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
							 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    NSError *error = nil;
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return persistentStoreCoordinator_;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    
    [managedObjectContext_ release];
    [managedObjectModel_ release];
    [persistentStoreCoordinator_ release];
    
    [_unfitViewController release];
	[_unfitNavigationController release];
	
	[_fitViewController release];
	[_fitNavigationController release];
	
	[_searchViewController release];
	[_searchNavigationController release];
	
	[_pictureViewController release];
	[_pictureNavigationController release];
	
	[_favoriteViewController release];
	[_favoriteNavigationController release];
	
	[_tabBarController release];
    [window release];
	
	[adMobAd release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark  AD

- (void)initAdMob
{
	if(NO == [RCTool isIpad])
	{
		adMobAd = [[GADBannerView alloc]
				   initWithFrame:CGRectMake(0.0,0,
											GAD_SIZE_320x50.width,
											GAD_SIZE_320x50.height)];
	}
	else
	{
		adMobAd = [[GADBannerView alloc]
				   initWithFrame:CGRectMake((768 - GAD_SIZE_728x90.width)/2.0,
											0,
											GAD_SIZE_728x90.width,
											GAD_SIZE_728x90.height)];
	}
	
	
	
	adMobAd.adUnitID = AD_ID;
	adMobAd.delegate = self;
	adMobAd.alpha = 0.0;
	adMobAd.rootViewController = _tabBarController;
	[adMobAd loadRequest:[GADRequest request]];
	
}

- (void)getAD:(id)agrument
{
	NSLog(@"getAD");
	
	if(adMobAd && adMobAd.alpha == 0.0 && nil == adMobAd.superview)
	{
		[adMobAd removeFromSuperview];
		adMobAd.delegate = nil;
		[adMobAd release];
		adMobAd = nil;
	}
	
	[self initAdMob];
}

#pragma mark -
#pragma mark GADBannerDelegate methods

- (UIViewController *)getVisibleViewController {
    
    UIViewController *visible = _tabBarController.selectedViewController; // For non-nav controllers
	if ([visible respondsToSelector:@selector(visibleViewController)]) // For nav controllers
		visible = [((UINavigationController*)visible) visibleViewController];
    
    return visible;
}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView
{
	NSLog(@"adViewDidReceiveAd");
	
    if(nil == adMobAd.superview && adMobAd.alpha == 0.0)
    {
        adMobAd.alpha = 1.0;
        NSLog(@"%@",[self getVisibleViewController]);
        
        UIViewController* visibleViewController = [self getVisibleViewController];
        if([visibleViewController isKindOfClass:[FDPictureViewController class]])
        {
            CGRect rect = adMobAd.frame;
            
            if([RCTool systemVersion] >= 7.0)
            {
                rect.origin.y = [RCTool getScreenSize].height -TAB_BAR_HEIGHT - adMobAd.frame.size.height;
                adMobAd.frame = rect;
            }
            else
            {
                rect.origin.y = [RCTool getScreenSize].height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - TAB_BAR_HEIGHT - adMobAd.frame.size.height;
                adMobAd.frame = rect;
            }
            
            [_tabBarController.selectedViewController.view addSubview: adMobAd];
        }
    }
}

- (void)adView:(GADBannerView *)bannerView
didFailToReceiveAdWithError:(GADRequestError *)error
{
	NSLog(@"didFailToReceiveAdWithError");

	[self performSelector:@selector(getAD:) 
			   withObject:nil afterDelay:10];
}


@end


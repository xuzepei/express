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
#import "RCHttpRequest.h"
#import "MobClick.h"

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


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //UMeng
    [MobClick startWithAppkey:UMENG_APP_KEY
                 reportPolicy:SEND_INTERVAL
                    channelId:nil];
    
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
    
    if([RCTool systemVersion] >=7.0)
    {
        [[UINavigationBar appearance] setBarTintColor:NAVIGATION_BAR_COLOR];
        
        //[[UITabBar appearance] setTintColor:NAVIGATION_BAR_COLOR];
        //[[UITabBar appearance] setBarTintColor:TAB_BAR_COLOR];
        
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        
//        NSShadow *shadow = [[[NSShadow alloc] init] autorelease];
//        shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
//        shadow.shadowOffset = CGSizeMake(1, 1);
        
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                               NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
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
    
    self.showFullScreenAd = YES;
    [self getAppInfo];
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
	
    self.adMobAd = nil;
    self.adInterstitial = nil;
    
    self.adView = nil;
    self.interstitial = nil;
    
    self.ad_id = nil;
	
    [super dealloc];
}

#pragma mark - AdMob

#pragma mark - App Info

- (void)getAppInfo
{
    NSString* urlString = APP_INFO_URL;
    
    RCHttpRequest* temp = [RCHttpRequest sharedInstance];
    [temp request:urlString delegate:self resultSelector:@selector(finishedGetAppInfoRequest:) token:nil];
}

- (void)finishedGetAppInfoRequest:(NSString*)jsonString
{
    if(0 == [jsonString length])
    {
        self.ad_id = [RCTool getAdId];
        
        [self getAD];
        
        return;
    }
    
    NSDictionary* result = [RCTool parseToDictionary: jsonString];
    if(result && [result isKindOfClass:[NSDictionary class]])
    {
        //保存用户信息
        [[NSUserDefaults standardUserDefaults] setObject:result forKey:@"app_info"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        self.ad_id = [RCTool getAdId];
        
        [self getAD];
    }
    
}

- (void)initAdMob
{
    if(_adMobAd && _adMobAd.alpha == 0.0 && nil == _adMobAd.superview)
	{
		[_adMobAd removeFromSuperview];
		_adMobAd.delegate = nil;
		[_adMobAd release];
		_adMobAd = nil;
	}
    
	if(NO == [RCTool isIpad])
	{
		_adMobAd = [[GADBannerView alloc]
                    initWithFrame:CGRectMake(0.0,0,
                                             320.0f,
                                             50.0f)];
	}
	else
	{
        _adMobAd = [[GADBannerView alloc]
                    initWithFrame:CGRectMake(0.0,0,
                                             728.0f,
                                             90.0f)];
	}
	
	
	
	_adMobAd.adUnitID = [RCTool getAdId];
	_adMobAd.delegate = self;
	_adMobAd.alpha = 0.0;
	_adMobAd.rootViewController = _tabBarController;
	[_adMobAd loadRequest:[GADRequest request]];
	
}

- (void)getAD
{
	NSLog(@"getAD");
    
    if(self.adMobAd && self.adMobAd.superview)
    {
        [self.adMobAd removeFromSuperview];
        self.adMobAd = nil;
    }
    
    if(self.adView && self.adView.superview)
    {
        [self.adView removeFromSuperview];
        self.adView = nil;
    }
    self.adInterstitial = nil;
    self.interstitial = nil;
	
	[self initAdMob];
    
    [self getAdInterstitial];
}

#pragma mark -
#pragma mark GADBannerDelegate methods

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView
{
	NSLog(@"adViewDidReceiveAd");
	
    if(nil == _adMobAd.superview && _adMobAd.alpha == 0.0)
    {
        _adMobAd.alpha = 1.0;
        CGRect rect = _adMobAd.frame;
        rect.origin.x = ([RCTool getScreenSize].width - rect.size.width)/2.0;
        rect.origin.y = [RCTool getScreenSize].height;
        _adMobAd.frame = rect;
 
        self.isAdMobVisible = NO;
    }
}

- (void)adView:(GADBannerView *)bannerView
didFailToReceiveAdWithError:(GADRequestError *)error
{
	NSLog(@"didFailToReceiveAdWithError");
    
    self.isAdMobVisible = NO;
    
    [self initAdView];
}

- (void)getAdInterstitial
{
    if(nil == self.adInterstitial && [self.ad_id length])
    {
        _adInterstitial = [[GADInterstitial alloc] init];
        _adInterstitial.adUnitID = [RCTool getScreenAdId];
        _adInterstitial.delegate = self;
    }
    
    [_adInterstitial loadRequest:[GADRequest request]];
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial
{
    NSLog(@"interstitialDidReceiveAd");
    
    if(self.showFullScreenAd)
    {
        self.showFullScreenAd = NO;
        [self showInterstitialAd:nil];
    }
    
}

- (void)interstitial:(GADInterstitial *)ad
didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"%s",__FUNCTION__);
    
    [self initInterstitial];
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad
{
    self.adInterstitial = nil;
    [self getAdInterstitial];
}

- (void)showInterstitialAd:(id)argument
{
    if(self.adInterstitial)
    {
        [self.adInterstitial presentFromRootViewController:_tabBarController.selectedViewController];
    }
    else if(self.interstitial && self.interstitial.loaded)
    {
        [self.interstitial presentFromViewController:_tabBarController.selectedViewController];
    }
}

#pragma mark - iAd

- (void)initAdView
{
    if(nil == _adView)
        _adView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
    _adView.delegate = self;
    CGRect rect = _adView.frame;
    rect.origin.y = [RCTool getScreenSize].height;
    _adView.frame = rect;
    
    self.isAdViewVisible = NO;
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"iAd,bannerViewDidLoadAd");
    
    //[[RCTool getRootNavigationController].topViewController.view addSubview:_adView];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"iAd,didFailToReceiveAdWithError");
    
    self.isAdViewVisible = NO;
    [self.adView removeFromSuperview];
    self.adView = nil;
    
    //如果iAd失败，则调用admob
    [self performSelector:@selector(initAdMob) withObject:nil afterDelay:3];
}

- (void)initInterstitial
{
    if(NO == [RCTool isIpad])
        return;
    
    if(nil == _interstitial)
    {
        _interstitial = [[ADInterstitialAd alloc] init];
        _interstitial.delegate = self;
    }
    
}

- (void)interstitialAdDidLoad:(ADInterstitialAd *)interstitialAd
{
    NSLog(@"iAd,interstitialAdDidLoad");
    

}

- (void)interstitialAdDidUnload:(ADInterstitialAd *)interstitialAd
{
    NSLog(@"iAd,interstitialAdDidUnload");
    self.interstitial = nil;
}

- (void)interstitialAd:(ADInterstitialAd *)interstitialAd didFailWithError:(NSError *)error
{
    NSLog(@"iAd,interstitialAd <%@> recieved error <%@>", interstitialAd, error);
    self.interstitial = nil;
    
    //尝试调用Admob的全屏广告
    [self getAdInterstitial];
}


@end


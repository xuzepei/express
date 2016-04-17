//
//  RCTool.h
//  rsscoffee
//
//  Created by beer on 8/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCTool : NSObject {

}

+ (BOOL)saveImage:(NSData*)data path:(NSString*)path;
+ (NSString*)getImageLocalPath:(NSString *)path;
+ (UIImage*)getImageFromLocal:(NSString*)path;
+ (BOOL)isExistingFile:(NSString*)path;
+ (BOOL)removeFile:(NSString*)filePath;
+ (UIImage *)imageWithImage:(UIImage *)image
               scaledToSize:(CGSize)newSize;

+ (NSString*)getUserDocumentDirectoryPath;
+ (NSString *)md5:(NSString *)str;
+ (CGFloat)systemVersion;
+ (NSDictionary*)parseToDictionary:(NSString*)jsonString;

+ (BOOL)isExistingFile:(NSString*)path;

+ (void)setReachabilityType:(int)type;
+ (int)getReachabilityType;
+ (BOOL)isReachableViaWiFi;
+ (BOOL)isReachableViaInternet;

+ (NSPersistentStoreCoordinator*)getPersistentStoreCoordinator;
+ (NSManagedObjectContext*)getManagedObjectContext;
+ (NSManagedObjectID*)getExistingEntityObjectIDForName:(NSString*)entityName
											 predicate:(NSPredicate*)predicate
									   sortDescriptors:(NSArray*)sortDescriptors
											   context:(NSManagedObjectContext*)context;

+ (NSArray*)getExistingEntityObjectsForName:(NSString*)entityName
								  predicate:(NSPredicate*)predicate
							sortDescriptors:(NSArray*)sortDescriptors;

+ (id)insertEntityObjectForName:(NSString*)entityName 
		   managedObjectContext:(NSManagedObjectContext*)managedObjectContext;

+ (id)insertEntityObjectForID:(NSManagedObjectID*)objectID 
		 managedObjectContext:(NSManagedObjectContext*)managedObjectContext;

+ (void)saveCoreData;

+ (void)importLocalData;

+ (BOOL)isIpad;

+ (UIView*)getAdView;
+ (void)showScreenAdView;

+ (NSDictionary*)parse:(NSString*)jsonString;

+ (NSString*)getKey;

+ (NSDictionary*)getResult:(NSString*)timeString;
+ (void)saveResult:(NSDictionary*)dict time:(NSString*)timeString;

+ (UIWindow*)frontWindow;

#pragma mark - 最近选择的快递

+ (void)addRecentExpress:(NSString*)expressCode;
+ (NSArray*)getRecentExpress;

#pragma mark - 兼容iOS6和iPhone5

+ (CGSize)getScreenSize;

+ (CGRect)getScreenRect;

+ (BOOL)isIphone5;

+ (CGFloat)systemVersion;

+ (void)playSound:(NSString*)filename;

+ (void)showAlert:(NSString*)aTitle message:(NSString*)message;

+ (BOOL)checkCrackedApp;

#pragma mark - App Info

+ (NSString*)getAdId;
+ (NSString*)getScreenAdId;
+ (int)getScreenAdRate;
+ (NSString*)getAppURL;
+ (BOOL)isOpenAll;
+ (NSString*)decrypt:(NSString*)text;
+ (NSString*)getTextById:(NSString*)textId;
+ (NSArray*)getOtherApps;
+ (NSDictionary*)getAlert;
+ (NSString*)getUrlByType:(int)type;
+ (BOOL)showLessAds;
+ (BOOL)showAdWhenLaunch;

@end

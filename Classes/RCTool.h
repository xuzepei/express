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

+ (NSString*)getUserDocumentDirectoryPath;
+ (NSString *)md5:(NSString *)str;

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

+ (void)playSound:(NSString*)filename;

+ (void)showAlert:(NSString*)aTitle message:(NSString*)message;

+ (BOOL)checkCrackedApp;

+ (CGFloat)systemVersion;

@end

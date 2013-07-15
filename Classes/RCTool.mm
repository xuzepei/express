//
//  RCTool.m
//  rsscoffee
//
//  Created by beer on 8/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RCTool.h"
#import "FoodAppDelegate.h"
#import "Reachability.h"
#import "Food.h"
#import <CommonCrypto/CommonDigest.h>
#import "NTDB.h"
#import "Express.h"
#import "SBJSON.h"
#import <AudioToolbox/AudioToolbox.h>

static int g_reachabilityType = -1;
static SystemSoundID g_soundID = 0;

void systemSoundCompletionProc(SystemSoundID ssID,void *clientData)
{
	AudioServicesRemoveSystemSoundCompletion(ssID);
	AudioServicesDisposeSystemSoundID(g_soundID);
	g_soundID = 0;
}


@implementation RCTool

+ (NSString*)getUserDocumentDirectoryPath
{
    //return NSTemporaryDirectory();
    
	NSArray* array = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
	if([array count])
		return [array objectAtIndex: 0];
	else
		return @"";
}

+ (NSString *)md5:(NSString *)str 
{
	const char *cStr = [str UTF8String];
	unsigned char result[16];
	CC_MD5( cStr, strlen(cStr), result );
	return [NSString stringWithFormat:
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			result[0], result[1], result[2], result[3], 
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];	
}


#pragma mark -
#pragma mark network

+ (void)setReachabilityType:(int)type
{
	g_reachabilityType = type;
}

+ (int)getReachabilityType
{
	return g_reachabilityType;
}

+ (BOOL)isReachableViaInternet
{
	Reachability* internetReach = [Reachability reachabilityForInternetConnection];
	[internetReach startNotifier];
	NetworkStatus netStatus = [internetReach currentReachabilityStatus];
	switch (netStatus)
    {
        case NotReachable:
        {
            return NO;
        }
        case ReachableViaWWAN:
        {
            return YES;
        }
        case ReachableViaWiFi:
        {
			return YES;
		}
		default:
			return NO;
	}
	
	return NO;
}

+ (BOOL)isReachableViaWiFi
{
	Reachability* internetReach = [Reachability reachabilityForInternetConnection];
	[internetReach startNotifier];
	NetworkStatus netStatus = [internetReach currentReachabilityStatus];
	switch (netStatus)
    {
        case NotReachable:
        {
            return NO;
        }
        case ReachableViaWWAN:
        {
            return NO;
        }
        case ReachableViaWiFi:
        {
			return YES;
		}
		default:
			return NO;
	}
	
	return NO;
}

+ (BOOL)isExistingFile:(NSString*)path
{
	if(0 == [path length])
		return NO;
	
	NSFileManager* fileManager = [NSFileManager defaultManager];
	return [fileManager fileExistsAtPath:path];
}

+ (NSPersistentStoreCoordinator*)getPersistentStoreCoordinator
{
	FoodAppDelegate* appDelegate = (FoodAppDelegate*)[[UIApplication sharedApplication] delegate];
	return [appDelegate persistentStoreCoordinator];
}

+ (NSManagedObjectContext*)getManagedObjectContext
{
	FoodAppDelegate* appDelegate = (FoodAppDelegate*)[[UIApplication sharedApplication] delegate];
	return [appDelegate managedObjectContext];
}

+ (NSManagedObjectID*)getExistingEntityObjectIDForName:(NSString*)entityName
											 predicate:(NSPredicate*)predicate
									   sortDescriptors:(NSArray*)sortDescriptors
											   context:(NSManagedObjectContext*)context

{
	if(0 == [entityName length] || nil == context)
		return nil;
	
	//NSManagedObjectContext* context = [RCTool getManagedObjectContext];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
											  inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	
	
	//sortDescriptors 是必传属性
	NSArray *temp = [NSArray arrayWithArray: sortDescriptors];
	[fetchRequest setSortDescriptors:temp];
	
	
	//set predicate
	[fetchRequest setPredicate:predicate];
	
	//设置返回类型
	[fetchRequest setResultType:NSManagedObjectIDResultType];
	
	
	//	NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] 
	//															initWithFetchRequest:fetchRequest 
	//															managedObjectContext:context 
	//															sectionNameKeyPath:nil 
	//															cacheName:@"Root"];
	//	
	//	//[context tryLock];
	//	[fetchedResultsController performFetch:nil];
	//	//[context unlock];
	
	NSArray* objectIDs = [context executeFetchRequest:fetchRequest error:nil];
	
	[fetchRequest release];
	
	if(objectIDs && [objectIDs count])
		return [objectIDs lastObject];
	else
		return nil;
}

+ (NSArray*)getExistingEntityObjectsForName:(NSString*)entityName
								  predicate:(NSPredicate*)predicate
							sortDescriptors:(NSArray*)sortDescriptors
{
	if(0 == [entityName length])
		return nil;
	
	NSManagedObjectContext* context = [RCTool getManagedObjectContext];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
											  inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	
	
	//sortDescriptors 是必传属性
	if(nil == sortDescriptors)
	{
		NSArray *temp = [NSArray arrayWithArray: sortDescriptors];
		[fetchRequest setSortDescriptors:temp];
	}
	else
		[fetchRequest setSortDescriptors:sortDescriptors];

	
	
	//set predicate
	[fetchRequest setPredicate:predicate];
	
	//设置返回类型
	[fetchRequest setResultType:NSManagedObjectResultType];
	
	NSArray* objects = [context executeFetchRequest:fetchRequest error:nil];
	
	[fetchRequest release];
	
	return objects;
}

+ (id)insertEntityObjectForName:(NSString*)entityName 
		   managedObjectContext:(NSManagedObjectContext*)managedObjectContext;
{
	if(0 == [entityName length] || nil == managedObjectContext)
		return nil;
	
	NSManagedObjectContext* context = managedObjectContext;
	id entityObject = [NSEntityDescription insertNewObjectForEntityForName:entityName 
													inManagedObjectContext:context];
	
	
	return entityObject;
	
}

+ (id)insertEntityObjectForID:(NSManagedObjectID*)objectID 
		 managedObjectContext:(NSManagedObjectContext*)managedObjectContext;
{
	if(nil == objectID || nil == managedObjectContext)
		return nil;
	
	return [managedObjectContext objectWithID:objectID];
}

+ (void)saveCoreData
{
	FoodAppDelegate* appDelegate = (FoodAppDelegate*)[[UIApplication sharedApplication] delegate];
	NSError *error = nil;
    if ([appDelegate managedObjectContext] != nil) 
	{
        if ([[appDelegate managedObjectContext] hasChanges] && ![[appDelegate managedObjectContext] save:&error]) 
		{

        } 
    }
}

+ (void)importLocalData
{
	NSArray* oldExpressArray = [RCTool getExistingEntityObjectsForName:@"Express"
													   predicate:nil
												 sortDescriptors:nil];
	for(NSManagedObject* object in oldExpressArray)
    {
        [[RCTool getManagedObjectContext] deleteObject: object];
    }
    
    [RCTool saveCoreData];
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"express" ofType:@"plist"];
    NSArray* expressArray = [[NSArray alloc] initWithContentsOfFile:path];
	
	if([expressArray count])
	{
//        NSString* path = [NSString stringWithFormat:@"%@/express.plist",[RCTool getUserDocumentDirectoryPath]];
//        [array writeToFile:path atomically:YES];
        
// NSDictionary 转 json
//        NSError *error;
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array
//                                                           options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
//                                                             error:&error];
//        
//        if (! jsonData) {
//            NSLog(@"Got an error: %@", error);
//        } else {
//            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//            NSLog(@"jsonString:%@",jsonString);
//        }
        
        
		for(NSDictionary* temp in expressArray)
		{
			NSString* idString = [temp objectForKey:@"id"];
			NSManagedObjectContext* insertionContext = [RCTool getManagedObjectContext];
			NSPredicate* predicate = [NSPredicate predicateWithFormat:@"id = %@",idString];
			NSManagedObjectID* objectID = [RCTool getExistingEntityObjectIDForName: @"Express"
																		 predicate: predicate
																   sortDescriptors: nil
																		   context: insertionContext];
			
			
			Express* express = nil;
			if(nil == objectID)
			{
				express = [RCTool insertEntityObjectForName:@"Express" 
									managedObjectContext:insertionContext];
			}
			else
			{
				express = (Express*)[RCTool insertEntityObjectForID:objectID
										 managedObjectContext:insertionContext];
			}
			
			express.id = idString;
			express.name = [temp objectForKey:@"name"];
			express.phoneNum = [temp objectForKey:@"phoneNum"];
			express.web = [temp objectForKey:@"web"];
			express.code = [temp objectForKey:@"code"];
			express.type = [temp objectForKey:@"type"];
			express.isHidden = [NSNumber numberWithBool: NO];
			express.isUsually = [temp objectForKey:@"isUsually"];

		}
		
		[RCTool saveCoreData];
	}
    
    [expressArray release];
}

+ (BOOL)isIpad
{
	UIDevice* device = [UIDevice currentDevice];
	if(device.userInterfaceIdiom == UIUserInterfaceIdiomPhone)
	{
		return NO;
	}
	else if(device.userInterfaceIdiom == UIUserInterfaceIdiomPad)
	{
		return YES;
	}
	
	return NO;
}

+ (UIView*)getAdView
{
	FoodAppDelegate* appDelegate = (FoodAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if(appDelegate.adMobAd.alpha)
    {
        UIView* adView = appDelegate.adMobAd;
        if(adView)
            return adView;
    }
	
	return nil;
}

+ (NSDictionary*)parse:(NSString*)jsonString
{
	if(0 == [jsonString length])
		return nil;
	
	SBJSON* sbjson = [[SBJSON alloc] init];
	NSDictionary* dict = [sbjson objectWithString:jsonString error:nil];
	[sbjson release];
	return dict;
}

+ (NSString*)getKey
{
    return KEY_2;
    
	static int i = 0;
	
	if(i & 1)
		return KEY_0;
	else
		return KEY_1;
	
	i++;
}

+ (NSDictionary*)getResult:(NSString*)timeString
{
	if(0 == [timeString length])
		return nil;
	
	NSString* filePath = [NSString stringWithFormat:@"%@/%@.db",[RCTool getUserDocumentDirectoryPath],timeString];
	return [NSDictionary dictionaryWithContentsOfFile:filePath];
}

+ (void)saveResult:(NSDictionary*)dict time:(NSString*)timeString
{
	if(nil == dict || 0 == [timeString length])
		return;
	
	NSString* filePath = [NSString stringWithFormat:@"%@/%@.db",[RCTool getUserDocumentDirectoryPath],timeString];
	[dict writeToFile:filePath atomically:NO];
}

+ (UIWindow*)frontWindow
{
	UIApplication *app = [UIApplication sharedApplication];
	UIWindow *frontWindow = [[app windows] lastObject];
	return frontWindow;
}

#pragma mark - 最近选择的快递

+ (void)addRecentExpress:(NSString*)expressCode
{
    NSString* path = [NSString stringWithFormat:@"%@/recent_express.plist",[RCTool getUserDocumentDirectoryPath]];
    NSMutableArray* recentExpressArray = [[NSMutableArray alloc] initWithContentsOfFile:path];
    if(recentExpressArray)
    {
        //BOOL isExisting = YES;
        for(NSString* code in recentExpressArray)
        {
            if([expressCode isEqualToString:code])
            {
                [recentExpressArray removeObject:code];
                break;
            }
        }
        
        [recentExpressArray insertObject:expressCode atIndex:0];
        
        if([recentExpressArray count] > 6)
        {
            [recentExpressArray removeLastObject];
        }
    }
    else{
        
        recentExpressArray = [[NSMutableArray alloc] init];
        
        [recentExpressArray insertObject:expressCode atIndex:0];
    }

    [recentExpressArray writeToFile:path atomically:YES];
    [recentExpressArray release];
}

+ (NSArray*)getRecentExpress
{
    NSString* path = [NSString stringWithFormat:@"%@/recent_express.plist",[RCTool getUserDocumentDirectoryPath]];
    NSArray* recentExpressArray = [[[NSArray alloc] initWithContentsOfFile:path] autorelease];
    
    return recentExpressArray;
}

#pragma mark - 兼容iOS6和iPhone5

+ (CGSize)getScreenSize
{
    return [[UIScreen mainScreen] bounds].size;
}

+ (CGRect)getScreenRect
{
    return [[UIScreen mainScreen] bounds];
}

+ (BOOL)isIphone5
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize size = [[UIScreen mainScreen] bounds].size;
        if(568 == size.height)
        {
            return YES;
        }
    }
    
    return NO;
}

+ (void)playSound:(NSString*)filename
{
    if(g_soundID || 0 == [filename length])
	    return;
    
	NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
	
	NSURL *fileUrl = [NSURL fileURLWithPath:path];
	g_soundID = 0;
	AudioServicesCreateSystemSoundID((CFURLRef)fileUrl, &g_soundID);
    
	AudioServicesAddSystemSoundCompletion(g_soundID,NULL,NULL,systemSoundCompletionProc, NULL);
	AudioServicesPlaySystemSound(g_soundID);
}

+ (void)showAlert:(NSString*)aTitle message:(NSString*)message
{
	if(0 == [aTitle length] || 0 == [message length])
		return;
	
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle: aTitle
													message: message
												   delegate: self
										  cancelButtonTitle: @"确定"
										  otherButtonTitles: nil];
    alert.tag = 110;
	[alert show];
	[alert release];
}


+ (BOOL)checkCrackedApp
{
    static BOOL isCraked = NO;
    
    NSBundle *bundle = [NSBundle mainBundle];
	NSDictionary *info = [bundle infoDictionary];
	if ([info objectForKey: @"SignerIdentity"] != nil)//判断是否为破解App,方法可能已过时
	{
		isCraked = YES;
	}
    else//通过检查是否为jailbreak设备来判断是否为破解App
    {
        NSArray *jailbrokenPath = [NSArray arrayWithObjects:
                                   @"/Applications/Cydia.app",
                                   @"/Applications/RockApp.app",
                                   @"/Applications/Icy.app",
                                   @"/usr/sbin/sshd",
                                   @"/usr/bin/sshd",
                                   @"/usr/libexec/sftp-server",
                                   @"/Applications/WinterBoard.app",
                                   @"/Applications/SBSettings.app",
                                   @"/Applications/MxTube.app",
                                   @"/Applications/IntelliScreen.app",
                                   @"/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
                                   @"/Applications/FakeCarrier.app",
                                   @"/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
                                   @"/private/var/lib/apt",
                                   @"/Applications/blackra1n.app",
                                   @"/private/var/stash",
                                   @"/private/var/mobile/Library/SBSettings/Themes",
                                   @"/System/Library/LaunchDaemons/com.ikey.bbot.plist",
                                   @"/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
                                   @"/private/var/tmp/cydia.log",
                                   @"/private/var/lib/cydia", nil];
        
        for(NSString *path in jailbrokenPath)
        {
            if ([[NSFileManager defaultManager] fileExistsAtPath:path])
            {
                isCraked = YES;
                break;
            }
        }
        
    }
    
    return isCraked;
}

+ (CGFloat)systemVersion
{
    CGFloat systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    return systemVersion;
}

@end

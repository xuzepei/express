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
#include <ifaddrs.h>
#include <arpa/inet.h>
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"

static int g_reachabilityType = -1;
static SystemSoundID g_soundID = 0;

void systemSoundCompletionProc(SystemSoundID ssID,void *clientData)
{
    AudioServicesRemoveSystemSoundCompletion(ssID);
    AudioServicesDisposeSystemSoundID(g_soundID);
    g_soundID = 0;
}


@implementation RCTool

+ (BOOL)saveImage:(NSData*)data path:(NSString*)path
{
    if(nil == data || 0 == [path length])
        return NO;
    
    NSString* directoryPath = [NSString stringWithFormat:@"%@/images",[RCTool getUserDocumentDirectoryPath]];
    if(NO == [RCTool isExistingFile:directoryPath])
    {
        NSFileManager* fileManager = [NSFileManager defaultManager];
        [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:NO attributes:nil error:NULL];
    }
    
    NSString* suffix = @"";
    NSRange range = [path rangeOfString:@"." options:NSBackwardsSearch];
    if(range.location != NSNotFound && ([path length] - range.location <= 4))
        suffix = [path substringFromIndex:range.location + range.length];
    
    NSString* md5Path = [RCTool md5:path];
    NSString* savePath = nil;
    if([suffix length])
    {
        savePath = [NSString stringWithFormat:@"%@/images/%@.%@",[RCTool getUserDocumentDirectoryPath],md5Path,suffix];
    }
    else
        savePath = [NSString stringWithFormat:@"%@/images/%@",[RCTool getUserDocumentDirectoryPath],md5Path];
    
    //保存原图
    if(NO == [data writeToFile:savePath atomically:YES])
        return NO;
    
    
    //	//保存小图
    //	UIImage* image = [UIImage imageWithData:data];
    //	if(nil == image)
    //		return NO;
    //
    //    if(image.size.width <= 140 || image.size.height <= 140)
    //    {
    //        return [data writeToFile:saveSmallImagePath atomically:YES];
    //    }
    //
    //	CGSize size = CGSizeMake(140, 140);
    //	// 创建一个bitmap的context
    //	// 并把它设置成为当前正在使用的context
    //	UIGraphicsBeginImageContext(size);
    //
    //	// 绘制改变大小的图片
    //	[image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    //
    //	// 从当前context中创建一个改变大小后的图片
    //	UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    //
    //	// 使当前的context出堆栈
    //	UIGraphicsEndImageContext();
    //
    //	NSData* data2 = UIImagePNGRepresentation(scaledImage);
    //	if(data2)
    //    {
    //		return [data2 writeToFile:saveSmallImagePath atomically:YES];
    //    }
    
    return YES;
}


+ (UIImage*)getImageFromLocal:(NSString*)path
{
    if(0 == [path length])
        return nil;
    
    NSString* suffix = @"";
    NSRange range = [path rangeOfString:@"." options:NSBackwardsSearch];
    if(range.location != NSNotFound && ([path length] - range.location <= 4))
        suffix = [path substringFromIndex:range.location + range.length];
    
    NSString* md5Path = [RCTool md5:path];
    NSString* savePath = nil;
    if([suffix length])
        savePath = [NSString stringWithFormat:@"%@/images/%@.%@",[RCTool getUserDocumentDirectoryPath],md5Path,suffix];
    else
        savePath = [NSString stringWithFormat:@"%@/images/%@",[RCTool getUserDocumentDirectoryPath],md5Path];
    
    return [UIImage imageWithContentsOfFile:savePath];
}

+ (NSString*)getImageLocalPath:(NSString *)path
{
    if(0 == [path length])
        return nil;
    
    NSString* suffix = @"";
    NSRange range = [path rangeOfString:@"." options:NSBackwardsSearch];
    if(range.location != NSNotFound && ([path length] - range.location <= 4))
        suffix = [path substringFromIndex:range.location + range.length];
    
    NSString* md5Path = [RCTool md5:path];
    if([suffix length])
        return [NSString stringWithFormat:@"%@/images/%@.%@",[RCTool getUserDocumentDirectoryPath],md5Path,suffix];
    else
        return [NSString stringWithFormat:@"%@/images/%@",[RCTool getUserDocumentDirectoryPath],md5Path];
}


+ (BOOL)isExistingFile:(NSString*)path
{
    if(0 == [path length])
        return NO;
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:path];
}

+ (BOOL)removeFile:(NSString*)filePath
{
    if([filePath length])
        return [[NSFileManager defaultManager] removeItemAtPath:filePath
                                                          error:nil];
    
    return NO;
}

+ (UIImage *)imageWithImage:(UIImage *)image
               scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

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

+ (NSDictionary*)parseToDictionary:(NSString*)jsonString
{
    if(0 == [jsonString length])
        return nil;
    
    NSData* data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if(nil == data)
        return nil;
    
    NSError* error = nil;
    NSJSONSerialization* json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if(error)
    {
        NSLog(@"parse errror:%@",[error localizedDescription]);
        return nil;
    }
    
    if([json isKindOfClass:[NSDictionary class]])
    {
        return (NSDictionary *)json;
    }
    
    return nil;
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

+ (void)showScreenAdView
{
    FoodAppDelegate* appDelegate = (FoodAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showInterstitialAd:nil];
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

+ (CGFloat)systemVersion
{
    CGFloat systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    return systemVersion;
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
        NSLog(@"+++isCraked");
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
                NSLog(@"!!!!isCraked");
                isCraked = YES;
                break;
            }
        }
        
    }
    
    return isCraked;
}

#pragma mark - App Info

+ (NSString*)getAdId
{
//    NSDictionary* app_info = [[NSUserDefaults standardUserDefaults] objectForKey:@"app_info"];
//    if(app_info && [app_info isKindOfClass:[NSDictionary class]])
//    {
//        NSString* ad_id = [app_info objectForKey:@"ad_id"];
//        if([ad_id length])
//            return ad_id;
//    }
    
    return AD_ID;
}

+ (NSString*)getScreenAdId
{
//    NSDictionary* app_info = [[NSUserDefaults standardUserDefaults] objectForKey:@"app_info"];
//    if(app_info && [app_info isKindOfClass:[NSDictionary class]])
//    {
//        NSString* ad_id = [app_info objectForKey:@"mediation_id"];
//        if(0 == [ad_id length])
//            ad_id = [app_info objectForKey:@"screen_ad_id"];
//        
//        if([ad_id length])
//            return ad_id;
//    }
    
    return SCREEN_AD_ID;
}

+ (int)getScreenAdRate
{
//    NSDictionary* app_info = [[NSUserDefaults standardUserDefaults] objectForKey:@"app_info"];
//    if(app_info && [app_info isKindOfClass:[NSDictionary class]])
//    {
//        NSString* ad_rate = [app_info objectForKey:@"screen_ad_rate"];
//        if([ad_rate intValue] > 0)
//            return [ad_rate intValue];
//    }
    
    return SCREEN_AD_RATE;
}

+ (NSString*)getAppURL
{
//    NSDictionary* app_info = [[NSUserDefaults standardUserDefaults] objectForKey:@"app_info"];
//    if(app_info && [app_info isKindOfClass:[NSDictionary class]])
//    {
//        NSString* link = [app_info objectForKey:@"link"];
//        if([link length])
//            return link;
//    }
    
    return APP_URL;
}

+ (BOOL)isOpenAll
{
//    NSDictionary* app_info = [[NSUserDefaults standardUserDefaults] objectForKey:@"app_info"];
//    if(app_info && [app_info isKindOfClass:[NSDictionary class]])
//    {
//        NSString* openall = [app_info objectForKey:@"openall"];
//        if([openall isEqualToString:@"1"])
//            return YES;
//    }
    
    return YES;
}

+ (NSString*)decryptUseDES:(NSString*)cipherText key:(NSString*)key {
    // 利用 GTMBase64 解碼 Base64 字串
    NSData* cipherData = [GTMBase64 decodeString:cipherText];
    unsigned char buffer[4096];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    
    // IV 偏移量不需使用
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          nil,
                                          [cipherData bytes],
                                          [cipherData length],
                                          buffer,
                                          4096,
                                          &numBytesDecrypted);
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData* data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plainText = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    }
    return plainText;
}

+ (NSString *)encryptUseDES:(NSString *)clearText key:(NSString *)key
{
    NSData *data = [clearText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    unsigned char buffer[4096];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          nil,
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          4096,
                                          &numBytesEncrypted);
    
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData *dataTemp = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        plainText = [GTMBase64 stringByEncodingData:dataTemp];
    }else{
        NSLog(@"DES加密失败");
    }
    return plainText;
}

+ (NSString*)decrypt:(NSString*)text
{
    if(0 == [text length])
        return @"";
    
    NSString* key = SECRET_KEY;
    NSString* encrypt = text;
    NSString* decrypt = [RCTool decryptUseDES:encrypt key:key];
    
    if([decrypt length])
        return decrypt;
    
    return @"";
}

+ (NSString*)getTextById:(NSString*)textId
{
    NSDictionary* app_info = [[NSUserDefaults standardUserDefaults] objectForKey:@"app_info"];
    if(app_info && [app_info isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* text_dict = [app_info objectForKey:@"text_dict"];
        if([text_dict isKindOfClass:[NSDictionary class]])
        {
            if([RCTool isOpenAll])
            {
                NSString* text = [text_dict objectForKey:textId];
                if([text length])
                    return text;
            }
        }
    }
    
    if([textId isEqualToString:@"ti_0"])
    {
        return @"设置";
    }
    else if([textId isEqualToString:@"ti_1"])
    {
        return @"精品应用推荐";
    }
    else if([textId isEqualToString:@"ti_2"])
    {
        return @"点击清除缓存";
    }
    else if([textId isEqualToString:@"ti_3"])
    {
        return @"去评价";
    }
    else if([textId isEqualToString:@"ti_4"])
    {
        return @"意见反馈";
    }
    else if([textId isEqualToString:@"ti_5"])
    {
        return @"缓存已成功清除";
    }
    else if([textId isEqualToString:@"ti_6"])
    {
        return @"下拉可以刷新了";
    }
    else if([textId isEqualToString:@"ti_7"])
    {
        return @"松开马上刷新了";
    }
    else if([textId isEqualToString:@"ti_8"])
    {
        return @"正在帮你刷新中...";
    }
    else if([textId isEqualToString:@"ti_9"])
    {
        return @"上拉可以加载更多数据了";
    }
    else if([textId isEqualToString:@"ti_10"])
    {
        return @"松开马上加载更多数据了";
    }
    else if([textId isEqualToString:@"ti_11"])
    {
        return @"正在帮你加载中...";
    }
    
    return @"";
}

+ (NSArray*)getOtherApps
{
    NSDictionary* app_info = [[NSUserDefaults standardUserDefaults] objectForKey:@"app_info"];
    if(app_info && [app_info isKindOfClass:[NSDictionary class]])
    {
        if([RCTool isOpenAll])
        {
            return [app_info objectForKey:@"other_apps"];
        }
    }
    
    return nil;
}

+ (NSDictionary*)getAlert
{
    NSDictionary* app_info = [[NSUserDefaults standardUserDefaults] objectForKey:@"app_info"];
    if(app_info && [app_info isKindOfClass:[NSDictionary class]])
    {
        if([RCTool isOpenAll])
        {
            NSDictionary* dict = [app_info objectForKey:@"alert"];
            if(dict && [dict isKindOfClass:[NSDictionary class]])
                return dict;
        }
    }
    
    return nil;
}

+ (NSString*)getUrlByType:(int)type
{
    NSDictionary* app_info = [[NSUserDefaults standardUserDefaults] objectForKey:@"app_info"];
    
    if(0 == type)
    {
        if(app_info && [app_info isKindOfClass:[NSDictionary class]])
        {
            NSString* url = [app_info objectForKey:@"url_0"];
            if([url length])
                return url;
        }
        
        return URL_0;
    }
    
    return @"";
}

+ (BOOL)showLessAds
{
    NSDictionary* app_info = [[NSUserDefaults standardUserDefaults] objectForKey:@"app_info"];
    if(app_info && [app_info isKindOfClass:[NSDictionary class]])
    {
        
        NSString* show_less_ads = [app_info objectForKey:@"show_less_ads"];
        if([show_less_ads isEqualToString:@"0"])
            return NO;
        
    }
    
    return YES;
}

+ (BOOL)showAdWhenLaunch
{
    NSDictionary* app_info = [[NSUserDefaults standardUserDefaults] objectForKey:@"app_info"];
    if(app_info && [app_info isKindOfClass:[NSDictionary class]])
    {
        NSString* show_ad_launch = [app_info objectForKey:@"show_ad_launch"];
        if([show_ad_launch isEqualToString:@"1"])
            return YES;
    }
    
    return NO;
}


@end

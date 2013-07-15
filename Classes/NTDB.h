//
//  NTDB.h
//  MLTBeer
//
//  Created by beer on 6/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface NTDB : NSObject {

}

+ (BOOL)openDB: (sqlite3 **)db;
+ (BOOL)createDBAndTables: (NSString *)dbPath;
+ (BOOL)isDBExisting;
+ (BOOL)insertRecord:(NSString *)tableName fields:(NSDictionary *)fields;
+ (NSMutableArray *)getRecords:(NSString *)tableName 
						fields:(NSArray *)fields option:(NSString*)option;
+ (BOOL)deleteRecord:(NSString *)tableName fields:(NSDictionary *)fields;

@end

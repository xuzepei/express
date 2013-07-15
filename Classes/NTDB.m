//
//  NTDB.m
//  MLTBeer
//
//  Created by beer on 6/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NTDB.h"
#import "RCTool.h"

#define DB_NAME @"test.db"

@implementation NTDB

+ (BOOL)openDB: (sqlite3 **)db
{
	NSFileManager *fileManager = [NSFileManager defaultManager];

	NSString *dbPath = [[NSBundle mainBundle] pathForResource:DB_NAME ofType:nil];
	if(0 == [dbPath length])
		return NO;

	if(NO == [fileManager fileExistsAtPath: dbPath])
		return NO;
	
	return sqlite3_open([dbPath UTF8String], db) == SQLITE_OK;
}

+ (BOOL)createDBAndTables: (NSString *)dbPath
{
	sqlite3 *db = NULL;
	if(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK)
	{
		NSString *sql = @"CREATE TABLE records (date varchar(64), fromlanguageid varchar(8), tolanguageid varchar(8), originaltext varchar(1024), translatedtext varchar(1024))";
		if(sqlite3_exec(db, [sql cStringUsingEncoding: NSUTF8StringEncoding], NULL, NULL, NULL) != SQLITE_OK)
		{
			sqlite3_close(db);
			return NO;
		}
	}
	else
		return NO;
	
	sqlite3_close(db);
	return YES;
}

+ (BOOL)isDBExisting
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString* userDocumentDirectoryPath = [RCTool getUserDocumentDirectoryPath];
	if(0 == [userDocumentDirectoryPath length])
		return NO;
	
	NSString *dbPath = [userDocumentDirectoryPath stringByAppendingString:@"/"];
	dbPath = [dbPath stringByAppendingString: DB_NAME];
	return [fileManager fileExistsAtPath: dbPath];
}

+ (BOOL)insertRecord:(NSString *)tableName fields:(NSDictionary *)fields
{
	sqlite3 *db = NULL;
	NSString *keys = [[fields allKeys] componentsJoinedByString:@","];
	NSString *values = @"";
	for(int i=0; i < [fields count]; i++)
	{
		values = [values stringByAppendingString:@"?"];
		if(i != [fields count] - 1)
			values = [values stringByAppendingString:@","];
	}
	
	const char *sql = [[NSString stringWithFormat:@"INSERT INTO %@ (%@) values(%@)", tableName, keys, values] UTF8String];
	if([NTDB openDB:&db])
	{
		sqlite3_stmt *statement;
		int result = sqlite3_prepare(db, sql, -1, &statement, 0);
		
		if(SQLITE_OK != result)
		{
			sqlite3_close(db);
			return FALSE;
		}
		
		for(int i=0; i < [fields count]; i++)
			sqlite3_bind_text(statement, i+1, [[[fields allValues] objectAtIndex:i] UTF8String], -1, SQLITE_TRANSIENT);
		
		result = sqlite3_step(statement);
		sqlite3_finalize(statement);
		sqlite3_close(db);
		return result == SQLITE_DONE;
	}
	
	sqlite3_close(db);
	return FALSE;
}

+ (BOOL)deleteRecord:(NSString *)tableName fields:(NSDictionary *)fields
{
	sqlite3 *db = NULL;
	NSString *formatedKeys = [[fields allKeys] componentsJoinedByString:@"=? AND "];
	NSArray *values = [fields allValues];
	const char *sql = [[NSString stringWithFormat:@"DELETE FROM %@ WHERE %@%@", tableName, formatedKeys, @"=?"] UTF8String];
	if([NTDB openDB:&db])
	{
		sqlite3_stmt *statement;
		int result = sqlite3_prepare(db, sql, -1, &statement, 0);
		
		if(SQLITE_OK != result)
		{
			sqlite3_close(db);
			return FALSE;
		}
		
		for(int i=0; i < [values count]; i++)
			sqlite3_bind_text(statement, i+1, [[values objectAtIndex:i] UTF8String], -1, SQLITE_TRANSIENT);
		
		result = sqlite3_step(statement);
		sqlite3_finalize(statement);
		sqlite3_close(db);
		return result == SQLITE_DONE;
	}
	sqlite3_close(db);
	return FALSE;
	
}

+ (NSMutableArray *)getRecords:(NSString *)tableName fields:(NSArray *)fields option:(NSString*)option
{
	NSMutableArray *results = [[[NSMutableArray alloc] init] autorelease];
	sqlite3 *db = NULL;
	if([NTDB openDB: &db])
	{
		NSString *keys = [fields componentsJoinedByString: @","];
		const char *sql = [[NSString stringWithFormat:@"SELECT %@ FROM %@ %@", keys, tableName, option] UTF8String];
		sqlite3_stmt *statement;
		int result = sqlite3_prepare(db, sql, -1, &statement, 0);
		
		if(SQLITE_OK != result)
		{
			sqlite3_close(db);
			return nil;
		}
		
		while(sqlite3_step(statement) == SQLITE_ROW)
		{
			NSMutableDictionary *record = [[NSMutableDictionary alloc] init];
			for(int i=0; i < [fields count]; i++)
			{
				NSString *key = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, i)];
				[record setObject:key forKey:[fields objectAtIndex:i]];
			}
			[results addObject: record];
			[record release];
		}
		sqlite3_finalize(statement);
	}
	sqlite3_close(db);
	return results;
}

@end

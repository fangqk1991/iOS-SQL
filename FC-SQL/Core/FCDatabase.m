//
//  FCDatabase.m
//  FC.Client
//
//  Created by fang on 2018/8/2.
//  Copyright © 2018 fangcha. All rights reserved.
//

#import "FCDatabase.h"
#import "FMDatabase.h"

@interface FCDatabase()

@property (nonatomic, strong) NSString *dbFile;
@property (nonatomic, strong) FMDatabase *database;

@end

@implementation FCDatabase

- (instancetype)initWithDBFile:(NSString *)dbFile
{
    if(self = [self init])
    {
        self.dbFile = dbFile;
    }

    return self;
}

- (void)importSQLFile:(NSString *)sqlFile
{
    FMDatabase *database = [FMDatabase databaseWithPath:_dbFile];
    
    if ([database open])
    {
        NSError *error;
        NSString *mySQL = [NSString stringWithContentsOfFile:sqlFile encoding:NSUTF8StringEncoding error:&error];
        
        if (error)
        {
            [NSException raise:@"SQL File open fail." format:@"%@", error.localizedDescription];
        }
        
        [database executeStatements:mySQL];
        [database close];
    }
    else
    {
        [NSException raise:@"Database open fail." format:@"Database open fail. Please check the db path(%@)", _dbFile];
    }
}

- (NSArray *)executeQuery:(NSString *)query values:(NSArray *)params
{
    FMDatabase *database = [FMDatabase databaseWithPath:_dbFile];

    NSMutableArray *results = [NSMutableArray array];

    if ([database open])
    {
        NSError *error;
        FMResultSet *s = [database executeQuery:query values:params error:&error];
        while ([s next]) {
            [results addObject:[s resultDictionary]];
        }

        [database close];
        
        return results;
    }

    return @[];
}

- (BOOL)executeUpdate:(NSString *)query values:(NSArray *)params
{
    FMDatabase *database = [FMDatabase databaseWithPath:_dbFile];
    
    if ([database open])
    {
        NSError *error;
        BOOL succ = [database executeUpdate:query values:params error:&error];
        [database close];
        return succ;
    }
    
    return NO;
}

@end

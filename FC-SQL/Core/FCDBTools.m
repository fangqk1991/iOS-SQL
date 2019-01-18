//
//  FCDBTools.m
//  FC.Client
//
//  Created by fang on 2018/8/2.
//  Copyright © 2018 fangcha. All rights reserved.
//

#import "FCDBTools.h"
#import "FCDBAdder.h"
#import "FCDBModifier.h"
#import "FCDBRemover.h"
#import "FCDBSearcher.h"

@interface FCDBTools()

@property (nonatomic, strong) FCDatabase *database;
@property (nonatomic, strong) id<FCSQLProtocol> handler;

@end

@implementation FCDBTools

- (instancetype)initWithDatabase:(FCDatabase *)database handler:(id<FCSQLProtocol>)handler
{
    if(self = [self init])
    {
        _database = database;
        _handler = handler;
    }
    
    return self;
}

- (void)add:(NSDictionary *)params
{
    NSString *table = [_handler sql_table];
    NSArray *cols = [_handler sql_insertableCols];
    
    FCDBAdder *builder = [[FCDBAdder alloc] initWithDatabase:_database];
    [builder setTable:table];
    
    for(NSString *key in cols)
    {
        id value = [NSNull null];
        if(params[key] != nil)
        {
            value = params[key];
        }
        [builder insertKey:key value:value];
    }
    
    [builder execute];
}

- (void)update:(NSDictionary *)params
{
    NSString *table = [_handler sql_table];
    NSArray *cols = [_handler sql_modifiableCols];
    
    FCDBModifier *builder = [[FCDBModifier alloc] initWithDatabase:_database];
    [builder setTable:table];
    
    id pKey = [_handler sql_primaryKey];
    NSArray *pKeys = [pKey isKindOfClass:[NSArray class]] ? pKey : [NSArray arrayWithObject:pKey];
    
    NSMutableDictionary *myParams = [NSMutableDictionary dictionaryWithDictionary:params];
    for(NSString *key in pKeys)
    {
        [builder checkParams:params primaryKey:key];
        [myParams removeObjectForKey:key];
    }
    
    for(NSString *key in cols)
    {
        id value = [NSNull null];
        if(myParams[key] != nil)
        {
            value = myParams[key];
        }
        [builder updateKey:key value:value];
    }
    
    [builder execute];
}

- (void)remove:(NSDictionary *)params
{
    NSString *table = [_handler sql_table];
    
    FCDBRemover *builder = [[FCDBRemover alloc] initWithDatabase:_database];
    [builder setTable:table];
    
    id pKey = [_handler sql_primaryKey];
    NSArray *pKeys = [pKey isKindOfClass:[NSArray class]] ? pKey : [NSArray arrayWithObject:pKey];
    
    for(NSString *key in pKeys)
    {
        [builder checkParams:params primaryKey:key];
    }
    
    [builder execute];
}

- (NSDictionary *)searchSingle:(NSDictionary *)params
{
    return [self searchSingle:params checkPrimaryKey:YES];
}

- (NSDictionary *)searchSingle:(NSDictionary *)params checkPrimaryKey:(BOOL)checkPrimaryKey
{
    if(checkPrimaryKey)
    {
        id pKey = [_handler sql_primaryKey];
        NSArray *pKeys = [pKey isKindOfClass:[NSArray class]] ? pKey : [NSArray arrayWithObject:pKey];
        
        for(NSString *key in pKeys)
        {
            if(params[key] == nil)
            {
                [NSException raise:@"SQLException" format:@"%@: primary key missing.", NSStringFromClass([self class])];
            }
        }
    }
    
    NSArray *items = [self fetchList:params page:0 feedsPerPage:1];
    if(items.count > 0)
    {
        return items[0];
    }
    
    return nil;
}

- (NSArray *)fetchList:(NSDictionary *)params page:(int)page feedsPerPage:(int)feedsPerPage
{
    NSString *table = [_handler sql_table];
    NSArray *cols = [_handler sql_cols];
    
    FCDBSearcher *builder = [[FCDBSearcher alloc] initWithDatabase:_database];
    [builder setTable:table];
    [builder setPageInfo:page feedsPerPage:feedsPerPage];
    
    for(NSString *key in cols)
    {
        [builder addColumn:key];
    }
    
    for(NSString *key in params)
    {
        [builder addConditionKey:key value:params[key]];
    }
    
    return [builder queryList];
}


- (int)fetchCount:(NSDictionary *)params
{
    NSString *table = [_handler sql_table];
    NSArray *cols = [_handler sql_cols];
    
    FCDBSearcher *builder = [[FCDBSearcher alloc] initWithDatabase:_database];
    [builder setTable:table];
    
    for(NSString *key in cols)
    {
        [builder addColumn:key];
    }
    
    for(NSString *key in params)
    {
        [builder addConditionKey:key value:params[key]];
    }
    
    return [builder queryCount];
}

@end

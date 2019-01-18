//
//  FCDBBuilderBase.m
//  FC.Client
//
//  Created by fang on 2018/8/2.
//  Copyright © 2018 fangcha. All rights reserved.
//

#import "FCDBBuilderBase.h"

@implementation FCDBBuilderBase

- (instancetype)init
{
    if(self = [super init])
    {
        _conditionColumns = [NSMutableArray array];
        _conditionValues = [NSMutableArray array];
    }
    
    return self;
}

- (instancetype)initWithDatabase:(FCDatabase *)database
{
    if(self = [self init])
    {
        _database = database;
    }
    
    return self;
}

- (void)checkParams:(NSDictionary *)params primaryKey:(NSString *)key
{
    if(!params[key])
    {
        [NSException raise:@"SQLException" format:@"Primary key missing"];
    }
    
    [self addConditionKey:key value:params[key]];
}

- (void)addConditionKey:(NSString *)key value:(NSString *)value
{
    [_conditionColumns addObject:[NSString stringWithFormat:@"(%@ = ?)", key]];
    [_conditionValues addObject:value];
}

- (void)addSpecialCondition:(NSString *)condition, ...
{
    NSUInteger numberOfArgs = [condition componentsSeparatedByString:@"?"].count - 1;
    
    NSMutableArray *arguments = [NSMutableArray array];
    
    va_list args;
    va_start(args, condition);
    
    for(int i = 0; i < numberOfArgs; ++i)
    {
        [arguments addObject:va_arg(args, id)];
    }
    
    va_end(args);
    
    [_conditionColumns addObject:[NSString stringWithFormat:@"(%@)", condition]];
    [_conditionValues addObjectsFromArray:arguments];
}

- (void)addStmtValues:(NSArray *)values
{
    [_conditionValues addObjectsFromArray:values];
}

- (NSArray *)conditions
{
    return _conditionColumns;
}

- (void)checkTableValid
{
    if(_table == nil)
    {
        [NSException raise:@"SQLException" format:@"Table missing"];
    }
}

- (NSString *)buildConditionStr
{
    return [[self conditions] componentsJoinedByString:@" AND "];
}

- (NSArray *)stmtValues
{
    return _conditionValues;
}

@end

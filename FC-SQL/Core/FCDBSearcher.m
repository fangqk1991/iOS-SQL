//
//  FCDBSearcher.m
//  FC.Client
//
//  Created by fang on 2018/8/2.
//  Copyright © 2018 fangcha. All rights reserved.
//

#import "FCDBSearcher.h"

@interface FCDBSearcher()

@property (nonatomic, strong) NSMutableArray *queryColumns;
@property (nonatomic) BOOL distinct;
@property (nonatomic) int page;
@property (nonatomic) int feedsPerPage;
@property (nonatomic, strong) NSString *optionStr;

@property (nonatomic, strong) NSMutableArray *orderRules;

@end

@implementation FCDBSearcher

- (instancetype)init
{
    if(self = [super init])
    {
        _queryColumns = [NSMutableArray array];
        _distinct = NO;
        _page = -1;
        _feedsPerPage = 1;
        _orderRules = [NSMutableArray array];
    }
    
    return self;
}

- (void)markDistinct
{
    _distinct = YES;
}

- (void)setColumns:(NSArray *)columns
{
    [_queryColumns removeAllObjects];
    [_queryColumns addObjectsFromArray:columns];
}

- (void)addColumn:(NSString *)column
{
    [_queryColumns addObject:column];
}

- (void)addOrderRule:(NSString *)sortKey direction:(NSString *)direction
{
    direction = [direction uppercaseString];
    if(![@"DESC" isEqualToString:direction])
    {
        direction = @"";
    }
    
    [_orderRules addObject:@{@"sort_key": sortKey, @"sort_direction": direction}];
}

- (void)setPageInfo:(int)page feedsPerPage:(int)feedsPerPage
{
    _page = page;
    _feedsPerPage = feedsPerPage;
}

- (void)setOptionStr:(NSString *)optionStr
{
    _optionStr = optionStr;
}

- (NSDictionary *)exportQuery
{
    [self checkTableValid];
    
    if(_queryColumns.count <= 0)
    {
        [NSException raise:@"SQLException" format:@"%@: queryColumns missing.", NSStringFromClass([self class])];
    }
    
    NSString *query = [NSString stringWithFormat:@"SELECT %@ %@ FROM %@",
                     _distinct ? @"DISTINCT" : @"",
                     [_queryColumns componentsJoinedByString:@", "],
                     self.table
                     ];
    
    NSArray *conditions = [self conditions];
    if(conditions.count > 0)
    {
        query = [NSString stringWithFormat:@"%@ WHERE %@", query, [self buildConditionStr]];
    }
    
    if(_optionStr != nil)
    {
        query = [NSString stringWithFormat:@"%@ %@", query, _optionStr];
    }
    
    return @{
             @"query": query,
             @"values": [self stmtValues]
             };
}

- (NSArray *)queryList
{
    NSDictionary *data = [self exportQuery];
    NSString *query = data[@"query"];
    NSArray *values = data[@"values"];
    
    if(_orderRules.count > 0)
    {
        NSMutableArray *orderItems = [[NSMutableArray alloc] init];
        for(NSDictionary *rule in _orderRules)
        {
            [orderItems addObject:[NSString stringWithFormat:@"%@ %@", rule[@"sort_key"], rule[@"sort_direction"]]];
        }
        
        query = [NSString stringWithFormat:@"%@ ORDER BY %@", query, [orderItems componentsJoinedByString:@", "]];
    }
    
    if(_page >= 0 && _feedsPerPage > 0)
    {
        query = [NSString stringWithFormat:@"%@ LIMIT %d, %d", query, _page * _feedsPerPage, _feedsPerPage];
    }
    
    return [self.database executeQuery:query values:values];
}

- (int)queryCount
{
    [self checkTableValid];
    
    NSString *query;
    
    if(_distinct)
    {
        query = [NSString stringWithFormat:@"SELECT COUNT(DISTINCT %@) AS count FROM %@", [_queryColumns componentsJoinedByString:@", "], self.table];
    }
    else
    {
        query = [NSString stringWithFormat:@"SELECT count(*) AS count FROM %@", self.table];
    }
    
    NSArray *conditions = [self conditions];
    if(conditions.count > 0)
    {
        query = [NSString stringWithFormat:@"%@ WHERE %@", query, [self buildConditionStr]];
    }
    
    NSArray *result = [self.database executeQuery:query values:[self stmtValues]];
    return [result[0][@"count"] intValue];
}

@end

//
//  FCDBAdder.m
//  FC.Client
//
//  Created by fang on 2018/8/2.
//  Copyright © 2018 fangcha. All rights reserved.
//

#import "FCDBAdder.h"

@interface FCDBAdder()

@property (nonatomic, strong) NSMutableArray *insertKeys;
@property (nonatomic, strong) NSMutableArray *insertValues;

@end

@implementation FCDBAdder

- (instancetype)init
{
    if(self = [super init])
    {
        _insertKeys = [NSMutableArray array];
        _insertValues = [NSMutableArray array];
    }
    
    return self;
}

- (void)insertKey:(NSString *)key value:(NSString *)value
{
    [_insertKeys addObject:key];
    [_insertValues addObject:value];
}

- (void)execute
{
    [self checkTableValid];
    
    if(_insertKeys.count <= 0)
    {
        [NSException raise:@"SQLException" format:@"%@: insertKeys missing.", NSStringFromClass([self class])];
    }
    
    NSArray *cols = _insertKeys;
    NSMutableArray *marks = [NSMutableArray arrayWithCapacity:cols.count];
    for(int i = 0; i < cols.count; ++i)
    {
        [marks addObject:@"?"];
    }
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES(%@)",
                     self.table,
                     [cols componentsJoinedByString:@", "],
                     [marks componentsJoinedByString:@", "]
                     ];
    [self.database executeUpdate:sql values:_insertValues];
}

@end

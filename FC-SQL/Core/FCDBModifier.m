//
//  FCDBModifier.m
//  FC.Client
//
//  Created by fang on 2018/8/3.
//  Copyright © 2018 fangcha. All rights reserved.
//

#import "FCDBModifier.h"

@interface FCDBModifier()

@property (nonatomic, strong) NSMutableArray *updateColumns;
@property (nonatomic, strong) NSMutableArray *updateValues;

@end


@implementation FCDBModifier

- (instancetype)init
{
    if(self = [super init])
    {
        _updateColumns = [NSMutableArray array];
        _updateValues = [NSMutableArray array];
    }
    
    return self;
}

- (void)updateKey:(NSString *)key value:(NSString *)value
{
    [_updateColumns addObject:[NSString stringWithFormat:@"%@ = ?", key]];
    [_updateValues addObject:value];
}

- (void)execute
{
    [self checkTableValid];
    
    if(_updateColumns.count <= 0)
    {
        [NSException raise:@"SQLException" format:@"%@: updateColumns missing.", NSStringFromClass([self class])];
    }
    
    if(self.conditionColumns.count <= 0)
    {
        [NSException raise:@"SQLException" format:@"%@: conditionColumns missing.", NSStringFromClass([self class])];
    }
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@",
                     self.table,
                     [_updateColumns componentsJoinedByString:@", "],
                     [[self conditions] componentsJoinedByString:@" AND "]
                     ];
    [self.database executeUpdate:sql values:[self stmtValues]];
}

- (NSArray *)stmtValues
{
    NSMutableArray *values = [NSMutableArray arrayWithArray:_updateValues];
    [values addObjectsFromArray:self.conditionValues];
    return values;
}

@end

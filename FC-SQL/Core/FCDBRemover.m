//
//  FCDBRemover.m
//  FC.Client
//
//  Created by fang on 2018/8/3.
//  Copyright © 2018 fangcha. All rights reserved.
//

#import "FCDBRemover.h"

@implementation FCDBRemover

- (void)execute
{
    [self checkTableValid];
    
    if(self.conditionColumns.count <= 0)
    {
        [NSException raise:@"SQLException" format:@"%@: conditionColumns missing.", NSStringFromClass([self class])];
    }
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@",
                     self.table,
                     [[self conditions] componentsJoinedByString:@" AND "]
                     ];
    [self.database executeUpdate:sql values:[self stmtValues]];
}

@end

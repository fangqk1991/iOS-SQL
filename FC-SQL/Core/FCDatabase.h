//
//  FCDatabase.h
//  FC.Client
//
//  Created by fang on 2018/8/2.
//  Copyright © 2018 fangcha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCDatabase : NSObject

- (instancetype)initWithDBFile:(NSString *)dbFile;

- (void)importSQLFile:(NSString *)sqlFile;

- (NSArray *)executeQuery:(NSString *)query values:(NSArray *)params;
- (BOOL)executeUpdate:(NSString *)query values:(NSArray *)params;

@end

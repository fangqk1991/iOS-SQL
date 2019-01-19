//
//  FCDBBuilderBase.h
//  FC.Client
//
//  Created by fang on 2018/8/2.
//  Copyright © 2018 fangcha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCDatabase.h"

@interface FCDBBuilderBase : NSObject

@property (nonatomic, strong) FCDatabase *database;
@property (nonatomic, strong) NSString *table;
@property (nonatomic, strong) NSMutableArray *conditionColumns;
@property (nonatomic, strong) NSMutableArray *conditionValues;

- (instancetype)initWithDatabase:(FCDatabase *)database;
- (void)checkParams:(NSDictionary *)params primaryKey:(NSString *)key;
- (void)addConditionKey:(NSString *)key value:(id)value;
- (void)addSpecialCondition:(NSString *)condition, ...;
- (void)addStmtValues:(NSArray *)values;
- (NSArray *)conditions;
- (void)checkTableValid;
- (NSString *)buildConditionStr;
- (NSArray *)stmtValues;

@end

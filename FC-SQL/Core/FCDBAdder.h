//
//  FCDBAdder.h
//  FC.Client
//
//  Created by fang on 2018/8/2.
//  Copyright © 2018 fangcha. All rights reserved.
//

#import "FCDBBuilderBase.h"

@interface FCDBAdder : FCDBBuilderBase

- (void)insertKey:(NSString *)key value:(NSString *)value;
- (void)execute;

@end

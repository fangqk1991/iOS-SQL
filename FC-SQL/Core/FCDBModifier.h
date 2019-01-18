//
//  FCDBModifier.h
//  FC.Client
//
//  Created by fang on 2018/8/3.
//  Copyright © 2018 fangcha. All rights reserved.
//

#import "FCDBBuilderBase.h"

@interface FCDBModifier : FCDBBuilderBase

- (void)updateKey:(NSString *)key value:(NSString *)value;
- (void)execute;

@end

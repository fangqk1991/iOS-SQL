//
//  FCDatabase+Invoker.m
//  FC-SQL
//
//  Created by fang on 2019/1/19.
//

#import "FCDatabase+Invoker.h"

@implementation FCDatabase(Invoker)

- (FCDBAdder *)fc_adder
{
    return [[FCDBAdder alloc] initWithDatabase:self];
}

- (FCDBModifier *)fc_modifier
{
    return [[FCDBModifier alloc] initWithDatabase:self];
}

- (FCDBRemover *)fc_remover
{
    return [[FCDBRemover alloc] initWithDatabase:self];
}

- (FCDBSearcher *)fc_searcher
{
    return [[FCDBSearcher alloc] initWithDatabase:self];
}

@end

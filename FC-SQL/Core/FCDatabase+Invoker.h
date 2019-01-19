//
//  FCDatabase+Invoker.h
//  FC-SQL
//
//  Created by fang on 2019/1/19.
//

#import "FCDatabase.h"
#import "FCDBAdder.h"
#import "FCDBModifier.h"
#import "FCDBRemover.h"
#import "FCDBSearcher.h"

@interface FCDatabase(Invoker)

- (FCDBAdder *)fc_adder;
- (FCDBModifier *)fc_modifier;
- (FCDBRemover *)fc_remover;
- (FCDBSearcher *)fc_searcher;

@end


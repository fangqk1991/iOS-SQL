//
//  FCDBSearcher.h
//  FC.Client
//
//  Created by fang on 2018/8/2.
//  Copyright © 2018 fangcha. All rights reserved.
//

#import "FCDBBuilderBase.h"

@interface FCDBSearcher : FCDBBuilderBase

- (void)markDistinct;
- (void)setColumns:(NSArray *)columns;
- (void)addColumn:(NSString *)column;
- (void)setPageInfo:(int)page feedsPerPage:(int)feedsPerPage;
- (void)setOptionStr:(NSString *)optionStr;
- (NSDictionary *)export;
- (NSArray *)queryList;
- (int)queryCount;

@end

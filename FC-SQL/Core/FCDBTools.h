//
//  FCDBTools.h
//  FC.Client
//
//  Created by fang on 2018/8/2.
//  Copyright © 2018 fangcha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCSQLProtocol.h"

@class FCDatabase;

@interface FCDBTools : NSObject

- (instancetype)initWithDatabase:(FCDatabase *)database handler:(id<FCSQLProtocol>)handler;

- (void)add:(NSDictionary *)params;
- (void)update:(NSDictionary *)params;
- (void)remove:(NSDictionary *)params;

- (NSDictionary *)searchSingle:(NSDictionary *)params;
- (NSDictionary *)searchSingle:(NSDictionary *)params checkPrimaryKey:(BOOL)checkPrimaryKey;
- (NSArray *)fetchList:(NSDictionary *)params page:(int)page feedsPerPage:(int)feedsPerPage;
- (int)fetchCount:(NSDictionary *)params;

@end

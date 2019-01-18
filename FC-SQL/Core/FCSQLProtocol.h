//
//  FCSQLProtocol.h
//  FC.Client
//
//  Created by fang on 2018/8/2.
//  Copyright © 2018 fangcha. All rights reserved.
//

#ifndef FCSQLProtocol_h
#define FCSQLProtocol_h

@protocol FCSQLProtocol

- (NSString *)sql_table;
- (NSArray *)sql_cols;
- (NSArray *)sql_insertableCols;
- (NSArray *)sql_modifiableCols;
- (id)sql_primaryKey;

@end


#endif /* FCSQLProtocol_h */

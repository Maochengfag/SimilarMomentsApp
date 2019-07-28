//
//  SqlOperation.h
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/7.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^BLOCK)(BOOL res);

@interface SqlOperation : NSObject

- (void)testblock:(BLOCK)block;



//插入数据
- (BOOL)doInsertTable:(NSString *)tableName data:(id)model;
//查询数据
- (BOOL)doSearchTable:(NSString *)tableName data:(id)model value:(NSString *)value key:(NSString *)key;
//更新数据
- (BOOL)doAlertTable:(NSString *)tableName data:(id)model key:(NSString *)key;
//删除数据
- (BOOL)doDeleteTable:(NSString *)tableName data:(id)model key:(NSString *)key;

@end

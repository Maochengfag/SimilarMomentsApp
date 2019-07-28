//
//  SqlManager.h
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/7.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SqlManager : NSObject

- (NSInteger)lastInsertPrimaryKeyId:(NSString *)tableName;
//单例创建数据库
+ (instancetype)shareDatabase;
+ (instancetype)shareDatabase:(NSString *)dbName;
+ (instancetype)shareDatabase:(NSString *)dbName path:(NSString *)dbpath;
//非单例创建数据库
- (instancetype)initWithDBName:(NSString *)dbName;
- (instancetype)initWithDBName:(NSString *)dbName path:(NSString *)dbPath;
//创建表 传入mode或者dictionary
- (BOOL)creatTable:(NSString *)tableName dicorModel:(id)parameters;
- (BOOL)createTable:(NSString *)tableName dicOrModel:(id)parameters excludeName:(NSArray *)nameArr;
//增加：向表中插入数据
- (BOOL)insertTable:(NSString *)tableName dicOrModel:(id)parameters;
//删除 根据条件删除表中数据
- (BOOL)deleteTable:(NSString *)tableName whereFormat:(NSString *)format,...;
//更改 根据条件更改表中数据
- (BOOL)updateTable:(NSString *)tableName dicOrModel:(id)paramenters whereFormat:(NSString *)format,...;
//查找 根据条件查表表中数据
- (NSArray *)lookupTale:(NSString *)tableName dicOrModel:(id)parameters whereFormat:(NSString *)format,...;

//批量插入或更改
- (NSArray *)insertTable:(NSString *)tableName dicOrModelArray:(NSArray *)dicOrModelArray;
//删除表
- (BOOL)deleteTable:(NSString *)tableName;
//清空表
- (BOOL)deleteAllDataFromTable:(NSString *)tableName;
//判断是否存在表
- (BOOL)isExistTable:(NSString *)tableName;
//几条数据
- (int)tableItemCount:(NSString *)tableName;
//表中字段名
- (NSArray *)columnNameArray:(NSString *)tableName;
//关闭数据库
- (void)close;
//打开数据库
- (void)open;
//增加字段
- (BOOL)alterTable:(NSString *)tableName dicOrModel:(id)parameters excludeName:(NSArray *)nameArr;

- (BOOL)alertTable:(NSString *)tableName dicOrModel:(id)parameters;

// 线程安全
- (void)inDatabase:(void(^)(void))block;
- (void)inTransaction:(void(^)(BOOL *roolback))block;
//二叉树和排序算法
@end

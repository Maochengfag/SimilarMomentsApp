//
//  SqlOperation.m
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/7.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import "SqlOperation.h"
#import "SqlManager.h"
#import "UserModel.h"
#import "LoginModel.h"

@interface SqlOperation()
@property (nonatomic, strong)NSMutableArray *blockArr;
@end

@implementation SqlOperation

- (instancetype)init{
    self = [super init];
    if (self) {
        self.blockArr = [NSMutableArray arrayWithCapacity:0];
        [self configureDataBase];
    }
    return self;
}

- (void)configureDataBase{
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSAllLibrariesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    SqlManager *db = [SqlManager  shareDatabase:@"User.sqlite" path:path];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (![db isExistTable:@"user"]) {
            [db creatTable:@"user" dicorModel:[UserModel class]];
        }
        if (![db  isExistTable:@"login"]) {
            [db creatTable:@"login" dicorModel:[LoginModel class]];
        }
    });
}

- (void)testblock:(BLOCK)block{
    block(YES);
}

- (BOOL)doInsertTable:(NSString *)tableName data:(id)model{
    SqlManager *db = [SqlManager shareDatabase];
    BOOL  res = [db insertTable:tableName dicOrModel:model];
    return res;
}

- (BOOL)doSearchTable:(NSString *)tableName data:(id)model value:(NSString *)value key:(NSString *)key{
    SqlManager *db = [SqlManager shareDatabase];
    NSArray *res = [db lookupTale:tableName dicOrModel:model  whereFormat:@"where %@ = '%@'",value,key];
    return  res.count > 0;
}

- (BOOL)doAlertTable:(NSString *)tableName data:(id)model key:(NSString *)key{
    SqlManager *db = [SqlManager shareDatabase];
    BOOL res  = [db updateTable:tableName dicOrModel:model whereFormat:key];
    return res;
}

- (BOOL)doDeleteTable:(NSString *)tableName data:(id)model key:(NSString *)key {
    SqlManager *db = [SqlManager shareDatabase];
    BOOL res =  [db deleteTable:tableName whereFormat:key];
    return res;
}

+ (BOOL)resolveClassMethod:(SEL)sel{
    NSString *methodName = NSStringFromSelector(sel);
    if ([methodName hasPrefix:@"doInsertTable"]) {
        return YES;
    }
    return [super resolveClassMethod:sel];
}
@end

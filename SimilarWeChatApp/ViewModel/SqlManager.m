//
//  SqlManager.m
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/7.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import "SqlManager.h"
#import "FMDB.h"
#import <objc/runtime.h>

// 数据库中常见的几种类型
#define SQL_TEXT @"TEXT" //文本
#define SQL_INTEGER @"INTEGER"  //int long integer
#define SQL_REAL @"REAL" // 浮点
#define SQL_BLOB @"BLOB" //data

@interface SqlManager()

@property (nonatomic, strong) NSString *dbPath;
@property (nonatomic, strong) FMDatabaseQueue *dbQueue;
@property (nonatomic, strong) FMDatabase  *db;

@end
@implementation SqlManager

- (FMDatabaseQueue *)dbQueue{
    
    if(!_dbQueue){
        FMDatabaseQueue *fmdb = [FMDatabaseQueue databaseQueueWithPath:_dbPath];
        self.dbQueue = fmdb;
        [_db close];
        self.db = [fmdb valueForKey:@"_db"];
    }
    
    return _dbQueue;
}

static SqlManager *manager = nil;

- (NSInteger)lastInsertPrimaryKeyId:(NSString *)tableName{
    NSString *sqlstr = [NSString stringWithFormat:@"SELECT * FROM %@ where pkid = (SELECT max(pkid) FROM %@)",tableName,tableName];
    FMResultSet *set = [_db executeQuery:sqlstr];
    while ([set next]) {
        return [set longForColumn:@"pkid"];
    }
    return 0;
}
//单例创建数据库
+ (instancetype)shareDatabase{
    return [SqlManager shareDatabase:nil];
}
+ (instancetype)shareDatabase:(NSString *)dbName{
    return [SqlManager shareDatabase:dbName path:nil];
}
+ (instancetype)shareDatabase:(NSString *)dbName path:(NSString *)dbpath{
    
    NSString *path;
    if(!dbName){
        dbName = @"User.sqlite";
    }
    if (!dbpath) {
        path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    }else{
        path = [dbpath stringByAppendingPathComponent:dbName];
    }
    
    FMDatabase *fmdb = [FMDatabase databaseWithPath:path];
    if ([fmdb open]) {
        manager = SqlManager.new;
        manager.db = fmdb;
        manager.dbPath = path;
    }
    
    if (![manager.db open]) {
        NSLog(@"database can not open !");
        return nil;
    }
    
    return manager;
}
//非单例创建数据库
- (instancetype)initWithDBName:(NSString *)dbName{
    return [self initWithDBName:dbName path:nil];
}
- (instancetype)initWithDBName:(NSString *)dbName path:(NSString *)dbPath{
    if (!dbName) {
        dbName = @"user.sqlite";
    }
    NSString *path;
    if (!dbPath) {
        path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:dbName];
    }else {
        path = [dbPath stringByAppendingPathComponent:dbName];
    }
    
    FMDatabase *fmdb = [FMDatabase   databaseWithPath:path];
    if ([fmdb open]) {
        self = [self init];
        if (self) {
            self.dbPath = path;
            self.db = fmdb;
            return  self;
        }
    }
    return nil;
}
//创建表 传入mode或者dictionary
- (BOOL)creatTable:(NSString *)tableName dicorModel:(id)parameters{
    return [self createTable:tableName dicOrModel:parameters excludeName:nil];
}
- (BOOL)createTable:(NSString *)tableName dicOrModel:(id)parameters excludeName:(NSArray *)nameArr{
    NSDictionary *dic;
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        dic = parameters;
    }else{
        
        Class CLS;
        if ([parameters isKindOfClass:[NSString class]]) {
            if (!NSClassFromString(parameters)) {
                CLS = nil;
            }else{
                CLS = NSClassFromString(parameters);
            }
        }else if ([parameters isKindOfClass:[NSObject class]]){
            CLS = [parameters class];
        }else{
            CLS = parameters;
        }
        
        dic = [self modelToDictionary:CLS excludePropertyName:nameArr];
    }
    
    NSMutableString *fieldStr = [[NSMutableString alloc] initWithFormat:@"CREATE TABLE %@ (pkid INTEGER PRIMARY KEY,",tableName];
    
    int keyCount = 0;

    for (NSString *key in dic) {
        keyCount ++;
        if ((nameArr && [nameArr containsObject:key]) || [key isEqualToString:@"pkid"]) {
            continue;
        }
        
        if (keyCount == dic.count){
            [fieldStr appendFormat:@"%@ %@)",key, dic[key]];
            break;
        }
        
       [fieldStr appendFormat:@"%@ %@,", key, dic[key]];
    }
    if ([fieldStr hasSuffix:@","] && ![fieldStr hasSuffix:@")"]) {
        [fieldStr deleteCharactersInRange:NSMakeRange(fieldStr.length-1, 1)];
        [fieldStr appendString:@")"];
    }
    BOOL creatFlag;
    creatFlag = [_db executeUpdate:fieldStr];
    
    return creatFlag;
}
//增加：向表中插入数据
- (BOOL)insertTable:(NSString *)tableName dicOrModel:(id)parameters{
    NSArray *columnArr = [self getColumnArr:tableName db:_db];
     return [self insertTable:tableName dicOrModel:parameters columnArr:columnArr];;
}

- (BOOL)insertTable:(NSString *)tableName dicOrModel:(id)parameters columnArr:(NSArray *)columnArr{
    BOOL flag;
    NSDictionary *dic;
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        dic = parameters;
    }else{
        dic = [self getModelPropertyKeyValue:parameters tableName:tableName clomnArr:columnArr];
    }
    
    NSMutableString *finalStr = [[NSMutableString alloc] initWithFormat:@"INSERT INTO %@(",tableName ];
    NSMutableString *temStr = [NSMutableString stringWithCapacity:0];
    NSMutableArray *argumentsArr = [NSMutableArray arrayWithCapacity:0];
    
    for (NSString *key in dic) {
        if (![columnArr containsObject:key] || [key isEqualToString:@"pkid"]) {
            continue;
        }
        [finalStr appendFormat:@"%@,", key];
        [temStr appendString:@"?,"];
        [argumentsArr addObject:dic[key]];
    }
    
    [finalStr deleteCharactersInRange:NSMakeRange(finalStr.length-1, 1)];
    if (temStr.length) {
        [temStr deleteCharactersInRange:NSMakeRange(temStr.length-1, 1)];
    }
    [finalStr appendFormat:@") values(%@)", temStr ];
    flag = [_db executeUpdate:finalStr withArgumentsInArray:argumentsArr];
    return flag;
}
//删除 根据条件删除表中数据
- (BOOL)deleteTable:(NSString *)tableName whereFormat:(NSString *)format,...{
    va_list args;
    va_start(args, format);
    NSString *where = format?[[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:args] :format;
    va_end(args);
    BOOL flag ;
    NSMutableString *finalStr = [[NSMutableString alloc] initWithFormat:@"delete from %@  %@",tableName, where];
    flag = [_db executeUpdate:finalStr];
     return flag;
}
//更改 根据条件更改表中数据
- (BOOL)updateTable:(NSString *)tableName dicOrModel:(id)paramenters whereFormat:(NSString *)format,...{
    va_list args;
    va_start(args, format);
    NSString *where = format?[[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:args] :format;
    va_end(args);
    BOOL flag ;
    NSDictionary *dic;
    NSArray *clomnArr = [self getColumnArr:tableName db:_db];
    
    if ([paramenters isKindOfClass:[NSDictionary class]]) {
        dic = paramenters;
    }else{
        dic = [self getModelPropertyKeyValue:paramenters tableName:tableName clomnArr:clomnArr];
    }
    NSMutableString *finalStr = [[NSMutableString  alloc] initWithFormat:@"update %@ set ", tableName ];
    NSMutableArray *argumentsArr = [NSMutableArray arrayWithCapacity:0];
    
    for (NSString *key in dic) {
        
        if (![clomnArr containsObject:key] || [key isEqualToString:@"pkid"]) {
            continue;
        }
        
        [finalStr appendFormat:@"%@ = %@,", key ,@"?"];
        [argumentsArr addObject:dic[key]];
    }
    
    [finalStr deleteCharactersInRange:NSMakeRange(finalStr.length-1, 1)];
    if (where.length) {
        [finalStr appendFormat:@" %@",where];
    }
    
    flag = [_db executeUpdate:finalStr withArgumentsInArray:argumentsArr];
     return flag;
}
//查找 根据条件查表表中数据
- (NSArray *)lookupTale:(NSString *)tableName dicOrModel:(id)parameters whereFormat:(NSString *)format,...{
    va_list args;
    va_start(args, format);
    NSString *where = format?[[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:args]:format;
    va_end(args);
    NSMutableArray *resultMArr = [NSMutableArray arrayWithCapacity:0];
    NSDictionary *dic;
    
    NSMutableString  *finalStr = [[NSMutableString alloc] initWithFormat:@"select * from %@ %@",tableName, where?where:@""];
    NSArray *clomnArr = [self getColumnArr:tableName db:_db];
    
    FMResultSet *set = [_db executeQuery:finalStr];
    
    if ([parameters isKindOfClass:[NSDictionary  class]]) {
        dic = parameters;
        
        while ([set next]) {
            NSMutableDictionary *resultDic = [NSMutableDictionary dictionaryWithCapacity:0];
            for (NSString *key in dic) {
                if ([dic[key] isEqualToString:SQL_TEXT]) {
                    id value = [set stringForColumn:key];
                    if (value)
                        [resultDic setObject:value forKey:key];
                } else if ([dic[key] isEqualToString:SQL_INTEGER]) {
                    [resultDic setObject:@([set longLongIntForColumn:key]) forKey:key];
                } else if ([dic[key] isEqualToString:SQL_REAL]) {
                    [resultDic setObject:[NSNumber numberWithDouble:[set doubleForColumn:key]] forKey:key];
                } else if ([dic[key] isEqualToString:SQL_BLOB]) {
                    id value = [set dataForColumn:key];
                    if (value)
                        [resultDic setObject:value forKey:key];
                }
            }
            if (resultDic) [resultMArr addObject:resultDic];
        }
    }else {
        Class CLS;
        if ([parameters isKindOfClass:[NSString class]]) {
            if (!NSClassFromString(parameters)) {
                CLS = nil;
            }else{
                CLS = NSClassFromString(parameters);
            }
        }else if ([parameters isKindOfClass:[NSObject class]]){
            CLS = [parameters class];
        }else{
            CLS = parameters;
        }
        
        if (CLS) {
            NSDictionary *propertyType = [self modelToDictionary:CLS excludePropertyName:nil];
            while ([set next]) {
                id model = CLS.new;
                for (NSString *name  in clomnArr) {
                    if ([propertyType[name] isEqualToString:SQL_TEXT]) {
                        id value = [set stringForColumn:name];
                        if (value) {
                            [model setValue:value forKey:name];
                        }
                    }else if ([propertyType[name] isEqualToString:SQL_INTEGER]){
                        [model setValue:@([set longForColumn:name]) forKey:name];
                    }else if ([propertyType[name] isEqualToString:SQL_REAL]){
                        [model setValue:[NSNumber numberWithDouble:[set doubleForColumn:name]] forKey:name];
                    }else if ([propertyType[name] isEqualToString:SQL_BLOB]){
                        id value = [set dataForColumn:name];
                        if (value) {
                            [model setValue:value forKey:name];
                        }
                    }
                }
                [resultMArr addObject:model];
            }
        }
    }
    
    return resultMArr;
}

//批量插入或更改
- (NSArray *)insertTable:(NSString *)tableName dicOrModelArray:(NSArray *)dicOrModelArray{
    int errorIndex = 0;
    NSMutableArray *resultMArr = [NSMutableArray arrayWithCapacity:0];
    
    NSArray * columnArr = [self getColumnArr:tableName db:_db];
    for (id parameter in dicOrModelArray) {
        BOOL flag = [self insertTable:tableName dicOrModel:parameter columnArr:columnArr];
        if (!flag) {
            [resultMArr addObject:@(errorIndex)];
        }
        errorIndex++;
    }
    return  resultMArr;
}
//删除表
- (BOOL)deleteTable:(NSString *)tableName{
    NSString *sqlstr = [NSString stringWithFormat:@"DROP TABLE %@",tableName];
    if (![_db executeUpdate:sqlstr]) {
        return NO;
    }
    return YES;
}
//清空表
- (BOOL)deleteAllDataFromTable:(NSString *)tableName{
    NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@",tableName];
    if (![_db executeUpdate:sqlstr]) {
        return NO;
    }
     return YES;
}
//判断是否存在表
- (BOOL)isExistTable:(NSString *)tableName{
    FMResultSet *set = [_db executeQuery:@"SELECT count(*) as 'count' FROM sqlite_master WHERE type ='table' and name = ?",tableName];
    while ([set next]) {
        NSInteger count = [set intForColumn:@"count"];
        if (count == 0) {
            return NO;
        }else{
            return YES;
        }
    }
    return NO;
}


//几条数据
- (int)tableItemCount:(NSString *)tableName{
    NSString *sqlstr = [NSString stringWithFormat:@"SELECT count(*) as 'count' FROM %@",tableName];
    
    FMResultSet *set = [_db executeQuery:sqlstr];
    while ([set next]) {
        return [set intForColumn:@"count"];
    }
    return 0;
}
//表中字段名
- (NSArray *)columnNameArray:(NSString *)tableName{
    return  [self getColumnArr:tableName db:_db];;
}
//关闭数据库
- (void)close{
    [_db close];
}
//打开数据库
- (void)open{
    [_db open];
}
//增加字段
- (BOOL)alterTable:(NSString *)tableName dicOrModel:(id)parameters excludeName:(NSArray *)nameArr{
    
    __block BOOL flag;
    [self inTransaction:^(BOOL *roolback) {
        if ([parameters isKindOfClass:[NSDictionary class]]) {
            for (NSString *key in parameters) {
                if ([nameArr containsObject:key]) {
                    continue;
                }
                
                flag = [self->_db executeUpdate:[NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUM %@ %@",tableName, key , parameters[key]]];
                if (!flag) {
                    *roolback = YES;
                    return;
                }
            }
        }else{
            Class CLS;
            if ([parameters isKindOfClass:[NSString class]]) {
                if (!NSClassFromString(parameters)) {
                    CLS = nil;
                }else{
                    CLS = NSClassFromString(parameters);
                }
            }else if ([parameters isKindOfClass:[NSObject class]]){
                CLS = [parameters class];
            }else{
                CLS = parameters;
            }
            NSDictionary *modelDic = [self modelToDictionary:CLS excludePropertyName:nameArr];
            NSArray *columnArr = [self getColumnArr:tableName db:self->_db];
            for (NSString *key in modelDic) {
                if (![columnArr containsObject:key] && ![nameArr containsObject:key]) {
                    flag = [self->_db executeUpdate:[NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ %@",tableName,key,modelDic[key]]];
                    if (!flag) {
                        *roolback = YES;
                        return ;
                    }
                }
            }
        }
    }];
    return flag;
}

- (BOOL)alertTable:(NSString *)tableName dicOrModel:(id)parameters{
    return [self alterTable:tableName dicOrModel:parameters excludeName:nil];
}

// 线程安全
- (void)inDatabase:(void(^)(void))block
{
    [[self dbQueue] inDatabase:^(FMDatabase * db) {
        block();
    }];
}
- (void)inTransaction:(void(^)(BOOL *roolback))block{
    [[self dbQueue] inTransaction:^(FMDatabase * db, BOOL * rollback) {
        block(rollback);
    }];
}

#pragma mark - *************** runtime

- (NSDictionary *)modelToDictionary:(Class)cls excludePropertyName:(NSArray *)nameArr{
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithCapacity:0];
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList(cls, &outCount);
    for (int i =0; i < outCount; i++) {
        NSString *name = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
        if ([nameArr containsObject:name]) {
            continue;
        }
        
        NSString *type = [NSString stringWithCString:property_getAttributes(properties[i]) encoding:NSUTF8StringEncoding];
        id value = [self propertTypeConvert:type];
        if (value) {
            [mDict setObject:value forKey:name];
        }
    }
    
    free(properties);
    
    return mDict;
}
// 获取model的key和value
- (NSDictionary *)getModelPropertyKeyValue:(id)model tableName:(NSString *)tableName clomnArr:(NSArray *)clomnArr{
    
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithCapacity:0 ];
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([model class], &outCount);
    
    for (int i =0; i < outCount; i++) {
        NSString *name = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
        if (![clomnArr containsObject:name]) {
            continue;
        }
        
        id value = [model valueForKey:name];
        if (value) {
            [mDic setObject:value forKey:name];
        }
    }
    free(properties);
    return mDic;
}


- (NSString *)propertTypeConvert:(NSString *)typeStr
{
    NSString *resultStr = nil;
    if ([typeStr hasPrefix:@"T@\"NSString\""]) {
        resultStr = SQL_TEXT;
    } else if ([typeStr hasPrefix:@"T@\"NSData\""]) {
        resultStr = SQL_BLOB;
    } else if ([typeStr hasPrefix:@"Ti"]||[typeStr hasPrefix:@"TI"]||[typeStr hasPrefix:@"Ts"]||[typeStr hasPrefix:@"TS"]||[typeStr hasPrefix:@"T@\"NSNumber\""]||[typeStr hasPrefix:@"TB"]||[typeStr hasPrefix:@"Tq"]||[typeStr hasPrefix:@"TQ"]) {
        resultStr = SQL_INTEGER;
    } else if ([typeStr hasPrefix:@"Tf"] || [typeStr hasPrefix:@"Td"]){
        resultStr= SQL_REAL;
    }
    
    return resultStr;
}

//private

- (NSArray *)getColumnArr:(NSString *)tableName db:(FMDatabase *)db{
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:0];
    FMResultSet *resulutSet = [db getTableSchema:tableName];
    while ([resulutSet next]) {
        [mArr addObject:[resulutSet stringForColumn:@"name"]];
    }
    return mArr;
}

@end

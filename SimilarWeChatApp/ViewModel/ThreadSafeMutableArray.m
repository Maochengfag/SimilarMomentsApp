//
//  ThreadSafeMutableArray.m
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/3.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import "ThreadSafeMutableArray.h"

@interface ThreadSafeMutableArray()

@property (nonatomic, strong) dispatch_queue_t syncQueue;
@property (nonatomic, strong) NSMutableArray* array;

@end

@implementation ThreadSafeMutableArray

- (instancetype)initCommon{
    self = [super init];
    if (self) {
        //%p 以16进制的形式输出内存地址，附加前缀0x
        NSString* uuid = [NSString stringWithFormat:@"com.mao.array_%p",self];
        //注意：_syncQueue是并行队列
        _syncQueue = dispatch_queue_create([uuid UTF8String], DISPATCH_QUEUE_CONCURRENT);
    }
    
    return self;
}

- (instancetype)init{
    
    self = [self initCommon];
    if (self) {
        _array = [NSMutableArray array];
    }
    
    return self;
}

- (instancetype)initWithCapacity:(NSUInteger)numItems{
    
    self = [self initCommon];
    
    if (self) {
        _array = [NSMutableArray arrayWithCapacity:numItems];
    }
    return self;
}

- (NSArray *)initWithContentsOfFile:(NSString *)path{
    self = [self initCommon];
    if (self) {
        _array = [NSMutableArray arrayWithContentsOfFile:path];
    }
    return self;
}

- (instancetype)initWithObjects:(id  _Nonnull const [])objects count:(NSUInteger)cnt{
    self = [self initCommon];
    
    if (self) {
        _array = [NSMutableArray array];
        for (NSUInteger i =0; i<cnt; i++) {
            [_array addObject:objects[i]];
        }
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [self initCommon];
    if (self) {
        _array = [[NSMutableArray array] initWithCoder:aDecoder];
    }
    
    return self;
}

#pragma mark - 数据操作方法 (凡涉及更改数组中元素的操作，使用异步派发+栅栏块；读取数据使用 同步派发+并行队列)

//读操作
- (NSUInteger)count{
    __block NSUInteger count;
    __weak typeof (self) weakSelf = self;
    dispatch_sync(_syncQueue, ^{
        count = weakSelf.array.count;
    }) ;
    
    return count;
}

- (id)objectAtIndex:(NSUInteger)index{
    __block id obj;
    __weak typeof (self) weakSelf = self;
    dispatch_sync(_syncQueue, ^{
        if (index < [weakSelf.array count]) {
            obj = weakSelf.array[index];
        }
    });
    
    return obj;
}

- (NSEnumerator *)objectEnumerator{
    __block NSEnumerator *enu;
    __weak typeof (self) weakSelf = self;
    dispatch_sync(_syncQueue, ^{
        enu = [weakSelf objectEnumerator];
    });
    
    return enu;
}

- (NSUInteger)indexOfObject:(id)anObject{
    __weak typeof (self) weakSelf = self;
    __block NSUInteger index = NSNotFound;
    
    dispatch_sync(_syncQueue, ^{
        for (int i =0; i < [weakSelf.array count]; i++) {
            if ([weakSelf.array objectAtIndex:i] == anObject) {
                index = i;
                break;
            }
        }
    });
    
    return index;
}

//更改操作
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index{
    __weak typeof (self) weakSelf = self;
    dispatch_barrier_async(_syncQueue, ^{
        [weakSelf.array insertObject:anObject atIndex:index];
    });
}

- (void)addObject:(id)anObject{
    __weak typeof (self) weakSelf = self;
    dispatch_barrier_async(_syncQueue, ^{
        if (anObject) {
            [weakSelf.array addObject:anObject];
        }
    });
}

- (void)removeObjectAtIndex:(NSUInteger)index{
    __weak typeof (self) weakSelf = self;
    dispatch_barrier_async(_syncQueue, ^{
        if (index < [weakSelf.array count]){
            [weakSelf.array removeObjectAtIndex:index];
        }
    });
}

- (void)removeLastObject{
    __weak typeof (self) weakSelf = self;
    dispatch_barrier_async(_syncQueue, ^{
        [weakSelf.array removeLastObject];
    });
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject{
    __weak typeof (self) weakSelf = self;
    
    dispatch_barrier_async(_syncQueue, ^{
        if (anObject && index < [weakSelf.array count]) {
            [weakSelf.array replaceObjectAtIndex:index withObject:anObject];
        }
    });
}


@end

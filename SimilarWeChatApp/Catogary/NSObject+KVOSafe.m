//
//  NSObject+KVOSafe.m
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/9.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import "NSObject+KVOSafe.h"
#import "NSObject+SafeSwizzle.h"
#import <objc/message.h>

@interface KVOObserverInfo()

@property (nonatomic, weak) id target;
@property (nonatomic, copy) NSString *targetAddress;
@property (nonatomic, copy) NSString *targetClassName;

@property (nonatomic, weak) id observer;
@property (nonatomic, copy) NSString *observerAddress;
@property (nonatomic, copy) NSString *observerClassName;

@property (nonatomic, copy) NSString *keyPath;
@property (nonatomic, assign) void *context;


@end

@implementation KVOObserverInfo

@end

@interface LSRecursiveLock:NSRecursiveLock
@end

@implementation LSRecursiveLock
- (void)dealloc{
    
    NSLog(@"LSRecursiveLock -----dealloc-------%@",self);
}
@end

@interface NSObject()
@property (nonatomic, strong) KVOObserverInfo *safe_willRemoveObserverInfo;
//提示用户有没移除的KVO  默认为YES dealloc时改为NO
@property (nonatomic, assign) BOOL safe_notNeedRemoveKeypathFromCrashArray;
@property (nonatomic, strong) LSRecursiveLock *safe_lock;

@end


@implementation NSObject (KVOSafe)

static NSMutableSet *KVOSafeSwizzledClass(){
    static dispatch_once_t onceToken;
    static NSMutableSet *swizzledClasses = nil;
    dispatch_once(&onceToken, ^{
        swizzledClasses = [[NSMutableSet alloc] init];
    });
    return swizzledClasses;
}

static NSMutableDictionary *KVOSafeDeallocCrashes(){
    static dispatch_once_t onceToken;
    static NSMutableDictionary *KVOSafeDeallocCrashes = nil;
    dispatch_once(&onceToken, ^{
        KVOSafeDeallocCrashes = [[NSMutableDictionary alloc] init];
    });
    return KVOSafeDeallocCrashes;
}

+(void)openKVOSafeProtector{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self safe_exchangeInstanceMethod:[self class] originalSel:@selector(addObserver:forKeyPath:options:context:) newSel:@selector(safe_addObserver:forKeyPath:options:context:)];
        
        [self safe_exchangeInstanceMethod:[self class] originalSel:@selector(observeValueForKeyPath:ofObject:change:context:) newSel:@selector(safe_observeValueForKeyPath:ofObject:change:context:)];
        [self safe_exchangeInstanceMethod:[self class] originalSel:@selector(removeObserver:forKeyPath:) newSel:@selector(safe_removeObserver:forKeyPath:)];
        
        [self safe_exchangeInstanceMethod:[self class] originalSel:@selector(removeObserver:forKeyPath:context:) newSel:@selector(safe_removeObserver:forKeyPath:context:)];
        
    });
}

//最后替换的dealloc 会最先调用倒序

- (void)safe_KVOChangeDidDeallocSignal{
    //此处交换dealloc方法是借鉴RAC源码
    Class classToSwizzle = [self class];
    @synchronized(KVOSafeSwizzledClass()){
        NSString *className = NSStringFromClass(classToSwizzle);
        SEL deallocSelector = sel_registerName("dealloc");
        
        __block void (*originalDealloc)(__unsafe_unretained id, SEL) = NULL;
        id newDealloc = ^(__unsafe_unretained id self){
            [self safe_KVODealloc];
            NSString *classAddress = [NSString stringWithFormat:@"%p",self];
            if (originalDealloc == NULL) {
                struct objc_super superInfo = {
                    .receiver = self,
                    .super_class = class_getSuperclass(classToSwizzle)
                };
                void (*msgSend)(struct objc_super *, SEL) = (__typeof__(msgSend))objc_msgSendSuper;
                msgSend(&superInfo, deallocSelector);
            }else{
                originalDealloc(self, deallocSelector);
            }
            [NSClassFromString(className) safe_dealloc_crash:classAddress];
        };
        
        IMP newDeallocIMP = imp_implementationWithBlock(newDealloc);
        if (!class_addMethod(classToSwizzle, deallocSelector, newDeallocIMP, "V@:")) {
            //该类已经包含一个实例方法
            Method deallocMethod = class_getInstanceMethod(classToSwizzle, deallocSelector);
            //我们需要在设置新实例之前存贮源实例方法
            //在setting的时候实例方法被调用
            originalDealloc = (__typeof__(originalDealloc)) method_getImplementation(deallocMethod);
            
            //我们需要再次存贮源实例 此时它仅仅改变了
            originalDealloc = (__typeof__(originalDealloc))method_setImplementation(deallocMethod, newDeallocIMP);
        }
        [KVOSafeSwizzledClass() addObject:className];
    }
}

//移除时不断要把哪些对象监听了自己字典移除，还要把observer的监听那些人字典移除
/**
 不带context 苹果也是倒序遍历数组，然后判断keypath是否相等，不管context是啥，如果相等则移除，如果没有相等的则奔溃 。
 **/
- (void)safe_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath{
    [self safe_allRemoveObserver:observer forKeyPath:keyPath context:nil isContext:NO];
}
/**
 带context参数方法。苹果是倒序遍历数组，然后判断keypath和context是都都相等，如果都相等则移除，如果没有相等就奔溃，如果context参数=NULL。也是相同逻辑，判断keypath是否相等，context是否等于NULL，有则移除，没有像等就奔溃
 **/
- (void)safe_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context{
    [self safe_allRemoveObserver:observer forKeyPath:keyPath context:context isContext:YES];
}


- (void)safe_allRemoveObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context isContext:(BOOL)isContext{
    //判断
    if (!observer || !keyPath || ([keyPath isKindOfClass:[NSString class]]&&keyPath.length <=0)) {
        return;
    }
        LSRecursiveLock *lock;
        @synchronized(self){
            lock = self.safe_lock;
            if (lock == nil) {
                lock = observer.safe_lock;
                if (lock == nil) {
                    lock = [[LSRecursiveLock alloc] init];
                    lock.name = [NSString stringWithFormat:@"%@",[observer class]];
                }
            }
        }
    
    [lock lock];
    
    KVOObserverInfo *info = [self safe_canAddOrRemoveObserverWithKeypathWithObserver:observer keyPath:keyPath context:context haveContext:context isAdd:NO];
    
    if (info == nil) {
        //重复删除观察者或不含油 或者keyPath=nil observer = nil
        NSString *text = @"";
        if (observer.safe_notNeedRemoveKeypathFromCrashArray) {
        }else{
            //observer走完了dealloc，然后去移除，事实上我们已经替他移除完了
            text = @"主动";
        }
        [self safe_logKVODebugInfoWithText:[NSString stringWithFormat:@"%@移除失败",text] observer:observer keyPath:keyPath context:context];
        [lock unlock];
        return;
    }
    
    @try{
        if (isContext) {
            NSString *targetAddress = [NSString stringWithFormat:@"%p",self];
            NSString *observerAddress = [NSString stringWithFormat:@"%p",observer];
            //此处是因为remove keypath context 调用的还是remove keypath方法
            KVOObserverInfo *info = [KVOObserverInfo new];
            info.keyPath = keyPath;
            info.context = context;
            info.targetAddress = targetAddress;
            info.observerAddress  = observerAddress;
            self.safe_willRemoveObserverInfo = info;
            [self safe_removeObserver:observer forKeyPath:keyPath context:context];
        }else{
            //newContext 是上面方法的参数值，因为上面方法底层调用的方法是不带context参数的remove方法
            void *newContext = NULL;
            if (self.safe_willRemoveObserverInfo) {
                newContext = self.safe_willRemoveObserverInfo.context;
            }
            
            [self safe_removeObserver:observer forKeyPath:keyPath];
            [self safe_logKVODebugInfoWithText:@"" observer:observer keyPath:keyPath context:newContext];
            
        }
    }
    @catch(NSException *exception){
        NSLog(@"exception ===%@ LSSafeProtectorCrashTypeKVO",exception);
    }
    @finally{
        if (isContext) {
            self.safe_willRemoveObserverInfo = nil;
        }
        [self safe_removeSuccessObserver:observer info:info];
        [lock unlock];
    }
}

- (void)safe_observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    @try{
        [self safe_observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    @catch(NSException *exception){
        NSLog(@"exception %@ typeKVO",exception);
    }
    @finally{}
}

// Keypath为对象的属性 通过keyPath作为创建对应的一条观察者路径keyPath-->observers--self
- (void)safe_addObserver:(NSString *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context{
    //判断入参
    if (!observer || ! keyPath || ([keyPath isKindOfClass:[NSString class]] && keyPath.length <=0)) {
        return;
    }
    
    observer.safe_notNeedRemoveKeypathFromCrashArray = YES;
    LSRecursiveLock *lock;
    @synchronized(self){
        lock = self.safe_lock;
        if (lock == nil) {
            lock = [[LSRecursiveLock alloc] init];
            lock.name = [NSString stringWithFormat:@"%@",[self class]];
            self.safe_lock = lock;
        }
    }
    [lock lock];
    
    KVOObserverInfo *info = [self safe_canAddOrRemoveObserverWithKeypathWithObserver:observer keyPath:keyPath context:context haveContext:YES isAdd:YES];
    if (info != nil) {
        //如果添加了直接return
        [self safe_logKVODebugInfoWithText:@"添加失败" observer:observer keyPath:keyPath context:context];
        [lock unlock];
        return ;
    }
    @try{
        [self safe_logKVODebugInfoWithText:@"添加成功" observer:observer keyPath:keyPath context:context];
        NSString *targetAddress = [NSString stringWithFormat:@"%p",self];
        NSString *observerAddress = [NSString stringWithFormat:@"%p",observer];
        KVOObserverInfo *info = [KVOObserverInfo new];
        info.target = self;
        info.observer = observer;
        info.keyPath = keyPath;
        info.context = context;
        info.targetAddress = targetAddress;
        info.observerAddress = observerAddress;
        info.targetClassName = NSStringFromClass([self class]);
        info.observerClassName = NSStringFromClass([observer class]);
        @synchronized(self.safe_downObservedKeyPathArray){
            [self.safe_downObservedKeyPathArray addObject:info];
        }
        @synchronized(observer.safe_upObservedArray){
            [observer.safe_upObservedArray addObject:info];
        }
        [self safe_addObserver:observer forKeyPath:keyPath options:options context:context];
        //交换dealloc方法
        [observer safe_KVOChangeDidDeallocSignal];
        [self safe_KVOChangeDidDeallocSignal];
    }
    @catch(NSException *exception){
        NSLog(@"exception ===%@",exception);
    }
    @finally{
        [lock unlock];
        
    }
}
/* 防止此种崩溃所以新创建个NSArray 和 NSMutableDictionary遍历
 Terminating app due to uncaught exception 'NSGenericException', reason: '*** Collection <__NSArrayM: 0x61800024f7b0> was mutated while being enumerated.'
 
 Terminating app due to uncaught exception 'NSGenericException', reason: '*** Collection <__NSDictionaryM: 0x170640de0> was mutated while being enumerated.'
 */
- (void)safe_KVODealloc{
    NSLog(@"\n******* 🚗🚗🚗🚗🚗  %@(%p)  safe_KVODealloc  🚗🚗🚗🚗🚗\n----------------------------------------",[self class],self);
    
    if (self.safe_upObservedArray.count > 0) {
        @synchronized(KVOSafeDeallocCrashes()){
            NSString *currentKey = LSFormatterStringFromObject(self);
            NSMutableDictionary *crashDic = [NSMutableDictionary dictionary];
            NSMutableArray *array = [NSMutableArray array];
            crashDic[@"keyPaths"] = array;
            crashDic[@"className"] = NSStringFromClass([self class]);
            KVOSafeDeallocCrashes()[currentKey] = crashDic;
            for (KVOObserverInfo *info in self.safe_upObservedArray) {
                NSMutableDictionary  *newDic = [NSMutableDictionary dictionary];
                newDic[@"targetName"] = info.targetClassName;
                newDic[@"targetAddress"] = info.targetAddress;
                newDic[@"keyPath"] = info.keyPath;
                newDic[@"context"] = [NSString stringWithFormat:@"%p",info.context];
                [array addObject:newDic];
            }
        }
    }
    
    //A->B A先销毁 B的safe_upObservedArray 里的info.target=nil,然后在B dealloc里在remove会导致移除不了，然后系统会报销毁时还持有某keypath的crash
    //A->B B先销毁 此时A remove 但事实上的A的safe_downObservedArray里info.observer=nil  所以B remove里会判断observer是否有值，如果没值则不remove导致没有remove
    
    //监听了那些人 让那些人移除自己
    NSMutableArray *newUpArray = [[[self.safe_upObservedArray reverseObjectEnumerator] allObjects] mutableCopy];
    for (KVOObserverInfo *upInfo in newUpArray) {
        id target = upInfo.target;
        if (target) {
            [target safe_allRemoveObserver:self forKeyPath:upInfo.keyPath context:upInfo.context isContext:upInfo.context != NULL];
        }else if ([upInfo.targetAddress isEqualToString:[NSString stringWithFormat:@"%p",self]]){
            [self safe_allRemoveObserver:self forKeyPath:upInfo.keyPath context:upInfo.context isContext:upInfo.context!=NULL];
        }
    }
    
    // 谁监听了自己移除他们 必须处理 不然A->B A先销毁了 在B里调用Aremove就无效 因为A=nil
    NSMutableArray *downNewArray = [[[self.safe_downObservedKeyPathArray reverseObjectEnumerator] allObjects] mutableCopy];
    for (KVOObserverInfo *downInfo in downNewArray) {
        [self safe_allRemoveObserver:downInfo.observer forKeyPath:downInfo.keyPath context:downInfo.context isContext:downInfo.context!=NULL];
    }
    
    self.safe_notNeedRemoveKeypathFromCrashArray = NO;
}

+ (void)safe_dealloc_crash:(NSString*)classAddress{
    
    //比如A先释放了然后走到此处，然后地址又被B重新使用了，A又释放了走了safe_KVODealloc方法，KVOSafeDeallocCrashes以地址为key的值又被重新赋值，导致误报(A还监听着B监听的内容)，赋值KVOSafeDeallocCrashes以地址为kay的字典的时候，导致字典被释放其他地方又使用，导致野指针
    
    @synchronized(KVOSafeDeallocCrashes()){
        NSString *currentKey = [NSString stringWithFormat:@"%@-%@",classAddress,NSStringFromClass(self)];
        NSDictionary *crashDic =KVOSafeDeallocCrashes()[currentKey];
        NSArray *array = [crashDic[@"keyPath"] copy];
        
        for (NSMutableDictionary *dic in array) {
            NSString *reason=[NSString stringWithFormat:@"%@:(%@） dealloc时仍然监听着 %@:%@ 的 keyPath of %@ context:%@",crashDic[@"className"],classAddress,dic[@"targetName"],dic[@"targetAddress"],dic[@"keyPath"],dic[@"context"]];
            NSException *exception = [NSException exceptionWithName:@"KVO crash" reason:reason userInfo:nil];
            NSLog(@"CrashTypeKVO ===%@",exception);
        }
        [KVOSafeDeallocCrashes() removeObjectForKey:currentKey];
    }
}

//为什么判断能否移除 而不是直接remove try catch 捕获异常 因为有的类remove keypath 两次 try直接奔溃
-(KVOObserverInfo*)safe_canAddOrRemoveObserverWithKeypathWithObserver:(NSObject *)observer keyPath:(NSString*)keyPath context:(void*)context haveContext:(BOOL)haveContext isAdd:(BOOL)isAdd{
    if (observer.safe_notNeedRemoveKeypathFromCrashArray == NO) {
        NSString *observerKey = LSFormatterStringFromObject(observer);
        NSMutableDictionary *dic = KVOSafeDeallocCrashes()[observerKey];
        NSMutableArray *array = dic[@"keyPaths"];
        __block NSMutableDictionary *willRemoveDic;
        if (array.count >0) {
            [[array copy] enumerateObjectsUsingBlock:^(NSMutableDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj[@"targetName"] isEqualToString:NSStringFromClass([self class])] &&[obj[@"targetAddress"] isEqualToString:[NSString stringWithFormat:@"%p",self]] && [keyPath isEqualToString:obj[@"keyPath"]]) {
                    
                    willRemoveDic = obj;
                    *stop = YES;
                }
            }];
            
            if (willRemoveDic) {
                [array removeObject:willRemoveDic];
                if (array.count <=0) {
                    @synchronized(KVOSafeDeallocCrashes()){
                        [KVOSafeDeallocCrashes() removeObjectForKey:observerKey];
                    }
                }
            }
        }
    }
    
    if (haveContext == NO && self.safe_willRemoveObserverInfo) {
        context = self.safe_willRemoveObserverInfo.context;
    }
    
    if (self.safe_willRemoveObserverInfo) {
        haveContext = YES;
    }
    //那些对象监听了自己
    NSMutableArray *downArray = self.safe_downObservedKeyPathArray;
    
    //返回已重复的KVO 或者将要移除的KVO
    __block KVOObserverInfo *info;
    if (isAdd) {
        [downArray enumerateObjectsUsingBlock:^(KVOObserverInfo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.observerAddress isEqualToString:[NSString stringWithFormat:@"%p",observer]] && [obj.keyPath isEqualToString:keyPath]) {
                if (obj.context == context) {
                    info = obj;
                    *stop = YES;
                }
            }
        }];
        if (info) {
            return info;
        }
        return nil;
    }
    
    //处理移除的逻辑
    [downArray enumerateObjectsWithOptions:(NSEnumerationReverse) usingBlock:^(KVOObserverInfo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.observerAddress isEqualToString:[NSString stringWithFormat:@"%p",observer]] && [obj.keyPath isEqualToString:keyPath]) {
            if (haveContext) {
                if (obj.context == context) {
                    info = obj;
                    *stop = YES;
                }
            }else{
                info = obj;
                *stop = YES;
            }
        }
    }];
    
    if (info) {
        return info;
    }
    return nil;
}


NSString * LSFormatterStringFromObject(id object) {
    return   [NSString stringWithFormat:@"%p-%@",object,NSStringFromClass([object class])];
}

-(void)safe_logKVODebugInfoWithText:(NSString*)text observer:(id)observer keyPath:(NSString*)keyPath context:(void*)context
{
    NSString *method;
    if ([text rangeOfString:@"添加"].length>0) {
        method=@" addObserver  ";
    }else{
        method=@"removeObserver";
    }
    NSString *emoji;
    if ([text rangeOfString:@"成功"].length>0) {
        emoji=@"😀😀😀😀😀";
    }else{
        emoji=@"😡😡😡😡😡";
    }
    
   NSLog(@"\n*******   %@ %@:     ##################\n\t%@(%p)  %@ %@(%p)   keyPath:%@  context:%p\n----------------------------------------",text,emoji,[self class],self,method,[observer class],observer,keyPath,context);
}

-(void)safe_removeSuccessObserver:(NSObject*)observer info:(KVOObserverInfo*)info{
    //那些对象监听了自己
    NSMutableArray *downArray = self.safe_downObservedKeyPathArray;
    //observer监听了哪些对象
    NSMutableArray *upArray = observer.safe_upObservedArray;
    if (info) {
        @synchronized(downArray){
            if ([downArray containsObject:info]) {
                [downArray removeObject:info];
            }
        }
        
        @synchronized(upArray){
            if ([upArray containsObject:info]) {
                [upArray removeObject:info];
            }
        }
    }
}


#pragma mark - 被监听的所有keypath 字典

- (NSMutableArray *)safe_downObservedKeyPathArray{
    NSMutableArray *array = objc_getAssociatedObject(self, _cmd);
    if (!array) {
        array = [NSMutableArray new];
        objc_setAssociatedObject(self, _cmd, array, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return array;
}

- (void)setSafe_downObservedKeyPathArray:(NSMutableArray *)safe_downObservedKeyPathArray{
    objc_setAssociatedObject(self, @selector(safe_downObservedKeyPathArray), safe_downObservedKeyPathArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - 监听了哪些对象数组

- (NSMutableArray *)safe_upObservedArray{
    @synchronized(self){
        NSMutableArray *array =objc_getAssociatedObject(self, _cmd);
        if (!array) {
            array = [NSMutableArray array];
            [self setSafe_upObservedArray:array];
        }
        return array;
    }
}

- (void)setSafe_upObservedArray:(NSMutableArray *)safe_upObservedArray{
    objc_setAssociatedObject(self,@selector(safe_upObservedArray) , safe_upObservedArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setSafe_willRemoveObserverInfo:(KVOObserverInfo *)safe_willRemoveObserverInfo{
    objc_setAssociatedObject(self, @selector(safe_willRemoveObserverInfo), safe_willRemoveObserverInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (KVOObserverInfo *)safe_willRemoveObserverInfo{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSafe_notNeedRemoveKeypathFromCrashArray:(BOOL)safe_notNeedRemoveKeypathFromCrashArray{
    objc_setAssociatedObject(self, @selector(safe_notNeedRemoveKeypathFromCrashArray), @(safe_notNeedRemoveKeypathFromCrashArray), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)safe_notNeedRemoveKeypathFromCrashArray{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

-(void)setSafe_lock:(LSRecursiveLock *)safe_lock{
    objc_setAssociatedObject(self, @selector(safe_lock), safe_lock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (LSRecursiveLock *)safe_lock{
    LSRecursiveLock *myLock = objc_getAssociatedObject(self, _cmd);
    return myLock;
}
@end

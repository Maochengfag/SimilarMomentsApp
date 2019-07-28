//
//  TableViewDataSource.m
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/2.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import "TableViewDataSource.h"
#import "ListViewCell.h"
#import "DataModel.h"

typedef BOOL(^RunloopBlock)(void);

@interface TableViewDataSource()
//存放任务的数组
@property (nonatomic,strong) NSMutableArray *tasks;
// 任务标记
@property (nonatomic,strong) NSMutableArray *tasksKeys;
//最大任务数
@property (nonatomic,assign) NSInteger max;

@end

@implementation TableViewDataSource

- (id)init{
    self = [super init];
    if (self) {
        _max = 10;
        self.tasksKeys = [NSMutableArray array];
        self.tasks = [NSMutableArray array];
        [self addRunLoopObserver];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell ==nil) {
        cell = [[ListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    DataModel *model = [_array objectAtIndex:indexPath.row];
    [cell fillCellWithModel:model];
    
    __weak typeof(self) weakSelf = self;
//    [self addTask:^BOOL{
//        DataModel *model = [weakSelf.array objectAtIndex:indexPath.row];
//        [cell fillCellWithModel:model];
//        return YES;
//    } withKey:cell];
   
    return cell;
}


- (void)addTask:(RunloopBlock)unit withKey:(id)key{
    [self.tasks addObject:unit];
    [self.tasksKeys addObject:key];
    if (self.tasks.count > self.max) {
        [self.tasks removeObjectAtIndex:0];
        [self.tasksKeys removeObjectAtIndex:0];
    }
}

static void Callback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void * info){
    
    TableViewDataSource *dataSource = (__bridge TableViewDataSource*)(info);
    if (dataSource.tasks.count ==0) {
        return;
    }
    
    BOOL result = NO;
    
    while (result == NO  && dataSource.tasks.count) {
        //取出任务
        RunloopBlock unit = dataSource.tasks.firstObject;
        //执行任务
        result = unit();
        //干掉第一个任务
        [dataSource.tasks removeObjectAtIndex:0];
        //干掉标识
        [dataSource.tasksKeys removeObjectAtIndex:0];
    }
}
- (void)addRunLoopObserver{
    //获取当前的runloop
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    //定义一个context
    CFRunLoopObserverContext context = {
        0,
        ( __bridge void*)(self),
        &CFRetain,
        &CFRelease,
        NULL
    };
    //定义一个观察者
    static CFRunLoopObserverRef defaultModeObserver;
    //创建观察者
    defaultModeObserver = CFRunLoopObserverCreate(NULL, kCFRunLoopBeforeWaiting, YES, NSIntegerMax - 99, &Callback, &context);
    //添加当前Runloop的观察者
    CFRunLoopAddObserver(runloop, defaultModeObserver, kCFRunLoopDefaultMode);
    //c语言 有creat 就需要release
    CFRelease(defaultModeObserver);
}

@end

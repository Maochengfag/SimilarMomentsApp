//
//  FirstViewController.m
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/1.
//  Copyright © 2019年 Mac. All rights reserved.
//



#import "FirstViewController.h"
#import "SourceTool.h"
#import "TableViewDelegate.h"
#import "TableViewDataSource.h"
#import "ThreadSafeMutableArray.h"
#include <objc/runtime.h>
#include <malloc/malloc.h>

@interface FirstViewController ()
{
    UITableView *tableView;
    TableViewDelegate *tableViewDelegate;
    TableViewDataSource *tableViewDataSource;
}
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"动态";
    [self testMutiblePicList];
//    [self getSize];
//    [self testThreadSafe];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPublishData:) name:KPUBLISHACTION object:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:KPUBLISHACTION object:nil];
}
- (void)testMutiblePicList{
    tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:tableView];
    tableViewDelegate = [[TableViewDelegate alloc] init];
    tableViewDataSource = [[TableViewDataSource alloc] init];
    tableView.delegate = tableViewDelegate;
    tableView.dataSource = tableViewDataSource;
    
    // Do any additional setup after loading the view, typically from a nib.
    //    __weak typeof(self) weakSelf = self;
    
    SourceTool *tool = [[SourceTool alloc] init];
    [tool listDataWithCall:^(NSArray *array) {
        NSLog(@"array===%i",array.count);
        self->tableViewDelegate.array = array;
        self->tableViewDataSource.array = array;
        [self->tableView reloadData];
    }];
}

- (void)testThreadSafe{
    ThreadSafeMutableArray *safeArray = [[ThreadSafeMutableArray alloc] init];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (NSInteger i = 0; i<10000; i++) {
        dispatch_async(queue, ^{
            NSString *str = [NSString stringWithFormat:@"array%d",(int)i+10];
            [safeArray addObject:str];
        });
    }
    
    sleep(1);
    
    NSLog(@"打印数组");
    [safeArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"obj==%@",obj);
    }];
}


- (void)getSize{
    
    NSObject *obj = [[NSObject alloc] init];
    NSLog(@"%zd",class_getInstanceSize([NSObject class]));
    
    NSLog(@"%zd", malloc_size((__bridge const void *)obj));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showPublishData:(NSNotification *)notifo{
    
    SourceTool *tool = [[SourceTool alloc] init];
    [tool publishDataWithDictionary:notifo.userInfo withList:tableViewDelegate.array addCallBack:^(NSArray *array) {
        self->tableViewDelegate.array = array;
        self->tableViewDataSource.array = array;
        [self->tableView reloadData];
    }];
}

@end

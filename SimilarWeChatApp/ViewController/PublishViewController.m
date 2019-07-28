//
//  PublishViewController.m
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/28.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import "PublishViewController.h"
#import "HDragItemListView.h"
#import "UIView+Ex.h"

#define kSingleLineHeight 36
#define kMaxLines 6

@interface PublishViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>


@property (nonatomic, strong) UITableView *tablView;
@property (nonatomic, strong) HDragItemListView *itemList;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSMutableArray *imageList;
@property (nonatomic, assign) CGFloat lastTextViewHeight;

@end

@implementation PublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发布";
    [self bulidLeftRightBarItem];
    [self bulidSubviews];
}

- (void)bulidLeftRightBarItem{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publish)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (void)bulidSubviews{
    
    _imageList = [NSMutableArray arrayWithCapacity:0];
    
    HDragItem  *item = [[HDragItem alloc] init];
    item.backgroundColor = [UIColor clearColor];
    item.image = [UIImage imageNamed:@"add_image"];
    item.isAdd = YES;
    
    //创建标签列表
    HDragItemListView *itemList = [[HDragItemListView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 0)];
    self.itemList = itemList;
    itemList.backgroundColor  = [UIColor clearColor];
    
    //高度可以设置为0 会自动根据标题计算
    //设置排序时 缩放比例
    
    itemList.scaleItemInSort = 1.3;
    itemList.isSort = YES;
    itemList.isFitItemListH = YES;
    [itemList addItem:item];
    
    __weak typeof (self) weakSelf = self;
    
    [itemList setClickItemBlock:^(HDragItem *item) {
        if (item.isAdd) {
            [weakSelf showUIImagePickerController];
        }
    }];
    
    /*
     * 移除tag 高度变化 得重设
     */
    
    itemList.deleteItemBlock = ^(HDragItem *item){
        HDragItem *lastItem = [weakSelf.itemList.itemArray lastObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!lastItem.isAdd) {
                HDragItem *item = [[HDragItem alloc] init];
                item.backgroundColor = [UIColor clearColor];
                item.image = [UIImage imageNamed:@"add_image"];
                item.isAdd = YES;
                [weakSelf.itemList addItem:item];
            }
        });
    };
    
    [self.view addSubview:itemList];
    
    _tablView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, KWidth, KHeight) style:UITableViewStylePlain];
    _tablView.delegate = self;
    _tablView.dataSource = self;
    _tablView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_tablView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidth, item.frame.size.height)];
    [headerView addSubview:itemList];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 10, KWidth, kSingleLineHeight)];
    _textView.font = [UIFont systemFontOfSize:16];
    _textView.text = @"    发表动态";
    [headerView addSubview:_textView];

    itemList.y = _textView.height +20;
    headerView.height = item.height + itemList.y;
    
    _tablView.tableHeaderView = headerView;
    _tablView.tableFooterView = [UIView new];

    [_tablView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewChange:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)publish{
    
    if (_imageList.count == 0)
        return;
    
    NSDictionary *publishDict = @{
                                  @"images":_imageList,
                                  @"text":self.textView.text
                                  };
    [[NSNotificationCenter defaultCenter] postNotificationName:KPUBLISHACTION object:nil userInfo:publishDict];
    
    sleep(1);
    
    [self dismiss];
    
}

#pragma  mark -- tableViewDelegate&&tableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"所在位置";
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"谁可以看";
    }else if (indexPath.row == 2){
        cell.textLabel.text = @"提醒谁看";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%@",cell.textLabel.text);
}

#pragma mark ---  textView

- (void)textViewChange:(NSNotificationCenter *)notifi{
    CGSize size = [_tablView sizeThatFits:CGSizeMake(KWidth, CGFLOAT_MAX)];
    CGFloat height = size.height;
    BOOL scrollEnabled = NO;
    
    if (height > kSingleLineHeight * kMaxLines) {
        height = kSingleLineHeight * kMaxLines;
        scrollEnabled = YES;
    }
    
    _textView.scrollEnabled = scrollEnabled;
    _textView.height = height;
    
    if (_lastTextViewHeight != height && _lastTextViewHeight > 0) {
        //换行
        [self updateHeaderViewHeight];
    }
    
}

- (void)updateHeaderViewHeight{
    self.itemList.y = _textView.height + 20;
    self.tablView.tableHeaderView.height = self.itemList.itemListH + self.itemList.y;
    [self.tablView beginUpdates];//加上这段代码 改header的时候 会有动画 不然会比较僵硬
    self.tablView.tableHeaderView = self.tablView.tableHeaderView;
    [self.tablView endUpdates];
}

#pragma mark - UIImagePickerController

- (void)showUIImagePickerController{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
                                                                        
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    [picker dismissViewControllerAnimated:YES completion:^{
        HDragItem *item = [[HDragItem alloc] init];
        item.image = image;
        [_imageList addObject:image];
        item.backgroundColor = [UIColor purpleColor];
        [self.itemList addItem:item];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateHeaderViewHeight];
        });
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  EditProfileViewController.m
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/14.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import "EditProfileViewController.h"
#import "SourceTool.h"
#import "EditInfoTVDelegate.h"
#import "EditInfoTVDataSource.h"
#import "PickPhotosViewController.h"

@interface EditProfileViewController (){
    EditInfoTVDelegate *deletate;
    EditInfoTVDataSource *dataSource;
}
@property (nonatomic, strong) UITableView *listVT;
@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"个人信息";
    deletate = [[EditInfoTVDelegate alloc] init];
    dataSource = [[EditInfoTVDataSource alloc] init];
    self.listVT = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.listVT setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.listVT.delegate = deletate;
    self.listVT.dataSource = dataSource;
    [self.view addSubview:self.listVT];
    
    SourceTool *tool = [[SourceTool alloc] init];
    [tool infoListWitchCall:^(NSArray *array) {
        self->deletate.array = array;
        self->dataSource.array = array;
        [self.listVT reloadData];
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //showPicker
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doPresentPicker) name:@"showPicker" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showPicker" object:nil];
}

- (void)doPresentPicker{
    
    PickPhotosViewController *picker = [[PickPhotosViewController alloc] init];
//    [self presentViewController:picker animated:YES completion:nil];
    [self.navigationController  pushViewController:picker animated:YES];
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

//
//  SecondViewController.m
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/1.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import "SecondViewController.h"
#import "UserModel.h"
#import "SqlOperation.h"
#import "SqlManager.h"
#import "LoginView.h"
#import "ProfileTVDelegate.h"
#import "ProfileTVDataSource.h"
#import "Masonry.h"
#import "SourceTool.h"
#import "ProfileTopView.h"
#import "LoginPageViewController.h"
#import "EditProfileViewController.h"

@interface SecondViewController ()<ProfileTopViewDelagate>
{
    UITableView *profileTV;
    ProfileTVDelegate *profileTVdelegate;
    ProfileTVDataSource *profileTVDataSource;
    ProfileTopView *topView;
}
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    topView = [[ProfileTopView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 60)];
    topView.delegate = self;
    
    profileTVdelegate = [[ProfileTVDelegate alloc] init];
    profileTVDataSource = [[ProfileTVDataSource alloc] init];
    profileTV = [[UITableView alloc] init];
    [profileTV setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:profileTV];
    profileTV.delegate = profileTVdelegate;
    profileTV.dataSource = profileTVDataSource;
    
    profileTV.tableHeaderView = topView;
    
    [profileTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.mas_equalTo(10);
        make.topMargin.mas_equalTo(20);
        make.rightMargin.mas_equalTo(0);
        make.bottomMargin.mas_equalTo(0);
    }];
    
    SourceTool *tool = [[SourceTool alloc]init];
    [tool profilListWithCall:^(NSArray *array) {
        self->profileTVdelegate.array = array;
        self->profileTVDataSource.dataArray = array;
        [self->profileTV reloadData];
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)skipToLoginVC:(login)login{
    
    SourceTool *tool = [[SourceTool alloc] init];
   NSString *userId = [NSString  stringWithFormat:@"%@",[tool doGetUserID]];
    if (userId.length >0 && ![userId isEqualToString:@"NULL"]) {
        EditProfileViewController *editProfileVC = [[EditProfileViewController alloc] init];
        editProfileVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:editProfileVC animated:YES];
    }else{
        LoginPageViewController *loginVC = [[LoginPageViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    }
}

@end

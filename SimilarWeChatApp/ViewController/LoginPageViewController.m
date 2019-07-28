//
//  LoginPageViewController.m
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/12.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import "LoginPageViewController.h"
#import "LoginView.h"
#import "Masonry.h"


@interface LoginPageViewController ()<LoginViewDelegate>
@property (nonatomic, strong)  LoginView *loginView;
@end

@implementation LoginPageViewController

@synthesize loginView = _loginView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self buildSubViews];
    self.title = @"登录";
   
    UIButton *disMissBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    disMissBtn.frame = CGRectMake(0, 0, 20, 20);
//    [disMissBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [disMissBtn setImage:[UIImage imageNamed:@"closed_small"] forState:UIControlStateNormal];
//    [self.view addSubview:disMissBtn];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:disMissBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    [disMissBtn addTarget:self action:@selector(doDismiss) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)buildSubViews{
    
   _loginView = [[LoginView alloc] init];
    _loginView.delegate = self;
    _loginView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_loginView];
//    _loginView.frame = self.view.frame;
    
    [_loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.mas_equalTo(0);
        make.topMargin.mas_equalTo(10);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(600);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doDismiss{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-  (void)loginAction{
    [self doDismiss];
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

//
//  RootTabBarVC.m
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/14.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import "RootTabBarVC.h"
#import "TestTabBar.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "PublishViewController.h"

@interface RootTabBarVC ()<AxcAE_TabBarDelegate>

@end

@implementation RootTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addChildViewControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addChildViewControllers{
    FirstViewController *firstVC = [[FirstViewController alloc] init];
    UIViewController *firstNavi = [[UINavigationController alloc] initWithRootViewController:firstVC];
    
    SecondViewController *secVC = [[SecondViewController alloc] init];
    UIViewController *secNavi = [[UINavigationController alloc] initWithRootViewController:secVC];
    
    NSArray <NSDictionary *> *vcArray = @[
    @{@"vc":firstNavi,@"normalImg":@"home_normal",@"selectImg":@"home_highlight",@"itemTitle":@"首页"},
        @{@"vc":[UIViewController new],@"normalImg":@"",@"selectImg":@"",@"itemTitle":@"发布"},
    @{@"vc":secNavi,@"normalImg":@"account_normal",@"selectImg":@"account_highlight",@"itemTitle":@"我的"}
                                          ];
    NSMutableArray *tabBarConfs = @[].mutableCopy;
    
    NSMutableArray *tabBarVC = @[].mutableCopy;
    
    [vcArray  enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        AxcAE_TabBarConfigModel  *model = [AxcAE_TabBarConfigModel new];
        model.itemTitle = [obj objectForKey:@"itemTitle"];
        model.selectImageName = [obj objectForKey:@"selectImg"];
        model.normalImageName = [obj objectForKey:@"normalImg"];
        model.selectColor = [UIColor blackColor];
        model.normalColor = [UIColor blackColor];
        
        if (idx ==1) {
            model.bulgeStyle = AxcAE_TabBarConfigBulgeStyleSquare;
            model.bulgeHeight = 30;
            model.itemLayoutStyle = AxcAE_TabBarItemLayoutStyleTopPictureBottomTitle;
            model.selectImageName = @"post_normal";
            model.normalImageName = @"post_normal";
            model.selectBackgroundColor = model.normalBackgroundColor = [UIColor clearColor];
            model.backgroundImageView.hidden = YES;
            model.componentMargin = UIEdgeInsetsMake(0, 0, 0, 0);
            model.icomImgViewSize = CGSizeMake(self.tabBar.frame.size.width / 5, 60);
            model.titleLabelSize = CGSizeMake(self.tabBar.frame.size.width / 5, 20);
            model.pictureWordsMargin = 0;
            model.titleLabel.font = [UIFont systemFontOfSize:11];
            model.itemSize = CGSizeMake(self.tabBar.frame.size.width / 5 - 5.0 ,self.tabBar.frame.size.height + 20);
        }else{
            // 来点效果好看
            model.interactionEffectStyle = AxcAE_TabBarInteractionEffectStyleSpring;
            // 点击背景稍微明显点吧
            model.selectBackgroundColor = AxcAE_TabBarRGBA(248, 248, 248, 1);
            model.normalBackgroundColor = [UIColor clearColor];
        }
        
        // 示例中为了方便就在这写了
        UIViewController *vc = [obj objectForKey:@"vc"];
        vc.view.backgroundColor = [UIColor whiteColor];
        // 5.将VC添加到系统控制组
        [tabBarVC addObject:vc];
        // 5.1添加构造Model到集合
        [tabBarConfs addObject:model];
    }];
    
    // 使用自定义的TabBar来帮助触发凸起按钮点击事件
    TestTabBar *testTabBar = [TestTabBar new];
    [self setValue:testTabBar forKey:@"tabBar"];
    
     self.viewControllers = tabBarVC;
    // 6.2 使用Set方式：
    self.axcTabBar = [AxcAE_TabBar new] ;
    self.axcTabBar.tabBarConfig = tabBarConfs;
    // 7.设置委托
    self.axcTabBar.delegate = self;
    self.axcTabBar.backgroundColor = [UIColor whiteColor];
    // 8.添加覆盖到上边
    [self.tabBar addSubview:self.axcTabBar];
    [self addLayoutTabBar]; // 10.添加适配
}


// 9.实现代理，如下：
static NSInteger lastIdx = 0;
- (void)axcAE_TabBar:(AxcAE_TabBar *)tabbar selectIndex:(NSInteger)index{
    if (index != 1) { // 不是中间的就切换
        // 通知 切换视图控制器
        [self setSelectedIndex:index];
        lastIdx = index;
    }else{ // 点击了中间的
        
        [self.axcTabBar setSelectIndex:lastIdx WithAnimation:NO]; // 换回上一个选中状态
        PublishViewController *publishVC = [[PublishViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:publishVC];
        [self presentViewController:navi animated:YES completion:nil];
    }
}
- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    [super setSelectedIndex:selectedIndex];
    if(self.axcTabBar){
        self.axcTabBar.selectIndex = selectedIndex;
    }
}

// 10.添加适配
- (void)addLayoutTabBar{
    // 使用重载viewDidLayoutSubviews实时计算坐标 （下边的 -viewDidLayoutSubviews 函数）
    // 能兼容转屏时的自动布局
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.axcTabBar.frame = self.tabBar.bounds;
    [self.axcTabBar viewDidLayoutItems];
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

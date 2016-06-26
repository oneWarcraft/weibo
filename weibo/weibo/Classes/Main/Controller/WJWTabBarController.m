//
//  WJWTabBarController.m
//  weibo
//
//  Created by Wang Wei on 16/6/18.
//  Copyright © 2016年 WangJiwei. All rights reserved.
//

#import "WJWTabBarController.h"
#import "WJWHomePageViewController.h"
#import "WJWMessageViewController.h"
#import "WJWNewViewController.h"
#import "WJWMeViewController.h"
#import "WJWDiscoverViewController.h"

#import "UIImage+Render.h"
#import "WJWTabBar.h"
#import "WJWNavigationController.h"

@interface WJWTabBarController ()

@end

@implementation WJWTabBarController

+ (void)load
{
    //获得全局的tabBarItem,设置统一风格  app所有？
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
//    UITabBarItem *tabBarItem = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[self]];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    //统一设置字体颜色  UIControlStateSelected
    dict[NSForegroundColorAttributeName] = [UIColor blackColor];
    [tabBarItem setTitleTextAttributes:dict forState:(UIControlStateSelected)];
    
    //统一设置字体大小  字体需要分开设置才有效 state不同  
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    [tabBarItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    
}


#pragma mark - 添加所有子控制器
- (void) setupAllTabBarChildrenController
{
    WJWHomePageViewController *homePageVC = [[WJWHomePageViewController alloc] init];
    //initWithRootViewController 相当于Push，把nav的根控制器push入栈
    WJWNavigationController *navEssen = [[WJWNavigationController alloc] initWithRootViewController:homePageVC];
    [self addChildViewController:navEssen];
    
    WJWMessageViewController *latestPostVC = [[WJWMessageViewController alloc] init];
    WJWNavigationController *LatestNaviVC = [[WJWNavigationController alloc]initWithRootViewController:latestPostVC];
    [self addChildViewController:LatestNaviVC];
    
//    WJWNewViewController *publishVC = [[WJWNewViewController alloc] init];
//    [self addChildViewController:publishVC];
    
    WJWDiscoverViewController *frienTrendVC = [[WJWDiscoverViewController alloc] init];
    WJWNavigationController *frienTrendNaviVC = [[WJWNavigationController alloc]initWithRootViewController:frienTrendVC];
    [self addChildViewController:frienTrendNaviVC];
    
    WJWMeViewController *aboutMeVC = [[WJWMeViewController alloc] init];
    WJWNavigationController *aboutMeNaviVC = [[WJWNavigationController alloc]initWithRootViewController:aboutMeVC];
    [self addChildViewController:aboutMeNaviVC];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //1. 搭建框架: 设置tabBarController的各个子控制器，及其各自根控制器  navi-viewCon
    [self setupAllTabBarChildrenController];
    
    //2. 设置tabBar上各个按钮内容 ->由对应子控制器的tabBarItem决定
    [self setupAllTabBarItemButton];

    [self createNewBTNAndLayout];
}

- (void) createNewBTNAndLayout
{
    WJWTabBar *tabBar = [[WJWTabBar alloc] init];

    //替换系统的tabBar  系统的是readOnly,用KVC修改。
    [self setValue:tabBar forKey:@"tabBar"];
}

#pragma mark - 设置所有标题按钮内容
- (void) setupAllTabBarItemButton
{
    
//    WJWLog(@"%@", self.childViewControllers);
    
    // 1. 首页
    UINavigationController *navEss = self.childViewControllers[0];
    //标题
    navEss.tabBarItem.title = @"首页";
    //默认图片
    navEss.tabBarItem.image = [UIImage imageNamed:@"tabbar_home"];
    //选中时显示图片
    navEss.tabBarItem.selectedImage = [UIImage imageNameWithOriginal:@"tabbar_home_selected"];
 
//     UIBarButtonItem *nightItem = [UIBarButtonItem itemWithSelectedImage:[UIImage imageNamed:@"mine-moon-icon"] selectedImage:[UIImage imageNamed:@"mine-moon-icon-click"] target:self action:@selector(night:)];
    
    // 2. 新帖按钮
    UINavigationController *navNewP = self.childViewControllers[1];
    //标题
    navNewP.tabBarItem.title = @"消息";
    //默认图片
    navNewP.tabBarItem.image = [UIImage imageNamed:@"tabbar_message_center"];
    //选中时显示图片
    navNewP.tabBarItem.selectedImage = [UIImage imageNameWithOriginal:@"tabbar_message_center_selected"];
    
    //    // 3. 发布按钮
    //    WJWPublishViewController *pubNav = self.childViewControllers[2];
    //    //标题
    //    pubNav.tabBarItem.title = @"新帖";
    //    //默认图片
    //    pubNav.tabBarItem.image = [UIImage imageNamed:@"tabBar_publish_icon.png"];
    //    //选中时显示图片
    //    pubNav.tabBarItem.selectedImage = [UIImage imageNameWithOriginal:@"tabBar_publish_click_icon.png"];
    
    
    // 4. 发现
    UINavigationController *focusNav = self.childViewControllers[2];
    //标题
    focusNav.tabBarItem.title = @"发现";
    //默认图片
    focusNav.tabBarItem.image = [UIImage imageNamed:@"tabbar_discover"];
    //选中时显示图片
    focusNav.tabBarItem.selectedImage = [UIImage imageNameWithOriginal:@"tabbar_discover_selected"];
    
    
    // 5. 我 按钮
    UINavigationController *myNav = self.childViewControllers[3];
    //标题
    myNav.tabBarItem.title = @"我";
    //默认图片
    myNav.tabBarItem.image = [UIImage imageNamed:@"tabbar_profile"];
    //选中时显示图片
    myNav.tabBarItem.selectedImage = [UIImage imageNameWithOriginal:@"tabbar_profile_selected"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

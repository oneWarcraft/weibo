//
//  WJWNavigationController.m
//  weibo
//
//  Created by Wang Wei on 16/6/20.
//  Copyright © 2016年 WangJiwei. All rights reserved.
//

#import "WJWNavigationController.h"


@interface WJWNavigationController ()<UIGestureRecognizerDelegate>


@end

@implementation WJWNavigationController

+ (void)load
{
    //    // 设置导航条背景图片
    //    [navBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    //
    UINavigationBar *naviBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
    
    NSMutableDictionary *attriDic = [NSMutableDictionary dictionary];
    
    attriDic[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    
    naviBar.titleTextAttributes = attriDic;
    
    [naviBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:(UIBarMetricsDefault)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 滑动功能
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    [self.view addGestureRecognizer:pan];
    
    // 控制器手势什么时候触发
    pan.delegate = self;
    //    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    //
    //    pan.delegate = self;
    
    self.interactivePopGestureRecognizer.enabled = NO;
    
    //    self.interactivePopGestureRecognizer.delegate = self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return (self.childViewControllers.count > 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    WJWLog(@"pushViewController");
    
    if (self.childViewControllers.count>0) {
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [btn setImage:[UIImage imageNamed:@"navigationButtonReturn.png"] forState:(UIControlStateNormal)];
        [btn setImage:[UIImage imageNamed:@"navigationButtonReturnClick.png"] forState:(UIControlStateHighlighted)];
        [btn setTitle:@"返回" forState:(UIControlStateNormal)];
        [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [btn setTitleColor:[UIColor redColor] forState:(UIControlStateHighlighted)];
        
        [btn sizeToFit];
        
        [btn setContentEdgeInsets:UIEdgeInsetsMake(0, -25, 0, 0)];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
        [btn addTarget:self action:@selector(backToFrontVC) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void) backToFrontVC
{
    [self popViewControllerAnimated:YES];
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

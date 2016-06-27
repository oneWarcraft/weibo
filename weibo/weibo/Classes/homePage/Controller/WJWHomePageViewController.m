//
//  WJWHomePageViewController.m
//  weibo
//
//  Created by Wang Wei on 16/6/20.
//  Copyright © 2016年 WangJiwei. All rights reserved.
//

#import "WJWHomePageViewController.h"
#import "UIBarButtonItem+Item.h"
#import "WJWTitleViewListVC.h"
#import "WJWPresentVC.h"
#import "WJWanimationModel.h"
#import "UIImage+Image.h"
#import <AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "WJWAccount.h"
#import "WJWAuthoController.h"
#import "WJWAccountTool.h"

@interface WJWHomePageViewController () <UIViewControllerTransitioningDelegate>

@end

@implementation WJWHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    
    //设置本导航控制器上的内容  左中右按钮
    [self setNavBarItem];
    
    
    [self loadNewData];
    
}

- (void)loadNewData
{
    WJWAccount *Caccount  = [WJWAccountTool shareAccountTool].currentAccount;
    
    NSString *token = Caccount.access_token;
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *urlstr = [NSString stringWithFormat:@"https://api.weibo.com/2/statuses/home_timeline.json?access_token=%@",token];
    
    
    
    NSDictionary *dict = @{
                           @"count":@(80),
                           @"max_id":@(0)
                           };
    
    
    [manager GET:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@", responseObject);
        
        //解析JSON对象
        NSArray *array = responseObject[@"statuses"];
        
        
//        NSArray *tempArray = [WJWHomePageMainItem mj_objectArrayWithKeyValuesArray:array];
        
        NSLog(@"数据:%@",responseObject);
        NSLog(@"+++++++++++++++++++++++");
//        [self.tableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error===%@",error);
    }];
}

- (void) setNavBarItem
{
    //设置导航条左边按钮
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"navigationbar_friendsearch"] highImage:[UIImage imageNamed:@"navigationbar_friendsearch_highlighted"] target:self action:@selector(leftNavClick)];

    //添加左边按钮
    UIButton *btn =  [[UIButton alloc] init];
    //正常状态
    [btn setImage:[UIImage imageNamed:@"navigationbar_friendsearch"] forState:UIControlStateNormal];
    //高亮状态
    [btn setImage:[UIImage imageNamed:@"navigationbar_friendsearch_highlighted"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(leftNavClick) forControlEvents:UIControlEventTouchUpInside];
    //导航条上面的View是需要尺寸大小.
    //让按钮自适应大小.
    [btn sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    
    //设置首页导航条中间按钮
    UIButton *btnM=  [UIButton buttonWithType:UIButtonTypeCustom];
    [btnM setTitle:@"Henry" forState:(UIControlStateNormal)];
    [btnM setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    btnM.bounds = CGRectMake(0, 0, 150, 30);
    self.navigationItem.titleView = btnM;
    [btnM sizeToFit];
    [btnM addTarget:self action:@selector(middleNavClick) forControlEvents:UIControlEventTouchUpInside];
    [btnM setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1.0]] forState:(UIControlStateHighlighted)];
    
    
    //添加右边按钮
    UIButton *btnR =  [[UIButton alloc] init];
    //正常状态
    [btnR setImage:[UIImage imageNamed:@"navigationbar_icon_radar"] forState:UIControlStateNormal];
    //高亮状态
    [btnR setImage:[UIImage imageNamed:@"navigationbar_icon_radar_highlighted"] forState:UIControlStateHighlighted];
    [btnR addTarget:self action:@selector(rightNavClick) forControlEvents:UIControlEventTouchUpInside];
    //导航条上面的View是需要尺寸大小.
    //让按钮自适应大小.
    [btnR sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnR];
    
    
    
//    //设置导航条中间按钮
//    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
//    
//    //设置导航条右边按钮 navigationbar_icon_radar
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"navigationbar_icon_radar"]highImage:[UIImage imageNamed:@"navigationbar_icon_radar_highlighted"] target:self action:@selector(rightNavClick)];
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

#pragma mark -- 导航条点击事件 左中右
- (void) leftNavClick
{
    WJWLog(@"左键");
}

#pragma mark -- 导航条中间/右侧转场动画
//点击导航条右侧按钮 转场动画 开始
- (void)rightNavClick{
    //    WJWRightMenuShowVC *showVc = [[WJWRightMenuShowVC alloc]init];
    //    showVc.transitioningDelegate = self;
    //    showVc.modalPresentationStyle = UIModalPresentationCustom;
    //    [self presentViewController:showVc animated:YES completion:nil];
    NSLog(@"右键");
//    [self.tableView reloadData];
    // //        [self.navigationController popViewControllerAnimated:YES];
}
//导航条右边 转场动画 结束

//点击导航条 中间title按钮 弹出列表 转场动画  开始
- (void)middleNavClick{
    WJWTitleViewListVC *showVc = [[WJWTitleViewListVC alloc]init];
    showVc.transitioningDelegate = self;
    showVc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:showVc animated:YES completion:nil];
    
    //    [self.navigationController popViewControllerAnimated:YES];
}

- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    
    return  [[WJWPresentVC alloc]initWithPresentedViewController:presented presentingViewController:presenting];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    
    WJWanimationModel *showDelegate = [[WJWanimationModel alloc]init];
    showDelegate.presented = YES;
    
    return showDelegate;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    WJWanimationModel *showDelegate = [[WJWanimationModel alloc]init];
    showDelegate.presented = NO;
    
    return showDelegate;
    
}
//导航条中间View转场动画 结束



@end

//
//  WJWHomePageViewController.m
//  weibo
//
//  Created by Wang Wei on 16/6/20.
//  Copyright © 2016年 WangJiwei. All rights reserved.
//

#import "WJWHomePageViewController.h"
#import "UIBarButtonItem+Item.h"

@interface WJWHomePageViewController ()

@end

@implementation WJWHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    [self setNavBarItem];
}

- (void) setNavBarItem
{
    //设置导航条左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"nav_item_game_icon"] highImage:[UIImage imageNamed:@"nav_item_game_click_icon"] target:self action:@selector(leftNavClick)];
    
    //设置导航条中间按钮
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    //设置导航条右边按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"navigationButtonRandom"] highImage:[UIImage imageNamed:@"navigationButtonRandomClick"] target:self action:@selector(rightNavClick)];
}

- (void) leftNavClick
{
    WJWLog(@"左键");
}

//- (void) mainTitleClicked
//{
//    WJWLog(@"中间键");
//}

- (void) rightNavClick
{
    WJWLog(@"右键");
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

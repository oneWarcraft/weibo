//
//  WJWMessageViewController.m
//  weibo
//
//  Created by Wang Wei on 16/6/20.
//  Copyright © 2016年 WangJiwei. All rights reserved.
//

#import "WJWMessageViewController.h"
#import "UIBarButtonItem+Item.h"

@interface WJWMessageViewController ()

@end

@implementation WJWMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yellowColor];
    
    [self setNavBarItem];
}

- (void) setNavBarItem
{
    //设置导航条中间按钮名字
    self.navigationItem.title = @"消息";
    
    //设置导航条左边按钮
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"发现群" style:UIBarButtonItemStylePlain target:self action:@selector(leftNavClick)];
    [leftItem setTintColor:[UIColor blackColor]];
    self.navigationItem.leftBarButtonItem = leftItem;
 
    //  设置右边的item
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navigationbar_icon_newchat"] style:UIBarButtonItemStylePlain target:self action:@selector(rightNavClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"MainTagSubIcon"] highImage:[UIImage imageNamed:@"MainTagSubIconClick"] target:self action:@selector(leftNavClick)];
//    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
}

- (void) leftNavClick
{
    WJWLog(@"左键");
}

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

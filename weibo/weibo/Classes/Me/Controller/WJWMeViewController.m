//
//  WJWMeViewController.m
//  weibo
//
//  Created by Wang Wei on 16/6/20.
//  Copyright © 2016年 WangJiwei. All rights reserved.
//

#import "WJWMeViewController.h"
#import "WJWSettingTableViewController.h"
#import "UIBarButtonItem+Item.h"

@interface WJWMeViewController ()

@end

@implementation WJWMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor purpleColor];
    [self setNavBarItem];
}

- (void) setNavBarItem
{
    //设置导航条左边按钮
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine-setting-icon"] highImage:[UIImage imageNamed:@"mine-setting-icon-click"] target:self action:@selector(setting)];
    
    UIBarButtonItem *nightItem = [UIBarButtonItem itemWithSelectedImage:[UIImage imageNamed:@"mine-moon-icon"] selectedImage:[UIImage imageNamed:@"mine-moon-icon-click"] target:self action:@selector(night:)];
    
    self.navigationItem.rightBarButtonItems = @[settingItem, nightItem];
    
    self.navigationItem.title = @"我的";
}


- (void)night:(UIButton *)button
{
    button.selected = !button.selected;
}

- (void)setting
{
    WJWSettingTableViewController *settingTVC = [[WJWSettingTableViewController alloc] init];
    
    settingTVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:settingTVC animated:YES];
    
    
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

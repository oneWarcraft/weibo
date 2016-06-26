//
//  WJWTitleViewListVC.m
//  sinaWeibo
//
//  Created by Wang Wei on 16/6/14.
//  Copyright © 2016年 林浩翔. All rights reserved.
//

#import "WJWTitleViewListVC.h"

@interface WJWTitleViewListVC () <UITableViewDataSource, UITableViewDelegate>


/**
 *  保存List分组内容 除去开头和结尾两部分
 */
@property (nonatomic, strong) NSMutableArray *titleListArray;
@property (weak, nonatomic) IBOutlet UITableView *tableViewControl;
@property (weak, nonatomic) IBOutlet UIButton *editMyGroup_BTN;
@property (strong,nonatomic)NSString *choosedItem;
@end

@implementation WJWTitleViewListVC

- (NSMutableArray *)titleListArray
{
    if (!_titleListArray) { //@"首页",@"好友圈",@"群微博",@"分割线",@"特别关注"---------@"其它--分割线",@"周边微博" [编辑我的分组]
                            //@[@"",@"分组1",@"分组2",@"分组3",@"分组4",@"",@"上海",@"深圳"]];
        _titleListArray = [NSMutableArray array];
        
        [_titleListArray addObjectsFromArray:@[@"首页",@"好友圈",@"群微博",@"分割线",@"特别关注",@"吃货组",@"旅游组",@"好玩的微博",@"iOS开发组",@"上海",@"深圳"]];
    }
    return _titleListArray;
}
static NSString *ID = @"listGroupID";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableViewControl.backgroundColor = [UIColor clearColor];
    [self.tableViewControl registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    [self.tableViewControl setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
    
//    self.tableViewControl.scrollEnabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//状态栏设为白色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
};

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleListArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];

    cell.textLabel.textColor = [UIColor colorWithRed:1/255.0 green:145/255.0 blue:146/255.0 alpha:1];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = self.choosedItem;
    }else{
        cell.textLabel.text = self.titleListArray[indexPath.row];
    }
    
    return cell;
}

#pragma mark - tableView代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *tempStr = self.titleListArray[indexPath.row];
    
    NSLog(@"%@", tempStr);

    [self dismissViewControllerAnimated:YES completion:nil];

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

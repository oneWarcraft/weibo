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
#import "WJWHomePageItem.h"

//#define MAS_SHORTHAND
//#define MAS_SHORTHAND_GLOBALS
//#import <Masonry.h>
//pod 'Masonry'

@interface WJWHomePageViewController () <UIViewControllerTransitioningDelegate>

/** 保存首页微博全部模型数据 */
@property (nonatomic, strong) NSMutableArray *hpWeiboArray;
/** 上拉刷新条的属性 */
//@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) UILabel *footView;
/** 用来加载下一页数据的参数 */
@property (nonatomic, assign) NSInteger page;

/** 是否正在加载更多数据... */
@property (nonatomic, assign, getter=isFooterRefreshing) BOOL footerRefreshing;

@end

@implementation WJWHomePageViewController

NSString *ID = @"hpCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor redColor];
    //设置要展示的TableView的内边距，刚好全部展示，其它地方用内边距填充，扩大展示范围
//    self.tableView.contentInset = UIEdgeInsetsMake(WJWNavBarMaxY, 0, WJWTabBarH, 0);
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -WJWTabBarH, 0);
    //tableView内边距调整了，它对应的滚动条也需要调整
//    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    
    //设置本导航控制器上的内容  左中右按钮
    [self setNavBarItem];
    
    //第一次启动App时，首页默认加第一批数据
    [self loadNewTopics];
    
    self.page = 1;
    //建立底部刷新提示条，上拉后变色变字，获取新一批数据
    [self setupRefresh];
}


//UIView *gfooterView = nil;
//- (UIView*)footerLoadingBar
//{
//    if (gfooterView == nil)
//    {
//        //创建View条
//        UIView *footerView = [[UIView alloc] init];
//        footerView.backgroundColor = [UIColor redColor];
//        //创建旋转进度演示图片
//        UIActivityIndicatorView *activIndiView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
//        [activIndiView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
//        //    [self.bb setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
//        //    [self.bb setBackgroundColor:[UIColor lightGrayColor]];
//        [footerView addSubview:activIndiView];
//        footerView.wjw_height = WJWTabBarH;
//        [activIndiView startAnimating];
//        
//        //创建问题图片
//        UILabel *textLable = [[UILabel alloc] init];
//        textLable.textAlignment = NSTextAlignmentCenter;
//        textLable.text = @"上拉加载更多数据";
//        textLable.wjw_height = WJWTabBarH;
//        [footerView addSubview:textLable];
//        
//        CGFloat centerX = footerView.center.x;
//        CGFloat centerY = footerView.center.y;
//        
//        activIndiView.frame = CGRectMake(centerX-40, centerY - 20, 40, 40);
//        [textLable makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(activIndiView.right);
//            make.centerY.equalTo(activIndiView.centerY);
//        }];
//    }
//    
////    return footerView;
//    return gfooterView;
//    
////    [activIndiView makeConstraints:^(MASConstraintMaker *make) {
////        make.left
////    }]
////    
////    [blueView makeConstraints:^(MASConstraintMaker *make) {
////        make.left.equalTo(self.view.left).offset(30);
////        make.bottom.equalTo(self.view.bottom).offset(-30);
////        make.right.equalTo(redView.left).offset(-30);
////        make.width.equalTo(redView.width);
////        //        make.height.equalTo(50);
////    }];
//    
////    self.tableView.tableFooterView = footerView;
//
//}

- (void)setupRefresh
{
    UILabel *footView = [[UILabel alloc] init];
//    footView.backgroundColor = [UIColor redColor];
    footView.textAlignment = NSTextAlignmentCenter;
    footView.text = @"上拉加载更多数据";
    footView.wjw_height = WJWTabBarH;

    
//    UIView *footView = [self footerLoadingBar ];
    
    self.tableView.tableFooterView = footView;
    self.footView = footView;
}

#pragma mark -- 获取网络数据
/** 加载最新微博 */
- (void)loadNewTopics
{
    WJWAccount *Caccount  = [WJWAccountTool shareAccountTool].currentAccount;
    
    NSString *token = Caccount.access_token;
    
    self.page = 1;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *urlstr = [NSString stringWithFormat:@"https://api.weibo.com/2/statuses/home_timeline.json?access_token=%@",token];
    
    NSLog(@"%@", urlstr);
    
    NSDictionary *dict = @{
                           @"count":@(50),
                           @"max_id":@(0),
                           @"page":@(self.page)
                           };
    
    
    [manager GET:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
        
        NSLog(@"%@", responseObject);
        
        //解析JSON对象
        NSArray *array = responseObject[@"statuses"];

        self.hpWeiboArray = [WJWHomePageItem mj_objectArrayWithKeyValuesArray:array];
        
        [self.tableView reloadData];
        
//        NSLog(@"数据:%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error===%@",error);
    }];
}

/** 加载更多微博 */
- (void)loadMoreTopics
{
    WJWAccount *Caccount  = [WJWAccountTool shareAccountTool].currentAccount;
    
    NSString *token = Caccount.access_token;
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *urlstr = [NSString stringWithFormat:@"https://api.weibo.com/2/statuses/home_timeline.json?access_token=%@",token];
    
    NSLog(@"%@", urlstr);
    
    NSDictionary *dict = @{
                           @"count":@(50),
                           @"max_id":@(0),
                           @"page":@(self.page)
                           };
    
    
    [manager GET:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
        
        NSLog(@"%@", responseObject);
        
        //解析JSON对象
        self.page++;
        NSArray *moreTopics = [WJWHomePageItem mj_objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        
        [self.hpWeiboArray addObjectsFromArray:moreTopics];
        // 结束刷新(恢复刷新控件的状态)
        self.footerRefreshing = NO;
        
        [self.tableView reloadData];
        //重新复制footerView试试
        
        
        // 结束刷新(恢复刷新控件的状态)
        self.footerRefreshing = NO;
        self.footView.text = @"上拉加载更多数据";
        self.footView.backgroundColor = [UIColor redColor];

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error===%@",error);
    }];
}

#pragma mark -- 代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //如果还没有数据，不需要处理FooterView
    if (self.hpWeiboArray.count == 0) return;
    //如果正在上拉刷新（加载更多数据）,直接返回
    if (self.isFooterRefreshing) return;
    
    //当偏移量超过 >= offsetY时，footerView就会完全出现，进入上拉加载数据状态
    CGFloat offsetY = self.tableView.contentSize.height + self.tableView.contentInset.bottom - self.tableView.wjw_height;
    
    if (self.tableView.contentOffset.y >= offsetY) {
        //进入刷新状态
        self.footerRefreshing = YES;
        self.footView.text = @"正在加载更多数据......";
        self.footView.backgroundColor = [UIColor blueColor];
        
        //发送请求给服务器，加载更多数据
        [self loadMoreTopics];
    }
}



#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //如果数据不满一个页面时，上拉条如何显示？
    self.footView.hidden = (self.hpWeiboArray.count == 0);
    
    return self.hpWeiboArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
//    }
    WJWHomePageItem *item = self.hpWeiboArray[indexPath.item];
    cell.textLabel.text = item.user[@"name"];
    cell.detailTextLabel.text = item.text;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}



#pragma mark -- 设置本页面导航栏内容
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

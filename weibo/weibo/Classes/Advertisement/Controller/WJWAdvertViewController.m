//
//  WJWAdvertViewController.m
//  baiSiBuDeJie
//
//  Created by Wang Wei on 16/6/19.
//  Copyright © 2016年 WangJiwei. All rights reserved.
//

#import "WJWAdvertViewController.h"
#import "WJWTabBarController.h"
#import <AFNetworking.h>
#import "WJWADItem.h"
#import <UIImageView+WebCache.h>
#import <MJExtension/MJExtension.h>


#define iphone6P (WJWScreenH == 736)
#define iphone6 (WJWScreenH == 667)
#define iphone5 (WJWScreenH == 568)
#define iphone4 (WJWScreenH == 480)
#define WJWScreenH [UIScreen mainScreen].bounds.size.height
#define WJWScreenW [UIScreen mainScreen].bounds.size.width

@interface WJWAdvertViewController ()
/**
 *  点击此按钮 跳过启动广告页面
 */
@property (weak, nonatomic) IBOutlet UIButton *countDown_BTN;
/**
 *  放置weibo启动图片的控件
 */
@property (weak, nonatomic) IBOutlet UIImageView *launchImage_ImageView;

//设置成透明，放置点击跳过按钮
@property (weak, nonatomic) IBOutlet UIView *adView;

//放置广告页面，广告图片网络获取
@property (weak, nonatomic) UIImageView *adverImageView;

/**
 *  倒计时定时器
 */
@property (weak, nonatomic) NSTimer *timer;
/**
 *  保存界面启动时收到的广告页面模型数据
 */
@property (nonatomic, strong) WJWADItem *adItem;
@end

@implementation WJWAdvertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //设置启动画面
    [self setupLaughImage];
    //加载网络数据--广告页面
    [self loadData];
    //启动倒计时定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChanged) userInfo:nil repeats:YES];
}

- (UIImageView *)adverImageView
{
    if (_adverImageView == nil)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        _adverImageView = imageView;
        [self.adView addSubview:imageView];
        
        //给广告页面添加手势，在用户点击广告后，跳转到广告详情页面
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapJumptoDetailAdverPage)];
        [imageView addGestureRecognizer:tap];
    }
    return _adverImageView;
}

//点击启动广告，跳转到广告详情网页
- (void) tapJumptoDetailAdverPage
{
    UIApplication *app = [UIApplication sharedApplication];
    
    if ([app canOpenURL:[NSURL URLWithString:self.adItem.ori_curl]]) {
        [app openURL:[NSURL URLWithString:self.adItem.ori_curl]];
    }else
    {
        WJWLog(@"error!: %@", self.adItem.ori_curl);
    }
}

- (void) timeChanged
{
    static NSInteger i = 3;
    
    NSString *str = [NSString stringWithFormat:@"跳过(%zd)", i];
    [self.countDown_BTN setTitle:str forState:(UIControlStateNormal)];
    
    if (i<=0) {
        [self countDownBTNClick];
    }
    
    i--;
}

- (void) setupLaughImage
{
    UIImage *image = nil;

    if (iphone6P) {
        image = [UIImage imageNamed:@"LaunchImage-800-Portrait"];
    }else if (iphone6)
    {
        image = [UIImage imageNamed:@"LaunchImage-800"];
    }else if (iphone5)
    {
        image = [UIImage imageNamed:@"LaunchImage-700"];
    }else if (iphone4)
    {
        image = [UIImage imageNamed:@"LaunchImage"];
    }
    else
    {//需要弄个默认的图片#####
        image = [UIImage imageNamed:@"LaunchImage"];
    }

    self.launchImage_ImageView.image = image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)countDownBTNClick
{
    NSLog(@"countDownBTNClick");
    [UIApplication sharedApplication].keyWindow.rootViewController = [[WJWTabBarController alloc] init];
    
    [self.timer invalidate];
}

/**
 *  加载网络数据 -- 启动画面的广告图片，由于没有微博的广告图片接口，就用百思不得姐的广告了
 */
- (void) loadData
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    mDict[@"code2"] = @"phcqnauGuHYkFMRquANhmgN_IauBThfqmgKsUARhIWdGULPxnz3vndtkQW08nau_I1Y1P1Rhmhwz5Hb8nBuL5HDknWRhTA_qmvqVQhGGUhI_py4MQhF1TvChmgKY5H6hmyPW5RFRHzuET1dGULnhuAN85HchUy7s5HDhIywGujY3P1n3mWb1PvDLnvF-Pyf4mHR4nyRvmWPBmhwBPjcLPyfsPHT3uWm4FMPLpHYkFh7sTA-b5yRzPj6sPvRdFhPdTWYsFMKzuykEmyfqnauGuAu95Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiu9mLfqHbD_H70hTv6qnHn1PauVmynqnjclnj0lnj0lnj0lnj0lnj0hThYqniuVujYkFhkC5HRvnB3dFh7spyfqnW0srj64nBu9TjYsFMub5HDhTZFEujdzTLK_mgPCFMP85Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiuBnHfdnjD4rjnvPWYkFh7sTZu-TWY1QW68nBuWUHYdnHchIAYqPHDzFhqsmyPGIZbqniuYThuYTjd1uAVxnz3vnzu9IjYzFh6qP1RsFMws5y-fpAq8uHT_nBuYmycqnau1IjYkPjRsnHb3n1mvnHDkQWD4niuVmybqniu1uy3qwD-HQDFKHakHHNn_HR7fQ7uDQ7PcHzkHiR3_RYqNQD7jfzkPiRn_wdKHQDP5HikPfRb_fNc_NbwPQDdRHzkDiNchTvwW5HnvPj0zQWndnHRvnBsdPWb4ri3kPW0kPHmhmLnqPH6LP1ndm1-WPyDvnHKBrAw9nju9PHIhmH9WmH6zrjRhTv7_5iu85HDhTvd15HDhTLTqP1RsFh4ETjYYPW0sPzuVuyYqn1mYnjc8nWbvrjTdQjRvrHb4QWDvnjDdPBuk5yRzPj6sPvRdgvPsTBu_my4bTvP9TARqnam";
    
    [manager GET:@"http://mobads.baidu.com/cpro/ui/mads.php" parameters:mDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        WJWLog(@"%@", responseObject);
        
        NSDictionary *adDict = [responseObject[@"ad"] firstObject];
        
        WJWADItem *item = [WJWADItem mj_objectWithKeyValues:adDict];
        self.adItem = item;
        
        if (item.w == 0) {
            return;
        }
        
        CGFloat w = WJWScreenW;
        CGFloat h = WJWScreenW/item.w * item.h;
        
        self.adverImageView.frame = CGRectMake(0, 0, w, h);
        
        //加载广告
        [self.adverImageView sd_setImageWithURL:[NSURL URLWithString:item.w_picurl]];
        
        //        [responseObject writeToFile:@"/Users/wangjiwei/Desktop/wjw.plist" atomically:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WJWLog(@"%@", error);
    }];
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

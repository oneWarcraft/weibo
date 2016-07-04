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
#import <MJRefresh/MJRefresh.h>
#import "WJWHomePageCellCell.h"
#import "TFHpple.h"

//#define MAS_SHORTHAND
//#define MAS_SHORTHAND_GLOBALS
//#import <Masonry.h>
//pod 'Masonry'

@interface WJWHomePageViewController () <UIViewControllerTransitioningDelegate> //, NSXMLParserDelegate

/** 保存首页微博全部模型数据 */
@property (nonatomic, strong) NSMutableArray <WJWHomePageItem*> *hpWeiboArray;
/** 用来加载下一页数据的参数 */
@property (nonatomic, assign) NSInteger page;


/**
 *  cell遮罩部分的处理
 */
@property (nonatomic, strong) UIView *converView;
@property (nonatomic, strong) UIButton *storeBTN;
@property (nonatomic, strong) UIButton *helpHeadlineBTN;
@property (nonatomic, strong) UIButton *cancleAttentionBTN;
@property (nonatomic, strong) UIButton *shieldBTN;
@property (nonatomic, strong) UIButton *reportBTN;

@property (nonatomic, strong) UILabel *hudLabel;


/** 数据源*/
@property (nonatomic ,strong) NSMutableArray *videos;
@end

@implementation WJWHomePageViewController

-(NSMutableArray *)videos
{
    if (_videos == nil) {
        _videos = [NSMutableArray array];
    }
    return _videos;
}

NSString *ID = @"hompageCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor redColor];
    //设置要展示的TableView的内边距，刚好全部展示，其它地方用内边距填充，扩大展示范围
//    self.tableView.contentInset = UIEdgeInsetsMake(WJWNavBarMaxY, 0, WJWTabBarH, 0);
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -WJWTabBarH, 0);
    //tableView内边距调整了，它对应的滚动条也需要调整
//    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    //添加下拉刷新功能
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    // 添加上拉刷新功能
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];

//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    [self.tableView registerNib:[UINib nibWithNibName:@"WJWHomePageCellCell" bundle:nil] forCellReuseIdentifier:ID];
    
    //设置本导航控制器上的内容  左中右按钮
    [self setNavBarItem];
    
//    //第一次启动App时，首页默认加第一批数据
//    [self loadNewTopics];
    
//    self.tableView.rowHeight = 230;
    
    self.page = 1;
}

- (void)loadNewTopicsHTML
{
    /* Configure session, choose between:
     * defaultSessionConfiguration
     * ephemeralSessionConfiguration
     * backgroundSessionConfigurationWithIdentifier:
     And set session-wide properties, such as: HTTPAdditionalHeaders,
     HTTPCookieAcceptPolicy, requestCachePolicy or timeoutIntervalForRequest.
     */
    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    /* Create session, and optionally set a NSURLSessionDelegate. */
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
    
    /* Create the Request:
     My API (GET http://www.miaopai.com/show/aN5jDN72Ozy446jsbdoAgw__.htm)
     */
    
    NSURL* URL = [NSURL URLWithString:@"http://www.miaopai.com/show/aN5jDN72Ozy446jsbdoAgw__.htm"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"GET";
    
    // Headers
    
    [request addValue:@"U_TRS1=000000c4.2314f10.57765ae1.efc5ac50; U_TRS2=000000c4.2404f10.57765ae1.70a4ec99; cookie_id=57765ae118b7a; USRHAWB=usrmdinst_9" forHTTPHeaderField:@"Cookie"];
    
    /* Start a new Task */
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            // Success
            NSLog(@"URL Session Task Succeeded: HTTP %ld", ((NSHTTPURLResponse*)response).statusCode);
            
            //            NSData * htmlData = data;
            
            TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:data];
            
            NSLog(@"xpathParser: %@", xpathParser);
            
            NSArray *dataArray = [xpathParser searchWithXPathQuery:@"//embed"];
            
            NSLog(@"dataArray: %@", dataArray);
            
            for (TFHppleElement *hppleElement in dataArray)
            {
                NSLog(@"%@", hppleElement.raw);
                
                NSLog(@"%@", hppleElement.text);
            }
            
            
            
            
            
            
            
            
            
            
            //            //解析XML Data
            //            //2.1 创建XML解析器
            //            NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
            //
            //            //2.2 设置代理
            //            parser.delegate = self;
            //
            //            //2.3 开始解析,该方法本身是阻塞的
            //            [parser parse];
            
        }
        else {
            // Failure
            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
        }
    }];
    [task resume];
}

- (void)loadNewTopicsVideoWrite
{
    // 复杂的     NSURL* URL = [NSURL URLWithString:@http://t.cn/R5mbHNu""];
    NSString *urlString1 = @"http://t.cn/R5mbHNu";//
    NSString *urlString2 = @"http://video.weibo.com/show?fid=1034:8e07a2276315fc08461614607b4eeb43";
//    NSString *urlString = @"http://www.miaopai.com/show/aN5jDN72Ozy446jsbdoAgw__.htm";//
    NSData *htmlData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlString2]];

    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];

    NSArray *dataArray = [xpathParser searchWithXPathQuery:@"//meta"];

    for (TFHppleElement *hppleElement in dataArray)
    {
        if ([[hppleElement objectForKey:@"property"] isEqualToString:@"og:videosrc"])
        {
            NSLog(@"1: %@", [hppleElement objectForKey:@"property"]);
            NSLog(@"2: %@", hppleElement.raw);
        }
    }
//
//    <!-- 判断是否为播放页是否有视频信息 -->
//    <meta property="og:type" content="video"/>
//    <meta property="og:title" content="【用兔子找零，想得出哦】“愚蠢的人类，啥时候才能进化到用-新闻晨报的秒拍"/>
//    <meta property="og:image" content="http://dlqncdn.miaopai.com/stream/aN5jDN72Ozy446jsbdoAgw___m.jpg"/>
//    <meta property="og:url" content="http://p.weibo.com/show/aN5jDN72Ozy446jsbdoAgw__.htm"/>
//    <meta property="og:videosrc" content="http://p.weibo.com/show/aN5jDN72Ozy446jsbdoAgw__.swf"/>
//    <meta property="og:width" content="480" />
//    <meta property="og:height" content="480" />
//    <!--End -->
    
//    // 复杂的 OK 例子
//    NSString *urlString = @"http://www.cnblogs.com/YouXianMing/";
//    NSData *htmlData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]];
//    
//    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
//    
//    NSArray *dataArray = [xpathParser searchWithXPathQuery:@"//div"];
//    
//    for (TFHppleElement *hppleElement in dataArray)
//    {
//        if ([[hppleElement objectForKey:@"class"] isEqualToString:@"c_b_p_desc"])
//        {
////            NSLog(@"%@", hppleElement.raw);
//            NSLog(@"%@", hppleElement.text);
//            //        if ([[hppleElement objectForKey:@"property"] isEqualToString:@"og:videosrc"])
//            //            NSLog(@"%@", hppleElement.text);
//        }
//    }
    
    
//    // 简单的  OK  例子
//    NSString *urlString = @"http://www.cnblogs.com/YouXianMing/";
//    NSData *htmlData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]];
//    
//    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
//    
//    NSArray *dataArray = [xpathParser searchWithXPathQuery:@"//title"];
//    
//    for (TFHppleElement *hppleElement in dataArray)
//    {
//        NSLog(@"%@", hppleElement.raw);
//        NSLog(@"%@", hppleElement.text);
//        //        if ([[hppleElement objectForKey:@"property"] isEqualToString:@"og:videosrc"])
//        //            NSLog(@"%@", hppleElement.text);
//    }
    
//    // 复杂的 failed
//    NSString *urlString = @"http://www.miaopai.com/show/aN5jDN72Ozy446jsbdoAgw__.htm";//
//    NSData *htmlData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]];
//    
//    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
//    
//    NSArray *dataArray = [xpathParser searchWithXPathQuery:@"//meta"];
//    
//    for (TFHppleElement *hppleElement in dataArray)
//    {
//        if ([[hppleElement objectForKey:@"property"] isEqualToString:@"og:videosrc"])
//            NSLog(@"%@", hppleElement.text);
//    }
    
}
//    /* Configure session, choose between:
//     * defaultSessionConfiguration
//     * ephemeralSessionConfiguration
//     * backgroundSessionConfigurationWithIdentifier:
//     And set session-wide properties, such as: HTTPAdditionalHeaders,
//     HTTPCookieAcceptPolicy, requestCachePolicy or timeoutIntervalForRequest.
//     */
//    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
//    
//    /* Create session, and optionally set a NSURLSessionDelegate. */
//    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
//    
//    /* Create the Request:
//     My API (GET http://www.miaopai.com/show/aN5jDN72Ozy446jsbdoAgw__.htm)
//     */
//    
//    NSURL* URL = [NSURL URLWithString:@"http://www.miaopai.com/show/aN5jDN72Ozy446jsbdoAgw__.htm"];
//    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
//    request.HTTPMethod = @"GET";
//    
//    // Headers
//    
//    [request addValue:@"U_TRS1=000000c4.2314f10.57765ae1.efc5ac50; U_TRS2=000000c4.2404f10.57765ae1.70a4ec99; cookie_id=57765ae118b7a; USRHAWB=usrmdinst_9" forHTTPHeaderField:@"Cookie"];
//    
//    /* Start a new Task */
//    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        if (error == nil) {
//            // Success
//            NSLog(@"URL Session Task Succeeded: HTTP %ld", ((NSHTTPURLResponse*)response).statusCode);
//            
////            NSData * htmlData = data;
//
////            TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:data];
//            TFHpple *xpathParser = [[TFHpple alloc] initWithXMLData:data];
//
//            NSLog(@"xpathParser: %@", xpathParser);
//
//            NSArray *dataArray = [xpathParser searchWithXPathQuery:@"//meta"];////title
//
////            NSLog(@"dataArray: %@", dataArray);
//
////            <!-- 判断是否为播放页是否有视频信息 -->
////            <meta property="og:type" content="video"/>
////            <meta property="og:title" content="【用兔子找零，想得出哦】“愚蠢的人类，啥时候才能进化到用-新闻晨报的秒拍"/>
////            <meta property="og:image" content="http://dlqncdn.miaopai.com/stream/aN5jDN72Ozy446jsbdoAgw___m.jpg"/>
////            <meta property="og:url" content="http://p.weibo.com/show/aN5jDN72Ozy446jsbdoAgw__.htm"/>
////            <meta property="og:videosrc" content="http://p.weibo.com/show/aN5jDN72Ozy446jsbdoAgw__.swf"/>
////            <meta property="og:width" content="480" />
////            <meta property="og:height" content="480" />
////            <!--End -->
//            
//            NSString *str = @"og:videosrc";
//            
//            NSInteger i = 0;
//            for (TFHppleElement *hppleElement in dataArray)
//            {
////                NSLog(@"%@", [hppleElement objectForKey:@"property"]);
//                if ([[hppleElement objectForKey:@"property"] isEqualToString:@"og:videosrc"])
//                {
////                if ([objectForKey:@"property"]{
//
//                }
//                NSLog(@"i=%zd  ---- %@", i, [hppleElement objectForKey:@"property"]);
//                NSLog(@"%@", hppleElement.text);
//                i++;
//
//                
////                NSLog(@"%@", hppleElement.raw);
////                NSLog(@"%@", hppleElement.content);
////                NSLog(@"%@", hppleElement.attributes);
////                NSLog(@"count = %lu", (unsigned long)hppleElement.attributes.count);
////                NSLog(@"%@", hppleElement.description);
////                
////                NSLog(@"%@", hppleElement.text);
////                NSLog(@"-------------------------------------");
//////                NSLog(@"%@", hppleElement.image);
//////                NSLog(@"%@", hppleElement.url);
//////                NSLog(@"%@", hppleElement.videosrc);
//////                NSLog(@"%@", hppleElement.width);
//////                NSLog(@"%@", hppleElement.height);
//            }
//            //            }
//        }
//        else {
//            // Failure
//            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
//        }
//    }];
//    [task resume];
//
//    
////    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
////    
////    /* Create session, and optionally set a NSURLSessionDelegate. */
////    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
////    
////    /* Create the Request:
////     My API (GET http://www.miaopai.com/show/aN5jDN72Ozy446jsbdoAgw__.htm)
////     */
////    
////    NSURL* URL = [NSURL URLWithString:@"http://www.miaopai.com/show/aN5jDN72Ozy446jsbdoAgw__.htm"];
////    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
////    request.HTTPMethod = @"GET";
////    
////    // Headers
////    
////    [request addValue:@"U_TRS1=000000c4.2314f10.57765ae1.efc5ac50; U_TRS2=000000c4.2404f10.57765ae1.70a4ec99; cookie_id=57765ae118b7a; USRHAWB=usrmdinst_9" forHTTPHeaderField:@"Cookie"];
////    
////    /* Start a new Task */
////    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
////        if (error == nil) {
////            // Success
////            NSLog(@"URL Session Task Succeeded: HTTP %ld", ((NSHTTPURLResponse*)response).statusCode);
////  
//////            NSData * htmlData = data;
////            
////            TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:data];
////            
//////            NSLog(@"xpathParser: %@", xpathParser);
////            
////            NSArray *dataArray = [xpathParser searchWithXPathQuery:@"meta property"];
////            
//////            NSLog(@"dataArray: %@", dataArray);
////           
////            for (TFHppleElement *hppleElement in dataArray)
////            {
////                NSLog(@"%@", hppleElement.raw);
////                
////                NSLog(@"%@", hppleElement.text);
////            }
////            
////            
////
////           
////            
////            
////            
////            
////            
////            
////            //            //解析XML Data
////            //            //2.1 创建XML解析器
////            //            NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
////            //
////            //            //2.2 设置代理
////            //            parser.delegate = self;
////            //
////            //            //2.3 开始解析,该方法本身是阻塞的
////            //            [parser parse];
////            
////        } 
////        else {
////            // Failure
////            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
////        }
////    }];
////    [task resume];
//}

//#pragma mark --------------------
//#pragma mark NSXMLParserDelegate
////1.开始解析XML文档
//-(void)parserDidStartDocument:(NSXMLParser *)parser
//{
//    NSLog(@"%s",__func__);
//}
//
////2.开始解析某个元素
//-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict
//{
//    NSLog(@"%s--开始解析元素%@---\n%@",__func__,elementName,attributeDict);
//    
//    if ([elementName isEqualToString:@"videos"]) {
//        //过滤根元素
//        return;
//    }
//    XMGVideo *videoM = [[XMGVideo alloc]init];
//    [videoM mj_setKeyValues:attributeDict];
//    [self.videos addObject:videoM];
//    
//    //[self.videos addObject:[XMGVideo mj_objectWithKeyValues:attributeDict]];
//}

////3.某个元素解析完毕
//-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
//{
//    NSLog(@"%s--结束%@元素的解析",__func__,elementName);
//}
//
////4.整个XML文档都已经解析完毕
//-(void)parserDidEndDocument:(NSXMLParser *)parser
//{
//    NSLog(@"%s",__func__);
//}




#pragma mark -- 获取网络数据
/** 加载最新微博 */
- (void)loadNewTopics
{
    WJWAccount *Caccount  = [WJWAccountTool shareAccountTool].currentAccount;
    
    NSString *token = Caccount.access_token;
    
    self.page = 1;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/html", nil];
   
    NSString *urlstr = [NSString stringWithFormat:@"https://api.weibo.com/2/statuses/home_timeline.json?access_token=%@",token];
//     NSString *urlstr = [NSString stringWithFormat:@"http://www.miaopai.com/show/aN5jDN72Ozy446jsbdoAgw__.htm"];
//    NSLog(@"%@", urlstr);
    
    NSDictionary *dict = @{
                           @"count":@(90),
                           @"max_id":@(0),
                           @"page":@(self.page)
                           };
   
    
    [manager GET:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
        
//        NSLog(@"%@", responseObject);
        
        //解析JSON对象
        NSArray *array = responseObject[@"statuses"];

        self.hpWeiboArray = [WJWHomePageItem mj_objectArrayWithKeyValuesArray:array];
/*
 如果用从text里截取出来的网址不能正常播放，就要用到这段代码
        // 如果是视频，则给模型添加视频相关配置 图片 播放网址  宽 高
        // 这个办法有点笨，后面再优化
        for (WJWHomePageItem *item in self.hpWeiboArray) {
            // 如果微薄text有网址链接，则判断是否是视频播放网址，即是否cell中需要有视频播放

            NSLog(@"%@", item.user[@"screen_name"]);
            NSLog(@"%@", item.text);

            
            // 复杂的     NSURL* URL = [NSURL URLWithString:@http://t.cn/R5mbHNu""];
            NSString *urlString1 = @"http://t.cn/R5mbHNu";//
            NSString *urlString2 = @"http://video.weibo.com/show?fid=1034:8e07a2276315fc08461614607b4eeb43";
            //    NSString *urlString = @"http://www.miaopai.com/show/aN5jDN72Ozy446jsbdoAgw__.htm";//
            NSData *htmlData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlString2]];
            
            TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
            
            NSArray *dataArray = [xpathParser searchWithXPathQuery:@"//meta"];
            
            for (TFHppleElement *hppleElement in dataArray)
            {
                if ([[hppleElement objectForKey:@"property"] isEqualToString:@"og:videosrc"])
                {
                    NSLog(@"1: %@", [hppleElement objectForKey:@"property"]);
                    NSLog(@"2: %@", hppleElement.raw);
                }
            }
            
//            // 从微薄text中如果解析出来这个网址，再判断是否是视频网址，如果是，则解析出播放网址
//            // 复杂的
//            NSString *urlString = @"http://www.miaopai.com/show/aN5jDN72Ozy446jsbdoAgw__.htm";
//            NSData *htmlData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]];
//            
//            TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
//            
//            NSArray *dataArray = [xpathParser searchWithXPathQuery:@"//meta"];
//            
//            for (TFHppleElement *hppleElement in dataArray)
//            {
//                if ([[hppleElement objectForKey:@"property"] isEqualToString:@"og:videosrc"])
//                {
//                    NSLog(@"1: %@", [hppleElement objectForKey:@"property"]);
//                    NSLog(@"2: %@", hppleElement.raw);
//                }
//            }
//        }
//        <!-- 判断是否为播放页是否有视频信息 -->
//        <meta property="og:type" content="video"/>
//        <meta property="og:title" content="【用兔子找零，想得出哦】“愚蠢的人类，啥时候才能进化到用-新闻晨报的秒拍"/>
//        <meta property="og:image" content="http://dlqncdn.miaopai.com/stream/aN5jDN72Ozy446jsbdoAgw___m.jpg"/>
//        <meta property="og:url" content="http://p.weibo.com/show/aN5jDN72Ozy446jsbdoAgw__.htm"/>
//        <meta property="og:videosrc" content="http://p.weibo.com/show/aN5jDN72Ozy446jsbdoAgw__.swf"/>
//        <meta property="og:width" content="480" />
//        <meta property="og:height" content="480" />
//        <!--End -->
//        
        
        }
  */
        
        
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
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
        
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_footer endRefreshing];
        NSLog(@"error===%@",error);
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        
    return self.hpWeiboArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    // 直接加载xib
    //WJWHomePageCellCell *cell = [WJWHomePageCellCell homePageCellCellWithTableView:tableView];
    //注册xib，根据ID加载
    WJWHomePageCellCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.delegate = self;
    cell.hpCellItem = self.hpWeiboArray[indexPath.item];
    
    
    
//    //广告框？搜索框？tableViewHeaderView？
//    if (0 == indexPath.row)
//    {
//        WJWSearchBarCell *cell = [WJWSearchBarCell loadSearchBarNib];
//        return cell;
//    }
    //    else if (1 == indexPath.row)

    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = self.hpWeiboArray[indexPath.item].cellHeight;
//    NSLog(@"heightForRowAtIndexPath   -------  %@", [NSString stringWithFormat:@"%f", height]);
    return height;
}

#pragma mark -- 点击Cell下拉按钮，弹出遮罩的处理
//点击cell右上角下拉框，弹出遮照 和 五条Button
- (void)HPMCellHUDButton:(WJWHomePageCellCell *)cell
{
    //遮照
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    // 1.添加阴影
    UIView *coverView = [[UIView alloc] init];
    coverView.frame = screenBounds;
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0.3;
    
    [self.view.superview addSubview:coverView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverBtnClick)];
    [coverView addGestureRecognizer:tap];
    self.converView = coverView;
    
    //    [self.view bringSubviewToFront:coverView];
    
    //添加五条Button按钮
    //起始位置 x
    CGFloat x = 60;
    //每条button的高度
    CGFloat h = 1.0 * screenBounds.size.height/13;
    //起始位置 y
    CGFloat y = 200;// 4 * h;
    //button 宽度
    CGFloat w = screenBounds.size.width - 2 * 60;
    
    UIButton *storeBTN = [[UIButton alloc] init];
    [storeBTN setTitle:@"收藏" forState:(UIControlStateNormal)];
    storeBTN.frame = CGRectMake(x, y, w, h);
    [storeBTN setBackgroundColor:[UIColor whiteColor]];
    [storeBTN setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [storeBTN setTitleEdgeInsets:(UIEdgeInsetsMake(1, 1, 1, 1))];
    //    [storeBTN setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:(UIControlStateHighlighted)];
    [storeBTN setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1.0]] forState:(UIControlStateHighlighted)];
    [storeBTN addTarget:self action:@selector(reptest:) forControlEvents:(UIControlEventTouchUpInside)];
    self.storeBTN = storeBTN;
    
    
    UIButton *helpHeadlineBTN = [[UIButton alloc] init];
    [helpHeadlineBTN setTitle:@"帮上头条" forState:(UIControlStateNormal)];
    helpHeadlineBTN.frame = CGRectMake(x, y + h, w, h);
    [helpHeadlineBTN setBackgroundColor:[UIColor whiteColor]];
    [helpHeadlineBTN setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    //    [helpHeadlineBTN setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:(UIControlStateHighlighted)];
    [helpHeadlineBTN setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1.0]] forState:(UIControlStateHighlighted)];
    [helpHeadlineBTN addTarget:self action:@selector(reptest:) forControlEvents:(UIControlEventTouchUpInside)];
    self.helpHeadlineBTN = helpHeadlineBTN;
    
    UIButton *cancleAttentionBTN = [[UIButton alloc] init];
    [cancleAttentionBTN setTitle:@"取消关注" forState:(UIControlStateNormal)];
    cancleAttentionBTN.frame = CGRectMake(x, y + 2*h, w, h);
    [cancleAttentionBTN setBackgroundColor:[UIColor whiteColor]];
    [cancleAttentionBTN setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [cancleAttentionBTN setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:(UIControlStateHighlighted)];
    //    [cancleAttentionBTN setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1.0]] forState:(UIControlStateHighlighted)];
    [cancleAttentionBTN addTarget:self action:@selector(reptest:) forControlEvents:(UIControlEventTouchUpInside)];
    self.cancleAttentionBTN = cancleAttentionBTN;
    
    UIButton *shieldBTN = [[UIButton alloc] init];
    [shieldBTN setTitle:@"屏蔽" forState:(UIControlStateNormal)];
    shieldBTN.frame = CGRectMake(x, y + 3*h, w, h);
    [shieldBTN setBackgroundColor:[UIColor whiteColor]];
    [shieldBTN setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    //    [shieldBTN setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:(UIControlStateHighlighted)];
    [shieldBTN setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1.0]] forState:(UIControlStateHighlighted)];
    [shieldBTN addTarget:self action:@selector(reptest:) forControlEvents:(UIControlEventTouchUpInside)];
    self.shieldBTN = shieldBTN;
    
    UIButton *reportBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    [reportBTN setTitle:@"举报" forState:(UIControlStateNormal)];
    reportBTN.frame = CGRectMake(x, y + 4*h, w, h);
    [reportBTN setBackgroundColor:[UIColor whiteColor]];
    [reportBTN setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [reportBTN setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:206/255.0 green:206/255.0 blue:206/255.0 alpha:1.0]] forState:(UIControlStateHighlighted)];
    [reportBTN addTarget:self action:@selector(reptest:) forControlEvents:(UIControlEventTouchUpInside)];
    self.reportBTN = reportBTN;
    
    
    [self.view.superview addSubview:storeBTN];
    [self.view.superview addSubview:helpHeadlineBTN];
    [self.view.superview addSubview:cancleAttentionBTN];
    [self.view.superview addSubview:shieldBTN];
    [self.view.superview addSubview:reportBTN];
}

- (void)coverBtnClick {
    [UIView animateWithDuration:0.2 animations:^{
        
        self.converView.alpha = 0.001;
        self.storeBTN.alpha = 0.001;
        self.helpHeadlineBTN.alpha = 0.001;
        self.helpHeadlineBTN.alpha = 0.001;
        self.helpHeadlineBTN.alpha = 0.001;
        self.helpHeadlineBTN.alpha = 0.001;
    } completion:^(BOOL finished) {
        [self.converView removeFromSuperview];
        self.converView = nil;
        
        [self.storeBTN removeFromSuperview];
        self.storeBTN = nil;
        
        [self.helpHeadlineBTN removeFromSuperview];
        self.helpHeadlineBTN = nil;
        
        [self.cancleAttentionBTN removeFromSuperview];
        self.cancleAttentionBTN = nil;
        
        [self.shieldBTN removeFromSuperview];
        self.shieldBTN = nil;
        
        [self.reportBTN removeFromSuperview];
        self.reportBTN = nil;
        
    }];
}

- (void)reptest:(UIButton*)btn
{
    NSLog(@"%@", btn.titleLabel.text);
    
    if ([btn.titleLabel.text isEqualToString:@"收藏"]) {
        [self showHUD:btn.titleLabel.text];
    }
    else if ([btn.titleLabel.text isEqualToString:@"帮上头条"])
    {
        NSLog(@"帮上头条");
    }else if ([btn.titleLabel.text isEqualToString:@"取消关注"])
    {
        NSLog(@"取消关注");
    }else if ([btn.titleLabel.text isEqualToString:@"屏蔽"])
    {
        NSLog(@"屏蔽");
    }else if ([btn.titleLabel.text isEqualToString:@"举报"])
    {
        NSLog(@"举报");
    }
    
    [self coverBtnClick];
}

- (void)showHUD:(NSString *)text
{
    // 显示hudLabel
    //        self.hudLabel.hidden = NO;
    self.hudLabel = [[UILabel alloc] init];
    self.hudLabel.backgroundColor = [UIColor blackColor];
    self.hudLabel.alpha = 1;
    self.hudLabel.textColor = [UIColor whiteColor];
    //    self.hudLabel = hudLable;
    
    self.hudLabel.text = text;
    // 慢慢出现(出现动画持续1s)
    [UIView animateWithDuration:1.0 animations:^{
        self.hudLabel.alpha = 1.0; // 完全不透明
    } completion:^(BOOL finished) {
        // 1.5s后慢慢消失(消失动画持续1s)
        [UIView animateWithDuration:1.0 delay:1.5 options:kNilOptions animations:^{
            self.hudLabel.alpha = 0.0;
        } completion:nil];
    }];
}

//- (void)ForwardWeiboCellDidClickBTN:(WJWHomePageMainTVCell *)cell
//{
//    WJWForwardWeiboVC *forwardWeiboVC = [[WJWForwardWeiboVC alloc] init];
//    
//    //cell赋值给新控制器
//    // forwardWeiboVC === cell;
//    
//    [self.navigationController pushViewController:forwardWeiboVC animated:YES];
//}


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

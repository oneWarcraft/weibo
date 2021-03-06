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
#import <MediaPlayer/MediaPlayer.h>

//#define MAS_SHORTHAND
//#define MAS_SHORTHAND_GLOBALS
//#import <Masonry.h>
//pod 'Masonry'

@interface WJWHomePageViewController () <UIViewControllerTransitioningDelegate, WJWHPCellDelegate> //, NSXMLParserDelegate

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


///** 数据源*/
//@property (nonatomic ,strong) NSMutableArray *videos;
@end

@implementation WJWHomePageViewController

//-(NSMutableArray *)videos
//{
//    if (_videos == nil) {
//        _videos = [NSMutableArray array];
//    }
//    return _videos;
//}

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
            
//            NSLog(@"xpathParser: %@", xpathParser);
            
            NSArray *dataArray = [xpathParser searchWithXPathQuery:@"//embed"];
            
//            NSLog(@"dataArray: %@", dataArray);
            
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



/**
 *  从cell text里把视频短网址解析出来
 */
-(NSString *)parseURLString:(NSString *)urlString{
    //组装一个字符串，需要把里面的网址解析出来
    //    NSString *urlString=@"sfdsfhttp://www.baidu.com";
    
    //NSRegularExpression类里面调用表达的方法需要传递一个NSError的参数。下面定义一个
    
    NSError *error;
    NSString *strURL = nil;
    //http+:[^\\s]* 这个表达式是检测一个网址的。
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"http+:[^\\s]*" options:0 error:&error];
    
    if (regex != nil)
    {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:urlString options:0 range:NSMakeRange(0, [urlString length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            
            //从urlString当中截取数据
            strURL=[urlString substringWithRange:resultRange];
            //输出结果
            NSLog(@"%@",strURL);
//            return result;
        }
        
    }
    
    //去掉字符串微博非合法字符 截取
//    NSString *testString = strURL;
    NSUInteger strLength = [strURL length];
    for (int i = 0; i<strLength; i++)
    {
        char commitChar = [strURL characterAtIndex:i];
        NSString *temp = [strURL substringWithRange:NSMakeRange(i,1)];
        const char *u8Temp = [temp UTF8String];
        // 合法字符：大小写字母  数字 : 58   / 47  . 46
        if (((commitChar>64)&&(commitChar<91)) || ((commitChar>96)&&(commitChar<123)) || ((commitChar>47)&&(commitChar<58)) || commitChar == 58 || commitChar == 47 || commitChar == 46 || 3!=strlen(u8Temp)) {
            continue;
        }
        strURL = [strURL substringToIndex:i];
        NSLog(@"获得视频网址 StrURL = %@", strURL);
        return strURL;
    }

    return strURL;
}

/**
 *  从XML里把视频真实播放网址解析出来
 *  只截取秒拍网站的，其它网站的不太好截取
 */
-(NSString *)parseVedioRealURL:(NSString *)urlString
{
    
    // NSString *strSource = @"<embed id=\"em\" src=\"http://wscdn.miaopai.com/splayer2.1.5.swf?scid=dVRsE0QGasz6rRgAC3laaA__&amp;token=&amp;autopause=false&amp;fromweibo=false\" type=\"application/x-shockwave-flash\" autostart=\"false\" width=\"100%\" height=\"100%\" quality=\"high\" allowfullscreen=\"true\" wmode=\"transparent\" allowscriptaccess=\"always\" pluginspage=\"http://www.macromedia.com/go/getflashplayer\">    &#13;";
    
    NSString *str = urlString;
    
    
    //####### 目前只限制秒拍的视频!!!!!!!!!!!!
    if(![str containsString:@"wscdn.miaopai.com"])
    {
        return nil;
    }
    
    
    
    // 1.动态获取截取的起始位置
    NSUInteger location = [str rangeOfString:@"src=\""].location + 5;
    // 2.动态获取截取的长度
    // 注意:rangeOfString是从左至右的开始查找, 只要找到就不找了
    //    NSUInteger length = [str rangeOfString:@"<" options:NSBackwardsSearch].location - location;
    NSUInteger length = [str rangeOfString:@"\" type="].location - location;
    length = length>10000?0:length;
    location = location>10000?0:location;
//    NSLog(@"location = %lu, length = %lu", location, length);
    NSRange range = NSMakeRange(location, length);
    NSString *newStr = [str substringWithRange:range];
//    NSLog(@"%@", str);
//    NSLog(@"%@", newStr);
    
    return newStr;
}

- (NSString*)converShortToLongWebSite:(NSString*)strShortWebSite
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
     My API (GET http://t.cn/R5mdENE)
     */
    
//    NSURL* URL = [NSURL URLWithString:@"http://t.cn/R5mdENE"];
    NSURL* URL = [NSURL URLWithString:strShortWebSite];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = @"GET";
    
    /* Start a new Task */
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            // Success
            NSLog(@"URL Session Task Succeeded: HTTP %ld", ((NSHTTPURLResponse*)response).statusCode);
            
            // 把长网址解析出来
            TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:data];
            
//            NSLog(@"xpathParser: %@", xpathParser);
            
            NSArray *dataArray = [xpathParser searchWithXPathQuery:@"//H1"];
            
//            NSLog(@"dataArray: %@", dataArray);
            
            for (TFHppleElement *hppleElement in dataArray)
            {
                NSLog(@"%@", hppleElement.raw);
                
                NSLog(@"%@", hppleElement.text);
            }
            
            
//            
//            
//            NSError *error;
//            NSString *strURL = nil;
//            //http+:[^\\s]* 这个表达式是检测一个网址的。
//            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"http+:[^\\s]*" options:0 error:&error];
//            
//            if (regex != nil)
//            {
//                NSTextCheckingResult *firstMatch=[regex firstMatchInString:urlString options:0 range:NSMakeRange(0, [urlString length])];
//                
//                if (firstMatch) {
//                    NSRange resultRange = [firstMatch rangeAtIndex:0];
//                    
//                    //从urlString当中截取数据
//                    strURL=[urlString substringWithRange:resultRange];
//                    //输出结果
//                    NSLog(@"%@",strURL);
//                    //            return result;
//                }
//                
//            }
            

        }
        else {
            // Failure
            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
        }
    }];
    [task resume];
    
    return nil;
}

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
                           @"count":@(60),
                           @"max_id":@(0),
                           @"page":@(self.page)
                           };
   
    
    [manager GET:urlstr parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
        
//        NSLog(@"%@", responseObject);
        NSLog(@"wwwwwwwwwwwww: %@", [NSThread currentThread]);
        //解析JSON对象
        NSArray *array = responseObject[@"statuses"];

        self.hpWeiboArray = [WJWHomePageItem mj_objectArrayWithKeyValuesArray:array];
        
        NSLog(@"添加视频前的数组内容:-----");
        for (WJWHomePageItem *item in self.hpWeiboArray)
        {
            NSLog(@"昵称: %@", item.user[@"screen_name"]);
            NSLog(@"视频网址: %@", item.videoPlayPath);
        }
        

//        [self getVideoPlayPath:self.hpWeiboArray ];
        
        
        // 从HTML XML里把视频网址相关信息解析出来
        //0.获得队列组,管理队列
//        dispatch_group_t group = dispatch_group_create();
//        
//        //1.获得并发队列
        dispatch_queue_t queue = dispatch_queue_create("resolvingURL", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"******************************************************************************************************************************************************************************");
        
//        NSInteger indexWJW = 0;
//        NSInteger count = self.hpWeiboArray.count;
        for (WJWHomePageItem *item in self.hpWeiboArray)
        {
            NSString *strURL = nil;
            //            NSLog(@"---- %@", item.text);
            if (item.text != nil && [item.text containsString:@"http://t.cn"]) { //据手动统计视频网址都以短网址http://t.cn开头
                // 拿到视频网址
                strURL = [self parseURLString:item.text];
                if (strURL == nil) {
                    NSLog(@"网址解析失败！！！");
                }
                
                NSLog(@"*********** %@", strURL);
                /*
                 //                // **********短地址转换为长地址****************************************************
                 //                L秒拍视频
                 //                http://t.cn/R5889Pi
                 //                http://www.miaopai.com/show/TcCLd74hdfnYcr3CruS2zw__.htm
                 //
                 //                L秒拍视频
                 //                http://t.cn/R58rTzP
                 //                http://video.weibo.com/show?fid=1034:550e267c7333789608105611bb3b0132
                 //
                 //                优酷 L催泪！毕没毕业的都该看看！
                 //                http://t.cn/R5RjKN3
                 //                http://v.youku.com/v_show/id_XMTYyNjY4MDQ5Ng==.html
                 // 短地址转换为长地址？？暂时用这个临时办法
                 //                * Configure session, choose between:
                 //                 * defaultSessionConfiguration
                 //                 * ephemeralSessionConfiguration
                 //                 * backgroundSessionConfigurationWithIdentifier:
                 //                 And set session-wide properties, such as: HTTPAdditionalHeaders,
                 //                 HTTPCookieAcceptPolicy, requestCachePolicy or timeoutIntervalForRequest.
                 //                 *
                 */
                
                //短地址转换为长地址,并解析出来视频网址
                NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
                
                //                * Create session, and optionally set a NSURLSessionDelegate. *
                NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
                
                //                * Create the Request:
                //                 My API (GET http://t.cn/R5mdENE)
                //                 *
                /*
                 <embed id="em" src="http://wscdn.miaopai.com/splayer2.1.5.swf?scid=0yWBK8MQQTVz5xGBhuCEJw__&amp;token=&amp;autopause=false&amp;fromweibo=false" type="application/x-shockwave-flash" autostart="false" width="100%" height="100%" quality="high" allowfullscreen="true" wmode="transparent" allowscriptaccess="always" pluginspage="http://www.macromedia.com/go/getflashplayer">    &#13;
                 </embed>
                 */
                //    NSURL* URL = [NSURL URLWithString:@"http://t.cn/R5mdENE"];
                NSURL* URL = [NSURL URLWithString:strURL];
                NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
                request.HTTPMethod = @"GET";
                
                //                * Start a new Task *
                NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    if (error == nil) {
                        // Success
                        NSLog(@"URL Session Task Succeeded: HTTP %ld, thread:%@", ((NSHTTPURLResponse*)response).statusCode, [NSThread currentThread]);
                        
                        // 把长网址解析出来
                        TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:data];
                        
                        //                        NSLog(@"xpathParser: %@", xpathParser);
                        
                        NSArray *dataArray = [xpathParser searchWithXPathQuery:@"//embed"];
                        
                        //                        NSLog(@"dataArray: %@", dataArray);
                        
                        for (TFHppleElement *hppleElement in dataArray)
                        {
                            //                            if ([[hppleElement objectForKey:@""] isEqualToString:@""])
                            {
                                //                              NSLog(@"%@", hppleElement);
                                //                                NSLog(@"raw: %@", hppleElement.raw);
                                
                                //                                NSLog(@"text: %@", hppleElement.text);
                                
                                NSString *strVedioPlayURL = [self parseVedioRealURL:hppleElement.raw];
                                
                                WJWLog(@"1：strVedioPlayURL= %@", strVedioPlayURL);
                                
                                // 检验所获取IP是否有效
                                UIApplication *app = [UIApplication sharedApplication];
                                //                                item.videoPlayPath = nil;
                                if ([app canOpenURL:[NSURL URLWithString:strVedioPlayURL]])
                                {
                                    //                                    [app openURL:[NSURL URLWithString:strVedioPlayURL]];
                                    
                                    //                                        NSLog(@"--- %@",item.videoPlayPath);
                                    
                                    item.videoPlayPath = strVedioPlayURL;
                                    NSLog(@"------------------------+++++--------------------------xian");
                                    WJWLog(@"2：strVedioPlayURL= %@", strVedioPlayURL);
                                    
                                    //                                        NSLog(@"++++--- %@",item.videoPlayPath);
                                    
                                }else
                                {
                                    //                                        item.videoPlayPath = nil;
                                    
                                }
                                
                            }
                        }
                        
                        /*
                         //
                         //
                         //            NSError *error;
                         //            NSString *strURL = nil;
                         //            //http+:[^\\s]* 这个表达式是检测一个网址的。
                         //            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"http+:[^\\s]*" options:0 error:&error];
                         //
                         //            if (regex != nil)
                         //            {
                         //                NSTextCheckingResult *firstMatch=[regex firstMatchInString:urlString options:0 range:NSMakeRange(0, [urlString length])];
                         //
                         //                if (firstMatch) {
                         //                    NSRange resultRange = [firstMatch rangeAtIndex:0];
                         //
                         //                    //从urlString当中截取数据
                         //                    strURL=[urlString substringWithRange:resultRange];
                         //                    //输出结果
                         //                    NSLog(@"%@",strURL);
                         //                    //            return result;
                         //                }
                         //
                         //            }
                         */
                        
                    }
                    else {
                        // Failure
                        NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
                    }
                    
//                    if (indexWJW >= count - 2)
//                    {
//                        [self.tableView reloadData];
//                        NSLog(@"----------------------------------------------------------->hou");
//                        for (WJWHomePageItem *item in self.hpWeiboArray)
//                        {
//                            NSLog(@"之后昵称: %@", item.user[@"screen_name"]);
//                            NSLog(@"之后视频网址: %@", item.videoPlayPath);
//                        }
//                    }
                }];
                [task resume];
                
                
                /*
                 //                // **********解析出视频网址****************************************************
                 //
                 //                // 解析HTML XML
                 //                // 正确视频网址  http://t.cn/R5nWSmn
                 ////                strURL = @"http://video.weibo.com/show?fid=1034:dfd697d40f8dc2706d731019604c70e1";
                 //                 //        @"http://v.youku.com/v_show/id_XMTYyNjY4MDQ5Ng==.html"     优酷
                 //                 //        @"http://www.miaopai.com/show/LOZYBkLy9IRT3FyjVd2nqw__.htm"
                 //
                 //                strURL = @"http://www.miaopai.com/show/LOZYBkLy9IRT3FyjVd2nqw__.htm";
                 //                NSLog(@"******** %@", strURL);
                 //                NSData *htmlData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:strURL]];
                 //
                 //                TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
                 //
                 //                NSArray *dataArray = [xpathParser searchWithXPathQuery:@"//meta"];
                 //
                 //                for (TFHppleElement *hppleElement in dataArray)
                 //                {
                 //                    if ([[hppleElement objectForKey:@"property"] isEqualToString:@"og:videosrc"])
                 //                    {
                 //                        NSLog(@"1: %@", [hppleElement objectForKey:@"property"]);
                 //                        NSLog(@"2: %@", hppleElement.raw);
                 //                    }
                 //                }
                 */
                
            }
//            indexWJW++;
        }
        
//        });
        
        // 由于是子线程里处理播放路径, 因此重新加载tableView就不能在这里了,需要全部任务执行完成后,在执行
        // 打算在GCD数组里
        //拦截通知
        //当队列组中所有的任务都执行完毕的时候回调用下面方法block
        NSLog(@"@@@@@@@@@@@@@@  %@", [NSThread currentThread]);
        
        //5.回到主线程设置UI
        
        //            self.imageView.image = image;
        NSLog(@"############### ---- %@",[NSThread currentThread]);
        
//        [self.tableView reloadData];
        
        NSLog(@"添加视频后的数组内容:-----");
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
        NSLog(@"----------------------------------------------------------->hou");
        for (WJWHomePageItem *item in self.hpWeiboArray)
        {
            NSLog(@"之后昵称: %@", item.user[@"screen_name"]);
            NSLog(@"之后视频网址: %@", item.videoPlayPath);
        }
        
        [self.tableView.mj_header endRefreshing];
        

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        NSLog(@"error===%@",error);
    }];
}

//废弃
- (void) getVideoPlayPath:(NSMutableArray *)AllDataPath
{
    // 从HTML XML里把视频网址相关信息解析出来
    //0.获得队列组,管理队列
    dispatch_group_t group = dispatch_group_create();
    
    //1.获得并发队列
    dispatch_queue_t queue = dispatch_queue_create("resolvingURL", DISPATCH_QUEUE_CONCURRENT);

    
//    //1.创建队列
//    dispatch_queue_t queue = dispatch_queue_create("WJW", DISPATCH_QUEUE_CONCURRENT);
//

    for (WJWHomePageItem *item in self.hpWeiboArray)
    {
//        //控制顺序:必须等任务完毕之后才能执行后面任务
//        dispatch_barrier_async(queue, ^{

        //2.使用函数添加任务
        //把当前的任务的执行情况纳入到队列组的监听范围
        dispatch_group_async(group, queue, ^{
            NSString *strURL = nil;
//            NSLog(@"---- %@", item.text);
            if (item.text != nil && [item.text containsString:@"http://t.cn"]) { //据手动统计视频网址都以短网址http://t.cn开头
                // 拿到视频网址
                strURL = [self parseURLString:item.text];
                if (strURL == nil) {
                    NSLog(@"网址解析失败！！！");
                }
                
                NSLog(@"*********** %@", strURL);
                /*
                 //                // **********短地址转换为长地址****************************************************
                 //                L秒拍视频
                 //                http://t.cn/R5889Pi
                 //                http://www.miaopai.com/show/TcCLd74hdfnYcr3CruS2zw__.htm
                 //
                 //                L秒拍视频
                 //                http://t.cn/R58rTzP
                 //                http://video.weibo.com/show?fid=1034:550e267c7333789608105611bb3b0132
                 //
                 //                优酷 L催泪！毕没毕业的都该看看！
                 //                http://t.cn/R5RjKN3
                 //                http://v.youku.com/v_show/id_XMTYyNjY4MDQ5Ng==.html
                 // 短地址转换为长地址？？暂时用这个临时办法
                 //                * Configure session, choose between:
                 //                 * defaultSessionConfiguration
                 //                 * ephemeralSessionConfiguration
                 //                 * backgroundSessionConfigurationWithIdentifier:
                 //                 And set session-wide properties, such as: HTTPAdditionalHeaders,
                 //                 HTTPCookieAcceptPolicy, requestCachePolicy or timeoutIntervalForRequest.
                 //                 *
                 */
                
                //短地址转换为长地址,并解析出来视频网址
                NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
                
                //                * Create session, and optionally set a NSURLSessionDelegate. *
                NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:nil];
                
                //                * Create the Request:
                //                 My API (GET http://t.cn/R5mdENE)
                //                 *
                /*
                 <embed id="em" src="http://wscdn.miaopai.com/splayer2.1.5.swf?scid=0yWBK8MQQTVz5xGBhuCEJw__&amp;token=&amp;autopause=false&amp;fromweibo=false" type="application/x-shockwave-flash" autostart="false" width="100%" height="100%" quality="high" allowfullscreen="true" wmode="transparent" allowscriptaccess="always" pluginspage="http://www.macromedia.com/go/getflashplayer">    &#13;
                 </embed>
                 */
                //    NSURL* URL = [NSURL URLWithString:@"http://t.cn/R5mdENE"];
                NSURL* URL = [NSURL URLWithString:strURL];
                NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
                request.HTTPMethod = @"GET";
                
                //                * Start a new Task *
                NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    if (error == nil) {
                        // Success
                        NSLog(@"URL Session Task Succeeded: HTTP %ld, thread:%@", ((NSHTTPURLResponse*)response).statusCode, [NSThread currentThread]);
                        
                        // 把长网址解析出来
                        TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:data];
                        
                        //                        NSLog(@"xpathParser: %@", xpathParser);
                        
                        NSArray *dataArray = [xpathParser searchWithXPathQuery:@"//embed"];
                        
                        //                        NSLog(@"dataArray: %@", dataArray);
                        
                        for (TFHppleElement *hppleElement in dataArray)
                        {
                            //                            if ([[hppleElement objectForKey:@""] isEqualToString:@""])
                            {
                                //                              NSLog(@"%@", hppleElement);
                                //                                NSLog(@"raw: %@", hppleElement.raw);
                                
                                //                                NSLog(@"text: %@", hppleElement.text);
                                
                                NSString *strVedioPlayURL = [self parseVedioRealURL:hppleElement.raw];
                                
                                WJWLog(@"1：strVedioPlayURL= %@", strVedioPlayURL);
                                
                                // 检验所获取IP是否有效
                                UIApplication *app = [UIApplication sharedApplication];
                                //                                item.videoPlayPath = nil;
                                if ([app canOpenURL:[NSURL URLWithString:strVedioPlayURL]])
                                {
                                    //                                    [app openURL:[NSURL URLWithString:strVedioPlayURL]];
                                    WJWLog(@"2：strVedioPlayURL= %@", strVedioPlayURL);
                                    
                                    NSLog(@"--- %@",item.videoPlayPath);
                                    
                                    item.videoPlayPath = strVedioPlayURL;
                                    
                                    NSLog(@"++++--- %@",item.videoPlayPath);
                                    
                                }else
                                {
                                    item.videoPlayPath = nil;
                                }
                                //                                item.videoPlayPath = @"asophiasophiasophiasophiasophiasophiasophiasophiasophia";
                            }
                        }
                        
                        /*
                         //
                         //
                         //            NSError *error;
                         //            NSString *strURL = nil;
                         //            //http+:[^\\s]* 这个表达式是检测一个网址的。
                         //            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"http+:[^\\s]*" options:0 error:&error];
                         //
                         //            if (regex != nil)
                         //            {
                         //                NSTextCheckingResult *firstMatch=[regex firstMatchInString:urlString options:0 range:NSMakeRange(0, [urlString length])];
                         //
                         //                if (firstMatch) {
                         //                    NSRange resultRange = [firstMatch rangeAtIndex:0];
                         //
                         //                    //从urlString当中截取数据
                         //                    strURL=[urlString substringWithRange:resultRange];
                         //                    //输出结果
                         //                    NSLog(@"%@",strURL);
                         //                    //            return result;
                         //                }
                         //
                         //            }
                         */
                        
                    }
                    else {
                        // Failure
                        NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
                    }
                }];
                [task resume];
                
                /*
                 //                // **********解析出视频网址****************************************************
                 //
                 //                // 解析HTML XML
                 //                // 正确视频网址  http://t.cn/R5nWSmn
                 ////                strURL = @"http://video.weibo.com/show?fid=1034:dfd697d40f8dc2706d731019604c70e1";
                 //                 //        @"http://v.youku.com/v_show/id_XMTYyNjY4MDQ5Ng==.html"     优酷
                 //                 //        @"http://www.miaopai.com/show/LOZYBkLy9IRT3FyjVd2nqw__.htm"
                 //
                 //                strURL = @"http://www.miaopai.com/show/LOZYBkLy9IRT3FyjVd2nqw__.htm";
                 //                NSLog(@"******** %@", strURL);
                 //                NSData *htmlData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:strURL]];
                 //
                 //                TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
                 //
                 //                NSArray *dataArray = [xpathParser searchWithXPathQuery:@"//meta"];
                 //
                 //                for (TFHppleElement *hppleElement in dataArray)
                 //                {
                 //                    if ([[hppleElement objectForKey:@"property"] isEqualToString:@"og:videosrc"])
                 //                    {
                 //                        NSLog(@"1: %@", [hppleElement objectForKey:@"property"]);
                 //                        NSLog(@"2: %@", hppleElement.raw);
                 //                    }
                 //                }
                 */
                
            }
        });
//        });
    }
 

        
//        NSLog(@"+++++++++++++++++++++++++++");

    
    // 由于是子线程里处理播放路径, 因此重新加载tableView就不能在这里了,需要全部任务执行完成后,在执行
    // 打算在GCD数组里
    //拦截通知
    //当队列组中所有的任务都执行完毕的时候回调用下面方法block
    dispatch_group_notify(group, queue, ^{
//        [self.tableView reloadData];
        
            NSLog(@"@@@@@@@@@@@@@@  %@", [NSThread currentThread]);
        //5.回到主线程设置UI
            dispatch_async(dispatch_get_main_queue(), ^{
    //            self.imageView.image = image;
            NSLog(@"############### ---- %@",[NSThread currentThread]);

            [self.tableView reloadData];
                
            NSLog(@"添加视频后的数组内容:-----");
            for (WJWHomePageItem *item in self.hpWeiboArray)
            {
                NSLog(@"之后昵称: %@", item.user[@"screen_name"]);
                NSLog(@"之后视频网址: %@", item.videoPlayPath);
            }
            
           });
    });
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
        
//        NSLog(@"%@", responseObject);
        
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

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.拿到该cell对应的数据
    WJWHomePageItem *videoPath  = self.hpWeiboArray[indexPath.row];

    if (videoPath.videoPlayPath != nil) {
        NSLog(@"%@", videoPath.videoPlayPath);
        //2.创建视频播放控制器
        //######## Use AVPlayerViewController in AVKit.
        MPMoviePlayerViewController *vc = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:videoPath.videoPlayPath]];
        
        
        //3.弹出控制器
        [self presentViewController:vc animated:YES completion:nil];
    }

    
    NSLog(@"didSelectRowAtIndexPath: 添加视频后的数组内容:-----");
    for (WJWHomePageItem *item in self.hpWeiboArray)
    {
        NSLog(@"之后昵称: %@", item.user[@"screen_name"]);
        NSLog(@"之后视频网址: %@", item.videoPlayPath);
    }
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

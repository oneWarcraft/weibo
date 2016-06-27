//
//  WJWAuthoController.m
//  weibo
//
//  Created by wangjiwei on 16/6/13.
//  Copyright © 2016年 王继伟. All rights reserved.
//
#import "WJWAuthoController.h"
#import "AFNetworking.h"
#import "WJWAccountTool.h"
#import "WJWAccount.h"
#import "WJWTabBarController.h"

#define kAppKey @"3319318993"
#define kRedirectURI @"http://www.baidu.com"
#define kAppsecret @"42ab25f151570b29727013da15d046e2"
#define kAccessTokenURL @"https://api.weibo.com/oauth2/access_token"
#define kBaseURL @"https://api.weibo.com"
#define kAuthorizeURL [kBaseURL stringByAppendingPathComponent:@"oauth2/authorize"]

@interface WJWAuthoController ()<UIWebViewDelegate>

@property (nonatomic,strong)UIWebView *webView;

@end

@implementation WJWAuthoController



-(void)viewDidLoad{
    
    [super viewDidLoad];
    //1.加载登录界面（获取未授权的Request Token）
    //https http
    NSString *urlStr = [kAuthorizeURL stringByAppendingFormat:@"?display=mobile&client_id=%@&redirect_uri=%@", kAppKey, kRedirectURI];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
    //2.设置代理
    _webView.delegate = self;
    
    
}

-(void)loadView
{
    _webView = [[UIWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    self.view = _webView;
}

#pragma mark 换取accessToken
-(void)getAccessToken:(NSString *)requestToken
{
    //https://api.weibo.com/oauth2/access_token
    // 基准路径：协议头://主机名
   
 NSMutableURLRequest *post = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kAccessTokenURL]];
    
 post.HTTPMethod = @"POST";
    
 NSString *param = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@",kAppKey, kAppsecret, kRedirectURI, requestToken];
    
        post.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithRequest:post completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //1.解析jason数据
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        //保存账号信息
        WJWAccount *account = [[WJWAccount alloc]init];
        account.access_token = dict[@"access_token"];
        account.uid = dict[@"uid"];
        [[WJWAccountTool shareAccountTool] saveAccount:account];
        
        
        NSLog(@"返回的JASON数据==%@",dict);
        
        //回到主界面
        //self.view.window.rootViewController = [[WJWTabBarController alloc]init];
        [self presentViewController:[[WJWTabBarController alloc]init] animated:NO completion:nil];
        
    }] resume];
    
    
    
}


#pragma mark 拦截webView的所有请求
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{

    //1.获得全路径
    NSString *urlStr = request.URL.absoluteString;
    NSLog(@"request.URL===%@",request.URL);
    //2.查找"code="的范围
    NSRange rang = [urlStr rangeOfString:@"code="];
    if (rang.length != 0) {
        //跳到“回调地址”，说明已经授权成功
        int index = (int)rang.location + (int)rang.length;
        NSString *requestToken = [urlStr substringFromIndex:index];
        //换取accessToken
        [self getAccessToken:requestToken];
        
        NSLog(@"requestToken===%@",requestToken);
        
        return NO;
    }
    
    return YES;
}





@end

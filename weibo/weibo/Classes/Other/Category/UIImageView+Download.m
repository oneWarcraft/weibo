//
//  UIImageView+Download.m
//  baiSiBuDeJie
//
//  Created by 王继伟 on 16/7/1.
//  Copyright © 2016年 WangJiwei. All rights reserved.
//

#import "UIImageView+Download.h"
#import <AFNetworking.h>

@implementation UIImageView (Download)

/*
 sd_setImageWithURL:placeholderImage:方法的执行步骤
 1.取消当前imageView之前关联的请求
 2.设置占位图片到当前imageView上面
 3.如果缓存中有对应的图片，那么就显示到当前imageView上面
 4.如果缓存中没有对应的图片，发送请求给服务器下载图片
 */

- (void)wjw_setImageWithOriginalImageURL:(NSString *)originalImageURL thumbnailImageURL:(NSString *)thumbnailImageURL placeholderImage:(UIImage *)placeholderImage completed:(SDWebImageCompletionBlock)completedBlock
{
    //从内存/沙盒缓存中获取原图
    UIImage *originalImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:originalImageURL];
    
    //如果内存/沙盒中有原图，那么就直接显示原图不管现在是什么网络状态）
    if (originalImage)
    {
        [self sd_setImageWithURL:[NSURL URLWithString:originalImageURL] completed:completedBlock];
    }else // 内存/沙盒缓存没有原图
    {
        // 先查看网络状态，能否连上网络 WIFI/3G4G
        AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
        //如果有网络，则从网络上下载图片
        
        if (manager.isReachableViaWiFi)
        { // 在使用Wifi, 下载原图
            [self sd_setImageWithURL:[NSURL URLWithString:originalImageURL] completed:completedBlock];
        }else if (manager.isReachableViaWWAN)  // 在使用手机自带网络,下载小图
        {
            //     用户的配置项假设利用NSUserDefaults存储到了沙盒中
            //    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"alwaysDownloadOriginalImage"];
            //    [[NSUserDefaults standardUserDefaults] synchronize];
#warning 从沙盒中读取用户的配置项：在3G\4G环境是否仍然下载原图
            //从用户偏好设置里查看用户的配置
            BOOL  alwaysDownloadOriginalImage = [[NSUserDefaults standardUserDefaults] boolForKey:@"alwaysDownloadOriginalImage"];
            // 如果：虽然在3G/4G下用户配置的仍然下载原图，土豪随意😄
            if (alwaysDownloadOriginalImage) {
                [self sd_setImageWithURL:[NSURL URLWithString:originalImageURL] completed:completedBlock];
            }else
            {// 用户没有配置，或者默认状态下，会下载小图，节省流量
                [self sd_setImageWithURL:[NSURL URLWithString:thumbnailImageURL] completed:completedBlock];
            }
 
        }else  // 如果没有网络
        {
            UIImage *thumbnailImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:thumbnailImageURL];
            // 如果没有网络, 看本地缓存 内存/沙盒 是否有小图
            if (thumbnailImage) { // 内存\沙盒缓存中有小图
                [self sd_setImageWithURL:[NSURL URLWithString:thumbnailImageURL] completed:completedBlock];
            }else // 实在没图，那么就用占位图片
            {
                [self sd_setImageWithURL:nil placeholderImage:placeholderImage completed:completedBlock];
            }
            
        }
        
    }
        

}

- (void)wjw_setImageWithOriginalImageURL:(NSString *)originalImageURL thumbnailImageURL:(NSString *)thumbnailImageURL placeholderImage:(UIImage *)placeholderImage
{
    [self wjw_setImageWithOriginalImageURL:originalImageURL thumbnailImageURL:thumbnailImageURL completed:nil];
}

- (void)wjw_setImageWithOriginalImageURL:(NSString *)originalImageURL thumbnailImageURL:(NSString *)thumbnailImageURL
{
    [self wjw_setImageWithOriginalImageURL:originalImageURL thumbnailImageURL:thumbnailImageURL placeholderImage:nil completed:nil];
    
}

- (void)wjw_setImageWithOriginalImageURL:(NSString *)originalImageURL thumbnailImageURL:(NSString *)thumbnailImageURL completed:(SDWebImageCompletionBlock)completedBlock
{
    [self wjw_setImageWithOriginalImageURL:originalImageURL thumbnailImageURL:thumbnailImageURL placeholderImage:nil completed:completedBlock];
}



@end

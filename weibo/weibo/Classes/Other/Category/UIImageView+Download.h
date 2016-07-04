//
//  UIImageView+Download.h
//  baiSiBuDeJie
//
//  Created by 王继伟 on 16/7/1.
//  Copyright © 2016年 WangJiwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>


@interface UIImageView (Download)

/**
 *   设置imageView显示的图片
 *
 *  @param originalImageURL 原图URL
 *  @param thumbnailImageURL   缩略图URL
 *  @param placeholderImage 占位图片
 *  @param completedBlock    获取图片完毕之后会调用的block
 */

- (void)wjw_setImageWithOriginalImageURL:(NSString *)originalImageURL thumbnailImageURL:(NSString*)thumbnailImageURL placeholderImage:(UIImage*)placeholderImage;

- (void)wjw_setImageWithOriginalImageURL:(NSString *)originalImageURL thumbnailImageURL:(NSString *)thumbnailImageURL placeholderImage:(UIImage *)placeholderImage completed:(SDWebImageCompletionBlock)completedBlock;

- (void)wjw_setImageWithOriginalImageURL:(NSString *)originalImageURL thumbnailImageURL:(NSString *)thumbnailImageURL;

- (void)wjw_setImageWithOriginalImageURL:(NSString *)originalImageURL thumbnailImageURL:(NSString *)thumbnailImageURL completed:(SDWebImageCompletionBlock)completedBlock;

@end

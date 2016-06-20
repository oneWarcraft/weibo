//
//  UIImage+Render.m
//  BuDeJie
//
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "UIImage+Render.h"

@implementation UIImage (Render)

+ (UIImage *)imageNameWithOriginal:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    
    // 返回一个没有渲染图片
    return  [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end

//
//  UIImage+CircleIcon.m
//  baiSiBuDeJie
//
//  Created by 王继伟 on 16/6/22.
//  Copyright © 2016年 WangJiwei. All rights reserved.
//  把一个正方形头像变成圆形头像

#import "UIImage+CircleIcon.h"

@implementation UIImage (CircleIcon)

+ (UIImage*) CircleWithSquareImage: (UIImage*)image
{
    //裁剪图片，开启上下文
    //scale：比例因素， 点:像素 0:自动识别比例因素
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    //描述圆形裁剪路径
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    //设为剪裁区域
    [clipPath addClip];
    //画图片
    [image drawAtPoint:CGPointZero];
    //取出图片
    image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭图形上下文
    UIGraphicsEndImageContext();
    
    return image;
}

/*
//另一种方法也可以裁剪圆形头像:
//但是这种方法在iOS8之前会掉帧，iOS9,帧数不会下降,苹果已修复这个问题

self.iconView.layer.cornerRadius = self.iconView.xmg_width * 0.5;

// 超出主层边框就会被裁剪掉
self.iconView.layer.masksToBounds = YES;
*/


@end

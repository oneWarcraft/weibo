//
//  UIBarButtonItem+Item.h
//  weibo
//
//  Created by Wang Wei on 16/6/19.
//  Copyright © 2016年 WangJiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Item)

+ (UIBarButtonItem *) itemWithImage:(UIImage *)image highImage:(UIImage*)highImage target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)itemWithSelectedImage:(UIImage *)image selectedImage:(UIImage *)selectedImage target:(id)target action:(SEL)action;
@end

//
//  UIBarButtonItem+Item.m
//  baiSiBuDeJie
//
//  Created by Wang Wei on 16/6/19.
//  Copyright © 2016年 WangJiwei. All rights reserved.
//

#import "UIBarButtonItem+Item.h"

@implementation UIBarButtonItem (Item)

+ (UIBarButtonItem *)itemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    
    [btn setImage:image forState:(UIControlStateNormal)];
    [btn setImage:highImage forState:(UIControlStateHighlighted)];
    
    [btn addTarget:target action:action forControlEvents:(UIControlEventTouchUpInside)];
    
//    btn.backgroundColor = [UIColor yellowColor];
    [btn sizeToFit];
    
    UIView *tempView = [[UIView alloc] initWithFrame:btn.bounds];
    [tempView addSubview:btn];
    
    return [[UIBarButtonItem alloc] initWithCustomView:tempView];
}

+ (UIBarButtonItem *)itemWithSelectedImage:(UIImage *)image selectedImage:(UIImage *)selectedImage target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    
    [btn setImage:image forState:(UIControlStateNormal)];
    [btn setImage:selectedImage forState:(UIControlStateSelected)];
    
    [btn addTarget:target action:action forControlEvents:(UIControlEventTouchUpInside)];
    
    //    btn.backgroundColor = [UIColor yellowColor];
    [btn sizeToFit];
    
    UIView *tempView = [[UIView alloc] initWithFrame:btn.bounds];
    [tempView addSubview:btn];
    
    return [[UIBarButtonItem alloc] initWithCustomView:tempView];
}





@end

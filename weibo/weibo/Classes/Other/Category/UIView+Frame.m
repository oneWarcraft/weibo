//
//  UIView+Frame.m
//  weibo
//
//  Created by Wang Wei on 16/6/19.
//  Copyright © 2016年 WangJiwei. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (CGFloat) WJW_X
{
    return self.frame.origin.x;
}

- (void)setWJW_X:(CGFloat)WJW_X
{
    CGRect temp = self.frame;
    temp.origin.x = WJW_X;
    self.frame = temp;
}

- (CGFloat) WJW_Y
{
    return self.frame.origin.y;
}

- (void) setWJW_Y:(CGFloat)WJW_Y
{
    CGRect temp = self.frame;
    temp.origin.y = WJW_Y;
    self.frame = temp;
}

- (CGFloat)WJW_Width
{
    return self.frame.size.width;
}

- (void)setWJW_Width:(CGFloat)WJW_Width
{
    CGRect temp = self.frame;
    temp.size.width = WJW_Width;
    self.frame = temp;
}

- (CGFloat)WJW_Height
{
    return self.frame.size.height;
}

- (void)setWJW_Height:(CGFloat)WJW_Height
{
    CGRect temp = self.frame;
    temp.size.height = WJW_Height;
    self.frame = temp;
}

@end

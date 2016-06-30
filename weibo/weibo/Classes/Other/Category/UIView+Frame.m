//
//  UIView+Frame.m
//
//
//  Copyright © 2016年 王继伟. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (CGFloat)wjw_centerX
{
    return self.center.x;
}
- (void)setWjw_centerX:(CGFloat)wjw_centerX
{
    CGPoint center = self.center;
    center.x = wjw_centerX;
    self.center = center;
}

- (CGFloat)wjw_centerY
{
    return self.center.y;
}
- (void)setWjw_centerY:(CGFloat)wjw_centerY
{
    CGPoint center = self.center;
    center.y = wjw_centerY;
    self.center = center;
}

- (CGFloat)wjw_height
{
    return self.frame.size.height;
}

- (void)setWjw_height:(CGFloat)wjw_height
{
    CGRect rect = self.frame;
    rect.size.height = wjw_height;
    self.frame = rect;
}

- (CGFloat)wjw_width
{
    return self.frame.size.width;
}

- (void)setWjw_width:(CGFloat)wjw_width
{
    CGRect rect = self.frame;
    rect.size.width = wjw_width;
    self.frame = rect;

}

- (CGFloat)wjw_x
{
    return self.frame.origin.x;
}

- (void)setWjw_x:(CGFloat)wjw_x
{
    CGRect rect = self.frame;
    rect.origin.x = wjw_x;
    self.frame = rect;

}

- (CGFloat)wjw_y
{
    return self.frame.origin.y;
}
- (void)setWjw_y:(CGFloat)wjw_y
{
    CGRect rect = self.frame;
    rect.origin.y = wjw_y;
    self.frame = rect;

}

+ (instancetype)wjw_viewFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}
@end

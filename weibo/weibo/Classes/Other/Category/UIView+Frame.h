//
//  UIView+Frame.h
//
//
//  Copyright © 2016年 王继伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)
@property CGFloat wjw_width;
@property CGFloat wjw_height;
@property CGFloat wjw_x;
@property CGFloat wjw_y;
@property CGFloat wjw_centerY;
@property CGFloat wjw_centerX;

+ (instancetype)wjw_viewFromXib;
@end

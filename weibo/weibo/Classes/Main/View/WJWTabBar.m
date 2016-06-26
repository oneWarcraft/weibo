//
//  WJWTabBar.m
//  weibo
//
//  Created by Wang Wei on 16/6/19.
//  Copyright © 2016年 WangJiwei. All rights reserved.
//

#import "WJWTabBar.h"
#import "UIView+Frame.h"

@interface WJWTabBar()

@property (weak, nonatomic) UIButton *plusButton;
@end

@implementation WJWTabBar

- (UIButton *)plusButton
{
    if (_plusButton == nil) {
        UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [plusBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"]forState:UIControlStateNormal];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"]forState:UIControlStateNormal];
        [plusBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"]forState:UIControlStateHighlighted];
//        [plusBtn setImage:[UIImage imageNamed:@"tabBar_publish_icon.png"] forState:(UIControlStateNormal)];
//        [plusBtn setImage:[UIImage imageNamed:@"tabBar_publish_click_icon.png"] forState:(UIControlStateHighlighted)];
        
        [plusBtn sizeToFit];
        
        _plusButton = plusBtn;
        
        [self addSubview:plusBtn];
    }
    return _plusButton;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger count = self.items.count + 1;
    
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = self.wjw_width / count;
    CGFloat btnH = self.wjw_height;
    
    int i = 0;
//    WJWLog(@" --------- %@", [self class]);
    for (UIView *tabBarButton in self.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            if (i == 2) {
                i += 1;
            }
            btnX = i * btnW;
            
            tabBarButton.frame = CGRectMake(btnX, btnY, btnW, btnH);
            
            i++;
        }
    }
    
    self.plusButton.center = CGPointMake(self.wjw_width * 0.5, self.wjw_height * 0.5);
}

@end

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
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:(UIControlStateNormal)];
        [btn setImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:(UIControlStateHighlighted)];
        
        [btn sizeToFit];
        
        _plusButton = btn;
        
        [self addSubview:btn];
    }
    return _plusButton;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger count = self.items.count + 1;
    
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = self.WJW_Width / count;
    CGFloat btnH = self.WJW_Height;
    
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
    
    self.plusButton.center = CGPointMake(self.WJW_Width * 0.5, self.WJW_Height * 0.5);
}

@end

//
//  WJWanimationModel.m
//  sinaWeibo
//
//  Created by Wang Wei on 16/6/14.
//  Copyright © 2016年 林浩翔. All rights reserved.
//

#import "WJWanimationModel.h"

@implementation WJWanimationModel

//动画的时间
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.5;
}


//动画是怎样执行的
//无论是弹出还是销毁，如果有动画，都会调用下面的方法。
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    //1. 获取目的控制器
    if (self.presented) {
        
        UIView *ToView = [transitionContext viewForKey:UITransitionContextToViewKey];
        ToView.alpha = 0;
        
        [UIView animateWithDuration:0.5 animations:^{
            
            ToView.alpha = 1;
            
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }else{
        
        UIView *FromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        FromView.alpha = 1;
        
        [UIView animateWithDuration:0.5 animations:^{
            FromView.alpha = 0;
            
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}
@end

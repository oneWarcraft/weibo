//
//  WJWPresentVC.m
//  sinaWeibo
//
//  Created by Wang Wei on 16/6/14.
//  Copyright © 2016年 林浩翔. All rights reserved.
//

#import "WJWPresentVC.h"

@interface WJWPresentVC ()<UIGestureRecognizerDelegate>
@property (nonatomic, weak) UIGestureRecognizer *tap;
@end

@implementation WJWPresentVC
- (void)containerViewWillLayoutSubviews{
    self.presentedViewController.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width * 0.25,100-44, 200, 44 * 8);
//    self.presentedViewController.view.layer.cornerRadius = 10;
    //    设置大小位置
//    self.presentedView.frame = CGRectMake(40, 60, 90, 176);
}

-(void)tap:(UITapGestureRecognizer*)tap{
    
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)presentationTransitionWillBegin{
    //    注意如果通过动画实现自定义的转场，必须自己添加对应的视图
    [self.containerView addSubview:self.presentedView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.delegate = self;
    [self.containerView addGestureRecognizer:tap];
    
    self.tap = tap;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    CGPoint curP = [touch locationInView:self.containerView];
    
    if (CGRectContainsPoint(self.presentedView.frame, curP)) {
        return NO;
    }else
    {
        return YES;
    }
}

- (void)dismissalTransitionDidEnd:(BOOL)completed{
    //    注意，如果当销毁控制器的时候，要移除对应的视图
    [self.presentedView removeFromSuperview];
    [self.containerView removeGestureRecognizer:self.tap];
}



@end

//
//  WJWListBTNCell.m
//  sinaWeibo
//
//  Created by Wang Wei on 16/6/14.
//  Copyright © 2016年 林浩翔. All rights reserved.
//

#import "WJWListBTNCell.h"

@implementation WJWListBTNCell

+ (instancetype)chooseAddress{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  WJWHomePageItem.m
//  weibo
//
//  Created by 王继伟 on 16/6/27.
//  Copyright © 2016年 WangJiwei. All rights reserved.
//

#import "WJWHomePageItem.h"
#import <UIKit/UIKit.h>

@implementation WJWHomePageItem




//计算cell的高度有两种算法，一种是在模型文件里计算(baisibudejie)，一种是在cell里计算（sinaweibo,other）
//模型里计算要注意很多值是写死的，比较简单，xib修改后要注意这里也要手动改，而Cell里计算时不存在这个问题，但是计算起来复杂一些。
- (CGFloat)cellHeight
{
    // 如果已经计算过，就直接返回
    if (_cellHeight) return _cellHeight;
 
//    // 强制布局(目的:让Label根据文字计算自己的尺寸)
//    [self layoutIfNeeded];
//    CGFloat cellHeight = CGRectGetMaxY(self.text_Lable.frame);

    // 文字的Y值  写死的，后面需要修改：1. 改成在Cell里动态计算高度，无须写死；2. 其它方法。#######################
    _cellHeight += WJWMargin + 40 + WJWMargin; //间隔 + 头像图片高度 + 间隔
    
    // 文字的高度
    CGSize textMaxSize = CGSizeMake(WJWScreenW - 2 * WJWMargin, MAXFLOAT);
    _cellHeight += [self.text boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil].size.height + WJWMargin;
    
    //中间内容的高度
    // 非段子，可能是图片、声音、视频帖子
    // if (self.type != WJWTopicTypeWord)
    if (self.pic_urls.count>0)
    {
        _cellHeight += [self middleHeight:_cellHeight];
    }
    
    
//    // 最热评论的高度
//    if (self.top_cmt.count)
//    {
//        _cellHeight += 21;
//        
//        
//        NSString *username = self.top_cmt.firstObject[@"user"][@"username"];
//        NSString *content = self.top_cmt.firstObject[@"content"];
//        if (content.length == 0) { // 没有文字内容，是个语音评论
//            content = @"[语音评论]";
//        }
//        NSString *topCmtText = [NSString stringWithFormat:@"%@ : %@", username, content];
//        _cellHeight += [topCmtText boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil].size.height + WJWMargin;
//    }

    
    //最下面第三部分 工具条的高度
    _cellHeight += 30 + WJWMargin;
    
    return _cellHeight;
}

//暂时这么写，应该不对，collection高度需要重新计算，还需要根据发来的图片等比例进行缩放
- (CGFloat)middleHeight:(CGFloat)cellHeight
{//如果有视频或者其他的要修改这里，暂时只显示图片文字
//看代码中的数据，貌似没有给出网络图片的宽高，就固定其大小
    
    NSLog(@"middleHeight  self.pic_urls.count:  %zd", self.pic_urls.count);
    CGFloat midHeightTemp = 0;
    if (self.pic_urls.count == 0) {
        return 0.0;
    }else{
        //有配图
        switch (self.pic_urls.count){
            case 1:
            {
                CGFloat middleW = (WJWScreenW - 2 * WJWMargin) * 2.0 /3.0;
                CGFloat middleH = middleW; // 高度需要重新计算，用宽高比例计算#####################
                CGFloat middleX = WJWMargin;
                CGFloat middleY = cellHeight;

                self.middleF = CGRectMake(middleX, middleY, middleW, middleH);
                
                midHeightTemp = middleH + WJWMargin;
                break;
            }

            case 2:
            {
                CGFloat middleW = (WJWScreenW - 2 * WJWMargin) * 2.0 /3.0;
                CGFloat middleH = (WJWScreenW - 2 * WJWMargin) * 1.0 /3.0;
                CGFloat middleX = WJWMargin;
                CGFloat middleY = cellHeight;
                
                self.middleF = CGRectMake(middleX, middleY, middleW, middleH);
                
                midHeightTemp = middleH + WJWMargin;
                break;
            }
                
            case 3:
            {
                CGFloat middleW = (WJWScreenW - 2 * WJWMargin);
                CGFloat middleH = (WJWScreenW - 2 * WJWMargin) * 1.0 /3.0;;
                CGFloat middleX = WJWMargin;
                CGFloat middleY = cellHeight;
                
                self.middleF = CGRectMake(middleX, middleY, middleW, middleH);
                
                midHeightTemp = middleH + WJWMargin;
                break;
            }
                
            case 4:
            case 5:
            case 6:
            {
                CGFloat middleW = (WJWScreenW - 2 * WJWMargin);
                CGFloat middleH = (WJWScreenW - 2 * WJWMargin) * 2.0 /3.0;
                CGFloat middleX = WJWMargin;
                CGFloat middleY = cellHeight;
                
                self.middleF = CGRectMake(middleX, middleY, middleW, middleH);
                
                midHeightTemp = middleH + WJWMargin;
                break;
            }
            case 7:
            case 8:
            case 9:
            {
                CGFloat middleW = (WJWScreenW - 2 * WJWMargin);
                CGFloat middleH = (WJWScreenW - 2 * WJWMargin);
                CGFloat middleX = WJWMargin;
                CGFloat middleY = cellHeight;
                
                self.middleF = CGRectMake(middleX, middleY, middleW, middleH);
                NSLog(@"估算frame: %@", NSStringFromCGRect(self.middleF));
                midHeightTemp = middleH + WJWMargin;
                break;
            }
            default:
                WJWLog(@"Error: %s, %zd", __FUNCTION__, __LINE__);
                break;
        }
    }

    return midHeightTemp;
}




@end

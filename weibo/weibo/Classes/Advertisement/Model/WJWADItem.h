//
//  WJWADItem.h
//  baiSiBuDeJie
//
//  Created by 王继伟 on 16/6/22.
//  Copyright © 2016年 WangJiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WJWADItem : NSObject

/**
 *  广告图片
 */
@property (nonatomic, strong) NSString *w_picurl;
/**
 *  广告界面跳转地址
 */
@property (nonatomic, strong) NSString *ori_curl;
/**
 *  宽度
 */
@property (nonatomic, assign) CGFloat w;
/**
 *  高度
 */
@property (nonatomic, assign) CGFloat h;

@end

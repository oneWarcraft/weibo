//
//  WJWHomePageItem.h
//  weibo
//
//  Created by 王继伟 on 16/6/27.
//  Copyright © 2016年 WangJiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kVerifiedTypeNone = - 1, // 没有认证
    kVerifiedTypePersonal = 0, // 个人认证
    kVerifiedTypeOrgEnterprice = 2, // 企业官方：CSDN、EOE、搜狐新闻客户端
    kVerifiedTypeOrgMedia = 3, // 媒体官方：程序员杂志、苹果汇
    kVerifiedTypeOrgWebsite = 5, // 网站官方：猫扑
    kVerifiedTypeOrgWebApp = 6, // 网站官方App：echo回声App
    kVerifiedTypeDaren = 220 // 微博达人
} VerifiedType;

@interface WJWHomePageItem : NSObject

@property (nonatomic, strong) NSArray *pic_urls; // 微博配图
@property (nonatomic, assign) int reposts_count; // 转发数
@property (nonatomic, assign) int comments_count; // 评论数
@property (nonatomic, assign) int attitudes_count; // 表态数(被赞)
@property (nonatomic, copy) NSString *source; // 微博来源
@property(nonatomic, copy) NSString *text;
@property (nonatomic,strong) NSDictionary *user;
@property (nonatomic, assign) BOOL verified; //是否是微博认证用户，即加V用户
@property (nonatomic, assign) VerifiedType verified_type; // 认证类型
@property(nonatomic, copy) NSString *created_at; //发表时间
@property (nonatomic, assign) int mbtype; //什么会员
@property (nonatomic, assign) int mbrank; // 会员等级

@end

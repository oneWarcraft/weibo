//
//  WJWHomePageItem.h
//  weibo
//
//  Created by 王继伟 on 16/6/27.
//  Copyright © 2016年 WangJiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WJWGeo.h"
//#import "WJWUser.h"

@class WJWHomePageItem; //WJWUser
//typedef NS_ENUM(NSUInteger, WJWTopicType) {
//    /** 全部 */
//    WJWTopicTypeAll = 1,
//    /** 图片 */
//    WJWTopicTypePicture = 10,
//    /** 文字 */
//    WJWTopicTypeWord = 29,
//    /** 声音 */
//    WJWTopicTypeVoice = 31,
//    /** 视频 */
//    WJWTopicTypeVideo = 41
//};

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

/** *微博MID */
@property(assign,nonatomic) int64_t    mid;
/*
 humbnail_pic	string	缩略图片地址，没有时不返回此字段
 bmiddle_pic	string	中等尺寸图片地址，没有时不返回此字段
 original_pic	string	原始图片地址，没有时不返回此字段
 */
//未使用的
/**	string	字符串型的微博ID*/
@property (nonatomic, copy) NSString *idstr;
/** *是否已收藏，true：是，false：否 */
@property(assign,nonatomic) BOOL    favorited;
/** *是否被截断，true：是，false：否 */
@property(assign,nonatomic) BOOL    truncated;
/** *暂未支持）回复ID */
@property(strong,nonatomic) NSString *in_reply_to_status_id;
/** *（暂未支持）回复人UID */
@property(strong,nonatomic) NSString *in_reply_to_user_id;
/** *（暂未支持）回复人昵称 */
@property(strong,nonatomic) NSString *in_reply_to_screen_name;
/** *缩略图片地址，没有时不返回此字段 */
@property(strong,nonatomic) NSString *thumbnail_pic;
/** *中等尺寸图片地址，没有时不返回此字段*/
@property(strong,nonatomic) NSString *bmiddle_pic;
/** *原始图片地址，没有时不返回此字段 */
@property(strong,nonatomic) NSString *original_pic;
/** *地理信息字段 详细 */
@property(strong,nonatomic) WJWGeo *geo;
/** *微博作者的用户信息字段 详细 */
//@property(strong,nonatomic) WJWUser *user;
/** *被转发的原微博信息字段，当该微博为转发微博时返回 详细 */
@property(strong,nonatomic) WJWHomePageItem *retweeted_status;
/** *暂未支持 */
@property(assign,nonatomic) int    mlevel;
/** *微博的可见性及指定可见分组信息。该object中type取值，0：普通微博，1：私密微博，3：指定分组微博，4：密友微博；list_id为分组的组号 */
@property(strong,nonatomic) NSObject *visible;
/** *微博配图ID。多图时返回多图ID，用来拼接图片url。用返回字段thumbnail_pic的地址配上该返回字段的图片ID，即可得到多个图片url。 */
/** *微博流内的推广微博ID */
@property(strong,nonatomic) NSArray *ad;


// 扩展
/** 视频图片 解析出来HTML */
@property (nonatomic, copy) NSString *videoPicture;
/** 视频网址  解析出来HTML */
@property (nonatomic, copy) NSString *videoPlayPath;
/** Video的宽 */
@property (nonatomic, assign) CGFloat videoWidth;
/** Video的高 */
@property (nonatomic, assign) CGFloat videoHeight;
/** 是否为动态图 */
@property (nonatomic, assign) BOOL is_gif;
/** 是否为超长图 */
@property (nonatomic, assign, getter=isBigPicture) BOOL bigPicture;

#if 0 
二组
/**	object	微博作者的用户信息字段 详细*/
@property (nonatomic, strong) XFUser *user;
@interface XFUser : NSObject
/**	string	字符串型的用户UID*/
@property (nonatomic, copy) NSString *idstr;

/**	string	友好显示名称*/
@property (nonatomic, copy) NSString *name;

/**	string	用户头像地址，50×50像素*/
@property (nonatomic, copy) NSString *profile_image_url;
/** 会员类型 > 2代表是会员 */
@property (nonatomic, assign) int mbtype;
/** 会员等级 */
@property (nonatomic, assign) int mbrank;
@property (nonatomic, assign, getter = isVip) BOOL vip;

/** 认证类型 */
@property (nonatomic, assign) XFUserVerifiedType verified_type;
#endif



/* 额外增加的属性（为了方便开发） */
/** 根据当前模型数据计算出来的cell高度 */
@property (nonatomic, assign) CGFloat cellHeight;
/** 中间内容的frame */
@property (nonatomic, assign) CGRect middleF;
@end

//
//  WJWAccount.h
//  weibo
//
//  Created by wangjiwei on 16/6/13.
//  Copyright © 2016年 王继伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJWAccount : NSObject<NSCoding>

/**　string	用于调用access_token，接口获取授权后的access token。*/
@property (nonatomic, copy) NSString *access_token;

/**　string	access_token的生命周期，单位是秒数。*/
@property (nonatomic, copy) NSNumber *expires_in;

/**　string	当前授权用户的UID。*/
@property (nonatomic, copy) NSString *uid;
/**	access token的创建时间 */
@property (nonatomic, strong) NSDate *created_time;
/** 用户昵称  */
@property (nonatomic,copy)NSString *name;

+ (instancetype)accountWithDict:(NSDictionary *)dict;

@end

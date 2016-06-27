//
//  WJWAccountTool.h
//  weibo
//
//  Created by wangjiwei on 16/6/13.
//  Copyright © 2016年 王继伟. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WJWAccount;

@interface WJWAccountTool : NSObject



//获得当前账号
@property (nonatomic, readonly)WJWAccount *currentAccount;

//存储账号信息
-(void)saveAccount:(WJWAccount *)account;
//移除账号
-(void)removeAccount;

+(instancetype)shareAccountTool;

@end

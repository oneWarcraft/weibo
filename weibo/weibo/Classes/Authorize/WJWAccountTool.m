//
//  WJWAccountTool.m
//  weibo
//
//  Created by wangjiwei on 16/6/13.
//  Copyright © 2016年 王继伟. All rights reserved.
//
#define WJWAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]

#import "WJWAccountTool.h"
#import "WJWAccount.h"

@implementation WJWAccountTool

#pragma mark -单列模型
static WJWAccountTool *_instance;

+(instancetype)shareAccountTool
{
    if (_instance == nil) {
        _instance = [[self alloc]init];
    }
    return _instance;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });

    return _instance;
}

-(instancetype)init
{
    if (self = [super init]) {
        _currentAccount = [NSKeyedUnarchiver unarchiveObjectWithFile:WJWAccountPath];
    }
    
    return self;
}

/**
 *  存储账号信息
 *
 *  @param account 账号模型
 */

-(void)saveAccount:(WJWAccount *)account
{
    
    _currentAccount = account;
    // 自定义对象的存储必须用NSKeyedArchiver
    [NSKeyedArchiver archiveRootObject:account toFile:WJWAccountPath];
}



#pragma mark 移除账号信息
-(void)removeAccount
{
    NSFileManager * fileManager = [[NSFileManager alloc]init];
    
    [fileManager removeItemAtPath:WJWAccountPath error:nil];
}

@end

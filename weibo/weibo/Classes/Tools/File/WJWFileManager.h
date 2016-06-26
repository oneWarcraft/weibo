//
//  WJWFileManager.h
//
//
//  Created by xiaomage on 16/4/6.
//  Copyright © 2012年 王继伟. All rights reserved.
//  专门用于处理文件业务

#import <Foundation/Foundation.h>

@interface WJWFileManager : NSObject

/**
 *  获取文件夹尺寸
 *
 *  @param directoryPath 文件夹全路径
 *
 *  @return 文件夹尺寸
 */
+ (NSInteger)getDirectorySize:(NSString *)directoryPath;


/**
 *  删除文件夹下所有文件
 *
 *  @param directoryPath 文件夹全路径
 */
+ (void)removeDirectoryPath:(NSString *)directoryPath;

@end

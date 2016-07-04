//
//  WJWGeo.h
//  weibo
//
//  Created by 王继伟 on 16/7/4.
//  Copyright © 2016年 WangJiwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJWGeo : NSObject

/** *经度坐标 */
@property(strong,nonatomic) NSString *longitude;
/** *维度坐标 */
@property(strong,nonatomic) NSString *latitude;
/** *所在城市的城市代码 */
@property(strong,nonatomic) NSString *city;
/** *所在省份的省份代码 */
@property(strong,nonatomic) NSString *province;
/** *所在城市的城市名称 */
@property(strong,nonatomic) NSString *city_name;
/** *所在省份的省份名称 */
@property(strong,nonatomic) NSString *province_name;
/** *所在的实际地址，可以为空 */
@property(strong,nonatomic) NSString *address;
/** *地址的汉语拼音，不是所有情况都会返回该字段 */
@property(strong,nonatomic) NSString *pinyin;
/** *更多信息，不是所有情况都会返回该字段 */
@property(strong,nonatomic) NSString *more;
@end

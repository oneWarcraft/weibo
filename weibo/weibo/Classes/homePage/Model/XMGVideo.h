//
//  XMGVideo.h
//  03-掌握-复杂JSON解析-数据展示

#import <Foundation/Foundation.h>

@interface XMGVideo : NSObject

/*
 "id": 1,
 "image": "resources/images/minion_01.png",
 "length": 10,
 "name": "小黄人 第01部",
 "url": "resources/videos/minion_01.mp4"
 */

/** 图片url*/
@property (nonatomic ,strong) NSString *image;
/** 视频的播放时间*/
@property (nonatomic ,strong) NSString *length;
/** 视频的名称*/
@property (nonatomic ,strong) NSString *name;
/** 视频的播放地址*/
@property (nonatomic ,strong) NSString *url;

@property (nonatomic ,strong) NSString *ID;

//@property (nonatomic ,strong) NSString *description;
//+(instancetype)videWithDict:(NSDictionary *)dict;

/* 问题
 1)有的时候并不能直接使用KVC转换
 2)手动转换耗时耗力,没有价值
 3)服务器返回的字段和语言的保留字一致,会覆盖系统的某些方法
 */
@end

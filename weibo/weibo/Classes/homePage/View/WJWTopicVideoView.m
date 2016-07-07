//
//  WJWTopicVideoView.m
//  weibo
//
//  Created by 王继伟 on 16/6/30.
//  Copyright © 2016年 WangJiwei. All rights reserved.
//

#import "WJWTopicVideoView.h"
#import "WJWHomePageItem.h"

@interface WJWTopicVideoView()

@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;
@property (weak, nonatomic) IBOutlet UILabel *videotimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation WJWTopicVideoView
- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(seeBigPicture)]];
}

- (void)seeBigPicture
{
//    WJWSeeBigPictureViewController *seeBigPicVC = [[WJWSeeBigPictureViewController alloc] init];
//    seeBigPicVC.bigPicItem = self.videoTopic;
//    [self.window.rootViewController presentViewController:seeBigPicVC animated:YES completion:nil];
}

- (void)setVideoItem:(WJWHomePageItem *)videoItem
{
    _videoItem = videoItem;
    
    //#######################
#warning 由于videoItem数据除视频路径外其他暂时拿不到，先不写了，在Xib上临时配置一下
    
    // 视频图片
//    [self.imageView wjw_setImageWithOriginalImageURL:videoItem.image1 thumbnailImageURL:videoItem.image0];

    // 视频播放次数
    videoItem.playcount = 560000;

    
    if (videoItem.playcount >= 10000) {
        self.playcountLabel.text = [NSString stringWithFormat:@"%.1f万播放", videoItem.playcount / 10000.0];
    } else {
        self.playcountLabel.text = [NSString stringWithFormat:@"%zd播放", videoItem.playcount];
    }
    // 播放时长： %02zd : 占据2位，多余的空位用0来填补
    self.videotimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", videoItem.videotime / 60, videoItem.videotime % 60];
}



@end

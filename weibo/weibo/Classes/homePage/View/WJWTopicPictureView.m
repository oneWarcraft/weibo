//
//  WJWTopicPictureView.m
//  weibo
//
//  Created by 王继伟 on 16/6/30.
//  Copyright © 2016年 WangJiwei. All rights reserved.
//

#import "WJWTopicPictureView.h"
#import "WJWHomePageItem.h"
//#import "WJWSeeBigPictureViewController.h"


@interface WJWTopicPictureView()
@property (weak, nonatomic) IBOutlet UIButton *seeBigPictureButton;
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation WJWTopicPictureView

- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(seeBigPicture)]];
}

- (void)seeBigPicture
{
}
- (void)setPicItem:(WJWHomePageItem *)picItem
{
    _picItem = picItem;
    
    NSLog(@"picItem.original_pic: %@", picItem.original_pic);
    NSLog(@"picItem.thumbnail_pic: %@", picItem.thumbnail_pic);
    // 中间图片
    [self.imageView wjw_setImageWithOriginalImageURL:picItem.original_pic thumbnailImageURL:picItem.thumbnail_pic completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        //下载完成后，如果是长图，就要进行特殊处理一下
        if (image == nil) return; //下载失败
        if (!picItem.isBigPicture) return; //不是长图
        
        //开启图形上下文
        CGFloat imageW = picItem.middleF.size.width;
        CGFloat imageH = picItem.middleF.size.height;
        UIGraphicsBeginImageContext(CGSizeMake(imageW, imageH));
        //绘图
#warning 需要拿到真实高度后再优化这里!!!!  ################
        [image drawInRect:CGRectMake(0, 0, imageW, imageW * 1.0)]; // picItem.height/picItem.width)];
        
        //获得图片
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
        //关闭图形上下文
        UIGraphicsEndImageContext();
        
    }];
    
//####################
#warning 后面再优化，加git标记，应该在右下角
    self.gifView.hidden = !picItem.is_gif;
    
    //查看大图按钮是否隐藏  ####################
    self.seeBigPictureButton.hidden = !picItem.isBigPicture;
}






/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//#define WJWScreenW [UIScreen mainScreen].bounds.size.width
//
//static CGFloat margin = 1;
//static NSInteger cols = 3;
////设置cell尺寸
//#define itemWH ((WJWScreenW - (cols - 1) * margin) / cols)
//- (void)setupPictureView
//{
//    //设置流水布局
//    UICollectionViewFlowLayout *flayout = [[UICollectionViewFlowLayout alloc] init];
//    
//    flayout.itemSize = CGSizeMake(itemWH, itemWH);
//
//    flayout.minimumInteritemSpacing = margin;
//    flayout.minimumLineSpacing = margin;
//    
//    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flayout];
//    collectionView.backgroundColor = WJWGlobeColor;
//    
//    collectionView.backgroundColor = WJWGlobeColor;
//    
//    self.collectionView = collectionView;
//    
//    collectionView.dataSource = self;
//    collectionView.delegate = self;
//    
//    //本View中有两个View  tableView和CollectionView 只能有一个scrollsToTop为YES时，点击statusBar，调回顶部才会生效。
//    collectionView.scrollsToTop = NO;
//    
//    self.tableView.tableFooterView = collectionView;
//    //    self.tableView.tableFooterView = [[UISwitch alloc] init];
//    
//    
//    [collectionView registerNib:[UINib nibWithNibName:@"WJWCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellID];
//}


@end

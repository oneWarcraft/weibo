//
//  WJWTopicPictureView.m
//  weibo
//
//  Created by 王继伟 on 16/6/30.
//  Copyright © 2016年 WangJiwei. All rights reserved.
//

#import "WJWTopicPictureView.h"

@implementation WJWTopicPictureView

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

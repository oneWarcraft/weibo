//
//  WJWHomePageCellCell.h
//  weibo
//
//  Created by 王继伟 on 16/6/30.
//  Copyright © 2016年 WangJiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WJWHomePageItem, WJWHomePageCellCell,userModel;
@protocol WJWHPCellDelegate <NSObject>

@optional
//点击下拉列框
- (void)HPMCellHUDButton:(WJWHomePageCellCell *)cell;
//点击转发按钮
- (void)ForwardWeiboCellDidClickBTN:(WJWHomePageCellCell *)cell;


@end


@interface WJWHomePageCellCell : UITableViewCell
//+ (instancetype)homePageCellCellWithTableView:(UITableView *)tableView;

/**
 *  模型数据
 */
@property (nonatomic, strong) WJWHomePageItem *hpCellItem;

//@property (nonatomic,strong ) userModel *userItem;
/**
 *  返回cell的高度
 */
- (CGFloat)cellHeight;

/** 代理属性 */
@property (nonatomic, weak) id<WJWHPCellDelegate>delegate;


@end

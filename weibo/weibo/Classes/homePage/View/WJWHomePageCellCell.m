//
//  WJWHomePageCellCell.m
//  weibo
//
//  Created by 王继伟 on 16/6/30.
//  Copyright © 2016年 WangJiwei. All rights reserved.
//

#import "WJWHomePageCellCell.h"


@interface WJWHomePageCellCell()

@property (weak, nonatomic) IBOutlet UIImageView *headIcon_ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *VType_ImageView; //
@property (weak, nonatomic) IBOutlet UILabel *name_Lable;
@property (weak, nonatomic) IBOutlet UIImageView *VIP_ImageView;
@property (weak, nonatomic) IBOutlet UILabel *createTime_Lable;
@property (weak, nonatomic) IBOutlet UILabel *fromSource_Lable;
@property (weak, nonatomic) IBOutlet UIButton *pullDown_Button;
@property (weak, nonatomic) IBOutlet UILabel *text_Lable;

@property (weak, nonatomic) IBOutlet UIButton *repost_Button;
@property (weak, nonatomic) IBOutlet UIButton *comment_Button;
@property (weak, nonatomic) IBOutlet UIButton *favourCount_Button;
@property (weak, nonatomic) IBOutlet UIStackView *stackView_StackView;

@property (weak, nonatomic) IBOutlet UIView *picturesView;



@end


@implementation WJWHomePageCellCell

//+ (instancetype)homePageCellCellWithTableView:(UITableView *)tableView {
//    
//    static NSString *pageCell = @"pageCell";
//    WJWHomePageCellCell *cell = [tableView dequeueReusableCellWithIdentifier:pageCell];
//    if (!cell) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"WJWHomePageCellCell" owner:nil options:nil] lastObject];
//    }
//    
//    return cell;
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

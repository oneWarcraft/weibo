//
//  WJWHomePageCellCell.m
//  weibo
//
//  Created by 王继伟 on 16/6/30.
//  Copyright © 2016年 WangJiwei. All rights reserved.
//

#import "WJWHomePageCellCell.h"
#import "WJWHomePageItem.h"
#import "UIImageView+WebCache.h"


// 获得RGB颜色
#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
//全局的背景色
#define kGlobalBackgroundColor kColor(250, 250, 250)
// 会员昵称颜色
#define kMBScreenNameColor kColor(243, 101, 18)
// 非会员昵称颜色
#define kScreenNameColor kColor(93, 93, 93);

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

/**
 *  设置cell每个控件的值
 */
- (void)setHpCellItem:(WJWHomePageItem *)hpCellItem
{
    _hpCellItem = hpCellItem;
    
    //更新时间还要分类  刚刚  几分钟 几个小时前  昨天  具体时间  一年期  ？？？？？？?????
    self.createTime_Lable.text = [self createdAt:hpCellItem.created_at];
    
    //设置来自xxxxxx
    NSString *resultStr = hpCellItem.source;
    
    NSUInteger loc = [resultStr rangeOfString:@"nofollow\">"].location+10;
    NSUInteger len = [resultStr rangeOfString:@"</a>"].location - loc; // /不需要转吗？？
    NSString *msgSec = [resultStr substringWithRange:NSMakeRange(loc,len)];
    
    self.fromSource_Lable.text = [NSString stringWithFormat:@"来自 %@",msgSec];
    
    //微博头像
    //sd_setImageWithURL:[NSURL URLWithString:homePageCellItem.user[@"profile_image_url"]]
    [self.headIcon_ImageView sd_setImageWithURL:[NSURL URLWithString:hpCellItem.user[@"profile_image_url"]] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    
    ;
    //加不加V
    NSInteger keyValue = [hpCellItem.user[@"verified_type"] integerValue];
    
    NSLog(@"%zd",keyValue);
    
    switch (keyValue) {
        case kVerifiedTypeNone: // "没有认证"认证
            _VType_ImageView.hidden = YES;
            break;
        case kVerifiedTypePersonal: // 个人
            _VType_ImageView.hidden = NO;
            _VType_ImageView.image = [UIImage imageNamed:@"avatar_vip"];
            break;
        case kVerifiedTypeOrgEnterprice:// 企业认证
            _VType_ImageView.hidden = NO;
            _VType_ImageView.image = [UIImage imageNamed:@"avatar_enterprise_vip"];
            break;
        case kVerifiedTypeOrgMedia: // 媒体官方
            _VType_ImageView.hidden = NO;
            _VType_ImageView.image = [UIImage imageNamed:@"avatar_enterprise_vip"];
            break;
        case kVerifiedTypeOrgWebsite: // 网站官方
            _VType_ImageView.hidden = NO;
            _VType_ImageView.image = [UIImage imageNamed:@"avatar_enterprise_vip"];
            break;
        case kVerifiedTypeOrgWebApp: // 网站官方App
            _VType_ImageView.hidden = NO;
            _VType_ImageView.image = [UIImage imageNamed:@"avatar_enterprise_vip"];
            break;
        case kVerifiedTypeDaren: // 微博达人
            _VType_ImageView.hidden = NO;
            _VType_ImageView.image = [UIImage imageNamed:@"avatar_grassroot"];
            break;
            // avatar_vgirl
        case 10: // 女性达人
            _VType_ImageView.image = [UIImage imageNamed:@"avatar_vgirl"];
            break;
        default:
            _VType_ImageView.hidden = YES;
            break;
    }
    
    
    self.name_Lable.text = hpCellItem.user[@"name"];
//    NSLog(@"配图地址::-----%@",hpCellItem.pic_urls.firstObject);
    
    self.text_Lable.text = hpCellItem.text;
    
    //是否vip
    // 判断是不是会员
    if (hpCellItem.user[@"mbtype"] == 0) {
        self.name_Lable.textColor = kScreenNameColor;
        _VIP_ImageView.hidden = YES;
    } else {
        self.name_Lable.textColor = kMBScreenNameColor;
        _VIP_ImageView.hidden = NO;
        
        
        NSLog(@"会员等级是--%zd",[hpCellItem.user[@"mbrank"] integerValue]);
        switch ([hpCellItem.user[@"mbrank"] integerValue]) {
            case 1:
                _VIP_ImageView.image = [UIImage imageNamed:@"common_icon_membership_level1"];
                break;
            case 2:
                _VIP_ImageView.image = [UIImage imageNamed:@"common_icon_membership_level2"];
                break;
            case 3:
                _VIP_ImageView.image = [UIImage imageNamed:@"common_icon_membership_level3"];
                break;
            case 4:
                _VIP_ImageView.image = [UIImage imageNamed:@"common_icon_membership_level4"];
                break;
            case 5:
                _VIP_ImageView.image = [UIImage imageNamed:@"common_icon_membership_level5"];
                break;
            case 6:
                _VIP_ImageView.image = [UIImage imageNamed:@"common_icon_membership_level6"];
                break;
                
            default:
                _VIP_ImageView.image = [UIImage imageNamed:@"common_icon_membership"];
                break;
        }
        
    }

    // 配图处理 collection处理
//    [self picture:homePageCellItem.pic_urls];
    
    NSString *transmitCount = [NSString stringWithFormat:@"%  i",hpCellItem.reposts_count];
    NSString *commentCount = [NSString stringWithFormat:@"%  i",hpCellItem.comments_count];
    
    NSString *favourCount = [NSString stringWithFormat:@"%  i",hpCellItem.attitudes_count];
    
    [self.repost_Button setTitle:transmitCount forState:UIControlStateNormal];
    [self.comment_Button setTitle:commentCount forState:UIControlStateNormal];
    [self.favourCount_Button setTitle:favourCount forState:UIControlStateNormal];
    
}

/**
 * 获取微博创建时间，并转换时间格式
 * 每次滑动都要调用，实时更新时间
 */
- (NSString *)createdAt:(NSString*)_createdAt
{
    // 1.将新浪时间字符串转为NSDate对象
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss zzzz yyyy";
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDate *date = [fmt dateFromString:_createdAt];
    
    // 2.获得当前时间
    NSDate *now = [NSDate date];
    
    // 3.获得当前时间和微博发送时间的间隔（差多少秒）
    NSTimeInterval delta = [now timeIntervalSinceDate:date];
    
    //获取时间的年份
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    //当前时间的年份
    comps = [calendar components:unitFlags fromDate:now];
    int nowYear=(int)[comps year];
    //XLog(@"now year %d", nowYear);
    //微博发布时间的年份
    comps = [calendar components:unitFlags fromDate:date];
    int dateYear=(int)[comps year];
    //XLog(@"date year %d", dateYear);
    
    // 4.根据时间间隔算出合理的字符串
    if (delta < 60) { // 1分钟内
        return @"刚刚";
    } else if (delta < 60 * 60) { // 1小时内
        return [NSString stringWithFormat:@"%.f分钟前", delta/60];
    } else if (delta < 60 * 60 * 24) { // 1天内
        return [NSString stringWithFormat:@"%.f小时前", delta/60/60];
    }else if (nowYear != dateYear){ //跨年
        fmt.dateFormat = @"YYYY-MM-dd HH:mm";
        return [fmt stringFromDate:date];
    }else { //不跨年
        fmt.dateFormat = @"MM-dd HH:mm";
        return [fmt stringFromDate:date];
    }
    
}

@end
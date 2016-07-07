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
#import "WJWTopicPictureView.h"
#import "WJWTopicVideoView.h"


// 获得RGB颜色
#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
//全局的背景色
#define kGlobalBackgroundColor kColor(250, 250, 250)
// 会员昵称颜色
#define kMBScreenNameColor kColor(243, 101, 18)
// 非会员昵称颜色
#define kScreenNameColor kColor(93, 93, 93);

@interface WJWHomePageCellCell() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *headIcon_ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *VType_ImageView;
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


/* 中间控件 */
/** 图片控件 */
@property (nonatomic, weak) WJWTopicPictureView *pictureView;
///** 多图片控件（>=2） */
//@property (nonatomic, weak) WJWPictureCollectionView *pictureCollectionView;
/** 视频控件 */
@property (nonatomic, weak) WJWTopicVideoView *videoView;

@property (nonatomic, strong) NSArray *picCollectionArray;
/** 创建的显示图片的collection */
@property (nonatomic, strong) UICollectionView *picCollectView;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *midSlotViewHeight_Constraint;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *midSlotViewWidth_Constraint;
//@property (weak, nonatomic) IBOutlet UIView *midSlot_View;

@end


@implementation WJWHomePageCellCell

#pragma mark - 懒加载
- (WJWTopicPictureView *)pictureView
{
    if (!_pictureView) {
        WJWTopicPictureView *pictureView = [WJWTopicPictureView wjw_viewFromXib];
        [self.contentView addSubview:pictureView];
        
        _pictureView = pictureView;
    }
    return _pictureView;
}

//- (UICollectionView *)picCollectView
//{
//    if (!_picCollectView) {
//        UICollectionView *CollecView = [UICollectionView wjw_viewFromXib];
//        [self.contentView addSubview:CollecView];
//        
//        _picCollectView = CollecView;
//    }
//    
//    return _picCollectView;
//}

//- (WJWTopicVoiceView *)voiceView
//{
//    if (!_voiceView) {
//        WJWTopicVoiceView *voiceView = [WJWTopicVoiceView wjw_viewFromXib];
//        [self.contentView addSubview:voiceView];
//        
//        _voiceView = voiceView;
//    }
//    return _voiceView;
//}

- (WJWTopicVideoView *)videoView
{
    if (!_videoView) {
        WJWTopicVideoView *videoView = [WJWTopicVideoView wjw_viewFromXib];
        [self.contentView addSubview:videoView];
        
        _videoView = videoView;
    }
    return _videoView;
}

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
NSString *collecNibID = @"collecNibID";
- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    
    if (self.hpCellItem.pic_urls.count > 1)
    {
        //创建collectionView
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        UICollectionView *collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 20, 270, 270) collectionViewLayout:flowLayout];

        collectView.frame = self.hpCellItem.middleF; // CGRectMake(20, 20, 350, 350);
        collectView.dataSource = self;
        collectView.delegate = self;
        collectView.allowsSelection = YES;
        collectView.backgroundColor = [UIColor grayColor];
        
        CGFloat itemWidth = (WJWScreenW - 4 * WJWMargin) / 3.0;
        flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
        flowLayout.minimumLineSpacing = 5;
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0);

        NSLog(@"collectView.frame: %@", NSStringFromCGRect(collectView.frame));
        [self.contentView addSubview:collectView];
        self.picCollectView = collectView;

            //保存当前cell的所有图片
        self.picCollectionArray = self.hpCellItem.pic_urls;
        
        [self.picCollectView registerNib:[UINib nibWithNibName:@"WJWPictureCollectionView" bundle:nil] forCellWithReuseIdentifier:collecNibID];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -- collection dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"numberOfItemsInSection: %zd", self.picCollectionArray.count);
    return self.picCollectionArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"%@", self.picCollectionArray[indexPath.item]);
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:self.picCollectionArray[indexPath.item]]];

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collecNibID forIndexPath:indexPath];

    cell.backgroundView = imageV;
    cell.backgroundColor = [UIColor greenColor];

    return cell;
}

#pragma mark -- cell 第三部分的处理
////cell通知外面 用代理方法！！！！！！！
////点击转发按钮
//- (IBAction)transmitCountClickBTN
//{
//    //    WJWForwardWeiboVC *forwardVC = [[WJWForwardWeiboVC alloc] init];
//    
//    // 通知代理(调用代理的方法)
//    if ([self.delegate respondsToSelector:@selector(ForwardWeiboCellDidClickBTN:)]) {
//        [self.delegate ForwardWeiboCellDidClickBTN:self];
//    }
//    //    [self.navigationController pushViewController:forwardVC animated:YES];
//}
////点击评论按钮
//- (IBAction)commentClikBTN
//{
//    // 通知代理(调用代理的方法)
//    if ([self.delegate respondsToSelector:@selector(ForwardWeiboCellDidClickBTN:)])
//    {
//        [self.delegate ForwardWeiboCellDidClickBTN:self];
//    }
//}
////点击点赞按钮
//- (IBAction)favourCountClickBTN
//{
//}



#pragma mark -- 点击Cell下拉按钮，实现遮罩
//下拉菜单
- (IBAction)pullDownMenuClik
{
    
    //添加遮照
    // 通知代理(调用代理的方法)
    if ([self.delegate respondsToSelector:@selector(HPMCellHUDButton:)]) {
        [self.delegate HPMCellHUDButton:self];
    }
    
}

#pragma mark -- 计算cell每个控件的高
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
    if (resultStr.length>0)
    {
        NSUInteger loc = [resultStr rangeOfString:@"nofollow\">"].location+10;
        NSUInteger len = [resultStr rangeOfString:@"</a>"].location - loc; // /不需要转吗？？
        NSString *msgSec = [resultStr substringWithRange:NSMakeRange(loc,len)];
        
        self.fromSource_Lable.text = [NSString stringWithFormat:@"来自 %@",msgSec];
    }
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
    } else
    {
        self.name_Lable.textColor = kMBScreenNameColor;
        _VIP_ImageView.hidden = NO;
        
        
//        NSLog(@"会员等级是--%zd",[hpCellItem.user[@"mbrank"] integerValue]);
        switch ([hpCellItem.user[@"mbrank"] integerValue])
        {
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
#warning 待确定如何从返回的一堆数据中如何区分视频 声音 图片 再修改这里
#warning 现在中间段先只添加图片
//    // 添加中间段内容
    WJWLog(@"HPVC 当前cell 有图片 %zd 张", self.hpCellItem.pic_urls.count);
    if (self.hpCellItem.pic_urls.count > 0)
    {
        if (self.hpCellItem.pic_urls.count == 1) { //如果只有一张图片
            self.pictureView.picItem = hpCellItem;
            
            self.pictureView.hidden = NO;
            self.picCollectView.hidden = YES;
        }
        else
        {
            self.pictureView.hidden = YES;
            self.picCollectView.hidden = NO;
        }
        
        
        
//        else
//        {
//            如果多张图片，另外创建cell时，创建CollectionView另外处理
//        }
        
    }
    
    
//    switch (hpCellItem.type) {
//        case WJWTopicTypePicture:
//            self.voiceView.hidden = YES;
//            self.videoView.hidden = YES;
//            self.pictureView.hidden = NO;
//            break;
//            
//        case WJWTopicTypeVoice:
//            self.voiceView.hidden = NO;
//            self.voiceView.voiceItem = topicItem;
//            self.videoView.hidden = YES;
//            self.pictureView.hidden = YES;
//            break;
//            
//        case WJWTopicTypeVideo:
//            self.voiceView.hidden = YES;
//            self.videoView.hidden = NO;
//            self.pictureView.hidden = YES;
//            break;
//            
//        case WJWTopicTypeWord:
//            self.voiceView.hidden = YES;
//            self.videoView.hidden = YES;
//            self.pictureView.hidden = YES;
//            break;
//            
//        default:
//            break;
//    }
    //如果是图片，此处图片用collectionView来展示
    
    
    
    
    NSString *transmitCount = [NSString stringWithFormat:@"%  i",hpCellItem.reposts_count];
    NSString *commentCount = [NSString stringWithFormat:@"%  i",hpCellItem.comments_count];
    NSString *favourCount = [NSString stringWithFormat:@"%  i",hpCellItem.attitudes_count];
 
    [self.repost_Button setTitle:transmitCount forState:UIControlStateNormal];
    [self.comment_Button setTitle:commentCount forState:UIControlStateNormal];
    [self.favourCount_Button setTitle:favourCount forState:UIControlStateNormal];

    [self.repost_Button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.comment_Button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.favourCount_Button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

}




#warning 待确定如何从返回的一堆数据中如何区分视频 声音 图片 再修改这里
#warning 现在中间段先只添加图片
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //目前只处理有图片的情况，对于视频暂不处理 ###############
    if (self.hpCellItem.pic_urls.count <= 0) {
        return;
    }
    
    switch (self.hpCellItem.pic_urls.count) {
        case 1:
            self.pictureView.frame = self.hpCellItem.middleF;
            break;
            
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
            self.picCollectView.frame = self.hpCellItem.middleF;
            break;
            
        default:
            WJWLog(@"%s, %d: error count:%zd", __func__, __LINE__, self.hpCellItem.pic_urls.count);
            break;
    }
    
//    switch (self.topicItem.type) {
//        case WJWTopicTypePicture: //图片
//            self.pictureView.frame = self.hpCellItem.middleF;
//    NSLog(@"frame: %@", NSStringFromCGRect(self.pictureView.frame));
//            break;
//            
//        case WJWTopicTypeVideo: //视频
//            self.videoView.frame = self.topicItem.middleF;
//            break;
//            
//            
//        default:
//            break;
//    }
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

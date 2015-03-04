//
//  QSUserCouponTableViewCell.m
//  suntry
//
//  Created by ysmeng on 15/2/16.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSUserCouponTableViewCell.h"

#import "UIImageView+CacheImage.h"
#import "NSDate+Formatter.h"

#import "QSCouponInfoDataModel.h"

#import "ColorHeader.h"
#import "DeviceSizeHeader.h"
#import "ImageHeader.h"

@interface QSUserCouponTableViewCell ()

@property (nonatomic,strong) UIImageView *couponImage;  //!<图片
@property (nonatomic,strong) UILabel *cosutomTitleLabel;       //!<标题
@property (nonatomic,strong) UILabel *dateLabel;        //!<有效期

@end

@implementation QSUserCouponTableViewCell

#pragma mark - 初始化
///初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        ///UI搭建
        [self createUserCouponListInfoUI];
        
    }
    
    return self;

}

#pragma mark - UI搭建
///UI搭建
- (void)createUserCouponListInfoUI
{

    ///边框
    UIView *lineRootView = [[UIView alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 5.0f, SIZE_DEFAULT_MAX_WIDTH, 80.0f)];
    lineRootView.backgroundColor = [UIColor clearColor];
    lineRootView.layer.borderColor = [[UIColor colorWithRed:194.0f / 255.0f green:181.0f / 255.0f blue:156.0f / 255.0f alpha:1.0f] CGColor];
    lineRootView.layer.borderWidth = 0.5f;
    lineRootView.layer.cornerRadius = 6.0f;
    [self.contentView addSubview:lineRootView];
    
    ///图片
    self.couponImage = [[UIImageView alloc] initWithFrame:CGRectMake(5.0f, 11.0f, 84.0f, 58.0f)];
    self.couponImage.userInteractionEnabled = YES;
    [lineRootView addSubview:self.couponImage];
    
    ///标题
    self.cosutomTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.couponImage.frame.origin.x + self.couponImage.frame.size.width + 5.0f, self.couponImage.frame.origin.y + 5.0f, lineRootView.frame.size.width - self.couponImage.frame.origin.x - self.couponImage.frame.size.width - 5.0f, 25.0f)];
    self.cosutomTitleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    self.cosutomTitleLabel.textColor = COLOR_HEXCOLOR(0x939598);
    [lineRootView addSubview:self.cosutomTitleLabel];
    
    ///有效期
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.cosutomTitleLabel.frame.origin.x,self.cosutomTitleLabel.frame.origin.y + self.cosutomTitleLabel.frame.size.height + 5.0f, self.cosutomTitleLabel.frame.size.width, 25.0f)];
    self.dateLabel.font = [UIFont systemFontOfSize:14.0f];
    self.dateLabel.textColor = COLOR_HEXCOLOR(0x939598);
    [lineRootView addSubview:self.dateLabel];

}

/**
 *  @author         yangshengmeng, 15-02-16 14:02:18
 *
 *  @brief          根据列表优惠券模型，更新优惠券信息
 *
 *  @param model    数据模型
 *
 *  @since          1.0.0
 */
- (void)updateUserCouponInfoCellUI:(QSCouponInfoDataModel *)model
{

    ///更新标题
    self.cosutomTitleLabel.text = model.goods_name;
    
    ///更新有效期
    NSString *startTime = [NSString stringWithFormat:@"%@", [NSDate timeStampStringToNSDate:model.begin_time]];
    NSString *endTime = [NSString stringWithFormat:@"%@", [NSDate timeStampStringToNSDate:model.over_time]];
    self.dateLabel.text = [NSString stringWithFormat:@"%@ 至 %@",[startTime substringToIndex:10],[endTime substringToIndex:10]];
    
    ///更新图片
    [self.couponImage loadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_SERVER_URL,model.banner]] placeholderImage:nil];

}

@end

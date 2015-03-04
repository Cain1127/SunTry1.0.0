//
//  QSStoreCarInfoCollectionViewCell.m
//  suntry
//
//  Created by ysmeng on 15/3/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSStoreCarInfoCollectionViewCell.h"
#import "QSGoodsDataModel.h"

#import "ColorHeader.h"

#import <objc/runtime.h>

///关联
static char PayPriceKey;        //!<支付金额关联key
static char GitPriceKey;        //!<充值所送的金额关联key
static char BackgroudViewKey;   //!<背景view

@implementation QSStoreCarInfoCollectionViewCell

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        
        [self createStoreCardInfoCellUI];
        
    }
    
    return self;
    
}

#pragma mark - UI搭建
- (void)createStoreCardInfoCellUI
{
    
    UILabel *priceLabel =[[UILabel alloc] initWithFrame:CGRectMake(0.0f, self.frame.size.height * 0.25, self.frame.size.width, self.frame.size.height * 0.25)];
    priceLabel.textColor = [UIColor brownColor];
    priceLabel.textAlignment = NSTextAlignmentCenter;
    priceLabel.text = [NSString stringWithFormat:@"￥%@",@"500"];
    priceLabel.font = [UIFont systemFontOfSize:20];
    objc_setAssociatedObject(self, &PayPriceKey, priceLabel, OBJC_ASSOCIATION_ASSIGN);
    
    UILabel *specialLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height*0.5+5.0f, self.frame.size.width, self.frame.size.height * 0.2)];
    specialLabel.textColor = [UIColor brownColor];
    specialLabel.textAlignment = NSTextAlignmentCenter;
    specialLabel.text = [NSString stringWithFormat:@"送￥%@",@"50"];
    specialLabel.font = [UIFont systemFontOfSize:16];
    objc_setAssociatedObject(self, &GitPriceKey, specialLabel, OBJC_ASSOCIATION_ASSIGN);
    
    ///加边框
    UIView *lineRootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height)];
    lineRootView.backgroundColor = [UIColor clearColor];
    lineRootView.layer.borderColor = [[UIColor colorWithRed:194.0f / 255.0f green:181.0f / 255.0f blue:156.0f / 255.0f alpha:1.0f] CGColor];
    lineRootView.layer.borderWidth = 0.5f;
    lineRootView.layer.cornerRadius = 6.0f;
    objc_setAssociatedObject(self, &BackgroudViewKey, lineRootView, OBJC_ASSOCIATION_ASSIGN);
    
    ///加载到content上
    [self.contentView addSubview:lineRootView];
    self.backgroundColor=[UIColor clearColor];
    [self.contentView addSubview:priceLabel];
    [self.contentView addSubview:specialLabel];
    
}

#pragma mark - 重写selected方法，修改控件的状态
- (void)setSelected:(BOOL)selected
{
    
    if (selected) {
        
        ///修改背景颜色
        UIView *bgView = objc_getAssociatedObject(self, &BackgroudViewKey);
        bgView.backgroundColor = COLOR_CHARACTERS_RED;
        
        ///修改标题颜色
        UILabel *titleLabel = objc_getAssociatedObject(self, &PayPriceKey);
        if (titleLabel) {
            
            titleLabel.textColor = [UIColor whiteColor];
            
        }
        
        UILabel *subTitleLabel = objc_getAssociatedObject(self, &GitPriceKey);
        if (subTitleLabel) {
            
            subTitleLabel.textColor = [UIColor whiteColor];
            
        }
        
    } else {
        
        ///修改背景颜色
        UIView *bgView = objc_getAssociatedObject(self, &BackgroudViewKey);
        bgView.backgroundColor = [UIColor clearColor];
        
        ///修改标题颜色
        UILabel *titleLabel = objc_getAssociatedObject(self, &PayPriceKey);
        if (titleLabel) {
            
            titleLabel.textColor = [UIColor brownColor];
            
        }
        
        UILabel *subTitleLabel = objc_getAssociatedObject(self, &GitPriceKey);
        if (subTitleLabel) {
            
            subTitleLabel.textColor = [UIColor brownColor];
            
        }
        
    }
    
    [super setSelected:selected];
    
}

#pragma mark - UI刷新
- (void)updateStoreCardInfoCellUI:(id)model
{
    
    ///转换模型
    QSGoodsDataModel *tempModel = model;
    
    ///更新标题
    UILabel *titleLabel = objc_getAssociatedObject(self, &PayPriceKey);
    if (titleLabel && tempModel.goodsPrice) {
        
        titleLabel.text = [NSString stringWithFormat:@"￥%@",tempModel.goodsPrice];
        
    }
    
    UILabel *subTitleLabel = objc_getAssociatedObject(self, &GitPriceKey);
    if (subTitleLabel && tempModel.presentPrice) {
        
        subTitleLabel.text = [NSString stringWithFormat:@"送￥%@",tempModel.presentPrice];
        
    }
    
}

@end

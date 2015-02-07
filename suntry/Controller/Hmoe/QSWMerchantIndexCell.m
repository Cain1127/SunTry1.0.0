//
//  QSWMerchantIndexCell.m
//  suntry
//
//  Created by 王树朋 on 15/2/6.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWMerchantIndexCell.h"
#import "DeviceSizeHeader.h"

@implementation QSWMerchantIndexCell



-(void)setFoodImageView:(UIImageView *)foodImageView
{
    CGFloat viewW=(SIZE_DEVICE_WIDTH-3*SIZE_DEFAULT_MARGIN_LEFT_RIGHT)*0.5;
    CGFloat viewH=viewW*289/335;
    _foodImageView.frame=CGRectMake(0, 0, viewW, viewH);
    [self.contentView addSubview:_foodImageView];
}

-(void)setFoodNameLabel:(UILabel *)foodNameLabel
{
    CGFloat viewW=(SIZE_DEVICE_WIDTH-3*SIZE_DEFAULT_MARGIN_LEFT_RIGHT)*0.5;
    CGFloat viewH=viewW*289/335;
    _foodNameLabel.frame=CGRectMake(0, viewH+10.0f, 80.0f, 20.0f);
    [self.contentView addSubview:_foodNameLabel];
}

-(void)setPriceLabel:(UILabel *)priceLabel
{
    CGFloat viewW=(SIZE_DEVICE_WIDTH-3*SIZE_DEFAULT_MARGIN_LEFT_RIGHT)*0.5;
    CGFloat viewH=viewW*289/335;
    _priceLabel.frame=CGRectMake(viewW-30.0f, viewH+10.f, 30.0f, 30.0f);
    [self.contentView addSubview:_priceLabel];

}

-(void)setPriceMarkImageView:(UIImageView *)priceMarkImageView
{
    CGFloat viewW=(SIZE_DEVICE_WIDTH-3*SIZE_DEFAULT_MARGIN_LEFT_RIGHT)*0.5;
    CGFloat viewH=viewW*289/335;
   _priceMarkImageView.frame=CGRectMake(viewW-30.0f-5.0f-20.0f, viewH+10.0f, 20.0f, 20.0f);
  [self.contentView addSubview:_priceMarkImageView];
}
@end

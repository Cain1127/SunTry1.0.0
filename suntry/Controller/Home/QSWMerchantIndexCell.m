//
//  QSWMerchantIndexCell.m
//  suntry
//
//  Created by 王树朋 on 15/2/6.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWMerchantIndexCell.h"
#import "DeviceSizeHeader.h"
#import "ColorHeader.h"

@implementation QSWMerchantIndexCell

-(id)initWithFrame:(CGRect)frame
{
    
    self=[super initWithFrame:frame];
    if (self) {
        
        CGFloat viewW=self.contentView.frame.size.width;
        CGFloat viewH=self.contentView.frame.size.height;
        _foodImageView=[[UIImageView alloc]init];
        _foodImageView.frame=CGRectMake(0, 0, viewW, viewH-30);
        
        _foodNameLabel=[[UILabel alloc]init];
        _foodNameLabel.frame=CGRectMake(0, viewH-20.0f, viewW-57.0f, 20.0f);
        [_foodNameLabel setFont:[UIFont systemFontOfSize:14.0f]];
        
        _priceMarkImageView=[[UIImageView alloc]init];
        _priceMarkImageView.frame=CGRectMake(viewW-35.0f-20.0f, viewH-20.0f, 20.0f, 20.0f);
        
        _priceLabel=[[UILabel alloc]init];
        _priceLabel.frame=CGRectMake(viewW-40.0f, viewH-20.f, 35.0f, 20.0f);
        [_priceLabel setFont:[UIFont systemFontOfSize:14.0f]];
        _priceLabel.textAlignment = NSTextAlignmentRight;
        _priceLabel.textColor=COLOR_CHARACTERS_RED;
        
        [self.contentView addSubview:_foodImageView];
        [self.contentView addSubview:_foodNameLabel];
        [self.contentView addSubview:_priceLabel];
        [self.contentView addSubview:_priceMarkImageView];
        
    }
    
    return self;
}


@end

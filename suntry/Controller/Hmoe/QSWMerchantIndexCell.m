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

-(id)initWithFrame:(CGRect)frame
{
    
    self=[super initWithFrame:frame];
    if (self) {
        
        CGFloat viewW=self.contentView.frame.size.width;
        CGFloat viewH=self.contentView.frame.size.height;
        _foodImageView=[[UIImageView alloc]init];
        _foodImageView.frame=CGRectMake(0, 0, viewW, viewH-30);
        
        _foodNameLabel=[[UILabel alloc]init];
        _foodNameLabel.frame=CGRectMake(0, viewH-20.0f, 100.0f, 20.0f);
        
        _priceMarkImageView=[[UIImageView alloc]init];
        _priceMarkImageView.frame=CGRectMake(viewW-30.0f-5.0f-20.0f, viewH-20.0f, 20.0f, 20.0f);
        
        _priceLabel=[[UILabel alloc]init];
        _priceLabel.frame=CGRectMake(viewW-30.0f, viewH-20.f, 30.0f, 30.0f);
        
   
        
        [self.contentView addSubview:_foodImageView];
        [self.contentView addSubview:_foodNameLabel];
        [self.contentView addSubview:_priceLabel];
        [self.contentView addSubview:_priceMarkImageView];
        
    }
    
    return self;
}


@end

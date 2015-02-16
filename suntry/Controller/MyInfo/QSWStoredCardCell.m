//
//  QSWStoredCardCell.m
//  suntry
//
//  Created by 王树朋 on 15/2/15.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWStoredCardCell.h"
#import "DeviceSizeHeader.h"
#import "ColorHeader.h"

@implementation QSWStoredCardCell

-(id)initWithFrame:(CGRect)frame
{

    self=[super initWithFrame:frame];
    if (self) {
        
        CGFloat viewW=self.contentView.frame.size.width;
        CGFloat viewH=self.contentView.frame.size.height;
        
        _cTimeLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height,viewW*1/3, viewH)];
        _cTimeLabel.textColor = [UIColor brownColor];
        _cTimeLabel.textAlignment=NSTextAlignmentCenter;
        _cTimeLabel.font=[UIFont systemFontOfSize:16.0f];
        
        _cPrcieLabel =[[UILabel alloc] initWithFrame:CGRectMake(viewW*1/3, self.frame.size.height, viewW*1/3, viewH)];
        _cPrcieLabel.textColor = [UIColor brownColor];
        _cPrcieLabel.textAlignment=NSTextAlignmentCenter;
        _cPrcieLabel.font=[UIFont systemFontOfSize:16.0f];
        
        _cBalanceLabel =[[UILabel alloc] initWithFrame:CGRectMake(viewW*2/3, self.frame.size.height, viewW*1/3, viewH)];
        _cBalanceLabel.textColor = [UIColor brownColor];
        _cBalanceLabel.textAlignment=NSTextAlignmentCenter;
        _cBalanceLabel.font=[UIFont systemFontOfSize:16.0f];
        
        ///加边框
        //    UIView *lineRootView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, cell.frame.size.width, cell.frame.size.height)];
        //    lineRootView.backgroundColor = [UIColor clearColor];
        //    lineRootView.layer.borderColor = [[UIColor colorWithRed:194.0f / 255.0f green:181.0f / 255.0f blue:156.0f / 255.0f alpha:1.0f] CGColor];
        //    lineRootView.layer.borderWidth = 0.5f;
        //    lineRootView.layer.cornerRadius = 6.0f;
        
        ///加载到content上
//        [self.contentView addSubview:lineRootView];
//        [self.contentView sendSubviewToBack:lineRootView];
        
        self.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:_cTimeLabel];
        [self.contentView addSubview:_cPrcieLabel];
        [self.contentView addSubview:_cBalanceLabel];

    }
    
    return  self;

}


@end

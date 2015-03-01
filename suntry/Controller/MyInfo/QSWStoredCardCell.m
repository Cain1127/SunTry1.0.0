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

    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat viewW = SIZE_DEFAULT_MAX_WIDTH;
        CGFloat viewH = 44.0f;
        
        _cTimeLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 0.0f,viewW * 1.0f / 3.0f, viewH)];
        _cTimeLabel.textColor = COLOR_CHARACTERS_ROOTLINE;
        _cTimeLabel.textAlignment = NSTextAlignmentCenter;
        _cTimeLabel.font=[UIFont systemFontOfSize:16.0f];
        
        _cPrcieLabel =[[UILabel alloc] initWithFrame:CGRectMake(viewW * 1.0f / 3.0f, 0.0f, viewW * 1.0f / 3.0f, viewH)];
        _cPrcieLabel.textColor = COLOR_CHARACTERS_ROOTLINE;
        _cPrcieLabel.textAlignment=NSTextAlignmentCenter;
        _cPrcieLabel.font=[UIFont systemFontOfSize:16.0f];
        
        _cBalanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewW * 2.0f / 3.0f, 0.0f, viewW * 1.0f / 3.0f, viewH)];
        _cBalanceLabel.textColor = COLOR_CHARACTERS_ROOTLINE;
        _cBalanceLabel.textAlignment = NSTextAlignmentCenter;
        _cBalanceLabel.font = [UIFont systemFontOfSize:16.0f];
        
        self.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:_cTimeLabel];
        [self.contentView addSubview:_cPrcieLabel];
        [self.contentView addSubview:_cBalanceLabel];

    }
    
    return  self;

}

@end

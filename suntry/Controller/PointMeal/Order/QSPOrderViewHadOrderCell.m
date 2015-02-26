//
//  QSPOrderViewHadOrderCell.m
//  suntry
//
//  Created by CoolTea on 15/2/11.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderViewHadOrderCell.h"
#import "DeviceSizeHeader.h"
#import "QSLabel.h"
#import "NSString+Calculation.h"
#import "QSGoodsDataModel.h"

#define ORDER_VIEW_HADORDER_CELL_HEIGHT         45.
#define ORDER_VIEW_HADORDER_CELL_LINE_COLOR              [UIColor colorWithRed:206/255. green:208/255. blue:210/255. alpha:1]
#define ORDER_VIEW_HADORDER_CELL_TITLE_FONT_SIZE     17.
#define ORDER_VIEW_HADORDER_CELL_FOOD_NAME_TEXT_COLOR             [UIColor colorWithRed:0.505 green:0.513 blue:0.525 alpha:1.000]

@interface QSPOrderViewHadOrderCell ()

@property(nonatomic,strong) QSGoodsDataModel        *foodData;

@end

@implementation QSPOrderViewHadOrderCell

@synthesize delegate;

- (instancetype)initOrderItemViewWithData:(id)foodData withCount:(NSInteger)count
{

    if (self = [super init]) {
        
        [self setFrame:CGRectMake(0, 0, SIZE_DEVICE_WIDTH, ORDER_VIEW_HADORDER_CELL_HEIGHT)];
        
        if (!foodData||![foodData isKindOfClass:[QSGoodsDataModel class]]) {
            NSLog(@"下单界面已选菜品Cell获取菜品数据错误！foodData：%@",foodData);
            return self;
        }
        
        self.foodData = (QSGoodsDataModel*)foodData;
        
        //增加减少菜品数量控件
        QSPFoodCountControlView *foodCountControlView = [[QSPFoodCountControlView alloc] initControlView];
        [foodCountControlView setMarginTopRight:CGPointMake(SIZE_DEVICE_WIDTH-10, (ORDER_VIEW_HADORDER_CELL_HEIGHT-foodCountControlView.frame.size.height)/2)];
        [foodCountControlView setCount:count];
        [foodCountControlView setDelegate:self];
        [self addSubview:foodCountControlView];
        
        UIView *lineButtomView = [[UIView alloc] initWithFrame:CGRectMake(12, ORDER_VIEW_HADORDER_CELL_HEIGHT-1, SIZE_DEVICE_WIDTH-24, 1)];
        [lineButtomView setBackgroundColor:ORDER_VIEW_HADORDER_CELL_LINE_COLOR];
        [self addSubview:lineButtomView];
        [self setUserInteractionEnabled:YES];
        
        NSString *priceStr = [NSString stringWithFormat:@"￥%@",[_foodData getOnsalePrice]];
        CGFloat priceStrWidth = [priceStr calculateStringDisplayWidthByFixedHeight:14.0 andFontSize:ORDER_VIEW_HADORDER_CELL_TITLE_FONT_SIZE]+4;
        QSLabel *priceLabel = [[QSLabel alloc] initWithFrame:CGRectMake(foodCountControlView.frame.origin.x-priceStrWidth+18, (ORDER_VIEW_HADORDER_CELL_HEIGHT-17)/2, priceStrWidth, 17)];
        [priceLabel setFont:[UIFont systemFontOfSize:ORDER_VIEW_HADORDER_CELL_TITLE_FONT_SIZE]];
        [priceLabel setText:priceStr];
        [priceLabel setTextColor:ORDER_VIEW_HADORDER_CELL_FOOD_NAME_TEXT_COLOR];
        [self addSubview:priceLabel];
        
        QSLabel *foodNameLabel = [[QSLabel alloc] initWithFrame:CGRectMake(12, priceLabel.frame.origin.y, priceLabel.frame.origin.x-12, 17)];
        [foodNameLabel setFont:[UIFont systemFontOfSize:ORDER_VIEW_HADORDER_CELL_TITLE_FONT_SIZE]];
        [foodNameLabel setText:_foodData.goodsName];
        [foodNameLabel setTextColor:ORDER_VIEW_HADORDER_CELL_FOOD_NAME_TEXT_COLOR];
        [self addSubview:foodNameLabel];
        
    }
    
    return self;
}

- (void)changedCount:(NSInteger)count
{
    
    if (delegate) {
        
        [delegate changedCount:count withFoodData:_foodData];
        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

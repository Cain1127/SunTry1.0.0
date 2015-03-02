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
//#import "QSGoodsDataModel.h"

#define ORDER_VIEW_HADORDER_CELL_HEIGHT                 45.
#define ORDER_VIEW_HADORDER_CELL_LINE_COLOR             [UIColor colorWithRed:206/255. green:208/255. blue:210/255. alpha:1]
#define ORDER_VIEW_HADORDER_CELL_TITLE_FONT_SIZE        17.
#define ORDER_VIEW_HADORDER_CELL_SUB_TITLE_FONT_SIZE    11.
#define ORDER_VIEW_HADORDER_CELL_FOOD_NAME_TEXT_COLOR   [UIColor colorWithRed:0.505 green:0.513 blue:0.525 alpha:1.000]

@interface QSPOrderViewHadOrderCell ()

@property (nonatomic, strong) NSDictionary        *foodData;
@property (nonatomic, strong) QSPFoodCountControlView *foodCountControlView;

@end

@implementation QSPOrderViewHadOrderCell

@synthesize delegate;

- (instancetype)initOrderItemViewWithData:(id)foodData withCount:(NSInteger)count
{

    if (self = [super init]) {
        
        [self setFrame:CGRectMake(0, 0, SIZE_DEVICE_WIDTH, ORDER_VIEW_HADORDER_CELL_HEIGHT)];
        
        if (!foodData||![foodData isKindOfClass:[NSDictionary class]]) {
            NSLog(@"下单界面已选菜品Cell获取菜品数据错误！foodData：%@",foodData);
            return self;
        }
        
        self.foodData = (NSDictionary*)foodData;
        
        //增加减少菜品数量控件
        self.foodCountControlView = [[QSPFoodCountControlView alloc] initControlView];
        [self.foodCountControlView setMarginTopRight:CGPointMake(SIZE_DEVICE_WIDTH, (ORDER_VIEW_HADORDER_CELL_HEIGHT-self.foodCountControlView.frame.size.height)/2)];
        [self.foodCountControlView setCount:count];
        [self.foodCountControlView setDelegate:self];
        [self addSubview:self.foodCountControlView];
        
        UIView *lineButtomView = [[UIView alloc] initWithFrame:CGRectMake(12, ORDER_VIEW_HADORDER_CELL_HEIGHT-1, SIZE_DEVICE_WIDTH-24, 1)];
        [lineButtomView setBackgroundColor:ORDER_VIEW_HADORDER_CELL_LINE_COLOR];
        [self addSubview:lineButtomView];
        [self setUserInteractionEnabled:YES];
        
        NSString *priceStr = [NSString stringWithFormat:@"￥%@",[_foodData objectForKey:@"sale_money"]];
        CGFloat priceStrWidth = [priceStr calculateStringDisplayWidthByFixedHeight:14.0 andFontSize:ORDER_VIEW_HADORDER_CELL_TITLE_FONT_SIZE]+4;
        QSLabel *priceLabel = [[QSLabel alloc] initWithFrame:CGRectMake(self.foodCountControlView.frame.origin.x-priceStrWidth+12, (ORDER_VIEW_HADORDER_CELL_HEIGHT-17)/2, priceStrWidth, 17)];
        [priceLabel setFont:[UIFont systemFontOfSize:ORDER_VIEW_HADORDER_CELL_TITLE_FONT_SIZE]];
        [priceLabel setText:priceStr];
        [priceLabel setTextColor:ORDER_VIEW_HADORDER_CELL_FOOD_NAME_TEXT_COLOR];
        [self addSubview:priceLabel];
        
        NSString *foodNameStr = [NSString stringWithFormat:@"%@",[_foodData objectForKey:@"name"]];
        CGFloat foodNameStrWidth = [foodNameStr calculateStringDisplayWidthByFixedHeight:14.0 andFontSize:ORDER_VIEW_HADORDER_CELL_TITLE_FONT_SIZE]+4;
        
        if (foodNameStrWidth > priceLabel.frame.origin.x-12) {
            foodNameStrWidth = priceLabel.frame.origin.x-12;
        }
        QSLabel *foodNameLabel = [[QSLabel alloc] initWithFrame:CGRectMake(12, priceLabel.frame.origin.y, foodNameStrWidth, 17)];
        [foodNameLabel setFont:[UIFont systemFontOfSize:ORDER_VIEW_HADORDER_CELL_TITLE_FONT_SIZE]];
        [foodNameLabel setText:[_foodData objectForKey:@"name"]];
        [foodNameLabel setTextColor:ORDER_VIEW_HADORDER_CELL_FOOD_NAME_TEXT_COLOR];
        [self addSubview:foodNameLabel];
        
        if ([_foodData objectForKey:@"diet"]) {
            NSArray *subFoodList = [_foodData objectForKey:@"diet"];
            if (subFoodList&&[subFoodList isKindOfClass:[NSArray class]]) {
                if ([subFoodList count]>0) {
                    //套餐
                    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(foodNameLabel.frame.origin.x+foodNameLabel.frame.size.width+6, 4, priceLabel.frame.origin.x - (foodNameLabel.frame.origin.x + foodNameLabel.frame.size.width-6), ORDER_VIEW_HADORDER_CELL_HEIGHT-8)];
                    [subView setBackgroundColor:[UIColor clearColor]];
                    [self addSubview:subView];
                    
                    for (int i=0; i<[subFoodList count]; i++) {
                        NSDictionary* subItem = [subFoodList objectAtIndex:i];
                        if (subItem && [subItem isKindOfClass:[NSDictionary class]]) {
                            NSString *foodNameStr = [subItem objectForKey:@"name"];
                            NSString *countStr = [subItem objectForKey:@"num"];
                            
                            NSString* showSubFoodStr = [NSString stringWithFormat:@"%@*%@",foodNameStr,countStr];
                            QSLabel *subFoodLabel = [[QSLabel alloc] initWithFrame:CGRectMake(0, (subView.frame.size.height/[subFoodList count])*i, subView.frame.size.width, subView.frame.size.height/[subFoodList count])];
                            [subFoodLabel setFont:[UIFont systemFontOfSize:ORDER_VIEW_HADORDER_CELL_SUB_TITLE_FONT_SIZE]];
                            [subFoodLabel setText:foodNameStr];
                            [subFoodLabel setTextColor:ORDER_VIEW_HADORDER_CELL_FOOD_NAME_TEXT_COLOR];
                            [subView addSubview:subFoodLabel];
                        }
                    }
                }
            }
        }
        
    }
    
    return self;
}

- (void)changedCount:(NSInteger)count
{
    
    if (delegate) {
        NSLog(@"changedCount:%ld withFoodData:%@",(long)count,_foodData);
        if (_foodData&&[_foodData isKindOfClass:[NSDictionary class]]) {
            NSDictionary *food = (NSDictionary*)_foodData;
            if ([food objectForKey:@"num_instock"]) {
                NSString *numInstockStr = [food objectForKey:@"num_instock"];
                if (count>numInstockStr.integerValue) {
                    count = numInstockStr.integerValue;
                    [self.foodCountControlView setCount:count];
                }
            }
        }
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

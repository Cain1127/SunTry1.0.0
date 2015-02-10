//
//  QSPFoodPackageView.m
//  suntry
//
//  Created by CoolTea on 15/2/10.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPFoodPackageView.h"
#import "DeviceSizeHeader.h"
#import "NSString+Calculation.h"
#import "QSLabel.h"
#import "QSBlockButton.h"
#import "QSPFoodPackageItemView.h"

#define PACKAGE_VIEW_BACKGROUND_COLOR                  [UIColor colorWithWhite:0 alpha:0.6]
#define PACKAGE_VIEW_FOOD_NAME_STRING_FONT_SIZE        20.
#define PACKAGE_VIEW_FOOD_NAME_TEXT_COLOR             [UIColor colorWithRed:0.505 green:0.513 blue:0.525 alpha:1.000]


@interface QSPFoodPackageView ()

@property(nonatomic,strong) QSLabel     *foodNameLabel;
@property(nonatomic,strong) UIView      *contentBackgroundView;

@end


@implementation QSPFoodPackageView


+ (instancetype)getPackageView
{
    
    static QSPFoodPackageView *packageView;
    
    if (!packageView) {
        
        packageView = [[QSPFoodPackageView alloc] initPackageView];
        
    }
    
    return packageView;
    
}

- (instancetype)initPackageView
{
    
    if (self = [super init]) {
        
        //半透明背景层
        [self setFrame:CGRectMake(0, 0, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT)];
        [self setBackgroundColor:PACKAGE_VIEW_BACKGROUND_COLOR];
        
        //中间内容区域层
        self.contentBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 345/375.*SIZE_DEVICE_WIDTH, 469/667.*SIZE_DEVICE_HEIGHT)];
        [_contentBackgroundView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_contentBackgroundView];
        
        //菜名元素
        NSString* foodNameStr = @"支竹焖烧肉美味营养套餐";
        CGFloat foodNameWidth = [foodNameStr calculateStringDisplayWidthByFixedHeight:14.0 andFontSize:PACKAGE_VIEW_FOOD_NAME_STRING_FONT_SIZE ]+4;
        self.foodNameLabel = [[QSLabel alloc] initWithFrame:CGRectMake(12, 16, foodNameWidth, 14)];
        [self.foodNameLabel setTextColor:PACKAGE_VIEW_FOOD_NAME_TEXT_COLOR];
        [self.foodNameLabel setFont:[UIFont systemFontOfSize:PACKAGE_VIEW_FOOD_NAME_STRING_FONT_SIZE ]];
        [self.foodNameLabel setText:foodNameStr];
        [_contentBackgroundView addSubview:self.foodNameLabel];
        
        //关闭按钮
        QSBlockButtonStyleModel *closeStyleModel = [QSBlockButtonStyleModel alloc];
        closeStyleModel.imagesNormal = @"close_button_normal_icon";
        closeStyleModel.imagesHighted = @"close_button_down_icon";
        UIButton *closeBt = [UIButton createBlockButtonWithFrame:CGRectMake(_contentBackgroundView.frame.size.width-32-8, 8, 32, 32) andButtonStyle:closeStyleModel andCallBack:^(UIButton *button) {
            [self hidePackageView];
            [self removeFromSuperview];
        }];
        [_contentBackgroundView addSubview:closeBt];
        
        //分割线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(_foodNameLabel.frame.origin.x, _foodNameLabel.frame.origin.y+_foodNameLabel.frame.size.height+12, _contentBackgroundView.frame.size.width-_foodNameLabel.frame.origin.x*2, 1)];
        [lineView setBackgroundColor:[UIColor colorWithRed:0.779 green:0.788 blue:0.793 alpha:1.000]];
        [_contentBackgroundView addSubview:lineView];
        
        CGFloat buttomY = lineView.frame.origin.y + lineView.frame.size.height;
        
        CGFloat scrollViewContentHight = 0.;
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(lineView.frame.origin.x, lineView.frame.origin.y+lineView.frame.size.height, lineView.frame.size.width, scrollViewContentHight)];
        [scrollView setBackgroundColor:[UIColor clearColor]];
        [_contentBackgroundView addSubview:scrollView];
        
        CGFloat scrollViewMaxHeight = SIZE_DEVICE_HEIGHT - 150;
        //套餐列表
        NSArray *foodPackageList = [NSArray arrayWithObjects:@"", nil];
        for (int i=0; i<[foodPackageList count]; i++) {
            
            QSPFoodPackageItemView *foodPackageView = [[QSPFoodPackageItemView alloc] initItemViewWithData:[foodPackageList objectAtIndex:i]];
            [foodPackageView setFrame:CGRectMake(0, scrollViewContentHight, foodPackageView.frame.size.width, foodPackageView.frame.size.height)];
            [scrollView addSubview:foodPackageView];
            scrollViewContentHight = foodPackageView.frame.origin.y + foodPackageView.frame.size.height;
            [scrollView setFrame:CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y, scrollView.frame.size.width, scrollViewContentHight>scrollViewMaxHeight?scrollViewMaxHeight:scrollViewContentHight)];
            [scrollView setContentSize:CGSizeMake(scrollView.contentSize.width, scrollViewContentHight)];
            
        }
        
        buttomY = scrollView.frame.origin.y+scrollView.frame.size.height;
        
        //确定按钮
        QSBlockButtonStyleModel *submitBtStyleModel = [QSBlockButtonStyleModel alloc];
        submitBtStyleModel.bgColor  = [UIColor colorWithRed:0.471 green:0.176 blue:0.224 alpha:1.000];;
        submitBtStyleModel.title    = @"确定";
        submitBtStyleModel.titleNormalColor = [UIColor whiteColor];
        submitBtStyleModel.cornerRadio = 6.;
        UIButton *submitBt = [UIButton createBlockButtonWithFrame:CGRectMake(12, buttomY, _contentBackgroundView.frame.size.width-12*2, 44) andButtonStyle:submitBtStyleModel andCallBack:^(UIButton *button) {
            
            NSLog(@"submitBtl");
            [self hidePackageView];
            [self removeFromSuperview];
            
        }];
        [_contentBackgroundView addSubview:submitBt];
        
        [_contentBackgroundView setFrame:CGRectMake(_contentBackgroundView.frame.origin.x,_contentBackgroundView.frame.origin.y, _contentBackgroundView.frame.size.width, submitBt.frame.origin.y+submitBt.frame.size.height+12)];
        
        [_contentBackgroundView setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    }
    
    return self;
    
}

- (void)showPackageView
{
    
    [self setHidden:NO];
    
}

- (void)hidePackageView
{
    
    [self setHidden:YES];
    
}

- (void)upFoodData:(id)data
{
    //TODO: 设置套餐数据
}

- (id)getSelectFoodData
{
    //TODO: 返回套餐选择结果
    NSMutableArray *selectPackageList = [NSMutableArray arrayWithCapacity:0];
    for (QSPFoodPackageItemView *item in [_contentBackgroundView subviews]) {
        
        [selectPackageList addObject:[item getSelectFoodList]];
        
    }
    
    return nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

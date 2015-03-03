//
//  QSPFoodPackageItemGridView.m
//  suntry
//
//  Created by CoolTea on 15/2/10.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPFoodPackageItemGridView.h"
#import "QSLabel.h"
#import "DeviceSizeHeader.h"
#import "UIImageView+CacheImage.h"
#import "NSString+Calculation.h"
#import "QSBlockButton.h"
#import "QSGoodsDataModel.h"
#import "ImageHeader.h"

#define PACKAGE_VIEW_FOOD_PACKAGE_NAME_STRING_FONT_SIZE        15.
#define PACKAGE_VIEW_FOOD_PACKAGE_NAME_TEXT_COLOR             [UIColor colorWithRed:0.505 green:0.513 blue:0.525 alpha:1.000]
#define PACKAGE_VIEW_FOOD_NAME_STRING_FONT_SIZE                15.
#define PACKAGE_VIEW_FOOD_NAME_TEXT_COLOR             [UIColor colorWithRed:0.505 green:0.513 blue:0.525 alpha:1.000]

@interface QSPFoodPackageItemGridView ()

@property(nonatomic,strong) QSGoodsDataSubModel     *foodData;
@property(nonatomic,strong) QSLabel                 *packageNameLabel;
@property(nonatomic,strong) UIButton                *selectBt;
@property(nonatomic,strong) UIButton                *foodImgButton;

@end

@implementation QSPFoodPackageItemGridView

@synthesize delegate;

- (instancetype)initGridViewWithData:(id)foodData
{
    
    if (self = [super init]) {
        
        [self setFrame:CGRectMake(0, 0, 144/375.*SIZE_DEVICE_WIDTH, 128/667.*SIZE_DEVICE_HEIGHT)];
        [self setBackgroundColor:[UIColor clearColor]];
        
        if (!foodData||![foodData isKindOfClass:[QSGoodsDataSubModel class]]) {
            NSLog(@"初始化套餐详情接收菜品数据出错！");
            return self;
        }
        
        self.foodData = (QSGoodsDataSubModel*)foodData;
        
        //菜展示图
        UIImageView *contentImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 97/667.*SIZE_DEVICE_HEIGHT)];
        [contentImgView setBackgroundColor:[UIColor clearColor]];
        [contentImgView setContentMode:UIViewContentModeScaleAspectFill];
        [contentImgView setClipsToBounds:YES];
        [self addSubview:contentImgView];
        
        [contentImgView loadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_SERVER_URL,_foodData.goodsImageUrl]] placeholderImage:nil];
        
        //菜名元素
        NSString* foodNameStr = _foodData.goodsName;
//        CGFloat foodNameWidth = [foodNameStr calculateStringDisplayWidthByFixedHeight:14.0 andFontSize:PACKAGE_VIEW_FOOD_NAME_STRING_FONT_SIZE ]+4;
        QSLabel *foodNameLabel = [[QSLabel alloc] initWithFrame:CGRectMake(contentImgView.frame.origin.x, self.frame.size.height-14-3-8, contentImgView.frame.size.width+10, 22)];
        [foodNameLabel setTextColor:PACKAGE_VIEW_FOOD_NAME_TEXT_COLOR];
        [foodNameLabel setFont:[UIFont systemFontOfSize:PACKAGE_VIEW_FOOD_NAME_STRING_FONT_SIZE ]];
        [foodNameLabel setText:foodNameStr];
        [foodNameLabel setAdjustsFontSizeToFitWidth:YES];
        [self addSubview:foodNameLabel];
        
        QSBlockButtonStyleModel *imgBtStyle = [[QSBlockButtonStyleModel alloc] init];
        [imgBtStyle setBgColor:[UIColor clearColor]];
        self.foodImgButton = [UIButton createBlockButtonWithFrame:contentImgView.frame andButtonStyle:imgBtStyle andCallBack:^(UIButton *button) {
            [self clickButton:button];
        }];
        [self addSubview:self.foodImgButton];
        
        //选择按钮
        QSBlockButtonStyleModel *selectStyleModel = [QSBlockButtonStyleModel alloc];
        selectStyleModel.imagesNormal = @"public_choose_normal";
        selectStyleModel.imagesSelected = @"public_choose_selected";
        selectStyleModel.bgColor = [UIColor clearColor];
        self.selectBt = [UIButton createBlockButtonWithFrame:CGRectMake(self.frame.size.width-40+2, -6, 44, 44) andButtonStyle:selectStyleModel andCallBack:^(UIButton *button) {
            [self clickButton:button];
        }];
        
        [self addSubview:self.selectBt];
        
    }
    
    return self;
    
}

- (void)clickButton:(UIButton*)button
{
    if (button.tag==0) {
        [self setSelectState:YES];
    }else{
        [self setSelectState:NO];
    }
    if (delegate) {
        [delegate beSeleted:button withData:_foodData];
    }
}

- (BOOL)getSelectState
{
    
    BOOL flag = NO;
    if (self.selectBt.tag==1) {
        
        flag = YES;
        
    }
    return flag;
    
}

- (void)setSelectState:(BOOL)state
{
    
    if (state) {
        _foodImgButton.tag = 1;
        _selectBt.tag = 1;
        [_selectBt setImage:[UIImage imageNamed:@"public_choose_selected"] forState:UIControlStateNormal];
        
    }else{
        _foodImgButton.tag = 0;
        _selectBt.tag = 0;
        [_selectBt setImage:[UIImage imageNamed:@"public_choose_normal"] forState:UIControlStateNormal];
        
    }
    
}

- (id)getFoodData
{
    return _foodData;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

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

#define PACKAGE_VIEW_FOOD_PACKAGE_NAME_STRING_FONT_SIZE        17.
#define PACKAGE_VIEW_FOOD_PACKAGE_NAME_TEXT_COLOR             [UIColor colorWithRed:0.505 green:0.513 blue:0.525 alpha:1.000]
#define PACKAGE_VIEW_FOOD_NAME_STRING_FONT_SIZE                17.
#define PACKAGE_VIEW_FOOD_NAME_TEXT_COLOR             [UIColor colorWithRed:0.505 green:0.513 blue:0.525 alpha:1.000]

@interface QSPFoodPackageItemGridView ()

@property(nonatomic,strong) id          foodData;
@property(nonatomic,strong) QSLabel     *packageNameLabel;
@property(nonatomic,strong) UIButton    *selectBt;

@end

@implementation QSPFoodPackageItemGridView


- (instancetype)initGridViewWithData:(id)foodData
{
    
    self.foodData = foodData;
    if (self = [super init]) {
        
        [self setFrame:CGRectMake(0, 0, 144/375.*SIZE_DEVICE_WIDTH, 128/667.*SIZE_DEVICE_HEIGHT)];
        [self setBackgroundColor:[UIColor clearColor]];
        
        //菜展示图
        UIImageView *contentImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 97/667.*SIZE_DEVICE_HEIGHT)];
        [contentImgView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:contentImgView];
        
        [contentImgView loadImageWithURL:[NSURL URLWithString:@"http://admin.9dxz.com/files/jpg(18).jpeg"] placeholderImage:nil];
        
        //菜名元素
        NSString* foodNameStr = @"猪扒拼鸡扒";
        CGFloat foodNameWidth = [foodNameStr calculateStringDisplayWidthByFixedHeight:14.0 andFontSize:PACKAGE_VIEW_FOOD_NAME_STRING_FONT_SIZE ]+4;
        QSLabel *foodNameLabel = [[QSLabel alloc] initWithFrame:CGRectMake(contentImgView.frame.origin.x, self.frame.size.height-14-3, foodNameWidth, 14)];
        [foodNameLabel setTextColor:PACKAGE_VIEW_FOOD_NAME_TEXT_COLOR];
        [foodNameLabel setFont:[UIFont systemFontOfSize:PACKAGE_VIEW_FOOD_NAME_STRING_FONT_SIZE ]];
        [foodNameLabel setText:foodNameStr];
        [self addSubview:foodNameLabel];
        
        //选择按钮
        QSBlockButtonStyleModel *selectStyleModel = [QSBlockButtonStyleModel alloc];
        selectStyleModel.imagesNormal = @"public_choose_normal";
        selectStyleModel.imagesSelected = @"public_choose_selected";
        self.selectBt = [UIButton createBlockButtonWithFrame:CGRectMake(self.frame.size.width-40+6, -6, 40, 40) andButtonStyle:selectStyleModel andCallBack:^(UIButton *button) {
            
            if (button.tag==0) {
                
                button.tag = 1;
                [button setImage:[UIImage imageNamed:@"public_choose_selected"] forState:UIControlStateNormal];
                
            }else{
                
                button.tag = 0;
                [button setImage:[UIImage imageNamed:@"public_choose_normal"] forState:UIControlStateNormal];
                
            }
            
        }];
        
        [self addSubview:self.selectBt];
        
    }
    
    return self;
    
}

- (BOOL)getSelectState
{
    
    BOOL flag = NO;
    if (self.selectBt.tag==1) {
        
        flag = YES;
        
    }
    return flag;
    
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

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
#import "QSGoodsDataModel.h"

#define PACKAGE_VIEW_BACKGROUND_COLOR                  [UIColor colorWithWhite:0 alpha:0.6]
#define PACKAGE_VIEW_FOOD_NAME_STRING_FONT_SIZE        15.
#define PACKAGE_VIEW_FOOD_NAME_TEXT_COLOR             [UIColor colorWithRed:0.505 green:0.513 blue:0.525 alpha:1.000]


@interface QSPFoodPackageView ()

@property(nonatomic,strong) QSLabel         *foodNameLabel;
@property(nonatomic,strong) UIView          *contentBackgroundView;
@property(nonatomic,strong) UIScrollView    *scrollView;
@property(nonatomic,strong) UIButton        *submitBt;
@property(nonatomic,strong) NSMutableDictionary    *packageSelectedFoodData;

@end


@implementation QSPFoodPackageView

@synthesize delegate;

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
        
        self.packageSelectedFoodData = [NSMutableDictionary dictionaryWithCapacity:0];
        
        //半透明背景层
        [self setFrame:CGRectMake(0, 0, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT)];
        [self setBackgroundColor:PACKAGE_VIEW_BACKGROUND_COLOR];
        
        //中间内容区域层
        self.contentBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 345/375.*SIZE_DEVICE_WIDTH, 469/667.*SIZE_DEVICE_HEIGHT)];
        [_contentBackgroundView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_contentBackgroundView];
        
        //菜名元素
        self.foodNameLabel = [[QSLabel alloc] initWithFrame:CGRectMake(12, 16, _contentBackgroundView.frame.size.width-50, 22)];
        [self.foodNameLabel setTextColor:PACKAGE_VIEW_FOOD_NAME_TEXT_COLOR];
        [self.foodNameLabel setFont:[UIFont systemFontOfSize:PACKAGE_VIEW_FOOD_NAME_STRING_FONT_SIZE ]];
         [_foodNameLabel setBackgroundColor:[UIColor clearColor]];
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
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(lineView.frame.origin.x, lineView.frame.origin.y+lineView.frame.size.height, lineView.frame.size.width, scrollViewContentHight)];
        [_scrollView setBackgroundColor:[UIColor clearColor]];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_contentBackgroundView addSubview:_scrollView];
        
        buttomY = _scrollView.frame.origin.y+_scrollView.frame.size.height;
        
        //确定按钮
        QSBlockButtonStyleModel *submitBtStyleModel = [QSBlockButtonStyleModel alloc];
        submitBtStyleModel.bgColor  = [UIColor colorWithRed:0.471 green:0.176 blue:0.224 alpha:1.000];;
        submitBtStyleModel.title    = @"确定";
        submitBtStyleModel.titleNormalColor = [UIColor whiteColor];
        submitBtStyleModel.cornerRadio = 6.;
        self.submitBt = [UIButton createBlockButtonWithFrame:CGRectMake(12, buttomY, _contentBackgroundView.frame.size.width-12*2, 44) andButtonStyle:submitBtStyleModel andCallBack:^(UIButton *button) {
            
            NSLog(@"submitBtl");
            
            if (![self checkSelected]) {
                UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请选择主食，配饮各一份" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alertview show];
                return ;
            }
            
            [self hidePackageView];
            [self removeFromSuperview];
            if (delegate) {
                [delegate submitPackageWithData:[self getSelectFoodData]];
            }
            
        }];
        [_contentBackgroundView addSubview:_submitBt];
        
        [_contentBackgroundView setFrame:CGRectMake(_contentBackgroundView.frame.origin.x,_contentBackgroundView.frame.origin.y, _contentBackgroundView.frame.size.width, _submitBt.frame.origin.y+_submitBt.frame.size.height+12)];
        
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

- (void)updateFoodData:(id)data
{
    
    [self.packageSelectedFoodData removeAllObjects];
    
    [self.foodNameLabel setText:@""];
    for (UIView *view in [_scrollView subviews]) {
        if (view && [view isKindOfClass:[QSPFoodPackageItemView class]]) {
            [view removeFromSuperview];
        }
    }
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, 100)];
    [_submitBt setFrame:CGRectMake(12, _scrollView.frame.origin.y+_scrollView.frame.size.height, _submitBt.frame.size.width, _submitBt.frame.size.height)];
    [_contentBackgroundView setFrame:CGRectMake(_contentBackgroundView.frame.origin.x,_contentBackgroundView.frame.origin.y, _contentBackgroundView.frame.size.width, _submitBt.frame.origin.y+_submitBt.frame.size.height+12)];
    [_contentBackgroundView setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    
    if (!data || ![data isKindOfClass:[QSGoodsDataModel class]]) {
        return;
    }
    
    QSGoodsDataModel *foodData = (QSGoodsDataModel*)data;
    [self.foodNameLabel setText:foodData.goodsName];
    
    [self.packageSelectedFoodData setObject:foodData.goodsID forKey:@"goods_id"];
    [self.packageSelectedFoodData setObject:[foodData getOnsalePrice] forKey:@"sale_money"];
    [self.packageSelectedFoodData setObject:foodData.goodsName forKey:@"name"];
    [self.packageSelectedFoodData setObject:foodData.shopkeeperID forKey:@"sale_id"];
    [self.packageSelectedFoodData setObject:@"0" forKey:@"num"];
    [self.packageSelectedFoodData setObject:foodData.goodsInstockNum forKey:@"num_instock"];
    
    //套餐列表
    CGFloat scrollViewContentHight = 0.;
    CGFloat scrollViewMaxHeight = SIZE_DEVICE_HEIGHT - 150;

    if (foodData.stapleFoodList&&[foodData.stapleFoodList isKindOfClass:[NSArray class]]&&[foodData.stapleFoodList count]) {
        
        QSPFoodPackageItemView *foodPackageView = [[QSPFoodPackageItemView alloc] initItemViewWithData:foodData.stapleFoodList withTypeName:@"主食"];
        [foodPackageView setTag:101];
        [foodPackageView setFrame:CGRectMake(0, scrollViewContentHight, foodPackageView.frame.size.width, foodPackageView.frame.size.height)];
        [_scrollView addSubview:foodPackageView];
        scrollViewContentHight = foodPackageView.frame.origin.y + foodPackageView.frame.size.height;
        [_scrollView setFrame:CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y, _scrollView.frame.size.width, scrollViewContentHight>scrollViewMaxHeight?scrollViewMaxHeight:scrollViewContentHight)];
        [_scrollView setContentSize:CGSizeMake(_scrollView.contentSize.width, scrollViewContentHight)];
    }
    
    if (foodData.ingredientList&&[foodData.ingredientList isKindOfClass:[NSArray class]]&&[foodData.ingredientList count]) {
        
        QSPFoodPackageItemView *foodPackageView = [[QSPFoodPackageItemView alloc] initItemViewWithData:foodData.ingredientList withTypeName:@"配汤、饮品"];
        [foodPackageView setTag:102];
        [foodPackageView setFrame:CGRectMake(0, scrollViewContentHight, foodPackageView.frame.size.width, foodPackageView.frame.size.height)];
        [_scrollView addSubview:foodPackageView];
        scrollViewContentHight = foodPackageView.frame.origin.y + foodPackageView.frame.size.height;
        [_scrollView setFrame:CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y, _scrollView.frame.size.width, scrollViewContentHight>scrollViewMaxHeight?scrollViewMaxHeight:scrollViewContentHight)];
        [_scrollView setContentSize:CGSizeMake(_scrollView.contentSize.width, scrollViewContentHight)];
    }
    
    [_submitBt setFrame:CGRectMake(12, _scrollView.frame.origin.y+_scrollView.frame.size.height, _submitBt.frame.size.width, _submitBt.frame.size.height)];
    [_contentBackgroundView setFrame:CGRectMake(_contentBackgroundView.frame.origin.x,_contentBackgroundView.frame.origin.y, _contentBackgroundView.frame.size.width, _submitBt.frame.origin.y+_submitBt.frame.size.height+12)];
    [_contentBackgroundView setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    
}

/**
 *  检查选择套餐是否成功
 *
 *  @return YES：成功  NO：不成功
 */
- (BOOL)checkSelected{
    
    BOOL flag = YES;
    for (UIView *view in [_scrollView subviews]) {
        if (view.tag == 101 || view.tag == 102) {
            
            QSPFoodPackageItemView *foodPackageView = (QSPFoodPackageItemView*)view;
            id  tempData = [foodPackageView getSelectFoodData];
            if (!tempData || ![tempData isKindOfClass:[QSGoodsDataSubModel class]]) {
                flag = NO;
            }
        }
    }

    return flag;
}

- (id)getSelectFoodData
{
    
    NSMutableArray *dietList = [NSMutableArray arrayWithCapacity:0];

    [self.packageSelectedFoodData setObject:@"1" forKey:@"num"];
    
    for (UIView *view in [_scrollView subviews]) {
        if (view&&[view isKindOfClass:[QSPFoodPackageItemView class]]) {
            QSPFoodPackageItemView *item = (QSPFoodPackageItemView*)view;
            
            if (view.tag==101) {
                NSMutableDictionary *tempFoodData = [NSMutableDictionary dictionaryWithCapacity:0];
                id  tempData = [item getSelectFoodData];
                if (tempData&&[tempData isKindOfClass:[QSGoodsDataSubModel class]]) {
                    QSGoodsDataSubModel *foodData = (QSGoodsDataSubModel*)tempData;
                    [tempFoodData setObject:foodData.goodsID forKey:@"goods_id"];
                    [tempFoodData setObject:[foodData getOnsalePrice] forKey:@"sale_money"];
                    [tempFoodData setObject:foodData.goodsName forKey:@"name"];
                    [tempFoodData setObject:foodData.shopkeeperID forKey:@"sale_id"];
                    [tempFoodData setObject:@"1" forKey:@"num"];
                    [tempFoodData setObject:foodData.goodsInstockNum forKey:@"num_instock"];
                    [dietList addObject:tempFoodData];
                    
                }else{
                    NSLog(@"%@ 101 [item getSelectFoodData]获取选择菜品失败",self);
                }
                
            }
            if (view.tag==102) {
                
                NSMutableDictionary *tempFoodData = [NSMutableDictionary dictionaryWithCapacity:0];
                id  tempData = [item getSelectFoodData];
                if (tempData&&[tempData isKindOfClass:[QSGoodsDataSubModel class]]) {
                    
                    QSGoodsDataSubModel *foodData = (QSGoodsDataSubModel*)tempData;
                    [tempFoodData setObject:foodData.goodsID forKey:@"goods_id"];
                    [tempFoodData setObject:[foodData getOnsalePrice] forKey:@"sale_money"];
                    [tempFoodData setObject:foodData.goodsName forKey:@"name"];
                    [tempFoodData setObject:foodData.shopkeeperID forKey:@"sale_id"];
                    [tempFoodData setObject:@"1" forKey:@"num"];
                    [tempFoodData setObject:foodData.goodsInstockNum forKey:@"num_instock"];
                    [dietList addObject:tempFoodData];
                    
                }else{
                    NSLog(@"%@ 102 [item getSelectFoodData]获取选择菜品失败",self);
                }
            }
        }
    }
    
    [self.packageSelectedFoodData setObject:dietList forKey:@"diet"];
    
    return _packageSelectedFoodData;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

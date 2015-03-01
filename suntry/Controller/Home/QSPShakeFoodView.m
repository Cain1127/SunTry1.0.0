//
//  QSPShakeFoodView.m
//  suntry
//
//  Created by CoolTea on 15/2/8.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPShakeFoodView.h"
#import "DeviceSizeHeader.h"
#import "QSPFoodCountControlView.h"
#import "NSString+Calculation.h"
#import "QSLabel.h"
#import "ColorHeader.h"
#import "QSBlockButton.h"
#import "UIImageView+CacheImage.h"
#import "QSGoodsDataModel.h"
#import "ImageHeader.h"
#import "QSPShoppingCarView.h"

#define SHAKEVIEW_FOOD_NAME_STRING_FONT_SIZE        20.
#define SHAKEVIEW_FOOD_NAME_STYLE_COLOR             COLOR_HEXCOLOR(0x94414D)
#define SHAKEVIEW_FOOD_NAME_STRING_COLOR            [UIColor colorWithRed:147/255.0 green:149/255.0 blue:151/255.0 alpha:1.]
#define SHAKEVIEW_FOOD_PRICE_ONSALE_STRING_COLOR    COLOR_HEXCOLOR(0x94414D)
#define SHAKEVIEW_FOOD_PRICE_ONSALE_FONT_SIZE       18.
#define SHAKEVIEW_FOOD_PRICE_OLD_FONT_SIZE          SHAKEVIEW_FOOD_PRICE_ONSALE_FONT_SIZE
#define SHAKEVIEW_FOOD_PRICE_OLD_STRING_COLOR       [UIColor colorWithRed:147/255.0 green:149/255.0 blue:151/255.0 alpha:1.]
#define SHAKEVIEW_FOOD_INSTOCK_FONT_SIZE            16.
#define SHAKEVIEW_FOOD_INSTOCK_STRING_COLOR            [UIColor colorWithRed:147/255.0 green:149/255.0 blue:151/255.0 alpha:1.]

@interface QSPShakeFoodView ()<SPFoodCountControlViewDelegate>

@property(nonatomic,strong) QSLabel     *foodTypeLabel;
@property(nonatomic,strong) QSLabel     *foodNameLabel;
@property(nonatomic,strong) UIImageView *contentImgView;
@property(nonatomic,strong) UIImageView *pricemarkIconView;
@property(nonatomic,strong) QSLabel     *priceLabel;
@property(nonatomic,strong) QSLabel     *oldPriceLabel;
@property(nonatomic,strong) QSLabel     *inStockCountLabel;
@property(nonatomic,strong) QSPFoodCountControlView *foodCountControlView;
@property(nonatomic,strong) QSGoodsDataModel *foodData;
@property(nonatomic,strong) NSMutableDictionary *foodDataInCarListFormatDic;

@end

@implementation QSPShakeFoodView
@synthesize delegate, currentViewType;

+ (instancetype)getShakeFoodView
{
    
    static QSPShakeFoodView *shakeFoodView;
    
    if (!shakeFoodView) {
        
        shakeFoodView = [[QSPShakeFoodView alloc] initShakeFoodView];
        
    }
    shakeFoodView.currentViewType = FoodDetailPopViewTypeNormal;
    [shakeFoodView setBackgroundColor:SHAKEVIEW_BACKGROUND_COLOR];
    return shakeFoodView;
    
}

- (instancetype)initShakeFoodView
{
    
    if (self = [super init]) {
        
        self.foodDataInCarListFormatDic = [NSMutableDictionary dictionaryWithCapacity:0];
        
        //半透明背景层
        [self setFrame:CGRectMake(0, 0, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT)];
        
        //背景关闭按钮
        QSBlockButtonStyleModel *bgBtStyleModel = [QSBlockButtonStyleModel alloc];
        UIButton *bgBt = [UIButton createBlockButtonWithFrame:self.frame andButtonStyle:bgBtStyleModel andCallBack:^(UIButton *button) {
            [self hideShakeFoodView];
        }];
        [self addSubview:bgBt];
        
        //中间内容区域层
        UIView *contentBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 345/375.*SIZE_DEVICE_WIDTH, 330/667.*SIZE_DEVICE_HEIGHT)];
        [contentBackgroundView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:contentBackgroundView];
        
        //菜类型元素
        NSString* foodTypeStr = @"";
        CGFloat foodTypeWidth = [foodTypeStr calculateStringDisplayWidthByFixedHeight:14.0 andFontSize:SHAKEVIEW_FOOD_NAME_STRING_FONT_SIZE ]+4;
        self.foodTypeLabel = [[QSLabel alloc] initWithFrame:CGRectMake(13, 10, foodTypeWidth, 20)];
        [self.foodTypeLabel setTextColor:SHAKEVIEW_FOOD_NAME_STYLE_COLOR];
        [self.foodTypeLabel setFont:[UIFont systemFontOfSize:SHAKEVIEW_FOOD_NAME_STRING_FONT_SIZE ]];
        [self.foodTypeLabel setText:foodTypeStr];
        [contentBackgroundView addSubview:self.foodTypeLabel];
        
        //菜名元素
        NSString* foodNameStr = @"";
        CGFloat foodNameWidth = [foodNameStr calculateStringDisplayWidthByFixedHeight:14.0 andFontSize:SHAKEVIEW_FOOD_NAME_STRING_FONT_SIZE ]+4;
        self.foodNameLabel = [[QSLabel alloc] initWithFrame:CGRectMake(self.foodTypeLabel.frame.origin.x+self.foodTypeLabel.frame.size.width, self.foodTypeLabel.frame.origin.y, foodNameWidth, self.foodTypeLabel.frame.size.height)];
        [self.foodNameLabel setTextColor:SHAKEVIEW_FOOD_NAME_STRING_COLOR];
        [self.foodNameLabel setFont:[UIFont systemFontOfSize:SHAKEVIEW_FOOD_NAME_STRING_FONT_SIZE ]];
        [self.foodNameLabel setText:foodNameStr];
        [contentBackgroundView addSubview:self.foodNameLabel];
        
        //关闭按钮
        QSBlockButtonStyleModel *closeStyleModel = [QSBlockButtonStyleModel alloc];
        closeStyleModel.imagesNormal = @"close_button_normal_icon";
        closeStyleModel.imagesHighted = @"close_button_down_icon";
        UIButton *closeBt = [UIButton createBlockButtonWithFrame:CGRectMake(contentBackgroundView.frame.size.width-44, 0, 44, 44) andButtonStyle:closeStyleModel andCallBack:^(UIButton *button) {
            [self hideShakeFoodView];
        }];
        [contentBackgroundView addSubview:closeBt];
        
        //菜展示图
        self.contentImgView = [[UIImageView alloc] initWithFrame:CGRectMake(13.0, self.foodTypeLabel.frame.origin.y+self.foodTypeLabel.frame.size.height+13, 318/375.*SIZE_DEVICE_WIDTH, 217/667.*SIZE_DEVICE_HEIGHT)];
        [self.contentImgView setBackgroundColor:[UIColor clearColor]];
        [contentBackgroundView addSubview:self.contentImgView];
        
        //价格图标
        self.pricemarkIconView = [[UIImageView alloc] initWithFrame:CGRectMake(6.0, self.contentImgView.frame.origin.y+self.contentImgView.frame.size.height, 40, 40)];
        [_pricemarkIconView setImage:[UIImage imageNamed:@"home_pricemark"]];
        [contentBackgroundView addSubview:_pricemarkIconView];
        
        //当前售卖价格
        NSString* priceStr = @"";
        CGFloat priceStrWidth = [priceStr calculateStringDisplayWidthByFixedHeight:14.0 andFontSize:SHAKEVIEW_FOOD_PRICE_ONSALE_FONT_SIZE]+4;
        self.priceLabel = [[QSLabel alloc] initWithFrame:CGRectMake(_pricemarkIconView.frame.origin.x+_pricemarkIconView.frame.size.width-4, _pricemarkIconView.frame.origin.y+10, priceStrWidth, 20)];
        [self.priceLabel setTextColor:SHAKEVIEW_FOOD_PRICE_ONSALE_STRING_COLOR];
        [self.priceLabel setFont:[UIFont systemFontOfSize:SHAKEVIEW_FOOD_PRICE_ONSALE_FONT_SIZE]];
        [self.priceLabel setText:priceStr];
        [contentBackgroundView addSubview:self.priceLabel];
        
        //原价格
        self.oldPriceLabel = [[QSLabel alloc] initWithFrame:CGRectMake(self.priceLabel.frame.origin.x+self.priceLabel.frame.size.width, self.priceLabel.frame.origin.y, 0,  self.priceLabel.frame.size.height)];
        [self.oldPriceLabel setFont:[UIFont systemFontOfSize:SHAKEVIEW_FOOD_PRICE_ONSALE_FONT_SIZE]];
        [contentBackgroundView addSubview:self.oldPriceLabel];
        
        //增加减少菜品数量控件
        self.foodCountControlView = [[QSPFoodCountControlView alloc] initControlView];
        [self.foodCountControlView setMarginTopRight:CGPointMake(contentBackgroundView.frame.size.width-13, self.contentImgView.frame.origin.y+self.contentImgView.frame.size.height+4)];
        [self.foodCountControlView setDelegate:self];
        [contentBackgroundView addSubview:self.foodCountControlView];
        
        //库存
        self.inStockCountLabel = [[QSLabel alloc] initWithFrame:CGRectMake(13.0, _pricemarkIconView.frame.origin.y+_pricemarkIconView.frame.size.height-4, contentBackgroundView.frame.size.width-30, 20)];
        [self.inStockCountLabel setFont:[UIFont systemFontOfSize:SHAKEVIEW_FOOD_INSTOCK_FONT_SIZE]];
        [self.inStockCountLabel setTextColor:SHAKEVIEW_FOOD_INSTOCK_STRING_COLOR];
        [contentBackgroundView addSubview:self.inStockCountLabel];
        
        [contentBackgroundView setFrame:CGRectMake(contentBackgroundView.frame.origin.x, contentBackgroundView.frame.origin.y, contentBackgroundView.frame.size.width, self.inStockCountLabel.frame.origin.y+self.inStockCountLabel.frame.size.height+13)];
        [contentBackgroundView setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    }
    
    [_pricemarkIconView setHidden:YES];
    [_foodCountControlView setHidden:YES];
    
    return self;
    
}

- (void)updateFoodData:(id)data
{
    
    _foodData = nil;
    self.foodDataInCarListFormatDic = [NSMutableDictionary dictionaryWithCapacity:0];
    if (![data isKindOfClass:[QSGoodsDataModel class]]) {
        NSLog(@"随机菜品数据格式错误！");
        return;
    }
    _foodData = (QSGoodsDataModel*)data;
    
    [self.foodDataInCarListFormatDic setObject:_foodData.goodsID forKey:@"goods_id"];
    [self.foodDataInCarListFormatDic setObject:_foodData.goodsName forKey:@"name"];
    [self.foodDataInCarListFormatDic setObject:_foodData.shopkeeperID forKey:@"sale_id"];
    [self.foodDataInCarListFormatDic setObject:[_foodData getOnsalePrice] forKey:@"sale_money"];
    NSMutableArray *subFoodList = [NSMutableArray arrayWithCapacity:0];
    if (_foodData.ingredientList) {
        for (id subfood in _foodData.ingredientList) {
            [subFoodList addObject:subfood];
        }
    }
    if (_foodData.stapleFoodList) {
        for (id subfood in _foodData.stapleFoodList) {
            [subFoodList addObject:subfood];
        }
    }
    [self.foodDataInCarListFormatDic setObject:subFoodList forKey:@"diet"];
    
    [_contentImgView setImage:nil];
    [_foodCountControlView setHidden:YES];
    //菜类型
    NSString* foodTypeStr = _foodData.goodsTypeName;
    CGFloat foodTypeWidth = [foodTypeStr calculateStringDisplayWidthByFixedHeight:14.0 andFontSize:SHAKEVIEW_FOOD_NAME_STRING_FONT_SIZE ]+4;
    [self.foodTypeLabel setFrame:CGRectMake(self.foodTypeLabel.frame.origin.x, self.foodTypeLabel.frame.origin.y, foodTypeWidth, self.foodTypeLabel.frame.size.height)];
    [self.foodTypeLabel setText:foodTypeStr];
    
    //菜名
    NSString* foodNameStr = _foodData.goodsName;
    CGFloat foodNameWidth = [foodNameStr calculateStringDisplayWidthByFixedHeight:14.0 andFontSize:SHAKEVIEW_FOOD_NAME_STRING_FONT_SIZE ]+4;
    
    foodNameWidth = _foodTypeLabel.superview.frame.size.width - self.foodTypeLabel.frame.origin.x-self.foodTypeLabel.frame.size.width - 32;
    
    [self.foodNameLabel setFrame:CGRectMake(self.foodTypeLabel.frame.origin.x+self.foodTypeLabel.frame.size.width, self.foodTypeLabel.frame.origin.y, foodNameWidth, self.foodNameLabel.frame.size.height)];
    [self.foodNameLabel setText:foodNameStr];
    
    //菜展示图
    [self.contentImgView loadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_SERVER_URL,_foodData.goodsImageUrl]] placeholderImage:nil];
    
    [_pricemarkIconView setHidden:NO];
    //当前售卖价格
    NSString* priceStr = [_foodData getOnsalePrice];
    CGFloat priceStrWidth = [priceStr calculateStringDisplayWidthByFixedHeight:14.0 andFontSize:SHAKEVIEW_FOOD_PRICE_ONSALE_FONT_SIZE]+4;
    [self.priceLabel setFrame:CGRectMake(self.priceLabel.frame.origin.x, self.priceLabel.frame.origin.y, priceStrWidth, self.priceLabel.frame.size.height)];
    [self.priceLabel setText:priceStr];
    
    //原价格
    NSString* oldPriceStr = [NSString stringWithFormat:@"原价:￥%@",_foodData.goodsPrice];
    NSDictionary *subStrAttribute = @{
                                      NSForegroundColorAttributeName :SHAKEVIEW_FOOD_PRICE_OLD_STRING_COLOR,
                                      NSStrikethroughStyleAttributeName : @2
                                      } ;
    NSAttributedString *attributedText = [[ NSAttributedString alloc ] initWithString :oldPriceStr attributes :subStrAttribute];
    CGFloat oldPriceWidth = [oldPriceStr calculateStringDisplayWidthByFixedHeight:14.0 andFontSize:SHAKEVIEW_FOOD_PRICE_OLD_FONT_SIZE]+4;
    [self.oldPriceLabel setAttributedText:attributedText];
    [self.oldPriceLabel setFrame:CGRectMake(self.priceLabel.frame.origin.x+self.priceLabel.frame.size.width, self.priceLabel.frame.origin.y, oldPriceWidth, self.oldPriceLabel.frame.size.height)];
    //库存
    NSString* inStockCountStr = [NSString stringWithFormat:@"现有库存：%@份",_foodData.goodsInstockNum];
    [self.inStockCountLabel setText:inStockCountStr];
    if (!_foodData.goodsInstockNum || [_foodData.goodsInstockNum isEqualToString:@""]) {
        [self.inStockCountLabel setHidden:YES];
    }else{
        [self.inStockCountLabel setHidden:NO];
    }
    
    //库存少于0时,或者套餐时隐藏添加减少控件
    if ( 0<=[_foodData.goodsInstockNum integerValue] && ![_foodData.goodsTypeID isEqualToString:@"5"]) {
       
        NSInteger count = [QSPShoppingCarData searchFoodCountInTheCar:_foodData];
        [_foodCountControlView setCount:count];
        NSLog(@"[QSPShoppingCarData searchFoodCountInTheCar:_foodData]:%ld",(long)[QSPShoppingCarData searchFoodCountInTheCar:_foodData]);
        
        [_foodCountControlView setHidden:NO];
    }
    
    if (currentViewType == FoodDetailPopViewTypeShake) {
        [self setFrame:CGRectMake(0, -SIZE_DEVICE_HEIGHT, self.frame.size.width, self.frame.size.height)];
    }
    
}

- (id)getFoodData
{
    
    return _foodData;
    
}

- (void)showShakeFoodView
{
    
    [self setHidden:NO];
    
    if (currentViewType == FoodDetailPopViewTypeNormal) {
        currentViewType = FoodDetailPopViewTypeNormal;
        [self setBackgroundColor:SHAKEVIEW_BACKGROUND_COLOR];
    }else if (currentViewType == FoodDetailPopViewTypeShake) {
        currentViewType = FoodDetailPopViewTypeNormal;
        [self setBackgroundColor:[UIColor clearColor]];
        
        [UIView animateWithDuration:0.3 animations:^{
            [self setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        }];
        
    }
    
}

- (void)hideShakeFoodView
{
    if (self.superview.tag == 111) {
        //隐藏摇一摇界面
        [self.superview setHidden:YES];
    }
    currentViewType = FoodDetailPopViewTypeNormal;
    [self setBackgroundColor:SHAKEVIEW_BACKGROUND_COLOR];
    [self setHidden:YES];
    [self removeFromSuperview];
}

- (void)changedCount:(NSInteger)count
{
    NSLog(@"changedCount:%ld",(long)count);
    [QSPShoppingCarData setShoppingCarDataListWithData:_foodDataInCarListFormatDic withCount:count AddOrSetPackageData:NO];
    if (delegate) {
        [delegate changedWithData:_foodData];
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

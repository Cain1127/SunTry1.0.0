//
//  QSPShoppingCarView.m
//  suntry
//
//  Created by CoolTea on 15/2/9.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPShoppingCarView.h"
#import "DeviceSizeHeader.h"
#import "QSLabel.h"
#import "NSString+Calculation.h"
#import "QSBlockButton.h"
#import "QSGoodsDataModel.h"
#import "QSPShoppingCarView.h"

#define SHOPPING_CAR_VIEW_HEIGHT                        49.
#define SHOPPING_CAR_VIEW_LEFTVIEW_BACKGROUND_COLOR    [UIColor colorWithRed:192/255. green:84/255. blue:100/255. alpha:1]
#define SHOPPING_CAR_VIEW_RIGHTVIEW_BACKGROUND_COLOR   [UIColor colorWithRed:148/255. green:65/255. blue:77/255. alpha:1]
#define SHOPPING_CAR_VIEW_TEXT_FONT_SIZE     17.
#define SHOPPING_CAR_VIEW_COUNT_TEXT_BACKGROUND_COLOR   [UIColor colorWithRed:129/255. green:67/255. blue:78/255. alpha:1]
#define SHOPPING_CAR_VIEW_COUNT_TEXT_FONT_SIZE          12.

#define SHOPPING_CAR_VIEW_RIGHTVIEW_FINAL_BACKGROUND_COLOR   [UIColor colorWithRed:189/255. green:180/255. blue:155/255. alpha:1]

#define SHOPPING_CAR_VIEW_SHIPPING_PRICE                15.

@interface QSPShoppingCarView ()

@property (nonatomic, strong) UIImageView       *shoppingCarIconView;
@property (nonatomic, strong) QSLabel           *leftInfoLabel;
@property (nonatomic, strong) QSLabel           *rightInfoLabel;
@property (nonatomic, strong) UILabel           *countLabel;
@property (nonatomic, strong) UIView            *rightView;
@property (nonatomic, strong) UIButton          *rightButton;
@property (nonatomic, assign) ProcessType       processType;

@end


@implementation QSPShoppingCarView

@synthesize delegate;

- (void)setProcessType:(ProcessType)type
{
    _processType = type;
}

- (instancetype)initShakeFoodView
{
    
    if (self = [super init]) {

        [self setFrame:CGRectMake(0, 0, SIZE_DEVICE_WIDTH, SHOPPING_CAR_VIEW_HEIGHT)];
        [self setBackgroundColor:[UIColor whiteColor]];
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250/375.*SIZE_DEVICE_WIDTH, self.frame.size.height)];
        [leftView setBackgroundColor:SHOPPING_CAR_VIEW_LEFTVIEW_BACKGROUND_COLOR];
        [self addSubview:leftView];
        
        self.rightView = [[UIView alloc] initWithFrame:CGRectMake(leftView.frame.origin.x+leftView.frame.size.width, 0, SIZE_DEVICE_WIDTH-leftView.frame.size.width, self.frame.size.height)];
        [self.rightView setBackgroundColor:SHOPPING_CAR_VIEW_RIGHTVIEW_BACKGROUND_COLOR];
        [self addSubview:self.rightView];
        
        self.shoppingCarIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shopping_car_icon"]];
        [self.shoppingCarIconView setFrame:CGRectMake(16, (self.frame.size.height-self.shoppingCarIconView.frame.size.height)/2, self.shoppingCarIconView.frame.size.width, self.shoppingCarIconView.frame.size.height)];
        
        [self addSubview:self.shoppingCarIconView];
        
        self.leftInfoLabel = [[QSLabel alloc] initWithFrame:CGRectMake(self.shoppingCarIconView.frame.origin.x+self.shoppingCarIconView.frame.size.width, (self.frame.size.height-24)/2, leftView.frame.size.width-(self.shoppingCarIconView.frame.origin.x+self.shoppingCarIconView.frame.size.width), 24)];
        [self.leftInfoLabel setTextColor:[UIColor whiteColor]];
        [self.leftInfoLabel setFont:[UIFont systemFontOfSize:SHOPPING_CAR_VIEW_TEXT_FONT_SIZE]];
        [leftView addSubview:self.leftInfoLabel];
        
        [self.leftInfoLabel setText:@"你的购物车是空的"];
        
        self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.shoppingCarIconView.frame.origin.x+self.shoppingCarIconView.frame.size.width/2, self.shoppingCarIconView.frame.origin.y-8, 0, 16)];
        [self.countLabel setTextColor:[UIColor whiteColor]];
        [self.countLabel setFont:[UIFont systemFontOfSize:SHOPPING_CAR_VIEW_COUNT_TEXT_FONT_SIZE]];
        [[self.countLabel layer] setCornerRadius:self.countLabel.frame.size.height/2.];
        [[self.countLabel layer] setMasksToBounds:YES];
        [self.countLabel setTextAlignment:NSTextAlignmentCenter];
        [self.countLabel setBackgroundColor:SHOPPING_CAR_VIEW_COUNT_TEXT_BACKGROUND_COLOR];
        
        [self addSubview:self.countLabel];
        
        self.rightInfoLabel = [[QSLabel alloc] initWithFrame:CGRectMake(0, self.leftInfoLabel.frame.origin.y, self.rightView.frame.size.width, 24)];
        [self.rightInfoLabel setTextColor:[UIColor whiteColor]];
        [self.rightInfoLabel setTextAlignment:NSTextAlignmentCenter];
        [self.rightInfoLabel setFont:[UIFont systemFontOfSize:SHOPPING_CAR_VIEW_TEXT_FONT_SIZE]];
        [self.rightView addSubview:self.rightInfoLabel];
        
//        [self.rightInfoLabel setText:@"￥20起配送"];
        
        self.rightButton = [UIButton createBlockButtonWithFrame:CGRectMake((_rightInfoLabel.frame.size.width-90)/2, (_rightInfoLabel.frame.size.height-44)/2, 90, 44) andButtonStyle:nil andCallBack:^(UIButton *button) {
            if (delegate) {
                [delegate orderWithData:[QSPShoppingCarData getShoppingCarDataList]];
            }
        }];
        [self.rightInfoLabel setUserInteractionEnabled:YES];
        [self.rightInfoLabel addSubview:_rightButton];
        [_rightButton setHidden:YES];
    }
    
    return self;
    
}

- (void)updateShoppingCar
{
    
    [_shoppingCarIconView setHidden:NO];
    [_rightButton setHidden:YES];
    [_countLabel setHidden:NO];
    NSArray *goodListInShoppingCar = [QSPShoppingCarData getShoppingCarDataList];
    NSInteger goodCount = [goodListInShoppingCar count];
    
    CGFloat currentPrice = 0;
    NSInteger totalCount = 0;
    
    if (goodCount>0) {
        
        for (int i=0; i<[goodListInShoppingCar count]; i++) {
            
            NSDictionary *tempDic = goodListInShoppingCar[i];
            if (tempDic) {
                //计算数量
                NSInteger perCount = [[tempDic objectForKey:@"num"] integerValue];
                totalCount += perCount;
//                //计算总额
                NSString *priceStr = [tempDic objectForKey:@"sale_money"];
                if (priceStr&&[priceStr isKindOfClass:[NSString class]]) {
                    currentPrice += (priceStr.floatValue * perCount);
                }
                
            }
        }
        
        NSString *countStr = [NSString stringWithFormat:@"%ld",(long)totalCount];
        //计算价格Label宽度
        CGFloat countStrWidth = [countStr calculateStringDisplayWidthByFixedHeight:14.0 andFontSize:SHOPPING_CAR_VIEW_COUNT_TEXT_FONT_SIZE];
        if (countStrWidth < 16) {
            countStrWidth = 16;
        }
        
        [self.countLabel setText:countStr];
        [self.countLabel setFrame:CGRectMake(self.countLabel.frame.origin.x, self.countLabel.frame.origin.y, countStrWidth, self.countLabel.frame.size.height)];
        [self.countLabel setHidden:NO];
        
        [self.leftInfoLabel setFrame:CGRectMake(_shoppingCarIconView.frame.origin.x+_shoppingCarIconView.frame.size.width, (self.frame.size.height-24)/2, (self.frame.size.width - _rightView.frame.size.width)-(_shoppingCarIconView.frame.origin.x+_shoppingCarIconView.frame.size.width), 24)];
        
        [self.leftInfoLabel setText:[NSString stringWithFormat:@"共￥%.2f",currentPrice]];
        
        if (SHOPPING_CAR_VIEW_SHIPPING_PRICE-currentPrice>0) {
            
            if (currentPrice==0) {
                
                [self.rightInfoLabel setText:[NSString stringWithFormat:@"￥%.f起配送",SHOPPING_CAR_VIEW_SHIPPING_PRICE]];
                
            }else{
                
                [self.rightInfoLabel setText:[NSString stringWithFormat:@"差￥%.2f配送", SHOPPING_CAR_VIEW_SHIPPING_PRICE-currentPrice]];
                
            }
            [self.rightView setBackgroundColor:SHOPPING_CAR_VIEW_RIGHTVIEW_BACKGROUND_COLOR];
            
        }else{
            
            [self.rightInfoLabel setText:@"选好了"];
            [self.rightView setBackgroundColor:SHOPPING_CAR_VIEW_RIGHTVIEW_FINAL_BACKGROUND_COLOR];
            [_rightButton setHidden:NO];
        }
        
    }else{
        
        [self.countLabel setHidden:YES];
        [self.leftInfoLabel setText:@"你的购物车是空的"];
        [self.rightInfoLabel setText:[NSString stringWithFormat:@"￥%.f起配送",SHOPPING_CAR_VIEW_SHIPPING_PRICE]];
        [self.rightView setBackgroundColor:SHOPPING_CAR_VIEW_RIGHTVIEW_BACKGROUND_COLOR];
    }
    
    if (ProcessTypeOnSubmitOrder == _processType) {
        
        [self.shoppingCarIconView setHidden:YES];
        
        [self.leftInfoLabel setFrame:CGRectMake(_shoppingCarIconView.frame.origin.x, (self.frame.size.height-24)/2, (self.frame.size.width - _rightView.frame.size.width), 24)];
        [self.leftInfoLabel setText:[NSString stringWithFormat:@"%ld份菜品,共￥%.2f",(long)totalCount,currentPrice]];
        
        [_countLabel setHidden:YES];
        
        if (SHOPPING_CAR_VIEW_SHIPPING_PRICE-currentPrice>0) {
            
            if (currentPrice==0) {
                
                [self.rightInfoLabel setText:[NSString stringWithFormat:@"￥%.f起配送",SHOPPING_CAR_VIEW_SHIPPING_PRICE]];
                
            }else{
                
                [self.rightInfoLabel setText:[NSString stringWithFormat:@"差￥%.2f配送", SHOPPING_CAR_VIEW_SHIPPING_PRICE-currentPrice]];
                
            }
            [self.rightView setBackgroundColor:SHOPPING_CAR_VIEW_RIGHTVIEW_BACKGROUND_COLOR];
            
        }else{
            
            [self.rightInfoLabel setText:@"确定下单"];
            [self.rightView setBackgroundColor:SHOPPING_CAR_VIEW_RIGHTVIEW_FINAL_BACKGROUND_COLOR];
            [_rightButton setHidden:NO];
            
        }
    }
    
}

- (void)changeGoods:(id)goodData withCount:(NSInteger)count
{
    
    [QSPShoppingCarData setShoppingCarDataListWithData:goodData withCount:count AddOrSetPackageData:(ProcessTypeOnSelectedFood==_processType)];
    [self updateShoppingCar];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

/////////////////////////////////

#define     SUNTRY_SHOPPING_CAR_DATA_LIST      @"suntry_shopping_car_data_list"

@implementation QSPShoppingCarData

+ (NSArray*)getShoppingCarDataList
{
    NSArray *array = [[NSUserDefaults standardUserDefaults] arrayForKey:SUNTRY_SHOPPING_CAR_DATA_LIST];
    if (!array) {
        array = [NSArray array];
    }
    return array;
}

+ (void)setShoppingCarDataListWithArray:(NSArray*)list
{
    if (list&&[list isKindOfClass:[NSArray class]]) {
        [[NSUserDefaults standardUserDefaults] setObject:list forKey:SUNTRY_SHOPPING_CAR_DATA_LIST];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void)setShoppingCarDataListWithData:(NSDictionary*)data withCount:(NSInteger)count AddOrSetPackageData:(BOOL)flag
{
    NSArray *oldArray = [self getShoppingCarDataList];
    NSMutableArray *goodListInShoppingCar = [NSMutableArray arrayWithCapacity:0];
    for (int i=0; i<[oldArray count]; i++) {
        NSDictionary *tempDic = oldArray[i];
        if (tempDic&&[tempDic isKindOfClass:[NSDictionary class]]) {
            [goodListInShoppingCar addObject:[NSMutableDictionary dictionaryWithDictionary:tempDic]];
        }
    }
    
    if (!data||!([data isKindOfClass:[NSDictionary class]])) {
        NSLog(@"购物车接受菜品数据格式出错！");
        return;
    }
    
    NSDictionary *foodData = (NSDictionary*)data;
    
    if ([goodListInShoppingCar count] == 0) {
        
        NSMutableDictionary *itemDic = [NSMutableDictionary dictionaryWithDictionary:foodData];
        [itemDic setObject:[NSString stringWithFormat:@"%ld",(long)count] forKey:@"num"];
        [goodListInShoppingCar addObject:itemDic];
        
    }else{
        
        BOOL hadGood = NO;
        NSMutableDictionary *tempDic;
        for (int i=0; i<[goodListInShoppingCar count]; i++) {
            tempDic = goodListInShoppingCar[i];
            if (tempDic&&[tempDic isKindOfClass:[NSDictionary class]]) {
                
                NSString *subGoodID = [tempDic objectForKey:@"goods_id"];
                NSString *currentGoodID = [foodData objectForKey:@"goods_id"];
                if (subGoodID && currentGoodID &&[currentGoodID isEqualToString:subGoodID]) {
                    
                    //判断是不是套餐数据
                    BOOL isPackage = NO;
                    id dietData = [tempDic objectForKey:@"diet"];
                    if (dietData && [dietData isKindOfClass:[NSArray class]]) {
                        NSArray *dietList = (NSArray*)dietData;
                        if ([dietList count]>0) {
                            //套餐时
                            isPackage = YES;
                            id dietCurrentData = [foodData objectForKey:@"diet"];
                            if (dietCurrentData && [dietCurrentData isKindOfClass:[NSArray class]]) {
                                NSArray *dietCurrentList = (NSArray*)dietCurrentData;
                                if ([dietCurrentList count] == [dietList count]) {
                                    BOOL isTheSame = YES;
                                    for (int i=0; i<[dietList count]; i++) {
                                        
                                        NSString *tempGoodID = [dietCurrentList[i] objectForKey:@"goods_id"];
                                        NSString *currentTempGoodID = [dietList[i] objectForKey:@"goods_id"];
                                        
                                        if (!tempGoodID || !currentTempGoodID ||![currentTempGoodID isEqualToString:tempGoodID]) {
                                            isTheSame = NO;
                                        }
                                    }
                                    
                                    if (isTheSame) {
                                        hadGood = YES;
                                        if (flag) {
                                            NSString *oldCountStr = [tempDic objectForKey:@"num"];
                                            count += oldCountStr.integerValue;
                                        }else{
                                            
                                        }
                                        break;
                                    }
                                }
                            }
                        }
                    }
                    
                    if (!isPackage) {
                        //单品
                        hadGood = YES;
                        break;
                    }
                }
            }
        }
        
        if (hadGood) {
            [tempDic setObject:[NSString stringWithFormat:@"%ld",(long)count] forKey:@"num"];
            if (0==count) {
                [goodListInShoppingCar removeObject:tempDic];
            }
        }else{
            NSMutableDictionary *itemDic = [NSMutableDictionary dictionaryWithDictionary:foodData];
            [itemDic setObject:[NSString stringWithFormat:@"%ld",(long)count] forKey:@"num"];
            if (0!=count) {
                [goodListInShoppingCar addObject:itemDic];
            }
        }
    }

    [self setShoppingCarDataListWithArray:goodListInShoppingCar];
}

+ (void)clearShoopingCar
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:SUNTRY_SHOPPING_CAR_DATA_LIST];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (CGFloat)getTotalPrice
{
    CGFloat totalPrice = 0.;
    NSArray *foodArray = [self getShoppingCarDataList];
    for (NSDictionary *item in foodArray) {
        NSString *countStr = [item objectForKey:@"num"];
        NSString *perPriceStr = [item objectForKey:@"sale_money"];
        totalPrice += (perPriceStr.floatValue * countStr.intValue);
    }
    return totalPrice;
}

+ (NSInteger)getTotalFoodCount
{
    NSInteger totalCount = 0;
    NSArray *foodArray = [self getShoppingCarDataList];
    for (NSDictionary *item in foodArray) {
        NSString *countStr = [item objectForKey:@"num"];
        totalCount += countStr.intValue;
    }
    return totalCount;
}

+ (NSInteger)searchFoodCountInTheCar:(QSGoodsDataModel*)foodData
{
    //转换QSGoodsDataModel为购物车的菜品字典格式
    NSMutableDictionary *foodDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [foodDic setObject:foodData.goodsID forKey:@"goods_id"];
    [foodDic setObject:foodData.goodsName forKey:@"name"];
    [foodDic setObject:foodData.shopkeeperID forKey:@"sale_id"];
    [foodDic setObject:[foodData getOnsalePrice] forKey:@"sale_money"];
    NSMutableArray *subFoodList = [NSMutableArray arrayWithCapacity:0];
    if (foodData.ingredientList) {
        for (id subfood in foodData.ingredientList) {
            [subFoodList addObject:subfood];
        }
    }
    if (foodData.stapleFoodList) {
        for (id subfood in foodData.stapleFoodList) {
            [subFoodList addObject:subfood];
        }
    }
    [foodDic setObject:subFoodList forKey:@"diet"];
    
    
    NSInteger count = 0;
    BOOL hadGood = NO;
    NSArray *goodListInShoppingCar = [self getShoppingCarDataList];

    NSDictionary *tempDic;
    for (int i=0; i<[goodListInShoppingCar count]; i++) {
        tempDic = goodListInShoppingCar[i];
        if (tempDic&&[tempDic isKindOfClass:[NSDictionary class]]) {
            
            NSString *subGoodID = [tempDic objectForKey:@"goods_id"];
            NSString *currentGoodID = [foodDic objectForKey:@"goods_id"];
            if (subGoodID && currentGoodID &&[currentGoodID isEqualToString:subGoodID]) {
                
                //判断是不是套餐数据
                BOOL isPackage = NO;
                id dietData = [tempDic objectForKey:@"diet"];
                if (dietData && [dietData isKindOfClass:[NSArray class]]) {
                    NSArray *dietList = (NSArray*)dietData;
                    if ([dietList count]>0) {
                        //套餐时
                        isPackage = YES;
                        id dietCurrentData = [foodDic objectForKey:@"diet"];
                        if (dietCurrentData && [dietCurrentData isKindOfClass:[NSArray class]]) {
                            NSArray *dietCurrentList = (NSArray*)dietCurrentData;
                            if ([dietCurrentList count] == [dietList count]) {
                                BOOL isTheSame = YES;
                                for (int i=0; i<[dietList count]; i++) {
                                    
                                    NSString *tempGoodID = [dietCurrentList[i] objectForKey:@"goods_id"];
                                    NSString *currentTempGoodID = [dietList[i] objectForKey:@"goods_id"];
                                    
                                    if (!tempGoodID || !currentTempGoodID ||![currentTempGoodID isEqualToString:tempGoodID]) {
                                        isTheSame = NO;
                                    }
                                }
                                
                                if (isTheSame) {
                                    hadGood = YES;
                                    break;
                                }
                            }
                        }
                    }
                }
                
                if (!isPackage) {
                    //单品
                    hadGood = YES;
                    break;
                }
            }
        }
    }
    
    if (hadGood) {
        NSString * countStr = [tempDic objectForKey:@"num"];
        if (countStr&&[countStr isKindOfClass:[NSString class]]) {
            count = countStr.integerValue;
        }
    }
    
    return count;
}

@end



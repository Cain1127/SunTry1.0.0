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

#define SHOPPING_CAR_VIEW_HEIGHT                        49.
#define SHOPPING_CAR_VIEW_LEFTVIEW_BACKGROUND_COLOR    [UIColor colorWithRed:192/255. green:84/255. blue:100/255. alpha:1]
#define SHOPPING_CAR_VIEW_RIGHTVIEW_BACKGROUND_COLOR   [UIColor colorWithRed:148/255. green:65/255. blue:77/255. alpha:1]
#define SHOPPING_CAR_VIEW_TEXT_FONT_SIZE     17.
#define SHOPPING_CAR_VIEW_COUNT_TEXT_BACKGROUND_COLOR   [UIColor colorWithRed:129/255. green:67/255. blue:78/255. alpha:1]
#define SHOPPING_CAR_VIEW_COUNT_TEXT_FONT_SIZE          12.

#define SHOPPING_CAR_VIEW_RIGHTVIEW_FINAL_BACKGROUND_COLOR   [UIColor colorWithRed:189/255. green:180/255. blue:155/255. alpha:1]

#define SHOPPING_CAR_VIEW_SHIPPING_PRICE                20.

@interface QSPShoppingCarView ()

@property (nonatomic, strong) UIImageView       *shoppingCarIconView;
@property (nonatomic, strong) QSLabel           *leftInfoLabel;
@property (nonatomic, strong) QSLabel           *rightInfoLabel;
@property (nonatomic, strong) NSMutableArray    *goodListInShoppingCar;
@property (nonatomic, strong) UILabel           *countLabel;
@property (nonatomic, strong) UIView            *rightView;
@property (nonatomic, strong) UIButton          *rightButton;
@property (nonatomic, assign) ProcessType       processType;

@end


@implementation QSPShoppingCarView

@synthesize delegate;

//+ (instancetype)getShoppingCarView
//{
//    
//    static QSPShoppingCarView *shoppingCarView;
//    
//    if (!shoppingCarView) {
//        
//        shoppingCarView = [[QSPShoppingCarView alloc] initShakeFoodView];
//        
//    }
//    
//    return shoppingCarView;
//    
//}

- (void)setProcessType:(ProcessType)type
{
    _processType = type;
}

- (instancetype)initShakeFoodView
{
    
    if (self = [super init]) {

        self.goodListInShoppingCar = [NSMutableArray arrayWithCapacity:0];
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
        
        [self.rightInfoLabel setText:@"￥24起配送"];
        
        self.rightButton = [UIButton createBlockButtonWithFrame:CGRectMake((_rightInfoLabel.frame.size.width-80)/2, (_rightInfoLabel.frame.size.height-44)/2, 80, 44) andButtonStyle:nil andCallBack:^(UIButton *button) {
            if (delegate) {
                [delegate orderWithData:_goodListInShoppingCar];
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
    NSInteger goodCount = [self.goodListInShoppingCar count];
    
    CGFloat currentPrice = 0;
    NSInteger totalCount = 0;
    
    if (goodCount>0) {
        
        ;
        for (int i=0; i<[_goodListInShoppingCar count]; i++) {
            
            NSDictionary *tempDic = _goodListInShoppingCar[i];
            if (tempDic) {
                NSInteger perCount = [[tempDic objectForKey:@"count"] integerValue];
                totalCount += perCount;
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
        
        currentPrice = totalCount * 8.88;
        
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
        [self.rightInfoLabel setText:@"￥20起配送"];
        
    }
    
    if (ProcessTypeOnSubmitOrder == _processType) {
        
        [self.shoppingCarIconView setHidden:YES];
        
        [self.leftInfoLabel setFrame:CGRectMake(_shoppingCarIconView.frame.origin.x, (self.frame.size.height-24)/2, (self.frame.size.width - _rightView.frame.size.width), 24)];
        [self.leftInfoLabel setText:[NSString stringWithFormat:@"%ld份菜品,共￥%.2f",totalCount,currentPrice]];
        
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

- (void)addGood:(id)goodData
{
    
    [self.goodListInShoppingCar addObject:goodData];
    
}

- (void)removeGood:(id)goodData
{
    
    [self.goodListInShoppingCar removeObject:goodData];
    
}

- (NSArray*)getGoods
{
    
    return _goodListInShoppingCar;
    
}

- (void)clearShoopingCar
{
    
    [self.goodListInShoppingCar removeAllObjects];
    
}

- (void)changeGoods:(id)goodData withCount:(NSInteger)count
{
    
    if (!_goodListInShoppingCar) {
        self.goodListInShoppingCar = [NSMutableArray arrayWithCapacity:0];
    }
    
    if ([_goodListInShoppingCar count] == 0) {
        
        //FIXME:添加进空购物车需修复，以下暂做测试
        NSMutableDictionary *itemDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:goodData,@"foodName",[NSNumber numberWithInt:(int)count],@"count",nil];
        [_goodListInShoppingCar addObject:itemDic];
        
    }else{
        
        //FIXME:添加进购物车需修复，以下暂做测试
        BOOL hadGood = NO;
        for (int i=0; i<[_goodListInShoppingCar count]; i++) {
            NSMutableDictionary *tempDic = _goodListInShoppingCar[i];
            if (tempDic) {
                //FIXME:这个判断是个坑，以实际数据关键Key为准。
                if ([goodData isEqualToString:[tempDic objectForKey:@"foodName"]]) {
                    hadGood = YES;
                    [tempDic setObject:[NSNumber numberWithInt:(int)(count)] forKey:@"count"];
                }
            }
        }
        
        if (NO==hadGood) {
            NSMutableDictionary *itemDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:goodData,@"foodName",[NSNumber numberWithInt:(int)count],@"count",nil];
            [_goodListInShoppingCar addObject:itemDic];
        }
        
    }
    
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

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

#define SHOPPING_CAR_VIEW_HEIGHT                        49.
#define SHOPPING_CAR_VIEW_LEFTVIEW_BACKGROUND_COLOR    [UIColor colorWithRed:192/255. green:84/255. blue:100/255. alpha:1]
#define SHOPPING_CAR_VIEW_RIGHTVIEW_BACKGROUND_COLOR   [UIColor colorWithRed:148/255. green:65/255. blue:77/255. alpha:1]
#define SHOPPING_CAR_VIEW_TEXT_FONT_SIZE     17.
#define SHOPPING_CAR_VIEW_COUNT_TEXT_BACKGROUND_COLOR   [UIColor colorWithRed:129/255. green:67/255. blue:78/255. alpha:1]
#define SHOPPING_CAR_VIEW_COUNT_TEXT_FONT_SIZE          12.

#define SHOPPING_CAR_VIEW_RIGHTVIEW_FINAL_BACKGROUND_COLOR   [UIColor colorWithRed:189/255. green:180/255. blue:155/255. alpha:1]

@interface QSPShoppingCarView ()

@property (nonatomic, strong) UIImageView       *shoppingCarIconView;
@property (nonatomic, strong) QSLabel           *leftInfoLabel;
@property (nonatomic, strong) QSLabel           *rightInfoLabel;
@property (nonatomic, strong) NSMutableArray    *goodListInShoppingCar;
@property (nonatomic, strong) UILabel           *countLabel;
@property (nonatomic, strong) UIView            *rightView;

@end


@implementation QSPShoppingCarView

+ (instancetype)getshoppingCarView
{
    
    static QSPShoppingCarView *shoppingCarView;
    
    if (!shoppingCarView) {
        
        shoppingCarView = [[QSPShoppingCarView alloc] initShakeFoodView];
        
    }
    
    return shoppingCarView;
    
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
    }
    
    return self;
    
}

- (void)updateShoppingCar
{
    
    self.goodListInShoppingCar = [NSArray arrayWithObjects:@"",@"",@"",@"",@"", nil];
    
    NSInteger goodCount = [self.goodListInShoppingCar count];
    
    if (goodCount>0) {
        
        NSString *countStr = [NSString stringWithFormat:@"%ld",(long)goodCount];
        //计算价格Label宽度
        CGFloat countStrWidth = [countStr calculateStringDisplayWidthByFixedHeight:14.0 andFontSize:SHOPPING_CAR_VIEW_COUNT_TEXT_FONT_SIZE];
        if (countStrWidth < 16) {
            countStrWidth = 16;
        }
        
        [self.countLabel setText:countStr];
        [self.countLabel setFrame:CGRectMake(self.countLabel.frame.origin.x, self.countLabel.frame.origin.y, countStrWidth, self.countLabel.frame.size.height)];
        [self.countLabel setHidden:NO];
        
        CGFloat currentPrice = 12.8965;
        
        [self.leftInfoLabel setText:[NSString stringWithFormat:@"共￥%.2f",currentPrice]];
        
        CGFloat shippingPrice = 20.;
        
        if (shippingPrice-currentPrice>0) {
            
            if (currentPrice==0) {
                
                [self.rightInfoLabel setText:[NSString stringWithFormat:@"￥%.f起配送",shippingPrice]];
                
            }else{
                
                [self.rightInfoLabel setText:[NSString stringWithFormat:@"差￥%.2f配送",shippingPrice-currentPrice]];
                
            }
            [self.rightView setBackgroundColor:SHOPPING_CAR_VIEW_RIGHTVIEW_BACKGROUND_COLOR];
            
        }else{
            
            [self.rightInfoLabel setText:@"选好了"];
            [self.rightView setBackgroundColor:SHOPPING_CAR_VIEW_RIGHTVIEW_FINAL_BACKGROUND_COLOR];
            
        }
        
    }else{
        
        [self.countLabel setHidden:YES];
        [self.leftInfoLabel setText:@"你的购物车是空的"];
        [self.rightInfoLabel setText:@"￥24起配送"];
        
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

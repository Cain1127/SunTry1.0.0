//
//  QSPFoodCountControlView.m
//  suntry
//
//  Created by CoolTea on 15/2/7.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPFoodCountControlView.h"
#import "NSString+Calculation.h"
#import "QSBlockButton.h"

#define FOOD_COUNT_FONT_SIZE  18.
#define FOOD_COUNT_LABEL_NORMAL_HEIGHT  22.
#define FOOD_COUNT_MAX_COUNT  999

@interface QSPFoodCountControlView ()

@property(nonatomic,assign) CGPoint     marginTopRight;//相对父View右上点距
@property(nonatomic,assign) NSInteger   countInt;//选择该菜的数量
@property(nonatomic,strong) UILabel     *countLabel;
@property(nonatomic,strong) UIButton    *addBt;
@property(nonatomic,strong) UIButton    *reduceBt;
@property(nonatomic,assign) BOOL        OnlyShowAddButton;

@end

@implementation QSPFoodCountControlView

@synthesize delegate;

- (instancetype)initControlView
{
    
    if (self = [super init]) {
        _OnlyShowAddButton = NO;
        self.marginTopRight = CGPointZero;
        [self setFrame:CGRectMake(0, 0, 104, 44)];
        //增加按钮
        QSBlockButtonStyleModel *addBtStyleModel = [QSBlockButtonStyleModel alloc];
        addBtStyleModel.imagesNormal = @"food_count_add_normal_bt";
        addBtStyleModel.imagesHighted = @"food_count_add_down_bt";
        self.addBt = [UIButton createBlockButtonWithFrame:CGRectMake(self.frame.size.width-46, 0, 44, 44) andButtonStyle:addBtStyleModel andCallBack:^(UIButton *button) {
            
            [self setCount:++self.countInt];
            
            if (delegate) {
                
                [delegate changedCount:_countInt];
                
            }
            
        }];
        
        self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.addBt.frame.origin.x-FOOD_COUNT_LABEL_NORMAL_HEIGHT, (self.frame.size.height-FOOD_COUNT_LABEL_NORMAL_HEIGHT)/2, 0, FOOD_COUNT_LABEL_NORMAL_HEIGHT)];
        [self.countLabel setTextColor:[UIColor blackColor]];
        [self.countLabel setFont:[UIFont systemFontOfSize:FOOD_COUNT_FONT_SIZE]];
        [[self.countLabel layer] setCornerRadius:self.countLabel.frame.size.height/2.];
        [[self.countLabel layer] setMasksToBounds:YES];
        [self.countLabel setTextAlignment:NSTextAlignmentCenter];
        [self.countLabel setBackgroundColor:[UIColor colorWithRed:230/255. green:230/255. blue:230/255. alpha:1]];
        [self addSubview:self.countLabel];
        [self addSubview:self.addBt];
        //减少按钮
        QSBlockButtonStyleModel *reduceBtStyleModel = [QSBlockButtonStyleModel alloc];
        reduceBtStyleModel.imagesNormal = @"food_count_reduce_normal_bt";
        reduceBtStyleModel.imagesHighted = @"food_count_reduce_down_bt";
        self.reduceBt = [UIButton createBlockButtonWithFrame:CGRectMake(self.countLabel.frame.origin.x-self.countLabel.frame.size.width-6, 0, 44, 44) andButtonStyle:reduceBtStyleModel andCallBack:^(UIButton *button) {
            
            [self setCount:--self.countInt];
            
            if (delegate) {
                
                [delegate changedCount:_countInt];
                
            }
            
        }];
        [self addSubview:self.reduceBt];
        [self setCount:0];
        
    }
    
    return self;
    
}

- (void)updateFrame
{
    
    [self setFrame:CGRectMake(_marginTopRight.x-self.frame.size.width, _marginTopRight.y, self.frame.size.width, self.frame.size.height)];
    
}

- (void)setMarginTopRight:(CGPoint)topRight
{
    
    _marginTopRight = topRight;
    [self updateFrame];
    
}

- (NSInteger)getCount
{
    
    return self.countInt;
    
}

- (void)setCount:(NSInteger)count
{
    
    self.countInt = count;
    [self updateFrame];
    
    if (self.countInt<=0) {
        
        self.countInt = 0;
        [self.countLabel setHidden:YES];
        [self.reduceBt setHidden:YES];
        
    }else{
        
        if (self.countInt>FOOD_COUNT_MAX_COUNT) {
            
            self.countInt=FOOD_COUNT_MAX_COUNT;
            
        }
        [self.countLabel setHidden:NO];
        [self.reduceBt setHidden:NO];
        
    }
    
    //当前添加的数量
    NSString *countStr = [NSString stringWithFormat:@"%ld",(long)self.countInt];
    //计算价格Label宽度
    CGFloat countStrWidth = [countStr calculateStringDisplayWidthByFixedHeight:self.countLabel.frame.size.height andFontSize:FOOD_COUNT_FONT_SIZE];
    if (countStrWidth < FOOD_COUNT_LABEL_NORMAL_HEIGHT) {
        countStrWidth = FOOD_COUNT_LABEL_NORMAL_HEIGHT;
    }
    [self.countLabel setText:countStr];
    [self.countLabel setFrame:CGRectMake(self.addBt.frame.origin.x-countStrWidth+6, (self.frame.size.height-self.countLabel.frame.size.height)/2, countStrWidth, self.countLabel.frame.size.height)];
    
    CGFloat offsetX = 0.;
    if (countStr.length>=3) {
        offsetX = 8*(countStr.length-2);
    }
    [self.reduceBt setFrame:CGRectMake(self.countLabel.frame.origin.x-self.countLabel.frame.size.width-16+offsetX, self.reduceBt.frame.origin.y, self.reduceBt.frame.size.width, self.reduceBt.frame.size.height)];
    
    if (_OnlyShowAddButton) {
        [_reduceBt setHidden:YES];
        [_countLabel setHidden:YES];
    }
}

- (void)setOnlyShowAddButton:(BOOL)flag
{
    _OnlyShowAddButton = flag;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

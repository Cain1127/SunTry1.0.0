//
//  QSPItemSelectePopView.m
//  suntry
//
//  Created by CoolTea on 15/3/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPItemSelectePopView.h"
#import "DeviceSizeHeader.h"
#import "NSString+Calculation.h"
#import "QSLabel.h"
#import "QSBlockButton.h"
#import "QSPAddNewAddressTextField.h"

#define ITEM_SELECT_VIEW_BACKGROUND_COLOR                  [UIColor colorWithWhite:0 alpha:0.6]
#define ITEM_SELECT_VIEW_FOOD_NAME_STRING_FONT_SIZE        17.
#define ITEM_SELECT_VIEW_FOOD_NAME_TEXT_COLOR             [UIColor colorWithRed:0.505 green:0.513 blue:0.525 alpha:1.000]


@interface QSPItemSelectePopView ()

@property(nonatomic,strong) UIScrollView            *contentBackgroundView;
@property(nonatomic,strong) NSMutableDictionary     *packageSelectedFoodData;

@end

@implementation QSPItemSelectePopView

@synthesize delegate;

+ (instancetype)getItemSelectePopView
{
    
    static QSPItemSelectePopView *selectView;
    
    if (!selectView) {
        
        selectView = [[QSPItemSelectePopView alloc] initItemSelectePopView];
        
    }
    
    return selectView;
    
}

- (instancetype)initItemSelectePopView
{
    
    if (self = [super init]) {
        
        self.packageSelectedFoodData = [NSMutableDictionary dictionaryWithCapacity:0];
        
        //半透明背景层
        [self setFrame:CGRectMake(0, 0, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT)];
        [self setBackgroundColor:ITEM_SELECT_VIEW_BACKGROUND_COLOR];
        
        //背景关闭按钮
        QSBlockButtonStyleModel *bgBtStyleModel = [QSBlockButtonStyleModel alloc];
        UIButton *bgBt = [UIButton createBlockButtonWithFrame:self.frame andButtonStyle:bgBtStyleModel andCallBack:^(UIButton *button) {
            [self hideItemSelectePopView];
            [self removeFromSuperview];
        }];
        [self addSubview:bgBt];

        
        //中间内容区域层
        self.contentBackgroundView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 345/375.*SIZE_DEVICE_WIDTH, 469/667.*SIZE_DEVICE_HEIGHT)];
        [self.contentBackgroundView setBackgroundColor:[UIColor whiteColor]];
        [self.contentBackgroundView.layer setCornerRadius:5.];
        [self.contentBackgroundView setShowsVerticalScrollIndicator:NO];
        [self addSubview:_contentBackgroundView];
        
        [_contentBackgroundView setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
        
    }
    
    return self;
    
}

- (void)showItemSelectePopView
{
    
    [self setHidden:NO];
    
}

- (void)hideItemSelectePopView
{
    
    [self setHidden:YES];
    
}

- (void)updateSelectData:(NSArray*)arrayData
{
    
    [self.packageSelectedFoodData removeAllObjects];
    
    for (UIView *view in [self.contentBackgroundView subviews]) {
        if (view.tag >= 1000) {
            [view removeFromSuperview];
        }
    }
    
    CGFloat scrollViewMaxHeight = SIZE_DEVICE_HEIGHT - 150;
    
    if (arrayData&&[arrayData isKindOfClass:[NSArray class]]) {
        for (int i=0;i<[arrayData count];i++) {
            
            //FIXME: 元素的名字
            NSString *itemName = [arrayData objectAtIndex:i];
            
            UIView *itembgView = [[UIView alloc] initWithFrame:CGRectMake(2, 2+(44+2)*i, self.contentBackgroundView.frame.size.width-5, 44)];
            [itembgView setUserInteractionEnabled:YES];
            [self.contentBackgroundView addSubview:itembgView];
            [itembgView setTag:1000+i];
            
            QSPAddNewAddressTextField *itemTextField = [[QSPAddNewAddressTextField alloc] initWithFrame:CGRectMake(0, 0, itembgView.frame.size.width, itembgView.frame.size.height)];
            [itemTextField setPlaceholder:itemName];
            [itemTextField setUserInteractionEnabled:NO];
            [itembgView addSubview:itemTextField];
            
            ///城市选择按钮
            QSBlockButtonStyleModel *itemBtStyle = [[QSBlockButtonStyleModel alloc] init];
            [itemBtStyle setTitleNormalColor:PLACEHOLDER_TEXT_COLOR];
            [itemBtStyle setBgColor:[UIColor clearColor]];
            UIButton *itemBt = [UIButton createBlockButtonWithFrame:itemTextField.frame andButtonStyle:itemBtStyle andCallBack:^(UIButton *button) {
                if (delegate) {
                    [delegate selectedItem:[arrayData objectAtIndex:button.tag] withIndex:button.tag inView:self];
                }
                [self hideItemSelectePopView];
                [self removeFromSuperview];
            }];
            [itemBt setTag:i];
            UIImageView *itemArrowMarkView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"public_arrow_normal"]];
            [itemArrowMarkView setFrame:CGRectMake(itemBt.frame.size.width-itemArrowMarkView.frame.size.width-6, (itemBt.frame.size.height-itemArrowMarkView.frame.size.height)/2, itemArrowMarkView.frame.size.width, itemArrowMarkView.frame.size.height)];
            [itemBt addSubview:itemArrowMarkView];
            [itembgView addSubview:itemBt];
            
            [self.contentBackgroundView setContentSize:CGSizeMake(self.contentBackgroundView.frame.size.width, itembgView.frame.origin.y+itembgView.frame.size.height+2)];
            [self.contentBackgroundView setFrame:CGRectMake(self.contentBackgroundView.frame.origin.x, self.contentBackgroundView.frame.origin.y, self.contentBackgroundView.frame.size.width, self.contentBackgroundView.contentSize.height>scrollViewMaxHeight?scrollViewMaxHeight:self.contentBackgroundView.contentSize.height)];
        }
    }
    
    [_contentBackgroundView setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

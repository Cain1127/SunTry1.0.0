//
//  QSPFoodInfoListTableViewCell.m
//  suntry
//
//  Created by CoolTea on 15/2/8.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPFoodInfoListTableViewCell.h"
#import "QSLabel.h"
#import "DeviceSizeHeader.h"
#import "QSPFoodTypeTableViewCell.h"
#import "UIImageView+CacheImage.h"
#import "NSString+Calculation.h"
#import "ColorHeader.h"

#define TABLEVIEW_FOOD_NAME_STRING_FONT_SIZE        14.
#define TABLEVIEW_FOOD_NAME_STRING_COLOR            COLOR_HEXCOLOR(0x94414D)
#define TABLEVIEW_FOOD_INSTOCK_STRING_COLOR         [UIColor colorWithRed:147/255.0 green:149/255.0 blue:151/255.0 alpha:1.]
#define TABLEVIEW_FOOD_PRICE_ONSALE_STRING_FONT_SIZE 16.
#define TABLEVIEW_FOOD_PRICE_ONSALE_STRING_COLOR     TABLEVIEW_FOOD_NAME_STRING_COLOR
#define FOOD_INFOLIST_TABLEVIEW_CELL_HEIGHT          80.

@interface QSPFoodInfoListTableViewCell ()

@property(nonatomic,strong) UIImageView *contentImgView;
@property(nonatomic,strong) QSLabel     *foodNameLabel;
@property(nonatomic,strong) QSLabel     *priceLabel;
@property(nonatomic,strong) QSLabel     *inStockCountLabel;
@property(nonatomic,strong) UIImageView *specialMarkImgView;
@property(nonatomic,strong) QSPFoodCountControlView *foodCountControlView;
@property(nonatomic,strong) id          foodData;

@end

@implementation QSPFoodInfoListTableViewCell

@synthesize delegate;

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];

        //菜展示图
        self.contentImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 10., 88/375.*SIZE_DEVICE_WIDTH, 60/667.*SIZE_DEVICE_HEIGHT)];
        [self.contentImgView setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.contentImgView];
        
        //菜名元素
        NSString* foodNameStr = @"";
        CGFloat foodNameWidth = [foodNameStr calculateStringDisplayWidthByFixedHeight:14.0 andFontSize:TABLEVIEW_FOOD_NAME_STRING_FONT_SIZE ]+4;
        self.foodNameLabel = [[QSLabel alloc] initWithFrame:CGRectMake(self.contentImgView.frame.origin.x+self.contentImgView.frame.size.width+10, self.contentImgView.frame.origin.y, foodNameWidth, 14)];
        [self.foodNameLabel setTextColor:TABLEVIEW_FOOD_NAME_STRING_COLOR];
        [self.foodNameLabel setFont:[UIFont systemFontOfSize:TABLEVIEW_FOOD_NAME_STRING_FONT_SIZE ]];
        [self.foodNameLabel setText:foodNameStr];
        [self.contentView addSubview:self.foodNameLabel];
        
        //特殊促销图标
        self.specialMarkImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.foodNameLabel.frame.origin.x+self.foodNameLabel.frame.size.width+2, self.foodNameLabel.frame.origin.y+1, 13/375.*SIZE_DEVICE_WIDTH, 13/667.*SIZE_DEVICE_HEIGHT)];
        [self.specialMarkImgView setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.specialMarkImgView];
        
        //库存
        self.inStockCountLabel = [[QSLabel alloc] initWithFrame:CGRectMake(self.foodNameLabel.frame.origin.x, self.foodNameLabel.frame.origin.y+self.foodNameLabel.frame.size.height+3, SIZE_DEVICE_WIDTH-FOOD_TYPE_TABLEVIEW_WIDTH-22-self.foodNameLabel.frame.origin.x, 16)];
        [self.inStockCountLabel setFont:[UIFont systemFontOfSize:TABLEVIEW_FOOD_NAME_STRING_FONT_SIZE]];
        [self.inStockCountLabel setTextColor:TABLEVIEW_FOOD_INSTOCK_STRING_COLOR];
        [self.contentView addSubview:self.inStockCountLabel];
        
        //价格图标
        UIImageView *pricemarkIconView = [[UIImageView alloc] initWithFrame:CGRectMake(self.foodNameLabel.frame.origin.x-6, self.inStockCountLabel.frame.origin.y+self.inStockCountLabel.frame.size.height, 36, 36)];
        [pricemarkIconView setImage:[UIImage imageNamed:@"home_pricemark"]];
        [pricemarkIconView setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:pricemarkIconView];
        
        //当前售卖价格
        NSString* priceStr = @"";
        CGFloat priceStrWidth = [priceStr calculateStringDisplayWidthByFixedHeight:14.0 andFontSize:TABLEVIEW_FOOD_PRICE_ONSALE_STRING_FONT_SIZE]+4;
        self.priceLabel = [[QSLabel alloc] initWithFrame:CGRectMake(pricemarkIconView.frame.origin.x+pricemarkIconView.frame.size.width-8, pricemarkIconView.frame.origin.y+(pricemarkIconView.frame.size.height-14)/2, priceStrWidth, 14)];
        [self.priceLabel setTextColor:TABLEVIEW_FOOD_PRICE_ONSALE_STRING_COLOR];
        [self.priceLabel setFont:[UIFont systemFontOfSize:TABLEVIEW_FOOD_PRICE_ONSALE_STRING_FONT_SIZE]];
        [self.priceLabel setText:priceStr];
        [self.contentView addSubview:self.priceLabel];
        
        //增加减少菜品数量控件
        self.foodCountControlView = [[QSPFoodCountControlView alloc] initControlView];
        [self.foodCountControlView setMarginTopRight:CGPointMake(SIZE_DEVICE_WIDTH-FOOD_TYPE_TABLEVIEW_WIDTH-10, self.priceLabel.frame.origin.y-8)];
        [self.foodCountControlView setDelegate:self];
        [self.contentView addSubview:self.foodCountControlView];
        
        UIView *lineButtomView = [[UIView alloc] initWithFrame:CGRectMake(11, FOOD_INFOLIST_TABLEVIEW_CELL_HEIGHT-1, SIZE_DEVICE_WIDTH-FOOD_TYPE_TABLEVIEW_WIDTH-22, 1)];
        [lineButtomView setBackgroundColor:FOODTYPE_TABLEVIEW_CELL_LINE_COLOR];
        [self.contentView addSubview:lineButtomView];
        [self.contentView setUserInteractionEnabled:YES];
        
    }
    
    return self;
    
}

- (void)upFoodData:(id)data
{
    
    self.foodData = data;
    
    [self.contentImgView loadImageWithURL:[NSURL URLWithString:@"http://admin.9dxz.com/files/jpg(18).jpeg"] placeholderImage:nil];
    
    //菜名元素
    NSString* foodNameStr = @"支竹焖烧肉";
    CGFloat foodNameWidth = [foodNameStr calculateStringDisplayWidthByFixedHeight:self.foodNameLabel.frame.size.height andFontSize:TABLEVIEW_FOOD_NAME_STRING_FONT_SIZE ]+4;
    [self.foodNameLabel setFrame:CGRectMake(self.foodNameLabel.frame.origin.x, self.foodNameLabel.frame.origin.y, foodNameWidth, self.foodNameLabel.frame.size.height)];
    [self.foodNameLabel setText:foodNameStr];
    
    [self.specialMarkImgView setFrame:CGRectMake(self.foodNameLabel.frame.origin.x+self.foodNameLabel.frame.size.width+2, self.foodNameLabel.frame.origin.y+1, self.specialMarkImgView.frame.size.width, self.specialMarkImgView.frame.size.height)];
//    [self.specialMarkImgView setImage:[UIImage imageNamed:@"food_special_mark"]];
    [self.specialMarkImgView setImage:[UIImage imageNamed:@"food_time_mark"]];
    
    //库存
    NSString* inStockCountStr = [NSString stringWithFormat:@"库存：%d份",1023];
    [self.inStockCountLabel setText:inStockCountStr];
    
    //当前售卖价格
    NSString* priceStr = @"108.8";
    CGFloat priceStrWidth = [priceStr calculateStringDisplayWidthByFixedHeight:14.0 andFontSize:TABLEVIEW_FOOD_PRICE_ONSALE_STRING_FONT_SIZE]+4;
    [self.priceLabel setFrame:CGRectMake(self.priceLabel.frame.origin.x, self.priceLabel.frame.origin.y, priceStrWidth, self.priceLabel.frame.size.height)];
    [self.priceLabel setText:priceStr];
    
}

- (void)changedCount:(NSInteger)count
{
    
    if (delegate) {
        
        [delegate changedCount:count withFoodData:_foodData];
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

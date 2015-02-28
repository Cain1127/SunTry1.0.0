//
//  QSOrderListTableViewCell.m
//  suntry
//
//  Created by CoolTea on 15/2/27.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSOrderListTableViewCell.h"
#import "QSLabel.h"
#import "DeviceSizeHeader.h"
#import "NSString+Calculation.h"
#import "QSOrderListItemDataModel.h"

#define ORDER_LIST_CELL_LINEVIEW_BACKGROUND_COLOR       [UIColor colorWithRed:0.808 green:0.812 blue:0.816 alpha:1.000]
#define ORDER_LIST_CELL_ORDER_NUM_STRING_COLOR          [UIColor colorWithRed:147/255.0 green:149/255.0 blue:151/255.0 alpha:1.]
#define ORDER_LIST_CELL_ORDER_NUM_STRING_FONT_SIZE      15.
#define ORDER_LIST_CELL_ORDER_NUM_COUNT_TEXT_COLOR      [UIColor colorWithRed:0.503 green:0.183 blue:0.236 alpha:1.000]


@interface QSOrderListTableViewCell ()

@property(nonatomic,strong) QSLabel     *orderNumLabel;
@property(nonatomic,strong) QSLabel     *totalPriceAndCountLabel;
@property(nonatomic,strong) QSLabel     *orderStateLabel;
@property(nonatomic,strong) QSLabel     *shippingStateLabel;
@property(nonatomic,strong) UIView      *lineTopView;
@property(nonatomic,strong) UIView      *lineBottomView;

@end

@implementation QSOrderListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        self.lineTopView = [[UIView alloc] initWithFrame:CGRectMake(12, 0, SIZE_DEVICE_WIDTH-12*2, 1)];
        [_lineTopView setBackgroundColor:ORDER_LIST_CELL_LINEVIEW_BACKGROUND_COLOR];
        [self.contentView addSubview:_lineTopView];
        
        UIImageView *sexArrowMarkView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"public_arrow_normal"]];
        [sexArrowMarkView setFrame:CGRectMake(SIZE_DEVICE_WIDTH-sexArrowMarkView.frame.size.width-6, (ORDER_LIST_CELL_HEIGHT-sexArrowMarkView.frame.size.height)/2, sexArrowMarkView.frame.size.width, sexArrowMarkView.frame.size.height)];
        [self.contentView addSubview:sexArrowMarkView];
        
        self.lineBottomView = [[UIView alloc] initWithFrame:CGRectMake(_lineTopView.frame.origin.x, ORDER_LIST_CELL_HEIGHT-1, _lineTopView.frame.size.width, 1)];
        [_lineBottomView setBackgroundColor:ORDER_LIST_CELL_LINEVIEW_BACKGROUND_COLOR];
        [self.contentView addSubview:_lineBottomView];
        
        
        CGFloat leftLabelWidth = (SIZE_DEVICE_WIDTH-_lineTopView.frame.origin.x)*2./3;
        self.orderNumLabel = [[QSLabel alloc] initWithFrame:CGRectMake(_lineTopView.frame.origin.x, 10, leftLabelWidth, 20)];
        [self.orderNumLabel setTextColor:ORDER_LIST_CELL_ORDER_NUM_STRING_COLOR];
        [self.orderNumLabel setFont:[UIFont systemFontOfSize:ORDER_LIST_CELL_ORDER_NUM_STRING_FONT_SIZE ]];
//        [self.orderNumLabel setText:@"订单号：123243253456"];
        [self.orderNumLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.orderNumLabel];
        
        self.totalPriceAndCountLabel = [[QSLabel alloc] initWithFrame:CGRectMake(self.orderNumLabel.frame.origin.x, self.orderNumLabel.frame.origin.y+self.orderNumLabel.frame.size.height, self.orderNumLabel.frame.size.width, self.orderNumLabel.frame.size.height)];
        [self.totalPriceAndCountLabel setTextColor:ORDER_LIST_CELL_ORDER_NUM_STRING_COLOR];
        [self.totalPriceAndCountLabel setFont:[UIFont systemFontOfSize:ORDER_LIST_CELL_ORDER_NUM_STRING_FONT_SIZE ]];
//        [self.totalPriceAndCountLabel setText:@"总价：￥188元，共988份餐品"];
        [self.totalPriceAndCountLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.totalPriceAndCountLabel];
        
        CGFloat rightLabelWidth = (SIZE_DEVICE_WIDTH-_lineTopView.frame.origin.x)*1./3;
        self.orderStateLabel = [[QSLabel alloc] initWithFrame:CGRectMake(sexArrowMarkView.frame.origin.x-rightLabelWidth+4, self.orderNumLabel.frame.origin.y, rightLabelWidth, self.orderNumLabel.frame.size.height)];
        [self.orderStateLabel setTextColor:ORDER_LIST_CELL_ORDER_NUM_STRING_COLOR];
        [self.orderStateLabel setFont:[UIFont systemFontOfSize:ORDER_LIST_CELL_ORDER_NUM_STRING_FONT_SIZE ]];
//        [self.orderStateLabel setText:@"已付款"];
        [self.orderStateLabel setTextAlignment:NSTextAlignmentRight];
        [self.orderStateLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.orderStateLabel];
        
        self.shippingStateLabel = [[QSLabel alloc] initWithFrame:CGRectMake(self.orderStateLabel.frame.origin.x, self.totalPriceAndCountLabel.frame.origin.y, self.orderStateLabel.frame.size.width, self.orderStateLabel.frame.size.height)];
        [self.shippingStateLabel setTextColor:ORDER_LIST_CELL_ORDER_NUM_STRING_COLOR];
        [self.shippingStateLabel setFont:[UIFont systemFontOfSize:ORDER_LIST_CELL_ORDER_NUM_STRING_FONT_SIZE ]];
//        [self.shippingStateLabel setText:@"一号餐车配送中"];
        [self.shippingStateLabel setTextAlignment:NSTextAlignmentRight];
        [self.shippingStateLabel setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:self.shippingStateLabel];
        
    }
    
    return self;
}

- (void)showTopLine:(BOOL)flag
{
    [self.lineTopView setHidden:!flag];
}

- (void)updateFoodData:(id)data
{
    [self.orderNumLabel setText:@""];
    [self.totalPriceAndCountLabel setText:@""];
    [self.orderStateLabel setText:@""];
    [self.shippingStateLabel setText:@""];
    if (data &&[data isKindOfClass:[QSOrderListItemDataModel class]]) {
        QSOrderListItemDataModel *item = (QSOrderListItemDataModel*)data;
        
        [self.orderNumLabel setText:[NSString stringWithFormat:@"订单号:%@",item.order_num]];
        
        NSString *totalPriceStr = item.total_money;
        NSString *totalCountStr = item.diet_num;
        NSMutableAttributedString *totalString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总价:￥%@元,共%@份餐品",totalPriceStr,totalCountStr]];
        [totalString addAttribute:NSForegroundColorAttributeName value:ORDER_LIST_CELL_ORDER_NUM_COUNT_TEXT_COLOR range:NSMakeRange(4,totalPriceStr.length)];
        [totalString addAttribute:NSForegroundColorAttributeName value:ORDER_LIST_CELL_ORDER_NUM_COUNT_TEXT_COLOR range:NSMakeRange(4+totalPriceStr.length+3,totalCountStr.length)];
        [totalString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:ORDER_LIST_CELL_ORDER_NUM_STRING_FONT_SIZE] range:NSMakeRange(4, totalPriceStr.length)];
        [totalString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:ORDER_LIST_CELL_ORDER_NUM_STRING_FONT_SIZE] range:NSMakeRange(4+totalPriceStr.length+3,totalCountStr.length)];
        [self.totalPriceAndCountLabel setAttributedText:totalString];
        
//        NSString *stateCode = item.order_status;
//        /**
//         '-1'=>'删除',
//         '0'=>'未确认',
//         '1'=>'确认',
//         '3'=>'送达',
//         '4'=>'取消',
//         */
//        
//        NSString *stateStr = @"";
//        if ([stateCode isEqualToString:@"-1"]) {
//            stateStr = @"删除";
//        }else if ([stateCode isEqualToString:@"0"]) {
//            stateStr = @"未确认";
//        }else if ([stateCode isEqualToString:@"1"]) {
//            stateStr = @"确认";
//        }else if ([stateCode isEqualToString:@"3"]) {
//            stateStr = @"送达";
//        }else if ([stateCode isEqualToString:@"4"]) {
//            stateStr = @"取消";
//        }
//
        
        NSString *ispayCode = item.is_pay;
        NSString *payStateStr = @"";
        if ([ispayCode isEqualToString:@"0"])
        {
            payStateStr = @"未付款";
        }else if ([ispayCode isEqualToString:@"1"])
        {
            payStateStr = @"已付款";
        }
        
        [self.orderStateLabel setText:payStateStr];
//        [self.shippingStateLabel setText:@"一号餐车配送中"];
        
        
    }
    

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

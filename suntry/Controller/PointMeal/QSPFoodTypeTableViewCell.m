//
//  QSPFoodTypeTableViewCell.m
//  suntry
//
//  Created by CoolTea on 15/2/8.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPFoodTypeTableViewCell.h"
#import "DeviceSizeHeader.h"

#define FOODTYPE_TABLEVIEW_CELL_TEXT_COLOR       [UIColor colorWithRed:146/255. green:148/255. blue:151/255. alpha:1]

@interface QSPFoodTypeTableViewCell ()

@property(nonatomic,strong) UILabel *typeNameLabel;
@property(nonatomic,strong) UIView  *lineTopView;
@end

@implementation QSPFoodTypeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.typeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 6, FOOD_TYPE_TABLEVIEW_WIDTH, 44)];
        [self.typeNameLabel setFont:[UIFont systemFontOfSize:QSPFOOD_TYPE_TABLEVIEW_CELL_TITLE_FONT_SIZE]];
        [self.typeNameLabel setTextAlignment:NSTextAlignmentCenter];
        [self.typeNameLabel setBackgroundColor:[UIColor whiteColor]];
        [self.typeNameLabel setTextColor:FOODTYPE_TABLEVIEW_CELL_TEXT_COLOR];
        [self.contentView addSubview:self.typeNameLabel];
        
        self.lineTopView = [[UIView alloc] initWithFrame:CGRectMake(0, self.typeNameLabel.frame.origin.y-1, FOOD_TYPE_TABLEVIEW_WIDTH, 1)];
        [self.lineTopView setBackgroundColor:FOODTYPE_TABLEVIEW_CELL_LINE_COLOR];
        [self.contentView addSubview:self.lineTopView];
        [self.contentView setUserInteractionEnabled:YES];
        
        UIView *lineButtomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.typeNameLabel.frame.origin.y+self.typeNameLabel.frame.size.height, FOOD_TYPE_TABLEVIEW_WIDTH, 1)];
        [lineButtomView setBackgroundColor:FOODTYPE_TABLEVIEW_CELL_LINE_COLOR];
        [self.contentView addSubview:lineButtomView];
        [self.contentView setUserInteractionEnabled:YES];
        
    }
    return self;
    
}

- (void)setFoodTypeName:(NSString*)title
{
    
    [self.typeNameLabel setText:title];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    if(selected)
    {
        
        [self.lineTopView setHidden:NO];
        [self.typeNameLabel setBackgroundColor:[UIColor whiteColor]];
        
    }else{
        
        [self.lineTopView setHidden:YES
         ];
        [self.typeNameLabel setBackgroundColor:[UIColor clearColor]];
        
    }
}

@end

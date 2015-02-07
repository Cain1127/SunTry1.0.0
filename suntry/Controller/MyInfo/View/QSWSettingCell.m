//
//  QSWSettingCell.m
//  suntry
//
//  Created by 王树朋 on 15/2/6.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWSettingCell.h"
#import "QSWSettingItem.h"
#import "QSWSettingArrowItem.h"
#import "QSWTextFielditem.h"
#import "CommonHeader.h"
#import "DeviceSizeHeader.h"

@interface QSWSettingCell()
/**
 *  箭头
 */
@property (strong, nonatomic) UIImageView *arrowView;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic,strong) UITextField *textFieldView;
@end

@implementation QSWSettingCell

- (UIImageView *)arrowView
{
    
    if (_arrowView == nil) {
        
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"public_arrow_normal"]];
        
    }
    
    return _arrowView;
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    
    static NSString *ID = @"setting";
    QSWSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[QSWSettingCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        
        cell.tableView = tableView;
        
    }
    
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        ///标题
        self.textLabel.highlightedTextColor = self.textLabel.textColor;
        self.textLabel.textColor = [UIColor brownColor];
        self.textLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        
        ///子标题
        self.detailTextLabel.highlightedTextColor = self.detailTextLabel.textColor;
        self.detailTextLabel.textColor = [UIColor brownColor];
        self.detailTextLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    if (iOS7) {
        frame.origin.x = 5;
        frame.size.width -= 10;
    }
    [super setFrame:frame];
}

- (void)setItem:(QSWSettingItem *)item
{
    _item = item;
    
    // 1.设置数据
    [self setupData];
    
    // 2.设置右边的控件
    [self setupRightView];
}

/**
 *  设置数据
 */
- (void)setupData
{
    
    // 1.图标
    if (self.item.icon) {
        
        self.imageView.image = [UIImage imageNamed:self.item.icon];
        
    }
    
    // 2.标题
    if (self.item.title) {
        
        self.textLabel.text = self.item.title;
        
    }
    
    /// 3.副标题
    if (self.item.subtitle) {
        
        self.detailTextLabel.text=self.item.subtitle;
        
    }
    
}

///设置自定义

/**
 *  设置右边的控件
 */
- (void)setupRightView
{
   
     if ([self.item isKindOfClass:[QSWSettingArrowItem class]]) {
         
         // 右边是箭头
       self.accessoryView=self.arrowView;
//         self.arrowView.frame = CGRectMake(0, 0.0f, self.arrowView.frame.size.width, self.frame.size.height);
//         [self.contentView addSubview:self.arrowView];
         
    }
    
    if ([self.item isKindOfClass:[QSWTextFieldItem class]]) {
        for (UIView *obj in [self.contentView subviews]) {
            
                        [obj removeFromSuperview];
            
                    }
        
        _textFieldView.frame = CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 0, self.contentView.frame.size.width, self.frame.size.height);
        [self.contentView addSubview:self.arrowView];

    }
     else {
        
        // 右边没有东西
        self.accessoryView=nil;
//        for (UIView *obj in [self.accessoryView subviews]) {
//            
//            [obj removeFromSuperview];
//            
//        }
//        
    }
    
}

@end

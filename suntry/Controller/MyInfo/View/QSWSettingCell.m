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
#import "QSWLabelItem.h"
#import "QSWSettingButtonItem.h"
#import "CommonHeader.h"
#import "DeviceSizeHeader.h"

@interface QSWSettingCell()<UITextFieldDelegate>

  //右侧箭头
@property (strong, nonatomic) UIImageView *arrowView;
 //右侧按钮
@property (strong,nonatomic) UIImageView *buttonView;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic,strong) UITextField *textFieldView;
@property (nonatomic,strong) UILabel *labelView;

@end

@implementation QSWSettingCell

- (UIImageView *)arrowView
{
    
    if (_arrowView == nil) {
        
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"public_arrow_normal"]];
        
    }
    
    return _arrowView;
    
}

- (UIImageView *)buttonView
{
    
    if (_buttonView == nil) {
        
        _buttonView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"myinfo_edit_normal"]];

        
    }
    
    return _buttonView;
    
}

-(UILabel *)labelView
{

    if (_labelView==nil) {
        
        _labelView=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60.0F, 30.0F)];
        _labelView.text=@"先生好";
    }
    
    return _labelView;
}

-(UITextField *)textFieldView
{

    if (_textFieldView==nil) {
        
        ///1.添加textfield输入框控件
        _textFieldView=[[UITextField alloc]initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 0, SIZE_DEVICE_WIDTH-2*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, self.frame.size.height)];

        _textFieldView.translatesAutoresizingMaskIntoConstraints=NO;
        _textFieldView.returnKeyType=UIReturnKeyDone;
        _textFieldView.clearButtonMode=UITextFieldViewModeUnlessEditing;
        _textFieldView.delegate = ((QSWTextFieldItem *)self.item).delegate;
        _textFieldView.tag = 200;
        _textFieldView.borderStyle = UITextBorderStyleRoundedRect;
        
    }
    return _textFieldView;
    
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
    [self setupCellView];
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
        
        if ([self.item isKindOfClass:[QSWTextFieldItem class]]) {
            
            self.textFieldView.placeholder = self.item.title;
            self.item.property = self.textFieldView;
            
        }
    
        self.textLabel.text = self.item.title;
       
    }
    
    /// 3.副标题
    if (self.item.subtitle) {
        
        if ([self.item isKindOfClass:[QSWTextFieldItem class]]) {
            
            self.textFieldView.text = self.item.subtitle;
            self.item.property = self.textFieldView;
            
        }
        
        if ([self.item isKindOfClass:[QSWLabelItem class]]) {
            
            self.labelView.text=self.item.subtitle;
            
        }
        self.detailTextLabel.text=self.item.subtitle;
        
    }
    
}

///设置自定义

/**
 *  设置cell的控件
 */
- (void)setupCellView
{
    ///原生cell
    if ([self.item isKindOfClass:[QSWSettingArrowItem class]]) {
        
        // 右边是箭头
        self.accessoryView=self.arrowView;
        
    }
    
    ///自定义textField样式cell
    else if ([self.item isKindOfClass:[QSWTextFieldItem class]]) {
        
        [self.contentView addSubview:self.textFieldView];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
    }
    
    else if ([self.item isKindOfClass:[QSWLabelItem class]]) {
        
        // 右边是标签
        self.accessoryView = self.labelView;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        
    }
    
    else if ([self.item isKindOfClass:[QSWSettingButtonItem class]]) {
        
        // 右边是按钮
        self.accessoryView = self.buttonView;
        //self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    
    
    //     else {
    //
    //        // 右边没有东西
    //        self.accessoryView=nil;
    //
    //    }
    
}



@end

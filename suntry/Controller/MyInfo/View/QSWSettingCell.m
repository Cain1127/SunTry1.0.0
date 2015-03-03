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
#import "QSPickerViewItem.h"

@interface QSWSettingCell()<UITextFieldDelegate>

@property (strong, nonatomic) UIImageView *arrowView;    //!<右侧箭头
@property (strong,nonatomic) UIImageView *buttonView;    //!<右侧按钮
@property (nonatomic, weak) UITableView *tableView;      //!<
@property (nonatomic,strong) UITextField *textFieldView;
@property (nonatomic,strong) UILabel *labelView;

@property (nonatomic,strong) UIView *titleArrowView;//!<有标题的带前头view

@end

@implementation QSWSettingCell

#pragma mark - 右侧箭头图片
///右侧箭头图片
- (UIImageView *)arrowView
{
    
    if (_arrowView == nil) {
        
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"public_arrow_normal"]];
        
    }
    
    return _arrowView;
    
}

#pragma mark - 右侧按钮
///右侧按钮
- (UIImageView *)buttonView
{
    
    if (_buttonView == nil) {
        
        _buttonView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"myinfo_edit_normal"]];
        
    }
    
    return _buttonView;
    
}

#pragma mark - 文字+箭头的view
///文字+箭头的view
- (UIView *)titleArrowView
{
    
    if (_titleArrowView == nil) {
        
        ///图片view
        UIImageView *arrowView = self.arrowView;
        
        ///初始化
        _titleArrowView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, arrowView.frame.size.width + 60.0f, 44.0f)];
        
        ///添加标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 57.0f, _titleArrowView.frame.size.height)];
        titleLabel.textAlignment = NSTextAlignmentRight;
        titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_titleArrowView addSubview:titleLabel];
        
        ///添加控件
        arrowView.frame = CGRectMake(titleLabel.frame.size.width + 3.0f, (_titleArrowView.frame.size.height - arrowView.frame.size.height) / 2.0f, arrowView.frame.size.width, arrowView.frame.size.height);
        [_titleArrowView addSubview:arrowView];
        
    }
    
    return _titleArrowView;
    
}

#pragma mark - 纯文字
///纯文字
-(UILabel *)labelView
{

    if (_labelView==nil) {
        
        _labelView=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60.0f, 30.0f)];
        _labelView.text=@"先生好";
    }
    
    return _labelView;
}

#pragma mark - 输入框
///输入框
-(UITextField *)textFieldView
{

    if (_textFieldView == nil) {
        
        ///1.添加textfield输入框控件
        _textFieldView=[[UITextField alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 0, SIZE_DEVICE_WIDTH - 2.0f * SIZE_DEFAULT_MARGIN_LEFT_RIGHT, self.frame.size.height)];

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
    if (!iOS7) {
        
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
    
    ///判断是否需要加底框
    if ([item isKindOfClass:[QSWTextFieldItem class]]) {
        
        return;
        
    }
    
    ///获取cell高度
    CGFloat height = 44.0f;
    
    ///如果是优惠郑列表的cell时，高度为60.0f
    if (item.subtitle) {
        
        height = 60.0f;
        
    }
    
    ///加边框
    UIView *lineRootView = [[UIView alloc] initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 0.0f, SIZE_DEFAULT_MAX_WIDTH - SIZE_DEFAULT_MARGIN_LEFT_RIGHT, height)];
    lineRootView.backgroundColor = [UIColor clearColor];
    lineRootView.layer.borderColor = [[UIColor colorWithRed:194.0f / 255.0f green:181.0f / 255.0f blue:156.0f / 255.0f alpha:1.0f] CGColor];
    lineRootView.layer.borderWidth = 0.5f;
    lineRootView.layer.cornerRadius = 6.0f;
    
    ///加载到content上
    [self.contentView addSubview:lineRootView];
    [self.contentView sendSubviewToBack:lineRootView];
    
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
        
    } else if ([self.item isKindOfClass:[QSWTextFieldItem class]]) {
        
        if ([self.item isKindOfClass:[QSPickerViewItem class]]) {
            
            ///设置右标题
            UILabel *rightTitleLabel = (UILabel *)[self.titleArrowView subviews][0];
            rightTitleLabel.text = ((QSPickerViewItem *)self.item).rightTitle;
            
            ///添加到输入框的右侧
            self.textFieldView.rightViewMode = UITextFieldViewModeAlways;
            self.textFieldView.rightView = self.titleArrowView;
            
        }
        
        ///自定义textField样式cell
        [self.contentView addSubview:self.textFieldView];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
    } else if ([self.item isKindOfClass:[QSWLabelItem class]]) {
        
        // 右边是标签
        self.accessoryView = self.labelView;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        
    } else if ([self.item isKindOfClass:[QSWSettingButtonItem class]]) {
        
        // 右边是按钮
        self.accessoryView = self.buttonView;
        
    }
    
}

@end

//
//  QSPOrderAddNewAddressView.m
//  suntry
//
//  Created by CoolTea on 15/2/25.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSPOrderAddNewAddressView.h"
#import "DeviceSizeHeader.h"
#import "NSString+Calculation.h"
#import "QSLabel.h"
#import "QSBlockButton.h"
#import "QSPAddNewAddressTextField.h"

#import "QSDatePickerViewController.h"
#import "ASDepthModalViewController.h"

#define ADD_NEW_ADDRESS_VIEW_BACKGROUND_COLOR           [UIColor colorWithWhite:0 alpha:0.6]
#define ADD_NEW_ADDRESS_LINEVIEW_BACKGROUND_COLOR       [UIColor colorWithRed:0.808 green:0.812 blue:0.816 alpha:1.000]
#define ADD_NEW_ADDRESS_VIEW_TEXT_STRING_FONT_SIZE        17.
#define ADD_NEW_ADDRESS_VIEW_TEXT_TIP_COLOR             [UIColor colorWithRed:0.505 green:0.513 blue:0.525 alpha:1.000]
#define ADD_NEW_ADDRESS_VIEW_TEXT_INFO_COLOR             [UIColor colorWithRed:0.503 green:0.183 blue:0.236 alpha:1.000]
#define ADD_NEW_ADDRESS_PICKERVIEW_BACKGROUND_COLOR           [UIColor colorWithWhite:1 alpha:0.6]


@interface QSPOrderAddNewAddressView ()

@property(nonatomic,strong) UIView                    *contentBackgroundView;
@property(nonatomic,assign) CGRect                    contentFrame;
@property(nonatomic,strong) UIScrollView              *scrollView;
@property(nonatomic,strong) UIButton                  *submitBt;
@property(nonatomic,strong) QSPAddNewAddressTextField *nameTextField;
@property(nonatomic,strong) QSPAddNewAddressTextField *sexTextField;
@property(nonatomic,strong) QSPAddNewAddressTextField *addressTextField;
@property(nonatomic,strong) QSPAddNewAddressTextField *companyTextField;
@property(nonatomic,strong) QSPAddNewAddressTextField *telephoneTextField;
@property(nonatomic,strong) QSLabel                   *sexLabel;
@property(nonatomic,strong) QSDatePickerViewController *sexPickerView;

@end

@implementation QSPOrderAddNewAddressView
@synthesize delegate;

+ (instancetype)getAddNewAddressView
{
    
    static QSPOrderAddNewAddressView *addNewAddressView;
    
    if (!addNewAddressView) {
        
        addNewAddressView = [[QSPOrderAddNewAddressView alloc] initAddNewAddressView];
    }
    
    [addNewAddressView clearContent];
    return addNewAddressView;
    
}

- (void)clearContent
{
    [self.nameTextField setText:@""];
    [self.telephoneTextField setText:@""];
    [self.addressTextField setText:@""];
    [self.companyTextField setText:@""];
}

- (instancetype)initAddNewAddressView
{
    
    if (self = [super init]) {
        
        //半透明背景层
        [self setFrame:CGRectMake(0, 0, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT)];
        [self setBackgroundColor:ADD_NEW_ADDRESS_VIEW_BACKGROUND_COLOR];
        
        //中间内容区域层
        self.contentBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 345/375.*SIZE_DEVICE_WIDTH, 469/667.*SIZE_DEVICE_HEIGHT)];
        [_contentBackgroundView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_contentBackgroundView];
        
        //新增地址提示
        QSLabel *tipLabel = [[QSLabel alloc] initWithFrame:CGRectMake(12, 16, _contentBackgroundView.frame.size.width-50, 22)];
        [tipLabel setTextColor:ADD_NEW_ADDRESS_VIEW_TEXT_TIP_COLOR];
        [tipLabel setFont:[UIFont systemFontOfSize:ADD_NEW_ADDRESS_VIEW_TEXT_STRING_FONT_SIZE ]];
        [tipLabel setBackgroundColor:[UIColor clearColor]];
        [tipLabel setText:@"新增地址"];
        [_contentBackgroundView addSubview:tipLabel];
        
        //关闭按钮
        QSBlockButtonStyleModel *closeStyleModel = [QSBlockButtonStyleModel alloc];
        closeStyleModel.imagesNormal = @"close_button_normal_icon";
        closeStyleModel.imagesHighted = @"close_button_down_icon";
        UIButton *closeBt = [UIButton createBlockButtonWithFrame:CGRectMake(_contentBackgroundView.frame.size.width-32-8, 8, 32, 32) andButtonStyle:closeStyleModel andCallBack:^(UIButton *button) {
            [self hideAddNewAddressView];
            [self removeFromSuperview];
        }];
        [_contentBackgroundView addSubview:closeBt];
        
        //第一条分割线
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(tipLabel.frame.origin.x, tipLabel.frame.origin.y+tipLabel.frame.size.height+12, _contentBackgroundView.frame.size.width-tipLabel.frame.origin.x*2, 1)];
        [lineView1 setBackgroundColor:ADD_NEW_ADDRESS_LINEVIEW_BACKGROUND_COLOR];
        [_contentBackgroundView addSubview:lineView1];
        
        //新增地址提示
        QSLabel *infoLabel = [[QSLabel alloc] initWithFrame:CGRectMake(0, lineView1.frame.origin.y+lineView1.frame.size.height+10, _contentBackgroundView.frame.size.width, 22)];
        [infoLabel setTextColor:ADD_NEW_ADDRESS_VIEW_TEXT_INFO_COLOR];
        [infoLabel setFont:[UIFont systemFontOfSize:ADD_NEW_ADDRESS_VIEW_TEXT_STRING_FONT_SIZE ]];
        [infoLabel setBackgroundColor:[UIColor clearColor]];
        [infoLabel setTextAlignment:NSTextAlignmentCenter];
        [infoLabel setText:@"您还没有送餐地址，请添加地址！"];
        [_contentBackgroundView addSubview:infoLabel];
        
        //第二条分割线
        UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(lineView1.frame.origin.x, infoLabel.frame.origin.y+infoLabel.frame.size.height+12, lineView1.frame.size.width, lineView1.frame.size.height)];
        [lineView2 setBackgroundColor:ADD_NEW_ADDRESS_LINEVIEW_BACKGROUND_COLOR];
        [_contentBackgroundView addSubview:lineView2];
        
        CGFloat buttomY = lineView2.frame.origin.y + lineView2.frame.size.height;
        
        CGFloat scrollViewContentHight = 0.;
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(lineView2.frame.origin.x, lineView2.frame.origin.y+lineView2.frame.size.height, lineView2.frame.size.width, scrollViewContentHight)];
        [_scrollView setBackgroundColor:[UIColor clearColor]];
        [_contentBackgroundView addSubview:_scrollView];
        
        buttomY = _scrollView.frame.origin.y+_scrollView.frame.size.height;
        
        //添加地址按钮
        QSBlockButtonStyleModel *submitBtStyleModel = [QSBlockButtonStyleModel alloc];
        submitBtStyleModel.bgColor  = [UIColor colorWithRed:0.471 green:0.176 blue:0.224 alpha:1.000];;
        submitBtStyleModel.title    = @"添加地址";
        submitBtStyleModel.titleNormalColor = [UIColor whiteColor];
        submitBtStyleModel.cornerRadio = 6.;
        self.submitBt = [UIButton createBlockButtonWithFrame:CGRectMake(12, buttomY, _contentBackgroundView.frame.size.width-12*2, 44) andButtonStyle:submitBtStyleModel andCallBack:^(UIButton *button) {
            
            if (![self checkAddress]) {
                
                return;
                
            }

            [self hideAddNewAddressView];
            [self removeFromSuperview];
            if (delegate) {
                
                [delegate AddNewAddressWithData:[self getAddressData]];
                
            }
            
        }];
        [_contentBackgroundView addSubview:_submitBt];
        
        [_contentBackgroundView setFrame:CGRectMake(_contentBackgroundView.frame.origin.x,_contentBackgroundView.frame.origin.y, _contentBackgroundView.frame.size.width, _submitBt.frame.origin.y+_submitBt.frame.size.height+12)];
        
        [_contentBackgroundView setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    }
    
    [self initTextField];
    
    self.contentFrame = self.frame;
    
    return self;
    
}

- (void)initTextField
{
    
    //地址输入框列表
    CGFloat scrollViewContentHight = 0.;
    CGFloat scrollViewMaxHeight = SIZE_DEVICE_HEIGHT - 150;
    

    self.nameTextField = [[QSPAddNewAddressTextField alloc] initWithFrame:CGRectMake(0, 10, _scrollView.frame.size.width, 44)];
    [self.nameTextField setPlaceholder:@"请填写联系人姓名"];
    [self.nameTextField setDelegate:self];
    [_scrollView addSubview:self.nameTextField];
    
    self.sexTextField = [[QSPAddNewAddressTextField alloc] initWithFrame:CGRectMake(0, self.nameTextField.frame.origin.y+self.nameTextField.frame.size.height+10, _scrollView.frame.size.width, 44)];
    [self.sexTextField setPlaceholder:@"您的性别"];
    [self.sexTextField setDelegate:self];
    [self.sexTextField setUserInteractionEnabled:NO];
    [_scrollView addSubview:self.sexTextField];
    
    ///性别选择按钮
    QSBlockButtonStyleModel *sexBtStyle = [[QSBlockButtonStyleModel alloc] init];
    [sexBtStyle setTitleNormalColor:PLACEHOLDER_TEXT_COLOR];
    [sexBtStyle setBgColor:[UIColor clearColor]];
    __weak QSPOrderAddNewAddressView *weakSelf = self;
    UIButton *sexBt = [UIButton createBlockButtonWithFrame:_sexTextField.frame andButtonStyle:sexBtStyle andCallBack:^(UIButton *button) {
        
        ///弹出性别选择窗口
        self.sexPickerView = [[QSDatePickerViewController alloc] init];
        self.sexPickerView.pickerType = kPickerType_Item;
        self.sexPickerView.dataSource = [[NSMutableArray alloc] initWithArray:@[@"女",@"男"]];
        self.sexPickerView.onCancelButtonHandler = ^{
            
            [ASDepthModalViewController dismiss];
            
        };
        self.sexPickerView.onItemConfirmButtonHandler = ^(NSInteger index, NSString *item){
            
            ///更换标题
            weakSelf.sexLabel.text = item;
            
            [ASDepthModalViewController dismiss];
            
        };
        
        ///用动画弹框
        [ASDepthModalViewController presentView:weakSelf.sexPickerView.view];
        
    }];

    UIImageView *sexArrowMarkView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"public_arrow_normal"]];
    [sexArrowMarkView setFrame:CGRectMake(sexBt.frame.size.width-sexArrowMarkView.frame.size.width-6, (sexBt.frame.size.height-sexArrowMarkView.frame.size.height)/2, sexArrowMarkView.frame.size.width, sexArrowMarkView.frame.size.height)];
    [sexBt addSubview:sexArrowMarkView];
    
    self.sexLabel = [[QSLabel alloc] initWithFrame:CGRectMake(0, 0, sexArrowMarkView.frame.origin.x, sexBt.frame.size.height)];
    [self.sexLabel setTextColor:PLACEHOLDER_TEXT_COLOR];
    [self.sexLabel setFont:[UIFont systemFontOfSize:ADD_NEW_ADDRESS_VIEW_TEXT_STRING_FONT_SIZE ]];
    [self.sexLabel setBackgroundColor:[UIColor clearColor]];
    [self.sexLabel setTextAlignment:NSTextAlignmentRight];
    [self.sexLabel setText:@"男"];
    [sexBt addSubview:self.sexLabel];
    
    [_scrollView addSubview:sexBt];
    
    self.addressTextField = [[QSPAddNewAddressTextField alloc] initWithFrame:CGRectMake(0, self.sexTextField.frame.origin.y+self.sexTextField.frame.size.height+10, _scrollView.frame.size.width, 44)];
    [self.addressTextField setDelegate:self];
    [self.addressTextField setPlaceholder:@"送餐地址，请尽量填写详细"];
    [_scrollView addSubview:self.addressTextField];
    
    self.companyTextField = [[QSPAddNewAddressTextField alloc] initWithFrame:CGRectMake(0, self.addressTextField.frame.origin.y+self.addressTextField.frame.size.height+10, _scrollView.frame.size.width, 44)];
    [self.companyTextField setPlaceholder:@"请输入公司名称"];
    [self.companyTextField setDelegate:self];
    [_scrollView addSubview:self.companyTextField];
    
    self.telephoneTextField = [[QSPAddNewAddressTextField alloc] initWithFrame:CGRectMake(0, self.companyTextField.frame.origin.y+self.companyTextField.frame.size.height+10, _scrollView.frame.size.width, 44)];
    [self.telephoneTextField setPlaceholder:@"配送人员联系您的电话"];
    [self.telephoneTextField setDelegate:self];
    [_scrollView addSubview:self.telephoneTextField];
    
    scrollViewContentHight = self.telephoneTextField.frame.origin.y + self.telephoneTextField.frame.size.height;
    [_scrollView setFrame:CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y, _scrollView.frame.size.width, scrollViewContentHight>scrollViewMaxHeight?scrollViewMaxHeight:scrollViewContentHight)];
    [_scrollView setContentSize:CGSizeMake(_scrollView.contentSize.width, scrollViewContentHight)];
    
    [_submitBt setFrame:CGRectMake(12, _scrollView.frame.origin.y+_scrollView.frame.size.height+10, _submitBt.frame.size.width, _submitBt.frame.size.height)];
    [_contentBackgroundView setFrame:CGRectMake(_contentBackgroundView.frame.origin.x,_contentBackgroundView.frame.origin.y, _contentBackgroundView.frame.size.width, _submitBt.frame.origin.y+_submitBt.frame.size.height+12)];
    [_contentBackgroundView setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    
}

- (BOOL)checkAddress
{
    
    BOOL flag = YES;
    
    NSString *infoStr = @"";
    if (flag && [[self.nameTextField text] isEqualToString:@""]) {
        
        flag = NO;
        infoStr= @"联系人姓名";
        
    }
    
    if (flag && [[self.addressTextField text] isEqualToString:@""]) {
        
        flag = NO;
        infoStr= @"送餐地址";
        
    }
    
    if (flag && [[self.telephoneTextField text] isEqualToString:@""]) {
        
        flag = NO;
        infoStr= @"联系电话";
        
    }
    
    if (flag && ![[self.telephoneTextField text] isEqualToString:@""]) {
        
        if (![self isMobileNumberClassification:[self.telephoneTextField text]]) {
            
            flag = NO;
            infoStr= @"正确的联系电话格式";
            
        }
        
    }
    
    if (!flag) {
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"请输入%@",infoStr] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [av show];
        
    }
    
    return flag;
    
}

- (void)showAddNewAddressView
{
    
    [self setHidden:NO];
    
}

- (void)hideAddNewAddressView
{
    
    [self setHidden:YES];
    
}

- (NSDictionary*)getAddressData
{
    
    NSMutableDictionary *addressDic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [addressDic setObject:[self.nameTextField text] forKey:@"name"];
    [addressDic setObject:[self.telephoneTextField text] forKey:@"phone"];
    [addressDic setObject:[self.addressTextField text] forKey:@"address"];
    [addressDic setObject:[self.sexLabel text] forKey:@"sex"];
    [addressDic setObject:[self.companyTextField text] forKey:@"company"];
    
    return addressDic;
    
}

- (void)hideKeybord
{
    
    [self.nameTextField resignFirstResponder];
    [self.sexTextField resignFirstResponder];
    [self.addressTextField resignFirstResponder];
    [self.companyTextField resignFirstResponder];
    [self.telephoneTextField resignFirstResponder];
    [self setFrame:self.contentFrame];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self hideKeybord];
    return YES;
    
}

//在UITextField 编辑之前调用方法
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    [self animateTextField: textField];
    
}

//在UITextField 编辑完成调用方法
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    [self animateTextField: textField];
    
}

//视图上移的方法
- (void) animateTextField: (UITextField *) textField
{
    
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    CGRect rect = [textField convertRect: textField.bounds toView:window];
    
    //设置视图上移的距离，单位像素
    int movementDistance =(self.frame.size.height - 280) - (rect.origin.y+rect.size.height); // tweak as needed
    //三目运算，判定是否需要上移视图或者不变
    int movement = movementDistance<0?movementDistance:0;
    //设置动画的名字
    [UIView beginAnimations: @"Animation" context: nil];
    //设置动画的开始移动位置
    [UIView setAnimationBeginsFromCurrentState: YES];
    //设置动画的间隔时间
    [UIView setAnimationDuration: 0.20];
    //设置视图移动的位移
    self.frame = CGRectOffset(self.frame, 0, movement);
    //设置动画结束
    [UIView commitAnimations];
    
}

- (BOOL)isMobileNumberClassification:(NSString*)phoneStr
{
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,1705
     * 联通：130,131,132,152,155,156,185,186,1709
     * 电信：133,1349,153,180,189,1700
     */
    //    NSString * MOBILE = @"^1((3//d|5[0-35-9]|8[025-9])//d|70[059])\\d{7}$";//总况
    
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188，1705
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d|705)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186,1709
     17         */
    NSString * CU = @"^1((3[0-2]|5[256]|8[56])\\d|709)\\d{7}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,1700
     22         */
    NSString * CT = @"^1((33|53|8[09])\\d|349|700)\\d{7}$";
    
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    
    //    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",PHS];
    
    if (([regextestcm evaluateWithObject:phoneStr] == YES)
        || ([regextestct evaluateWithObject:phoneStr] == YES)
        || ([regextestcu evaluateWithObject:phoneStr] == YES)
        || ([regextestphs evaluateWithObject:phoneStr] == YES))
    {
        
        return YES;
        
    }
    else
    {
        
        return NO;
        
    }
    
}

@end

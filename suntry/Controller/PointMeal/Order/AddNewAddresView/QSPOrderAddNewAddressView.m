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

#import "QSRequestManager.h"

#import "QSUserManager.h"
#import "QSUserInfoDataModel.h"

#import "QSDatePickerViewController.h"
#import "ASDepthModalViewController.h"

#import "QSPItemSelectePopView.h"
#import "QSDistrictReturnData.h"
#import "QSDistrictDataModel.h"

#define ADD_NEW_ADDRESS_VIEW_BACKGROUND_COLOR           [UIColor colorWithWhite:0 alpha:0.6]
#define ADD_NEW_ADDRESS_LINEVIEW_BACKGROUND_COLOR       [UIColor colorWithRed:0.808 green:0.812 blue:0.816 alpha:1.000]
#define ADD_NEW_ADDRESS_VIEW_TEXT_STRING_FONT_SIZE        17.
#define ADD_NEW_ADDRESS_VIEW_TEXT_TIP_COLOR             [UIColor colorWithRed:0.505 green:0.513 blue:0.525 alpha:1.000]
#define ADD_NEW_ADDRESS_VIEW_TEXT_INFO_COLOR             [UIColor colorWithRed:0.503 green:0.183 blue:0.236 alpha:1.000]
#define ADD_NEW_ADDRESS_PICKERVIEW_BACKGROUND_COLOR           [UIColor colorWithWhite:1 alpha:0.6]


@interface QSPOrderAddNewAddressView ()<QSPItemSelectePopViewDelegate>

@property(nonatomic,strong) UIView                    *contentBackgroundView;
@property(nonatomic,assign) CGRect                    contentFrame;
@property(nonatomic,strong) UIScrollView              *scrollView;
@property(nonatomic,strong) UIButton                  *submitBt;
@property(nonatomic,strong) QSPAddNewAddressTextField *nameTextField;
@property(nonatomic,strong) QSPAddNewAddressTextField *sexTextField;
@property(nonatomic,strong) QSPAddNewAddressTextField *cityTextField;
@property(nonatomic,strong) QSPAddNewAddressTextField *areaTextField;
@property(nonatomic,strong) QSPAddNewAddressTextField *addressTextField;
@property(nonatomic,strong) QSPAddNewAddressTextField *companyTextField;
@property(nonatomic,strong) QSPAddNewAddressTextField *telephoneTextField;
@property(nonatomic,strong) QSLabel                   *sexLabel;
@property(nonatomic,strong) QSDatePickerViewController *sexPickerView;

@property (nonatomic,retain) QSUserInfoDataModel *userInfo;//!<当前用户信息

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
        
        ///获取用户信息
        self.userInfo = nil;
        
        //半透明背景层
        [self setFrame:CGRectMake(0, 0, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT*2)];
        [self setBackgroundColor:ADD_NEW_ADDRESS_VIEW_BACKGROUND_COLOR];
        
        //背景关闭按钮
        QSBlockButtonStyleModel *bgBtStyleModel = [QSBlockButtonStyleModel alloc];
        UIButton *bgBt = [UIButton createBlockButtonWithFrame:self.frame andButtonStyle:bgBtStyleModel andCallBack:^(UIButton *button) {
            if (delegate) {
                [delegate closeAddNewAddressView];
            }
            [self hideAddNewAddressView];
            [self removeFromSuperview];
        }];
        [self addSubview:bgBt];
        
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
            if (delegate) {
                [delegate closeAddNewAddressView];
            }
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
            
            ///保存送餐地址到个人送餐地址中
            [self saveSendAddress];

            [self hideAddNewAddressView];
            [self removeFromSuperview];
            if (delegate) {
                
                [delegate AddNewAddressWithData:[self getAddressData]];
                
            }
            
        }];
        [_contentBackgroundView addSubview:_submitBt];
        
        [_contentBackgroundView setFrame:CGRectMake(_contentBackgroundView.frame.origin.x,_contentBackgroundView.frame.origin.y, _contentBackgroundView.frame.size.width, _submitBt.frame.origin.y+_submitBt.frame.size.height+12)];
        
        [_contentBackgroundView setCenter:CGPointMake(self.frame.size.width/2, SIZE_DEVICE_HEIGHT/2)];
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
    if (self.userInfo.receidName && self.userInfo.receidName.length > 2) {
        
        self.nameTextField.text = self.userInfo.receidName;
        
    } else {
    
        [self.nameTextField setPlaceholder:@"请填写联系人姓名"];
    
    }
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
        
        if ([[UIDevice currentDevice].systemVersion doubleValue] == 7.0) {
            //iOS7.0 使用ActionSheet
            UIActionSheet *acs = [[UIActionSheet alloc] initWithTitle:@"请选择您的性别" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"先生",@"女士", nil];
            [acs setDelegate:self];
            [acs showInView:self];
            return;
        }

        ///弹出性别选择窗口
        self.sexPickerView = [[QSDatePickerViewController alloc] init];
        self.sexPickerView.pickerType = kPickerType_Item;
        self.sexPickerView.dataSource = [[NSMutableArray alloc] initWithArray:@[@"女士",@"先生"]];
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
    [self.sexLabel setText:(self.userInfo.gender ? (([self.userInfo.gender intValue] == 0) ? @"先生" : @"女士") : @"先生")];
    [sexBt addSubview:self.sexLabel];
    
    [_scrollView addSubview:sexBt];
    
    self.cityTextField = [[QSPAddNewAddressTextField alloc] initWithFrame:CGRectMake(0, self.sexTextField.frame.origin.y+self.sexTextField.frame.size.height+10, (_scrollView.frame.size.width-10)/2, 44)];
    [self.cityTextField setPlaceholder:@"请选择城市"];
    [self.cityTextField setDelegate:self];
    [self.cityTextField setUserInteractionEnabled:NO];
    [_scrollView addSubview:self.cityTextField];
    
    ///城市选择按钮
    QSBlockButtonStyleModel *cityBtStyle = [[QSBlockButtonStyleModel alloc] init];
    [cityBtStyle setTitleNormalColor:PLACEHOLDER_TEXT_COLOR];
    [cityBtStyle setBgColor:[UIColor clearColor]];
    UIButton *cityBt = [UIButton createBlockButtonWithFrame:self.cityTextField.frame andButtonStyle:cityBtStyle andCallBack:^(UIButton *button) {
        NSLog(@"cityBT ");
        [self hideKeybord];
        
        //!!!! : 城市数组
        NSArray *cityArray = [NSArray arrayWithObjects:@"广州", nil ];
        
        if ([cityArray count]==1) {//只有一个时直接默认选择，不弹选择框
            [self.cityTextField setPlaceholder:[cityArray objectAtIndex:0]];
            return ;
        }
        
        QSPItemSelectePopView *selectView = [QSPItemSelectePopView getItemSelectePopView];
        [self addSubview:selectView];
        [selectView setDelegate:self];
        [selectView setTag:110];
        [selectView updateSelectData:cityArray];
        [selectView showItemSelectePopView];
    }];
    UIImageView *cityArrowMarkView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"public_arrow_normal"]];
    [cityArrowMarkView setFrame:CGRectMake(cityBt.frame.size.width-cityArrowMarkView.frame.size.width-6, (cityBt.frame.size.height-cityArrowMarkView.frame.size.height)/2, cityArrowMarkView.frame.size.width, cityArrowMarkView.frame.size.height)];
    [cityBt addSubview:cityArrowMarkView];
    [_scrollView addSubview:cityBt];
    
    self.areaTextField = [[QSPAddNewAddressTextField alloc] initWithFrame:CGRectMake(self.cityTextField.frame.origin.x+self.cityTextField.frame.size.width+10, self.sexTextField.frame.origin.y+self.sexTextField.frame.size.height+10, self.cityTextField.frame.size.width, 44)];
    [self.areaTextField setPlaceholder:@"请选择区"];
    [self.areaTextField setDelegate:self];
    [self.areaTextField setUserInteractionEnabled:NO];
    [_scrollView addSubview:self.areaTextField];
    
    ///区选择按钮
    QSBlockButtonStyleModel *areaBtStyle = [[QSBlockButtonStyleModel alloc] init];
    [areaBtStyle setTitleNormalColor:PLACEHOLDER_TEXT_COLOR];
    [areaBtStyle setBgColor:[UIColor clearColor]];
    UIButton *areaBt = [UIButton createBlockButtonWithFrame:self.areaTextField.frame andButtonStyle:areaBtStyle andCallBack:^(UIButton *button) {
        NSLog(@"areaBT ");
        [self hideKeybord];
        
        ///数据地址
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/districtData"];
        ///首先转成data
        NSData *saveData = [NSData dataWithContentsOfFile:path];
        ///encode数据
        QSDistrictReturnData *districtData = [NSKeyedUnarchiver unarchiveObjectWithData:saveData];
        
        //区数组
        NSMutableArray *areaArray = [NSMutableArray arrayWithCapacity:0];
        for (QSDistrictDataModel *data in districtData.districtList) {
            if (data&&[data isKindOfClass:[QSDistrictDataModel class]]) {
                QSDistrictDataModel *areaData = (QSDistrictDataModel*)data;
                if ([areaData.status isEqualToString:@"1"]) {
                    [areaArray addObject:areaData.val];
                }
            }
        }
        
        if ([areaArray count]==1) {//只有一个时直接默认选择，不弹选择框
            [self.areaTextField setPlaceholder:[areaArray objectAtIndex:0]];
            return ;
        }
        
        QSPItemSelectePopView *selectView = [QSPItemSelectePopView getItemSelectePopView];
        [self addSubview:selectView];
        [selectView setDelegate:self];
        [selectView setTag:111];
        [selectView updateSelectData:areaArray];
        [selectView showItemSelectePopView];
    }];
    UIImageView *areaArrowMarkView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"public_arrow_normal"]];
    [areaArrowMarkView setFrame:CGRectMake(areaBt.frame.size.width-areaArrowMarkView.frame.size.width-6, (areaBt.frame.size.height-areaArrowMarkView.frame.size.height)/2, areaArrowMarkView.frame.size.width, areaArrowMarkView.frame.size.height)];
    [areaBt addSubview:areaArrowMarkView];
    [_scrollView addSubview:areaBt];
    
    self.addressTextField = [[QSPAddNewAddressTextField alloc] initWithFrame:CGRectMake(0, self.cityTextField.frame.origin.y+self.cityTextField.frame.size.height+10, _scrollView.frame.size.width, 44)];
    [self.addressTextField setDelegate:self];
    
    if (self.userInfo.address && self.userInfo.address.length > 2) {
        
        self.addressTextField.text = self.userInfo.address;
        
    } else {
    
        [self.addressTextField setPlaceholder:@"送餐地址，请尽量填写详细"];
    
    }
    
    [_scrollView addSubview:self.addressTextField];
    
    self.companyTextField = [[QSPAddNewAddressTextField alloc] initWithFrame:CGRectMake(0, self.addressTextField.frame.origin.y+self.addressTextField.frame.size.height+10, _scrollView.frame.size.width, 44)];
    
    if (self.userInfo.company && self.userInfo.company.length > 2) {
        
        self.companyTextField.text = self.userInfo.company;
        
    } else {
    
        [self.companyTextField setPlaceholder:@"请输入公司名称"];
    
    }
    
    [self.companyTextField setDelegate:self];
    [_scrollView addSubview:self.companyTextField];
    
    self.telephoneTextField = [[QSPAddNewAddressTextField alloc] initWithFrame:CGRectMake(0, self.companyTextField.frame.origin.y + self.companyTextField.frame.size.height+10, _scrollView.frame.size.width, 44)];
    [self.telephoneTextField setPlaceholder:@"配送人员联系您的电话"];
    NSString *tempPhone = [self.userInfo.phone copy];
    if (tempPhone && tempPhone.length == 11) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            self.telephoneTextField.text = self.userInfo.phone;
            
        });
        
    }
    
    [self.telephoneTextField setDelegate:self];
    [_scrollView addSubview:self.telephoneTextField];
    
    scrollViewContentHight = self.telephoneTextField.frame.origin.y + self.telephoneTextField.frame.size.height;
    [_scrollView setFrame:CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y, _scrollView.frame.size.width, scrollViewContentHight>scrollViewMaxHeight?scrollViewMaxHeight:scrollViewContentHight)];
    [_scrollView setContentSize:CGSizeMake(_scrollView.contentSize.width, scrollViewContentHight)];
    
    [_submitBt setFrame:CGRectMake(12, _scrollView.frame.origin.y+_scrollView.frame.size.height+10, _submitBt.frame.size.width, _submitBt.frame.size.height)];
    [_contentBackgroundView setFrame:CGRectMake(_contentBackgroundView.frame.origin.x,_contentBackgroundView.frame.origin.y, _contentBackgroundView.frame.size.width, _submitBt.frame.origin.y+_submitBt.frame.size.height+12)];
    [_contentBackgroundView setCenter:CGPointMake(self.frame.size.width/2, SIZE_DEVICE_HEIGHT/2)];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            //先生
            self.sexLabel.text = @"先生";
            break;
        case 1:
            //女士
            self.sexLabel.text = @"女士";
            break;
        default:
            break;
    }
}

- (BOOL)checkAddress
{
    
    BOOL flag = YES;
    
    NSString *infoStr = @"";
    if (flag && [[self.nameTextField text] isEqualToString:@""]) {
        
        flag = NO;
        infoStr= @"请输入联系人姓名";
        
    }
    
    if (flag && [[self.cityTextField placeholder] isEqualToString:@"请选择城市"]) {
        
        flag = NO;
        infoStr= @"请选择城市";
        
    }
    
    if (flag && [[self.areaTextField placeholder] isEqualToString:@"请选择区"]) {
        
        flag = NO;
        infoStr= @"请选择区";
        
    }
    
    if (flag && [[self.addressTextField text] isEqualToString:@""]) {
        
        flag = NO;
        infoStr= @"请输入送餐地址";
        
    }
    
    if (flag && [[self.telephoneTextField text] isEqualToString:@""]) {
        
        flag = NO;
        infoStr= @"请输入联系电话";
        
    }
    
    if (flag && ![[self.telephoneTextField text] isEqualToString:@""]) {
        
        if (![self isMobileNumberClassification:[self.telephoneTextField text]]) {
            
            flag = NO;
            infoStr= @"请输入正确的联系电话格式";
            
        }
        
    }
    
    if (!flag) {
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"%@",infoStr] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
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
    [addressDic setObject:[self.cityTextField placeholder] forKey:@"city"];
    [addressDic setObject:[self.areaTextField placeholder] forKey:@"area"];
    
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
    
    [self animateTextField: textField witMoveUpOrDown:YES];
    
}

//在UITextField 编辑完成调用方法
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    [self animateTextField: textField witMoveUpOrDown:NO];
    
}

//视图上移的方法
- (void) animateTextField: (UITextField *) textField  witMoveUpOrDown:(BOOL)flag
{
    
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    CGRect rect = [textField convertRect: textField.bounds toView:window];
    
    //设置视图上移的距离，单位像素
    int movementDistance =(SIZE_DEVICE_HEIGHT - 280) - (rect.origin.y+rect.size.height); // tweak as needed
    //三目运算，判定是否需要上移视图或者不变
    int movement = movementDistance<0?movementDistance:0;
    
    //设置动画的名字
    [UIView beginAnimations: @"Animation" context: nil];
    //设置动画的开始移动位置
    [UIView setAnimationBeginsFromCurrentState: YES];
    //设置动画的间隔时间
    [UIView setAnimationDuration: 0.20];
    //设置视图移动的位移
    if (flag) {
        self.frame = CGRectOffset(self.frame, 0, movement);
    }else{
        self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
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

#pragma mark - 保存送餐地址到个人信息中
- (void)saveSendAddress
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        ///性别
        NSString *genderString = self.sexLabel.text ? self.sexLabel.text : @"先生";
        NSString *gender = ([genderString isEqualToString:@"先生"]) ? @"0" : @"1";
        
        ///地址
        NSString *address = [NSString stringWithFormat:@"%@%@%@",self.cityTextField.placeholder,self.areaTextField.placeholder,self.addressTextField.text];
        
        ///公司
        NSString *company = self.companyTextField.text;
        
        ///电话
        NSString *phone = self.telephoneTextField.text;
        
        ///是否默认配送地址
        NSString *isMaster = @"1";
        
        ///用户名
        NSString *name = self.nameTextField.text;
        
        ///生成参数
        NSDictionary *params = @{@"name" : name,
                                 @"sex" : gender,
                                 @"address" : address,
                                 @"company" : company,
                                 @"phone" : phone,
                                 @"master" : isMaster};
        
        ///发回服务端添加
        [QSRequestManager requestDataWithType:rRequestTypeAddSendAddress andParams:params andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
            
            ///添加成功
            if (rRequestResultTypeSuccess == resultStatus) {
                
                ///打印成功信息
                NSLog(@"====================用户送餐地址添加成功====================");
                
                ///刷新当前用户数据
                [QSUserManager updateUserData:^(BOOL flag) {
                    
                    if (flag) {
                        
                        NSLog(@"====================用户信息更新成功====================");
                        
                    } else {
                    
                        NSLog(@"====================用户信息更新失败====================");
                    
                    }
                    
                }];
                
            } else {
                
                NSLog(@"====================用户送餐地址添加失败====================");
                
            }
            
        }];
        
    });

}

#pragma mark -QSPItemSelectePopViewDelegate

- (void)selectedItem:(id)data withIndex:(NSInteger)index inView:(QSPItemSelectePopView*)view
{
    if (view.tag == 110) {
        //城市名字
        NSString *cityName = @"";
        if (data&&[data isKindOfClass:[NSString class]]) {
            cityName = (NSString*)data;
        }
        [self.cityTextField setPlaceholder:cityName];
    }else if (view.tag == 111) {
        //区名字
        NSString *areaName = @"";
        if (data&&[data isKindOfClass:[NSString class]]) {
            areaName = (NSString*)data;
        }
        [self.areaTextField setPlaceholder:areaName];
    }
}

@end

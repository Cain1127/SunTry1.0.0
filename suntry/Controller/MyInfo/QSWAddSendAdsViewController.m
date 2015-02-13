//
//  QSWAddSendAdsViewController.m
//  suntry
//
//  Created by 王树朋 on 15/2/7.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWAddSendAdsViewController.h"
#import "QSWSettingCell.h"
#import "QSWSettingItem.h"
#import "QSWSettingGroup.h"
#import "QSWSettingArrowItem.h"
#import "QSWTextFieldItem.h"
#import "DeviceSizeHeader.h"
@interface QSWAddSendAdsViewController ()<UITextFieldDelegate>

@end

@implementation QSWAddSendAdsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title=@"新增送餐地址";
    [self setupGroup0];
    [self setupGroup1];
    [self setupGroup2];
    [self setupGroup3];
    [self setupGroup4];
    [self setupFooter];
    
}

-(void)setupGroup0
{

    QSWSettingGroup *group = [self addGroup];
    
    QSWTextFieldItem *item = [QSWTextFieldItem itemWithTitle:@"请填写联系人姓名"];
    
    group.items = @[item];

}

-(void)setupGroup1
{
    
    QSWSettingGroup *group = [self addGroup];
    
    QSWTextFieldItem *item = [QSWTextFieldItem itemWithTitle:@"您的性别"];
    
    
    group.items = @[item];
    
}

-(void)setupGroup2
{
    
    QSWSettingGroup *group = [self addGroup];
    
    QSWTextFieldItem *item = [QSWTextFieldItem itemWithTitle:@"送餐地址请尽量填写详细"];
    
    
    group.items = @[item];
    
}

-(void)setupGroup3
{
    
    QSWSettingGroup *group = [self addGroup];
    
    QSWTextFieldItem *item = [QSWTextFieldItem itemWithTitle:@"请输入公司全称"];
    
    
    group.items = @[item];
    
}

-(void)setupGroup4
{
    
    QSWSettingGroup *group = [self addGroup];
    
    QSWTextFieldItem *item = [QSWTextFieldItem itemWithTitle:@"配送人员联系您的电话"];
    
    group.items = @[item];
    
}

- (void)setupFooter
{
    // 按钮
    UIButton *footterButton = [[UIButton alloc] init];
    CGFloat footterButtonX = SIZE_DEFAULT_MARGIN_LEFT_RIGHT + 2;
    CGFloat footterButtonY = 10;
    CGFloat footterButtonW = self.tableView.frame.size.width - 2 * footterButtonX;
    CGFloat footterButtonH = 44;
    footterButton.frame = CGRectMake(footterButtonX, footterButtonY, footterButtonW, footterButtonH);
    
    // 背景和文字
    [footterButton setBackgroundImage:[UIImage imageNamed:@"nav_backgroud"] forState:UIControlStateNormal];
    [footterButton setBackgroundImage:[UIImage imageNamed:@"nav_backgroud"] forState:UIControlStateHighlighted];
    [footterButton setTitle:@"添加" forState:UIControlStateNormal];
    footterButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [footterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    // footer
    UIView *footer = [[UIView alloc] init];
    CGFloat footerH = footterButtonH + 20;
    footer.frame = CGRectMake(0, 0, 0, footerH);
    self.tableView.tableFooterView = footer;
    [footer addSubview:footterButton];
    [footterButton addTarget:self action:@selector(gotoNextVC) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)gotoNextVC
{


}


#pragma mark--UItextFieldDelegate方法
///开始编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (textField.tag == 200) {
        
        return YES;
        
    }
    
    if (textField.tag==201) {
        
        
    }
    
    return NO;
    
}

///键盘回收
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    NSLog(@"%@",textField.text);
    return YES;
    
}

///键盘回收
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITextField *textField = (UITextField *)[self.view viewWithTag:200];
    [textField resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  QSWLoginViewController.m
//  suntry
//
//  Created by 王树朋 on 15/2/13.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWLoginViewController.h"
#import "QSWSettingCell.h"
#import "QSWSettingItem.h"
#import "QSWSettingGroup.h"
#import "QSWTextFieldItem.h"
#import "DeviceSizeHeader.h"
#import "QSMyinfoViewController.h"

@interface QSWLoginViewController ()

@end

@implementation QSWLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"登录";
    [self setupGroup0];
    [self setupGroup1];
    [self setupFooter];
}

-(void)setupGroup0
{
    
    QSWSettingGroup *group = [self addGroup];
    
    QSWTextFieldItem *item = [QSWTextFieldItem itemWithTitle:@"输入您的手机号码"];
    
    
    group.items = @[item];
    
}

-(void)setupGroup1
{
    
    QSWSettingGroup *group = [self addGroup];
    
    QSWTextFieldItem *item = [QSWTextFieldItem itemWithTitle:@"输入您的登录密码"];
    
    
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
    [footterButton setTitle:@"登录" forState:UIControlStateNormal];
    footterButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [footterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    // footer
    UIView *footer = [[UIView alloc] init];
    CGFloat footerH = footterButtonH + 20.0f + SIZE_DEFAULT_MARGIN_LEFT_RIGHT+30.0f;
    footer.frame = CGRectMake(0, 0, 0, footerH);
    self.tableView.tableFooterView = footer;
    [footer addSubview:footterButton];
    [footterButton addTarget:self action:@selector(gotoLoginVC) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *forgetPsw=[[UILabel alloc]initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEFAULT_MARGIN_LEFT_RIGHT,100.0f, 30.0f)];
    forgetPsw.text=@"忘记密码";
    forgetPsw.textAlignment=NSTextAlignmentLeft;
    [footer addSubview:forgetPsw];
    
    UILabel *rerestPsw=[[UILabel alloc]initWithFrame:CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_WIDTH-SIZE_DEFAULT_MARGIN_LEFT_RIGHT-100.0f,100.0f, 30.0f)];
    rerestPsw.text=@"重置密码";
    rerestPsw.textAlignment=NSTextAlignmentRight;
    [footer addSubview:rerestPsw];
    
    
}

///进入登录界面
-(void)gotoLoginVC
{
    
    QSMyinfoViewController *myinfo=[[QSMyinfoViewController alloc] init];
    [self.navigationController pushViewController:myinfo animated:YES];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

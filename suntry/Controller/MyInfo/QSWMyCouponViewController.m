//
//  QSWMyCouponViewController.m
//  suntry
//
//  Created by 王树朋 on 15/2/6.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSWMyCouponViewController.h"
#import "QSWSettingCell.h"
#import "QSWSettingItem.h"
#import "QSWSettingGroup.h"
#import "QSWSettingArrowItem.h"
#import "DeviceSizeHeader.h"
#import "ColorHeader.h"

@interface QSWMyCouponViewController ()<UITextFieldDelegate>

@end

@implementation QSWMyCouponViewController

- (void)viewDidLoad {
    
    ///自定义返回按钮
    UIBarButtonItem *turnBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(turnBackAction)];
    turnBackButton.tintColor = [UIColor whiteColor];
    
    ///设置返回按钮的颜色
    [turnBackButton setBackButtonBackgroundImage:[UIImage imageNamed:@"nav_back_normal"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [turnBackButton setBackButtonBackgroundImage:[UIImage imageNamed:@"nav_back_selected"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    self.navigationItem.leftBarButtonItem = turnBackButton;
    
    [super viewDidLoad];
    self.title=@"我的优惠券";
    [self setupHeader];
    [self setupGrounp0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupHeader

{

    ///1.添加textfield输入框控件
    UITextField *textfield=[[UITextField alloc] init];
    textfield.placeholder = @"输入您的优惠编码";
    textfield.translatesAutoresizingMaskIntoConstraints=NO;
    textfield.returnKeyType=UIReturnKeySearch;
    //textfield.autocorrectionType=UITextAutocorrectionTypeNo;
    textfield.clearButtonMode=UITextFieldViewModeUnlessEditing;
    textfield.delegate=self;
    textfield.tag = 200;
    textfield.borderStyle = UITextBorderStyleRoundedRect;
    
    ///2.添加按钮
    
    UIButton *addButton=[[UIButton alloc]init];
    addButton.translatesAutoresizingMaskIntoConstraints=NO;
    addButton.layer.cornerRadius = 6.0f;
    [addButton setTitle:@"添加" forState:UIControlStateNormal];
    addButton.backgroundColor=COLOR_CHARACTERS_RED;
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addButton.layer.cornerRadius=6.0f;
    [addButton addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    ///3.headerView
    UIView *header = [[UIView alloc] init];
    CGFloat headerH = 44.0f+2*SIZE_DEFAULT_MARGIN_LEFT_RIGHT;
    header.frame = CGRectMake(0, 0, SIZE_DEVICE_WIDTH-2*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, headerH);
    self.tableView.tableHeaderView = header;
    [header addSubview:textfield];
    [header addSubview:addButton];
    
    ///4.添加VFL约束
    ///参数
    NSDictionary *___viewsVFL=NSDictionaryOfVariableBindings(textfield,addButton);
    NSDictionary *___sizeVFL = @{@"margin" : [NSString stringWithFormat:@"%.2f",SIZE_DEFAULT_MARGIN_LEFT_RIGHT]};
    
    ///约束
    NSString *___hVFL_textField = @"H:|-margin-[textfield]-5-[addButton(64)]-margin-|";
    NSString *___vVFL_textField = @"V:|-margin-[textfield(44)]";
    NSString *___vVFL_addButton=@"V:[addButton(44)]";
    
    ///添加约束
    [header addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_textField options:NSLayoutFormatAlignAllCenterY metrics:___sizeVFL views:___viewsVFL]];
    [header addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_textField  options:0 metrics:___sizeVFL views:___viewsVFL]];
    [header addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_addButton options:0 metrics:___sizeVFL views:___viewsVFL]];
    
}

#pragma mark - 返回事件
- (void)turnBackAction
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

///搜索按钮事件
-(void)addButtonAction
{

    
}

-(void)setupGrounp0
{

    QSWSettingGroup *group = [self addGroup];
    
    QSWSettingItem *item = [QSWSettingItem itemWithIcon:@"home_car_selected" title:@"李先生:119110118" subtitle:@"地址:天河体育西108号"];
    
    group.items = @[item];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;

}

@end

//
//  QSHomeViewController.m
//  SunTry
//
//  Created by 王树朋 on 15/1/31.
//  Copyright (c) 2015年 wangshupeng. All rights reserved.
//

#import "QSHomeViewController.h"
#import "UITextField+CustomField.h"
#import "DeviceSizeHeader.h"
#import "ColorHeader.h"
#import "QSMapManager.h"
#import "QSWMerchantIndexViewController.h"

@interface QSHomeViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,copy)  NSString *inputContent;//!<输入框内容
@property (nonatomic,strong)NSArray *searchDataSource;//!<返回数据源
@property (nonatomic,strong)UITextField *locationTextField;//!<定位搜索
@property (nonatomic,strong)UIImageView *chooseImage;//选择图片框

@end

@implementation QSHomeViewController


///获取输入框内容
-(NSString *)inputContent
{
    if (_inputContent==nil) {
        
        NSString *dict=[[NSString alloc]init];
        
        _inputContent=dict;
    }
    
    return _inputContent;
    
}

///获取接口数据
-(NSArray *)searchDataSource
{
    if (_searchDataSource==nil) {
        //NSArray *dictArry=[NSArray arrayWithObject:<#(id)#>];
    }
    
    return _searchDataSource;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title=[NSString stringWithFormat:@"天河"];
    
    ///1.添加textfield输入框控件
    UITextField *textfield=[[UITextField alloc] init];
    textfield.placeholder = @"请输入您的位置";
    textfield.translatesAutoresizingMaskIntoConstraints=NO;
    textfield.returnKeyType=UIReturnKeySearch;
    //textfield.autocorrectionType=UITextAutocorrectionTypeNo;
    textfield.clearButtonMode=UITextFieldViewModeUnlessEditing;
    textfield.delegate=self;
    textfield.tag = 200;
    textfield.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:textfield];
    
    ///2.添加搜索框按钮
    UIButton *searchButton=[[UIButton alloc] init];
    searchButton.translatesAutoresizingMaskIntoConstraints=NO;
    searchButton.backgroundColor=COLOR_CHARACTERS_RED;
    searchButton.layer.cornerRadius = 6.0f;
    [searchButton setImage:[UIImage imageNamed:@"public_search_normal"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(locationSearch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchButton];
    
    ///3.添加定位textfield
    //添加中间文字内容
    _locationTextField=[[UITextField alloc] init];
    _locationTextField.translatesAutoresizingMaskIntoConstraints=NO;
    _locationTextField.borderStyle=UITextBorderStyleRoundedRect;
    _locationTextField.autocorrectionType=UITextAutocorrectionTypeNo;
    _locationTextField.text=@"定位当前地址" ;
    
    //添加左边选择状态图片
    _chooseImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"public_choose_normal"]];
    _chooseImage.highlightedImage=[UIImage imageNamed:@"public_choose_selected"];
    _locationTextField.leftView=_chooseImage;
    _locationTextField.leftViewMode=UITextFieldViewModeAlways;
    _locationTextField.delegate = self;
    _locationTextField.tag=201;
    
    [self.view addSubview:_locationTextField];
    
    ///textfiled公共属性
    textfield.enablesReturnKeyAutomatically=YES;//!<没有输入任何字符的话，右下角的返回按钮是disabled
    
    ///2.VFL生成约束
    
    ///参数
    NSDictionary *___viewsVFL=NSDictionaryOfVariableBindings(textfield,searchButton,_locationTextField);
    NSDictionary *___sizeVFL = @{@"margin" : [NSString stringWithFormat:@"%.2f",SIZE_DEFAULT_MARGIN_LEFT_RIGHT]};
    
    ///约束
    NSString *___hVFL_textField = @"H:|-margin-[textfield]-5-[searchButton(44)]-margin-|";
    NSString *___hVFL_locationTextField = @"H:|-margin-[_locationTextField(>=160)]-margin-|";
    NSString *___vVFL_all = @"V:|-10-[textfield(44)]-8-[_locationTextField(textfield)]";
    
    ///添加约束
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_textField options:NSLayoutFormatAlignAllCenterY metrics:___sizeVFL views:___viewsVFL]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___hVFL_locationTextField options:0 metrics:___sizeVFL views:___viewsVFL]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:___vVFL_all options:0 metrics:___sizeVFL views:___viewsVFL]];
    
}

///点击按钮搜索事件
-(void)locationSearch
{
    [self touchesBegan:nil withEvent:nil];
    ///删除定位按钮
    [UIView animateWithDuration:0.5 animations:^{
        
        [_locationTextField removeFromSuperview];
        
    } completion:^(BOOL finished) {
        
        [self setupTabbleView];
        
    }];
}

///加载返回的搜索tabbleview
-(void)setupTabbleView
{
    
    CGRect rect=CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 66.0f, SIZE_DEFAULT_MAX_WIDTH-2*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 44 * 5);
    UITableView *tabbleView=[[UITableView alloc]initWithFrame:rect];
    tabbleView.delegate=self;
    tabbleView.dataSource=self;
    [self.view addSubview:tabbleView];
    
}

#pragma mark --UItabbleViewDelegate方法
///返回行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 5;
    //return self.searchDataSource.count;
    
}

/// 返回行高
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44.0f;
    
}

///返回的每行
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *Indentifier=@"cellIndentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:Indentifier];
    
    if (cell==nil) {
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Indentifier];
        cell.imageView.image=[UIImage imageNamed:@"public_choose_normal"];
        cell.textLabel.text=[NSString stringWithFormat:@"城建大厦"];
    }
    
    return cell;
    
}

///点击每一行事件
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self touchesBegan:nil withEvent:nil];
    QSWMerchantIndexViewController *VC=[[QSWMerchantIndexViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
    
}

#pragma mark--UItextFieldDelegate方法
///开始编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (textField.tag == 200) {
        
        _inputContent=nil;
        _inputContent=textField.text;
        
        return YES;
        
    }
    
    if (textField.tag==201) {
        
        [self locationSearch];
        
        ///定位搜索
        //        QSMapManager *mapManager=[[QSMapManager alloc]init];
        //        [mapManager getUserLocation:^(BOOL isLocalSuccess, NSString *placename) {
        //
        //            NSLog(@"当前用户地标%@",placename);
        //            _inputContent=placename;
        //            [self locationSearch];
        //
        //        }];
        
    }
    
    
    return NO;
    
}

///键盘回收
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    [self locationSearch];
    NSLog(@"%@",textField.text);
    return YES;
    
}

///键盘回收
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITextField *textField = (UITextField *)[self.view viewWithTag:200];
    [textField resignFirstResponder];
    
}

@end

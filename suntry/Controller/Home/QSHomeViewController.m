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
#import "QSBlockButton.h"
#import "QSRequestManager.h"
#import "QSRequestTaskDataModel.h"
#import "QSSelectDataModel.h"
#import "QSSelectReturnData.h"
#import "QSDistrictReturnData.h"

typedef enum {
    DistrictListTable= 1,
    SearchListTable
}tableViewType;

@interface QSHomeViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    BOOL isOpened;
}

@property(nonatomic,strong) UITableView *districtListTableView;//区选择view
@property(nonatomic,strong) NSArray   *districtList;//区选择数据列表
@property(nonatomic,strong) UIButton *districtButton;//区选择按钮
@property(nonatomic,strong) NSString *districtName;//区名

@property (nonatomic,copy)  NSString *inputContent;//!<输入框内容
@property (nonatomic,strong)UITextField *locationTextField;//!<定位搜索
@property (nonatomic,strong)UIImageView *chooseImage;//选择图片框

@property(nonatomic,strong) UITableView *searchListTableView;//搜索返回列表view
@property(nonatomic,strong) NSArray     *searchList;//搜索返回数据
@property(nonatomic,assign) int streetID;//街道ID
@end

@implementation QSHomeViewController


///获取输入框内容
-(NSString *)inputContent
{
    if (_inputContent==nil) {
        
        NSString *dict=[[NSString alloc] init];
        
        _inputContent=dict;
        
    }
    
    return _inputContent;
    
}

///获取区的接口数据
-(NSArray *)districtList
{
    if (_districtList==nil) {
        
        ///数据地址
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/districtData"];
        
        ///首先转成data
        NSData *saveData = [NSData dataWithContentsOfFile:path];
        
        ///encode数据
        QSDistrictReturnData *districtData = [NSKeyedUnarchiver unarchiveObjectWithData:saveData];
        self.districtList = [[NSMutableArray alloc] initWithArray:districtData.districtList];
        
        NSLog(@"================区信息个数================");
        NSLog(@"%ld",self.districtList.count);
        NSLog(@"================区信息个数================");
        
    }
    
    return _districtList;
}

-(NSArray *)searchList
{
    
    if (_searchList==nil) {
        
        ///数据地址
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/selectData"];
        ///首先转成data
        NSData *saveData = [NSData dataWithContentsOfFile:path];
        
        ///encode数据
        QSSelectReturnData *selectData = [NSKeyedUnarchiver unarchiveObjectWithData:saveData];
        self.searchList = [[NSMutableArray alloc] initWithArray:selectData.selectList];
        
        NSLog(@"===============天河区模糊搜索数据数量================");
        NSLog(@"%ld", self.searchList.count);
         NSLog(@"===============天河区模糊搜索数据数量================");

    }
    return _searchList;

}

#pragma mark --加载控件
- (void)viewDidLoad {
    
    [super viewDidLoad];
 
     isOpened=NO;
    
    ///0.添加导航栏主题view
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70.0f, 30.0f)];
    [navTitle setFont:[UIFont boldSystemFontOfSize:17]];
    [navTitle setTextColor:[UIColor whiteColor]];
    [navTitle setBackgroundColor:[UIColor clearColor]];
    [navTitle setTextAlignment:NSTextAlignmentRight];
    [navTitle setText:@"天河区"];
    
    UIImageView *titleImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_arrow_down"] ];
    
    _districtButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 110.0f, 30.0f)];
    [_districtButton addSubview:navTitle];
    [_districtButton addSubview:titleImageView];

    self.navigationItem.titleView = _districtButton;
    [_districtButton addTarget:self action:@selector(setupTopTableView) forControlEvents:UIControlEventTouchUpInside];
    
    //默认选中天河
    [self.districtListTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    
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
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem=backItem;
    //backItem.image=[UIImage imageNamed:@"nav_back_normal"];
    backItem.title=@"";
    
}

#pragma mark --按钮点击事件
-(void)locationSearch
{
    [self touchesBegan:nil withEvent:nil];
    ///删除定位按钮
    [UIView animateWithDuration:0.5 animations:^{
        
        [_locationTextField removeFromSuperview];
        
    } completion:^(BOOL finished) {
        
        [self setupSearchTabbleView];
        
    }];
}

///加载头部区选择的tabbleview
-(void)setupTopTableView
{
    // 1.(状态取反)
    isOpened=!isOpened;
    
    if (isOpened) {
        
        self.districtButton.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
        //1.加载discitTabbleView
        _districtListTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, _districtButton.frame.origin.y, SIZE_DEVICE_WIDTH, [_districtList count]*35.0f)];
        _districtListTableView.delegate=self;
        _districtListTableView.dataSource=self;
        [_districtListTableView setTag: DistrictListTable];
        
        [self.view addSubview:_districtListTableView];
        
        ///刷新数据
        [self.districtListTableView reloadData];
    }
    else
      {
         self.districtButton.imageView.transform = CGAffineTransformMakeRotation(0);
        [_districtListTableView removeFromSuperview];
       }
        
    }

///加载返回的搜索tabbleview
-(void)setupSearchTabbleView
{
    
    CGRect rect=CGRectMake(SIZE_DEFAULT_MARGIN_LEFT_RIGHT, 66.0f, SIZE_DEFAULT_MAX_WIDTH-2*SIZE_DEFAULT_MARGIN_LEFT_RIGHT, SIZE_DEVICE_HEIGHT-64.0f-49.0f-66.0f);
    _searchListTableView=[[UITableView alloc]initWithFrame:rect];
    _searchListTableView.delegate=self;
    _searchListTableView.dataSource=self;
    [_searchListTableView setTag:SearchListTable];
    [self.view addSubview:_searchListTableView];
    
    ///刷新数据
    [self.searchListTableView reloadData];
    
}

#pragma mark --UItabbleViewDelegate代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    NSInteger count = 1;
    
    switch (tableView.tag){
            
        case DistrictListTable:
            
            break;
            
        case SearchListTable:
            
            count = 1;
            
            break;
        default:
            break;
            
    }
    
    return count;
    
}

///返回行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSInteger count = 0;
    
    switch (tableView.tag){
            
        case DistrictListTable:
            
            count = [self.districtList count];
            
            break;
            
        case SearchListTable:
          
            count = [self.searchList count];
            
            break;
        default:
            break;
            
    }
    
    return count;

    
}

/// 返回行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height=0;
    switch (tableView.tag) {
        case DistrictListTable:
        {
            height=35;
        }
            break;
            
        case SearchListTable:
        {
            height=44;
        }
            
        default:
            break;
    }
    
    return height;
    
}

///返回的每行
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (tableView.tag) {
        case DistrictListTable:
        {
            static NSString *Indentifier=@"cellIndentifier";
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:Indentifier];
            
            if (cell==nil) {
                
                cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Indentifier];
                
            }
            
            cell.textLabel.textAlignment=NSTextAlignmentCenter;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            QSDistrictDataModel *tempModel = self.districtList[indexPath.row];
            cell.textLabel.text = tempModel.val;
            return cell;
            
        }
            break;
            
        case SearchListTable:
        {
            static NSString *Indentifier=@"cellIndentifier";
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:Indentifier];
            
            if (cell==nil) {
                
                cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Indentifier];
                
            }
            cell.imageView.image=[UIImage imageNamed:@"public_choose_normal"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            QSSelectDataModel *tempModel = self.searchList[indexPath.row];
            cell.textLabel.text=tempModel.streetName;
            return cell;
        }
            break;
            
        default:
            return  nil;
    }
    }

///点击每一行事件
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (tableView.tag) {
        case DistrictListTable:
        {
            
            _districtButton.titleLabel.text= [NSString stringWithFormat:@"%d",(int)indexPath.row];
            [_districtListTableView removeFromSuperview];
            //[self touchesBegan:nil withEvent:nil];
        }
            break;
            
        case SearchListTable:
        {
            
            QSWMerchantIndexViewController *VC=[[QSWMerchantIndexViewController alloc] initWithID:@"299" andDistictName:@"体育西"];
            [self.navigationController pushViewController:VC animated:YES];
            //[self touchesBegan:nil withEvent:nil];
            
        }
        default:
            break;
    }
    
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

//
//  QSMyinfoViewController.m
//  SunTry
//
//  Created by 王树朋 on 15/1/31.
//  Copyright (c) 2015年 wangshupeng. All rights reserved.
//

#import "QSMyinfoViewController.h"
#import "QSMapManager.h"
#import "QSMapNavigationViewController.h"

@interface QSMyinfoViewController ()

@end

@implementation QSMyinfoViewController

#pragma mark - UI搭建
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    ///隐藏导航栏
    self.navigationController.navigationBarHidden = NO;
    
    
    ///可展示信息的
    
    UIButton *mapButton=[[UIButton alloc]initWithFrame:CGRectMake(20.0f, 200.0f, 100.0f, 40.0f)];
    
    [mapButton setTitle:@"地图导航" forState:UIControlStateNormal];
    [mapButton setTintColor:[UIColor blueColor]];
    mapButton.backgroundColor=[UIColor redColor];
    
    [self.view addSubview:mapButton];
    
    [mapButton addTarget:self action:@selector(gotoMapVC) forControlEvents:UIControlEventTouchUpInside];
    
    
}


#pragma mark -进入地图导航页面
-(void)gotoMapVC
{
    QSMapNavigationViewController *VC=[[QSMapNavigationViewController alloc]init] ;
    
    [self.navigationController pushViewController:VC animated:YES];
    
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

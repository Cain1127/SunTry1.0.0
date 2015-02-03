//
//  QSTabBarViewController.m
//  SunTry
//
//  Created by 王树朋 on 15/1/31.
//  Copyright (c) 2015年 wangshupeng. All rights reserved.
//

#import "QSTabBarViewController.h"
#import "QSHomeViewController.h"
#import "QSMyinfoViewController.h"
#import "QSOrderViewController.h"
#import "QSPointMealViewController.h"
#import "ColorHeader.h"
#import "ImageHeader.h"
@interface QSTabBarViewController ()

@end

@implementation QSTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化所有的子控制器
    [self setupAllChildViewControllers];
}


-(void)setupAllChildViewControllers
{
    
    ///1.首页
    QSHomeViewController *home=[[QSHomeViewController alloc]init];
    [self setupChildViewController:home title:@"广州" imageName:@"tab_home_normal" selectedImageName:@"tab_home_selected"];
    
    ///2.点餐
    QSPointMealViewController *pointmeal=[[QSPointMealViewController alloc]init];
    [self setupChildViewController:pointmeal title:@"点餐" imageName:@"tab_pointmeal_normal" selectedImageName:@"tab_pointmeal_selected"];
    
    ///3.定餐
    QSOrderViewController *order=[[QSOrderViewController alloc]init];
    [self setupChildViewController:order title:@"订单" imageName:@"tab_order_normal" selectedImageName:@"tab_order_selected"];
    
    ///4.我的
    QSMyinfoViewController *myinfo=[[QSMyinfoViewController alloc]init];
    [self setupChildViewController:myinfo title:@"我的" imageName:@"tab_myinfo_normal" selectedImageName:@"tab_myinfo_selected"];

}

/**
 *  初始化一个子控制器
 *
 *  @param childVc           需要初始化的子控制器
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    // 1.设置控制器的属性
    childVc.navigationItem.title=[NSString stringWithFormat:@"%@",title];
    childVc.view.backgroundColor=[UIColor whiteColor];
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 2.包装一个导航控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    
    ///设置导航栏背景颜色
    nav.navigationBar.backgroundColor=COLOR_CHARACTERS_RED;
    
    [self addChildViewController:nav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

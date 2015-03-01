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
#import "QSPointMealViewController.h"
#import "ColorHeader.h"
#import "ImageHeader.h"
#import "QSOrderListViewController.h"
#import "CommonHeader.h"
#import "QSWLoginViewController.h"
#import "QSWMerchantIndexViewController.h"

@interface QSTabBarViewController ()

@property (nonatomic,copy) NSString *streetID;  //!<街道ID
@property (nonatomic,copy) NSString *street;    //!<街道

@end

@implementation QSTabBarViewController

#pragma mark - 初始化
- (instancetype)initWithID:(NSString *)streetID andDistictName:(NSString *)street
{

    if (self = [super init]) {
        
        self.street = street ? street : @"体育西路";
        self.streetID = streetID ? streetID : @"299";
        
    }
    
    return self;

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // 初始化所有的子控制器
    [self setupAllChildViewControllers];
    
}


-(void)setupAllChildViewControllers
{
    
    ///tabbar容器
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    QSWMerchantIndexViewController *home = [[QSWMerchantIndexViewController alloc] initWithID:self.streetID andDistictName:self.street];
    [tempArray addObject:[self setupChildViewController:home title:@"首页" imageName:@"tab_home_normal" selectedImageName:@"tab_home_selected"]];
    [home.navigationController setNavigationBarHidden:YES];
    
    ///2.点餐
    QSPointMealViewController *pointmeal=[[QSPointMealViewController alloc]init];
    [tempArray addObject:[self setupChildViewController:pointmeal title:@"点餐" imageName:@"tab_pointmeal_normal" selectedImageName:@"tab_pointmeal_selected"]];
    [pointmeal setHidesBottomBarWhenPushed:YES];
    
    ///3.定餐
    QSOrderListViewController *order=[[QSOrderListViewController alloc]init];
    [tempArray addObject:[self setupChildViewController:order title:@"订单" imageName:@"tab_order_normal" selectedImageName:@"tab_order_selected"]];
    
    ///4.我的
    QSMyinfoViewController *myinfo=[[QSMyinfoViewController alloc]init];
    [tempArray addObject:[self setupChildViewController:myinfo title:@"我的" imageName:@"tab_myinfo_normal" selectedImageName:@"tab_myinfo_selected"]];
    
    ///添加
    self.viewControllers = tempArray;

}

/**
 *  初始化一个子控制器
 *
 *  @param childVc           需要初始化的子控制器
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (UINavigationController *)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    
    // 1.设置控制器的属性
    childVc.title=[NSString stringWithFormat:@"%@",title];
    childVc.view.backgroundColor=[UIColor whiteColor];
    childVc.automaticallyAdjustsScrollViewInsets = NO;
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 2.包装一个导航控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    
    ///设置导航栏背景图片
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_backgroud"] forBarMetrics: UIBarMetricsDefault];
    
    ///设置tabbar文字的选择状态
    self.tabBar.tintColor = COLOR_CHARACTERS_RED;
    
    return nav;
}

@end

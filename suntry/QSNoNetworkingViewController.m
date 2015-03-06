//
//  QSMapNavigationViewController.m
//  SunTry
//
//  Created by 王树朋 on 15/1/30.
//  Copyright (c) 2015年 7tonline. All rights reserved.
//

#import "QSNoNetworkingViewController.h"
#import "QSAnnotation.h"
#import "QSMapManager.h"
#import "DeviceSizeHeader.h"
#import "QSBlockButton.h"
#import "QSLabel.h"
#import "ColorHeader.h"

#import <MapKit/MapKit.h>
#import <objc/runtime.h>

#define ORDER_LIST_VIEWCONTROLLER_NAV_TITLE_FONT_SIZE   17.
#define ORDER_LIST_VIEWCONTROLLER_CONTENT_COLOR         [UIColor colorWithRed:0.505 green:0.513 blue:0.525 alpha:1.000]
#define ORDER_LIST_VIEWCONTROLLER_CONTENT_FONT_SIZE     17.

@interface QSNoNetworkingViewController ()

@property(nonatomic,strong) UIImageView *suntryImage;   //!<关于香哉图片

@property (nonatomic, strong) UIView *nodataView;       //!<图片与文字底部view
@property (nonatomic,assign) int turnBackStep;          //!<返回事件时的步长

///点击重新刷新时的回调
@property (nonatomic,copy) void(^refreshCallBack)(BOOL flag);

@property (nonatomic,copy) void(^noNetworkingCallBack)(void);

@end

@implementation QSNoNetworkingViewController

#pragma mark - 初始化
- (instancetype)initWithCallBack:(void(^)(void))callBack
{

    if (self = [super init]) {
        
        ///保存回调
        if (callBack) {
            
            self.noNetworkingCallBack = callBack;
            
        }
        
    }
    
    return self;

}

/*!
 *  @author     wangshupeng, 15-03-05 13:03:08
 *
 *  @brief      根据给定的返回步长，创建无网络显示页面
 *
 *  @param step 返回的步长
 *
 *  @return     返回无网络页面
 *
 *  @since      1.0.0
 */
- (instancetype)initWithTurnBackStep:(int)step andRefreshBlock:(void(^)(BOOL flag))refreshCallBack
{

    if (self = [super init]) {
        
        ///保存返回步长
        self.turnBackStep = step;
        
        ///保存回调
        if (refreshCallBack) {
            
            self.refreshCallBack = refreshCallBack;
            
        }
        
    }
    
    return self;

}

#pragma mark - UI搭建
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    ///自定义返回按钮
    UIBarButtonItem *turnBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_normal"] style:UIBarButtonItemStylePlain target:self action:@selector(turnBackAction)];
    turnBackButton.tintColor = [UIColor whiteColor];
    
    ///设置返回按钮的颜色
    [turnBackButton setBackButtonBackgroundImage:[UIImage imageNamed:@"nav_back_normal"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [turnBackButton setBackButtonBackgroundImage:[UIImage imageNamed:@"nav_back_selected"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    self.navigationItem.leftBarButtonItem = turnBackButton;
    
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [navTitle setFont:[UIFont boldSystemFontOfSize:17]];
    [navTitle setTextColor:[UIColor whiteColor]];
    [navTitle setBackgroundColor:[UIColor clearColor]];
    [navTitle setTextAlignment:NSTextAlignmentCenter];
    [navTitle setText:@"车车在哪儿"];
    self.navigationItem.titleView = navTitle;
    
    ///图片加载
    self.nodataView = [[UIView alloc] initWithFrame:CGRectMake(0, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT-64.0f)];
    [self.view addSubview:_nodataView];
    
    UIImageView *nodataImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"network_error_icon"]];
    [nodataImgView setCenter:self.view.center];
    [nodataImgView setFrame:CGRectMake(nodataImgView.frame.origin.x, 174.0f/667.0f*SIZE_DEVICE_HEIGHT, nodataImgView.frame.size.width, nodataImgView.frame.size.height)];
    [_nodataView addSubview:nodataImgView];
    
    QSLabel *topLabel = [[QSLabel alloc] initWithFrame:CGRectMake(20, nodataImgView.frame.origin.y-50.0f, SIZE_DEVICE_WIDTH-40.0f, 50.0f)];
    [topLabel setFont:[UIFont systemFontOfSize:30.0f]];
    [topLabel setBackgroundColor:[UIColor clearColor]];
    [topLabel setNumberOfLines:1];
    [topLabel setTextAlignment:NSTextAlignmentCenter];
    [topLabel setText:@"网络加载异常！"];
    [topLabel setTextColor:COLOR_CHARACTERS_RED];
    [_nodataView addSubview:topLabel];
    
    QSLabel *infoLabel = [[QSLabel alloc] initWithFrame:CGRectMake(20, nodataImgView.frame.origin.y+nodataImgView.frame.size.height+5, SIZE_DEVICE_WIDTH-40, 25)];
    [infoLabel setFont:[UIFont boldSystemFontOfSize:ORDER_LIST_VIEWCONTROLLER_CONTENT_FONT_SIZE]];
    [infoLabel setBackgroundColor:[UIColor clearColor]];
    [infoLabel setNumberOfLines:1];
    [infoLabel setTextAlignment:NSTextAlignmentCenter];
    [infoLabel setText:@"当前网络加载异常，请稍后再试!"];
    [infoLabel setTextColor:ORDER_LIST_VIEWCONTROLLER_CONTENT_COLOR];
    [_nodataView addSubview:infoLabel];
    
    QSLabel *infoLabel1 = [[QSLabel alloc] initWithFrame:CGRectMake(20, infoLabel.frame.origin.y+infoLabel.frame.size.height+5, SIZE_DEVICE_WIDTH-40, 25)];
    [infoLabel setFont:[UIFont boldSystemFontOfSize:ORDER_LIST_VIEWCONTROLLER_CONTENT_FONT_SIZE]];
    [infoLabel1 setBackgroundColor:[UIColor clearColor]];
    [infoLabel1 setNumberOfLines:1];
    [infoLabel1 setTextAlignment:NSTextAlignmentCenter];
    [infoLabel1 setText:@"如您的网络无异常，请点击刷新屏幕！"];
    [infoLabel1 setTextColor:ORDER_LIST_VIEWCONTROLLER_CONTENT_COLOR];
    [_nodataView addSubview:infoLabel1];
    
    UIButton *abcd=[QSBlockButton createBlockButtonWithFrame:CGRectMake(0.0f, 84.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT-64.0f-49.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        if (self.refreshCallBack) {
            
            self.refreshCallBack(YES);
            
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    abcd.backgroundColor=[UIColor clearColor];
    [self.view addSubview:abcd];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
}
#pragma mark - 返回事件
- (void)turnBackAction
{
    
    ///判断是否需要回调
    if (self.noNetworkingCallBack) {
        
        self.noNetworkingCallBack();
        
    }
    
    if (self.turnBackStep > 2) {
        
        int sumVC = (int)[self.navigationController.viewControllers count];
        int turnBackIndex = sumVC - self.turnBackStep;
        UIViewController *tempVC = self.navigationController.viewControllers[turnBackIndex];
        if (tempVC) {
            
            [self.navigationController popToViewController:tempVC animated:YES];
            
        } else {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    } else {
        
        [self.navigationController popViewControllerAnimated:NO];
        
    }

    
}


@end

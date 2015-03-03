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

///关联
static char titleLabelKey;//!<标题关联

@interface QSNoNetworkingViewController ()

@property(nonatomic,strong) UIImageView *suntryImage;  //!<关于香哉图片

@property (nonatomic, strong) UIView *nodataView;      //!<图片与文字底部view

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

#pragma mark - UI搭建
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    ///导航栏
    UIImageView *navRootView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, 64.0f)];
    navRootView.userInteractionEnabled = YES;
    navRootView.image = [UIImage imageNamed:@"nav_backgroud"];
    [self.view addSubview:navRootView];
    
    ///添加导航栏标题
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake((navRootView.frame.size.width - 80.0f) / 2.0f, 64.0f - 37.0f, 80.0f, 30.0f)];
    [navTitle setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [navTitle setTextColor:[UIColor whiteColor]];
    [navTitle setBackgroundColor:[UIColor clearColor]];
    [navTitle setTextAlignment:NSTextAlignmentRight];
    navTitle.adjustsFontSizeToFitWidth = YES;
    [navTitle setText:@"温馨提示"];
    [navRootView addSubview:navTitle];
    objc_setAssociatedObject(self, &titleLabelKey, navTitle, OBJC_ASSOCIATION_ASSIGN);
    
    ///返回按钮
    UIButton *turnBackButton = [UIButton createBlockButtonWithFrame:CGRectMake(10.0f, navTitle.frame.origin.y, 30.0f, 30.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        ///判断是否需要回调
        if (self.noNetworkingCallBack) {
            
            self.noNetworkingCallBack();
            
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    [turnBackButton setImage:[UIImage imageNamed:@"nav_back_normal"] forState:UIControlStateNormal];
    [turnBackButton setImage:[UIImage imageNamed:@"nav_back_selected"] forState:UIControlStateHighlighted];
    [navRootView addSubview:turnBackButton];
    
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
    
}

@end

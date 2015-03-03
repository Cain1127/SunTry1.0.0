//
//  QSAdvertDetailViewController.m
//  suntry
//
//  Created by ysmeng on 15/3/3.
//  Copyright (c) 2015年 广州七升网络科技有限公司. All rights reserved.
//

#import "QSAdvertDetailViewController.h"

#import "DeviceSizeHeader.h"

#import "QSBlockButton.h"

@interface QSAdvertDetailViewController ()

@property (nonatomic,copy) NSString *advertURL; //!<广告地址
@property (nonatomic,copy) NSString *title;     //!<标题

@end

@implementation QSAdvertDetailViewController

#pragma mark - 初始化
/**
 *  @author     yangshengmeng, 15-03-03 13:03:15
 *
 *  @brief      根据广告的地址，展示广告详情
 *
 *  @param url  广告地址
 *
 *  @return     返回给定地址的广告详情页
 *
 *  @since      1.0.0
 */
- (instancetype)initWithDetailURL:(NSString *)url  andTitle:(NSString *)title
{

    if (self = [super init]) {
        
        self.advertURL = url;
        self.title = title;
        
    }
    
    return self;

}

#pragma mark - UI搭建
///UI搭建
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    ///导航栏底view
    UIImageView *navRootView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SIZE_DEVICE_WIDTH, 64.0f)];
    navRootView.image = [UIImage imageNamed:@"nav_backgroud"];
    navRootView.userInteractionEnabled = YES;
    [self.view addSubview:navRootView];
    
    ///标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(navRootView.frame.size.width / 2.0f - 60.0f, 27.0f, 120.0f, 30.0f)];
    titleLabel.text = self.title ? self.title : @"香哉";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [navRootView addSubview:titleLabel];
    
    ///自定义返回按钮
    UIButton *turnBackButton = [UIButton createBlockButtonWithFrame:CGRectMake(5.0f, 20.0f, 44.0f, 44.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        ///返回
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    ///设置返回按钮的颜色
    [turnBackButton setImage:[UIImage imageNamed:@"nav_back_normal"] forState:UIControlStateNormal];
    [turnBackButton setImage:[UIImage imageNamed:@"nav_back_selected"] forState:UIControlStateHighlighted];
    [navRootView addSubview:turnBackButton];
    
    ///广告webview
    UIWebView *advertView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 64.0f, SIZE_DEVICE_WIDTH, SIZE_DEVICE_HEIGHT - 69.0f)];
    advertView.backgroundColor = [UIColor whiteColor];
    advertView.scalesPageToFit = YES;
    
    ///取消滚动条
    for (UIView *obj in [advertView subviews]) {
        
        if ([obj isKindOfClass:[UIScrollView class]]) {
            
            ((UIScrollView *)obj).showsHorizontalScrollIndicator = NO;
            ((UIScrollView *)obj).showsVerticalScrollIndicator = NO;
            
        }
        
    }
    
    [self.view addSubview:advertView];
    
    if (self.advertURL) {
        
        [advertView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.advertURL]]];
        
    }
    
}

@end

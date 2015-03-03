//
//  QSMapNavigationViewController.m
//  SunTry
//
//  Created by 王树朋 on 15/1/30.
//  Copyright (c) 2015年 7tonline. All rights reserved.
//

#import "QSMapNavigationViewController.h"
#import "QSAnnotation.h"
#import "QSMapManager.h"
#import "DeviceSizeHeader.h"
#import "QSBlockButton.h"

#import <MapKit/MapKit.h>
#import <objc/runtime.h>

#import "QSCarPostionDataModel.h"
#import "QSCarPostionReturnData.h"
#import "QSRequestManager.h"
#import "QSRequestTaskDataModel.h"

#import "MBProgressHUD.h"

#import "QSNoNetworkingViewController.h"

///关联
static char titleLabelKey;//!<标题关联

@interface QSMapNavigationViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>

@property (nonatomic,strong) MKMapView *mapView;
@property (nonatomic,strong) CLLocationManager *locMgr;      //!<定位服务管理
@property (nonatomic,retain) NSMutableArray *carPostionList; //!<餐车地址列表
@property (nonatomic,copy) NSString *title;                  //!<餐车名称

@property (nonatomic,retain) MBProgressHUD *hud;             //!<HUD

@end

@implementation QSMapNavigationViewController

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
    [navTitle setText:@"车车在哪儿"];
    [navRootView addSubview:navTitle];
    objc_setAssociatedObject(self, &titleLabelKey, navTitle, OBJC_ASSOCIATION_ASSIGN);
    
    ///返回按钮
    UIButton *turnBackButton = [UIButton createBlockButtonWithFrame:CGRectMake(10.0f, navTitle.frame.origin.y, 30.0f, 30.0f) andButtonStyle:nil andCallBack:^(UIButton *button) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    [turnBackButton setImage:[UIImage imageNamed:@"nav_back_normal"] forState:UIControlStateNormal];
    [turnBackButton setImage:[UIImage imageNamed:@"nav_back_selected"] forState:UIControlStateHighlighted];
    [navRootView addSubview:turnBackButton];
    
    ///初始化mapView
    _mapView=[[MKMapView alloc] init];
    _mapView.frame=CGRectMake(0.0f, 64.0f, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 49.0f);
    
    // 1.跟踪用户位置(显示用户的具体位置)
    //self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    // 2.设置地图类型
    //self.mapView.mapType = MKMapTypeStandard;
    
    // 3.设置代理
    self.mapView.delegate = self;
    
    //    QSMapManager *mapManager=[[QSMapManager alloc] init];
    //    [mapManager startUserLocation:^(BOOL isLocalSuccess, double longitude, double latitude) {
    //
    //        // 设置地图的显示范围
    //        MKCoordinateSpan span = MKCoordinateSpanMake(0.021321, 0.019366);
    //        MKCoordinateRegion region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(latitude, longitude), span);
    //        [_mapView setRegion:region animated:YES];
    //
    //    }];
    
    [self.view addSubview:_mapView];
    
    ///显示HUD
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self getCarPostingInfo];
    
}

#pragma mark --添加大头针

- (void)addAnnotations {
    
    QSCarPostionDataModel *tempModel1=[[QSCarPostionDataModel alloc] init];
    
    for (int i=0; i<[self.carPostionList count]; i++) {
        
        tempModel1=self.carPostionList[i];
        self.title=tempModel1.carName;
        
        QSCarPostionDataSubModel *carPostion=[[QSCarPostionDataSubModel alloc] init];
        
        carPostion=tempModel1.postionList;
        CGFloat latitude= carPostion.latitude;
        CGFloat longitude=carPostion.longitude;
        
        switch (i) {
            case 0:
            {
                // 1.餐车1
                QSAnnotation *anno0 = [[QSAnnotation alloc] init];
                anno0.title = self.title;
                anno0.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
                
                // 设置地图的显示范围
                MKCoordinateSpan span = MKCoordinateSpanMake(0.171321, 0.169366);
                MKCoordinateRegion region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(latitude, longitude), span);
                [_mapView setRegion:region animated:YES];
                
                [self.mapView addAnnotation:anno0];
                
            }
                break;
                
            case 1:
            {
                // 2.餐车2
                QSAnnotation *anno1 = [[QSAnnotation alloc] init];
                anno1.title = self.title;
                anno1.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
                [self.mapView addAnnotation:anno1];
                
            }
                break;
                
            default:
                break;
        }
        
        
    }
    
}

#pragma mark--大头针代理方法
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (![annotation isKindOfClass:[QSAnnotation class]]) return nil;
    
    static NSString *ID = @"car";
    // 从缓存池中取出可以循环利用的大头针view
    MKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView == nil) {
        annoView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ID];
        // 显示子标题和标题
        annoView.canShowCallout = YES;
        // 设置大头针描述的偏移量
        annoView.calloutOffset = CGPointMake(0, -10);
        
    }
    
    // 传递模型
    annoView.annotation = annotation;
    
    if (self.carPostionList[0]) {
        
        annoView.image = [UIImage imageNamed:@"home_carpostion1"];
        
    }
    
    annoView.image=[UIImage imageNamed:@"home_carpostion0"];
    
    return annoView;
}

#pragma mark - 餐车地址网络信息请求
///餐车地址网络信息请求
- (void)getCarPostingInfo
{
    
    //餐车地址信息请求参数
    NSDictionary *dict = @{@"mer_id" : @"1"};
    [QSRequestManager requestDataWithType:rRequestTypeCarPostion andParams:dict andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///判断是否请求成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            [self.hud hide:YES afterDelay:0.5];
            
            //模型转换
            QSCarPostionReturnData *tempModel = resultData;
            
            if ([tempModel.carPostionList count] > 0) {
                
                //清空的数据源
                [self.carPostionList removeAllObjects];
                
                self.carPostionList=[[NSMutableArray alloc] init];
                
                ///保存数据源
                [self.carPostionList addObjectsFromArray:tempModel.carPostionList];
                
                ///reload数据
                //[self.view reloadData];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self addAnnotations];
                    
                });
                
                
            }
            
        } else {
            
            NSLog(@"================餐车地址信息请求失败================");
            NSLog(@"error : %@",errorInfo);
            NSLog(@"================餐车地址信息请求失败================");
            
            QSNoNetworkingViewController *networkingErrorVC=[[QSNoNetworkingViewController alloc] initWithCallBack:^{
                
                
                
            }];
            networkingErrorVC.hidesBottomBarWhenPushed = YES;
            networkingErrorVC.navigationController.hidesBottomBarWhenPushed = NO;
            [self.navigationController pushViewController:networkingErrorVC animated:YES];
            
        }
        
    }];
    
}


@end

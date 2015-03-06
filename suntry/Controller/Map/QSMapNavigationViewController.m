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
    self.automaticallyAdjustsScrollViewInsets=NO;
    
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
    
    ///初始化mapView
    _mapView=[[MKMapView alloc] init];
    _mapView.frame=CGRectMake(0.0f, 0.0f, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    
    [self.mapView setZoomEnabled:YES];
    
    // 设置地图的显示范围
    MKCoordinateSpan span = MKCoordinateSpanMake(0.601321, 0.609366);
    MKCoordinateRegion region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(23.12, 113.31), span);
    [_mapView setRegion:region animated:YES];

    
    // 2.设置地图类型
    self.mapView.mapType = MKMapTypeStandard;
    
    // 3.设置代理
    self.mapView.delegate = self;
    
    [self.view addSubview:_mapView];
    
    [self getCarPostingInfo];
    
}

#pragma mark - 返回事件
- (void)turnBackAction
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
        
        QSAnnotation *anno0 = [[QSAnnotation alloc] init];
        anno0.title = self.title;
        anno0.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        // 设置地图的显示范围
        MKCoordinateSpan span = MKCoordinateSpanMake(0.021321, 0.019366);
        MKCoordinateRegion region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(latitude, longitude), span);
        [_mapView setRegion:region animated:YES];
        
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:latitude
                                                     longitude:longitude];
        //2.反地理编码
        CLGeocoder *geocoder=[[CLGeocoder alloc]init];
        
        [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
            
            if (error) {
                
                //有错误
                NSLog(@"========================================");
                NSLog(@"============无法获取当前用户位置===========");
                NSLog(@"========================================");
                
            } else {//编码成功
                
                //取出最前面的地址
                CLPlacemark *pm = [placemarks firstObject];
                
                ///删除省份之前的字符串
                NSMutableString *tempTitle = [pm.name mutableCopy];
                NSRange tempRange = [tempTitle rangeOfString:@"市"];
                NSString *resultTitle = [tempTitle substringFromIndex:tempRange.location + 1];
                
                anno0.subtitle = resultTitle;
                //anno0.subtitle=pm.name;
                
            }
        }];
        
        
        [self.mapView addAnnotation:anno0];
        
        //黙认选中
        [self.mapView selectAnnotation:anno0 animated:YES];
        
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

#pragma mark --选中某个大头针代理方法
//- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
//{
//
//
//        // 1.删除以前的MJTuangouDescAnnotation
//        for (id annotation in mapView.annotations) {
//            if ([annotation isKindOfClass:[annotation class]]) {
//                [mapView removeAnnotation:annotation];
//            }
//
//        // 在这颗被点击的大头针上面, 添加一颗用于描述的大头针
//        QSAnnotation *descAnno = [[QSAnnotation alloc] init];
//        descAnno.tuangou = anno.tuangou;
//        [mapView addAnnotation:descAnno];
//        QSAnnotation *anno = view.annotation;
//
//    }
//}



#pragma mark - 餐车地址网络信息请求
///餐车地址网络信息请求
- (void)getCarPostingInfo
{
    
    ///显示HUD
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //餐车地址信息请求参数
    NSDictionary *dict = @{@"mer_id" : @"1"};
    [QSRequestManager requestDataWithType:rRequestTypeCarPostion andParams:dict andCallBack:^(REQUEST_RESULT_STATUS resultStatus, id resultData, NSString *errorInfo, NSString *errorCode) {
        
        ///判断是否请求成功
        if (rRequestResultTypeSuccess == resultStatus) {
            
            //模型转换
            QSCarPostionReturnData *tempModel = resultData;
            
            if ([tempModel.carPostionList count] > 0) {
                
                [self.hud hide:YES afterDelay:0.5];
                
                //清空的数据源
                [self.carPostionList removeAllObjects];
                
                self.carPostionList=[[NSMutableArray alloc] init];
                
                ///保存数据源
                [self.carPostionList addObjectsFromArray:tempModel.carPostionList];
                
                ///reload数据
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self addAnnotations];
                    
                });
                
            } else {
                                
                self.hud.labelText = @"暂无配送中的订单...";
                [self.hud hide:YES afterDelay:1.5f];
                
            }
            
        } else {
            
            NSLog(@"================餐车地址信息请求失败================");
            NSLog(@"error : %@",errorInfo);
            NSLog(@"================餐车地址信息请求失败================");
            
            ///隐藏HUD
            [self.hud hide:YES];
            
            QSNoNetworkingViewController *networkingErrorVC = [[QSNoNetworkingViewController alloc] initWithTurnBackStep:3 andRefreshBlock:^(BOOL flag) {
                
                ///判断是否刷新
                if (flag) {
                    
                    [self getCarPostingInfo];
                    
                }
                
            }];
            networkingErrorVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:networkingErrorVC animated:YES];
            
        }
        
    }];
    
}


@end

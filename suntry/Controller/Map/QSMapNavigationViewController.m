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

///关联
static char titleLabelKey;//!<标题关联

@interface QSMapNavigationViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>{
    
    MKMapView *_mapView;
    
}

@property (nonatomic,strong) CLLocationManager *locMgr;//!<定位服务管理
@property (nonatomic,strong) CLGeocoder *geocoder;     //!<地理编码器

@end

@implementation QSMapNavigationViewController

-(CLGeocoder *)geocoder
{
    
    if (!_geocoder) {
        
        self.geocoder=[[CLGeocoder alloc]init];
        
    }
    
    return _geocoder;
    
}


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
    _mapView.frame=CGRectMake(0.0f, 64.0f, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 64.0f - 49.0f);
    
    _mapView.delegate=self;
    [self.view addSubview:_mapView];
    
    ///获取用户位置
    [self getUseLocation];
    
    ///导航
    NSString *destinationPm=@"天河员村";
    
    QSMapManager *mapManamer=[[QSMapManager alloc]init];
    [mapManamer getUserLocation:^(BOOL isLocalSuccess, NSString *placename) {
        
        ///起点为placename
        NSLog(@"==============用户导航起点位置===============");
        NSLog(@"%@",placename);
        [self.geocoder geocodeAddressString:placename completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error) return;
            
                CLPlacemark *fromPm=[placemarks firstObject];
            
            [self.geocoder geocodeAddressString:destinationPm completionHandler:^(NSArray *placemarks, NSError *error) {
                if (error) return ;
            
                CLPlacemark *toPm=[placemarks firstObject];
                
                [self addLineFrom:fromPm to:toPm];
            }];
            
        }];
    }];
    
    [self countLineDistance];
}

/**
 *  添加导航的线路
 *
 *  @param fromPm 起始位置
 *  @param toPm   结束位置
 */
- (void)addLineFrom:(CLPlacemark *)fromPm to:(CLPlacemark *)toPm
{
    // 1.添加2个大头针
    QSAnnotation *fromAnno = [[QSAnnotation alloc] init];
    fromAnno.coordinate = fromPm.location.coordinate;
    fromAnno.title = fromPm.name;
    [_mapView addAnnotation:fromAnno];
    
    QSAnnotation *toAnno = [[QSAnnotation alloc] init];
    toAnno.coordinate = toPm.location.coordinate;
    toAnno.title = toPm.name;
    [_mapView addAnnotation:toAnno];
    
    /// 2.查找路线
    
    /// 方向请求
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    /// 设置起点
    MKPlacemark *sourcePm = [[MKPlacemark alloc] initWithPlacemark:fromPm];
    request.source = [[MKMapItem alloc] initWithPlacemark:sourcePm];
    
    /// 设置终点
    MKPlacemark *destinationPm = [[MKPlacemark alloc] initWithPlacemark:toPm];
    request.destination = [[MKMapItem alloc] initWithPlacemark:destinationPm];
    
    /// 方向对象
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    /// 计算路线
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        NSLog(@"总共%d条路线", response.routes.count);
        
        /// 遍历所有的路线
        for (MKRoute *route in response.routes) {
            /// 添加路线遮盖
            [_mapView addOverlay:route.polyline];
        }
    }];
}

#pragma mark -获得当前用户位置
-(void)getUseLocation
{
    ///1.跟踪用户位置(显示用户的具体位置)
    /// [self.locMgr startUpdatingLocation];
    
    ///关闭地图用户信息
    _mapView.showsUserLocation=NO;
    
    ///跟踪用户信息
    _mapView.userTrackingMode=MKUserTrackingModeFollow;
    
    ///地图显示用户信息
    _mapView.showsUserLocation=YES;
    
    ///2.设置地图类型
    _mapView.mapType=MKMapTypeStandard;//!<标准类型
    
}
#pragma mark -MKMapViewDelegate
/*!
 *  @author wangshupeng, 15-01-30 15:01:08
 *
 *  @brief  监听用户位置信息
 *
 *  @param mapView   当前地图
 *  @param userLocation 用户位置信息
 *
 *  @since 1.0
 */
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    userLocation.title=@"我的位置";
    userLocation.subtitle=@"追香哉得鸡腿";
    
    ///设置用户坐标为中心点
    CLLocationCoordinate2D center=userLocation.location.coordinate;
    ///设置地图的中心点(以用户所在的位置为中心点)
    [_mapView setCenterCoordinate:center animated:YES];
    
    NSLog(@"==============用户位置==================");
    NSLog(@"%f %f",center.latitude,center.longitude);
    NSLog(@"=======================================");
    

    
    ///设置地图的显示范围
    MKCoordinateSpan span=MKCoordinateSpanMake(0.021321, 0.019366);
    MKCoordinateRegion region=MKCoordinateRegionMake(center, span);
    [mapView setRegion:region animated:YES];
    [_locMgr stopUpdatingLocation];
            
}


#pragma mark - MKMapViewDelegate
///画导航线
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor redColor];
    return renderer;
}

///获取用户
//- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
//{
//    NSLog(@"%f %f", mapView.region.span.latitudeDelta, mapView.region.span.longitudeDelta);
//}

/**
 *  计算2个经纬度之间的直线距离
 */
- (void)countLineDistance
{
    /// 计算2个经纬度之间的直线距离
    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:40 longitude:116];
    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:41 longitude:116];
    CLLocationDistance distance = [loc1 distanceFromLocation:loc2];
    NSLog(@"%f", distance);
}

///定位服务代理方法
#pragma mark - CLLocationManagerDelegate



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

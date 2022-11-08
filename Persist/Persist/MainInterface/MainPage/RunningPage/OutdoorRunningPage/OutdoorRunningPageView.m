//
//  OutdoorRunningPageView.m
//  Persist
//
//  Created by 张博添 on 2022/2/28.
//

#import "OutdoorRunningPageView.h"
#import <Masonry.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>

#define selfViewWidth self.frame.size.width
#define selfViewHeight self.frame.size.height

static const float navigationBarHeight = 50.0;

@interface OutdoorRunningPageView()
<MAMapViewDelegate, AMapLocationManagerDelegate>
{
    CLLocationManager *cllocationManager;
    AMapLocationManager *locationManager;
    MATraceManager *manager;
    CLLocationCoordinate2D myCoordinate;
}

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) UIButton *locateButton;

@property (nonatomic, strong) NSMutableArray *locationPoint;
@property (nonatomic, strong) NSMutableArray *lineArray;
@property (nonatomic, strong) MAPolyline *runLine;

@property (nonatomic, strong) NSNumber *trackLength;

@property (nonatomic, strong) MAUserLocation *currentLocation;
@property (nonatomic, strong) MAPolyline *polyline;



@property (nonatomic, assign, readonly) float statusBarHeight;

@property (nonatomic, strong) UIView *statusBarView;
@property (nonatomic, strong) UIView *navigationBarView;

@property (nonatomic, strong) UIButton *foldButton;

@property (nonatomic, strong) UIView *labelsView;
@property (nonatomic, strong) UILabel *lengthLabel;
@property (nonatomic, strong) UILabel *speedLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIButton *stopButton;

@property (nonatomic, strong) NSTimer *myTimer;
@property (nonatomic, strong) NSTimer *buttonTimer;

@end
@implementation OutdoorRunningPageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self buildUI];
    
    _totalDistance = 0;
    _totalSteps = 0;
    _totalTime = 0;
    
//    [self startRunning];
    
//    [self buildTimer];
    
    return self;
}

- (float)statusBarHeight {
    NSSet *set = [[UIApplication sharedApplication] connectedScenes];
    UIWindowScene *windowScene = [set anyObject];
    UIStatusBarManager *statusBarManager2 =  windowScene.statusBarManager;
    return statusBarManager2.statusBarFrame.size.height;
}

#pragma mark buildUI
- (void)buildUI {
    _statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, selfViewWidth, self.statusBarHeight)];
    [self addSubview:_statusBarView];
    
    _navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.statusBarHeight, selfViewWidth, navigationBarHeight)];
    [self addSubview:_navigationBarView];
    
#pragma mark 左上角标题
    UILabel *titleLabel = [[UILabel alloc] init];
    [_navigationBarView addSubview:titleLabel];
    titleLabel.text = @"跑步";
    titleLabel.font = [UIFont systemFontOfSize:16 * (navigationBarHeight - 15) / titleLabel.font.lineHeight];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self->_navigationBarView.mas_left).offset(10);
        make.top.mas_equalTo(self->_navigationBarView.mas_top).offset(10);
        make.bottom.mas_equalTo(self->_navigationBarView.mas_bottom).offset(-10);
    }];
    
    [self buildLabels];
    
    [self buildMapView];
    [self buildFoldButton];
}

#pragma mark - 标签
- (void)buildLabels {
    _labelsView = [[UIView alloc] initWithFrame:CGRectMake(0, selfViewHeight - 300, selfViewWidth, 100)];
    [self addSubview:_labelsView];
    
    UILabel *speedTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, selfViewWidth / 3, 40)];
    [_labelsView addSubview:speedTitleLabel];
    speedTitleLabel.font = [UIFont systemFontOfSize:16 * 30 / speedTitleLabel.font.lineHeight];
    speedTitleLabel.textAlignment = NSTextAlignmentCenter;
    speedTitleLabel.text = @"配速";
    
    _speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, selfViewWidth / 3 - 20, 60)];
    [_labelsView addSubview:_speedLabel];
    _speedLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:16 * 50 / _speedLabel.font.lineHeight];
    _speedLabel.adjustsFontSizeToFitWidth = YES;
    _speedLabel.text = @"0'00\"";
    _speedLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *timeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(selfViewWidth / 3, 0, selfViewWidth / 3, 40)];
    [_labelsView addSubview:timeTitleLabel];
    timeTitleLabel.font = [UIFont systemFontOfSize:16 * 30 / timeTitleLabel.font.lineHeight];
    timeTitleLabel.textAlignment = NSTextAlignmentCenter;
    timeTitleLabel.text = @"时间";
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + selfViewWidth / 3, 40, selfViewWidth / 3 - 20, 60)];
    [_labelsView addSubview:_timeLabel];
    _timeLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:16 * 50 / _timeLabel.font.lineHeight];
    _timeLabel.adjustsFontSizeToFitWidth = YES;
    _timeLabel.text = @"00:00:00";
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *lengthTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(selfViewWidth / 3 * 2, 0, selfViewWidth / 3, 40)];
    [_labelsView addSubview:lengthTitleLabel];
    lengthTitleLabel.font = [UIFont systemFontOfSize:16 * 30 / lengthTitleLabel.font.lineHeight];
    lengthTitleLabel.textAlignment = NSTextAlignmentCenter;
    lengthTitleLabel.text = @"距离";
    
    _lengthLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + selfViewWidth / 3 * 2, 40, selfViewWidth / 3 - 20, 60)];
    [_labelsView addSubview:_lengthLabel];
    _lengthLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:16 * 50 / _lengthLabel.font.lineHeight];
    _lengthLabel.adjustsFontSizeToFitWidth = YES;
    _lengthLabel.text = @"0.00";
    _lengthLabel.textAlignment = NSTextAlignmentCenter;
    
}

#pragma mark - 地图View
- (void)buildMapView {
    
    [AMapServices sharedServices].enableHTTPS = YES;
    //检查隐私合规
//    [AMapLocationManager updatePrivacyAgree:AMapPrivacyAgreeStatusDidAgree];
//    [AMapLocationManager updatePrivacyShow:AMapPrivacyShowStatusDidShow privacyInfo:AMapPrivacyInfoStatusDidContain];
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, self.statusBarHeight + navigationBarHeight, selfViewWidth, selfViewHeight - (self.statusBarHeight + navigationBarHeight) - 300)];
    //把地图添加至view
    [self addSubview:_mapView];
    _mapView.delegate = self;
    
    _mapView.showsIndoorMap = YES;
    
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    _mapView.zoomLevel = 18;
    _mapView.zoomEnabled = YES;    //NO表示禁用缩放手势，YES表示开启
    _mapView.rotateEnabled= NO;    //NO表示禁用旋转手势，YES表示开启
    [_mapView setShowsCompass:NO];
    
    _lineArray = [[NSMutableArray alloc] init];
    
    _locationPoint = [[NSMutableArray alloc] init];
    
    _trackLength = [[NSNumber alloc] initWithDouble:0];
    
    _locateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _locateButton.frame = CGRectMake(5, _mapView.frame.size.height / 4 * 3, 35, 35);
    [_mapView addSubview:_locateButton];
    [_locateButton setBackgroundImage:[UIImage imageNamed:@"locate.png"] forState:UIControlStateNormal];
    [_locateButton addTarget:self action:@selector(pressLocate) forControlEvents:UIControlEventTouchUpInside];
    [self buildStopButton];
    
    [self location];
    [self buildTimer];
}

- (void)pressLocate {
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    [self.mapView setZoomLevel:18 animated:YES];
}


#pragma mark - 定时器
- (void)buildTimer {
    //初始化定时器
    _myTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateSpeed) userInfo:nil repeats:YES];
    //将定时器加入主循环中
    [[NSRunLoop mainRunLoop] addTimer:_myTimer forMode:NSDefaultRunLoopMode];
    [_myTimer fire];
}

#pragma mark - 定位
- (void)location {
    
    cllocationManager = [[CLLocationManager alloc] init];
    //获取授权认证
    [cllocationManager requestAlwaysAuthorization];
    [cllocationManager requestWhenInUseAuthorization];
    [AMapLocationManager updatePrivacyAgree:AMapPrivacyAgreeStatusDidAgree];
    [AMapLocationManager updatePrivacyShow:AMapPrivacyShowStatusDidShow privacyInfo:AMapPrivacyInfoStatusDidContain];
    if([CLLocationManager locationServicesEnabled]){
        locationManager = [[AMapLocationManager alloc]init];
        [locationManager setDelegate:self];
        //是否允许后台定位。默认为NO。只在iOS 9.0及之后起作用。设置为YES的时候必须保证 Background Modes 中的 Location updates 处于选中状态，否则会抛出异常。由于iOS系统限制，需要在定位未开始之前或定位停止之后，修改该属性的值才会有效果。
        [locationManager setAllowsBackgroundLocationUpdates:YES];
        //指定定位是否会被系统自动暂停。默认为NO。
        [locationManager setPausesLocationUpdatesAutomatically:NO];
        //设定定位的最小更新距离。单位米，默认为 kCLDistanceFilterNone，表示只要检测到设备位置发生变化就会更新位置信息
        [locationManager setDistanceFilter:5];
        //设定期望的定位精度。单位米，默认为 kCLLocationAccuracyBest
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        locationManager.allowsBackgroundLocationUpdates = YES;
        locationManager.pausesLocationUpdatesAutomatically = NO;
        
        //开始定位服务
        [locationManager startUpdatingLocation];
    }
}

#pragma mark - MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        [self operationForLocation:userLocation];
//        NSLog(@"前台");
    } else if([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        // 2、后台模式
        [self operationForLocation:userLocation];
//        NSLog(@"后台");
    } else if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
        // 3、不活跃模式
        [self operationForLocation:userLocation];
    }
}
- (void)mapViewRequireLocationAuth:(CLLocationManager *)locationManager {
    [locationManager requestAlwaysAuthorization];
}

#pragma mark 处理坐标
- (void)operationForLocation:(MAUserLocation *)userLocation {
    _currentLocation = userLocation;
//    NSLog(@"位置更新");
//    NSLog(@"当前位置：%f,%f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    if (!userLocation.location) {
        cllocationManager = [[CLLocationManager alloc] init];
        //获取授权认证
        [cllocationManager requestAlwaysAuthorization];
//        [cllocationManager requestWhenInUseAuthorization];
    }//坐标数组为空
    if (_locationPoint.count == 0) {
        
        [self updateLength];
        if (userLocation.location) {
            [_locationPoint addObject:userLocation.location];
        }
            
    } else {//非空
        
        CLLocation *location = [_locationPoint lastObject];
        CLLocationDegrees latitude  = location.coordinate.latitude;
        CLLocationDegrees longitude = location.coordinate.longitude;
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        MAMapPoint point1 = MAMapPointForCoordinate(coordinate);
        MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude));
        CLLocationDistance distance = MAMetersBetweenMapPoints(point1, point2);

        if (distance >= 1) {
            _trackLength = [NSNumber numberWithDouble:_trackLength.doubleValue + distance];
            [self updateLength];
            [_locationPoint addObject:[[CLLocation alloc] initWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude]];
        }
        MAMapPoint* pointArray = (MAMapPoint *)malloc(sizeof(CLLocationCoordinate2D) * _locationPoint.count);

        // 2、创建坐标点并添加到数组中
        for (int idx = 0; idx < _locationPoint.count; idx++) {
            CLLocation *location = [_locationPoint objectAtIndex:idx];
            CLLocationDegrees latitude  = location.coordinate.latitude;
            CLLocationDegrees longitude = location.coordinate.longitude;
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
            MAMapPoint point = MAMapPointForCoordinate(coordinate);
            pointArray[idx] = point;
        }
        // 3、防止重复绘制
        if (_runLine) {
            //在地图上移除已有的坐标点
            [_mapView removeOverlay:_runLine];
        }
        // 4、画线
        _runLine = [MAPolyline polylineWithPoints:pointArray count:_locationPoint.count];
        // 5、将折线(覆盖)添加到地图
        if (nil != _runLine) {
            [_mapView addOverlay:_runLine];
        }
        // 6、清除分配的内存
        free(pointArray);
    }
}

#pragma mark 处理距离
- (void)updateLength {
//    NSLog(@"%@", [NSString stringWithFormat:@"%.2f千米", _trackLength.doubleValue / 1000]);
    _lengthLabel.text = [NSString stringWithFormat:@"%.2f", _trackLength.doubleValue / 1000];
    _totalDistance = _trackLength.doubleValue / 1000;
}

#pragma mark 处理速度
- (void)updateSpeed {
    _totalTime++;
    _timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", (int)_totalTime / 3600, ((int)_totalTime % 3600) / 60, (int)_totalTime % 60];
    if (_trackLength.doubleValue < 1) {
//        _speedLabel.text = @"0分0秒";
    } else {
        _speedLabel.text = [NSString stringWithFormat:@"%d'%02d%@", (int)(_totalTime / 60 / _trackLength.doubleValue * 1000), (int)((_totalTime / 60 / _trackLength.doubleValue * 1000 - (int)(_totalTime / 60 / _trackLength.doubleValue * 1000)) * 60), @"\""];
    }
}

#pragma mark 处理路线
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id)overlay {
    if ([overlay isKindOfClass:[MAPolyline class]]) {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        polylineRenderer.lineWidth = 5.f;
        polylineRenderer.strokeColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:0.6];
        polylineRenderer.lineJoinType = kMALineJoinRound;
        polylineRenderer.lineCapType = kMALineCapRound;
        return polylineRenderer;
    }
    return nil;
}

#pragma mark 创建折叠按钮
- (void)buildFoldButton {
    _foldButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _foldButton.frame = CGRectMake(selfViewWidth / 2 - 30, _mapView.frame.size.height - 30, 60, 30);
    [_mapView addSubview:_foldButton];
//    [_foldButton setBackgroundColor:[UIColor grayColor]];
    [_foldButton addTarget:self action:@selector(pressFold) forControlEvents:UIControlEventTouchUpInside];
    _foldButton.tag = 1;
    
    [_foldButton setBackgroundImage:[UIImage imageNamed:@"down.png"] forState:UIControlStateNormal];
}

#pragma mark 点击折叠按钮
- (void)pressFold {
    if (_foldButton.tag == 0) {
        _foldButton.tag = 1;
        self.labelsView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            [self.mapView setFrame:CGRectMake(0, self.statusBarHeight + navigationBarHeight, selfViewWidth, selfViewHeight - (self.statusBarHeight + navigationBarHeight) - 300)];
            [self.foldButton setFrame:CGRectMake(selfViewWidth / 2 - 30, self->_mapView.frame.size.height - 30, 60, 30)];
            [self.foldButton setBackgroundImage:[UIImage imageNamed:@"down.png"] forState:UIControlStateNormal];
            [self.labelsView setAlpha:1];
            [self.labelsView setTransform:CGAffineTransformMakeScale(1, 1)];
        } completion:^(BOOL finished){
            self.mapView.userTrackingMode = MAUserTrackingModeFollow;
        }];
    } else {
        _foldButton.tag = 0;
        [UIView animateWithDuration:0.3 animations:^{
            [self.mapView setFrame:CGRectMake(0, self.statusBarHeight + navigationBarHeight, selfViewWidth, selfViewHeight - (self.statusBarHeight + navigationBarHeight) - 200)];
            [self.foldButton setFrame:CGRectMake(selfViewWidth / 2 - 30, self->_mapView.frame.size.height - 30, 60, 30)];
            [self.foldButton setBackgroundImage:[UIImage imageNamed:@"up.png"] forState:UIControlStateNormal];
            [self.labelsView setAlpha:0];
            [self.labelsView setTransform:CGAffineTransformMakeScale(0.1, 0.1)];
        } completion:^(BOOL finished){
            self.mapView.userTrackingMode = MAUserTrackingModeFollow;
            self.labelsView.hidden = YES;
        }];
    }
}

- (void)buildStopButton {
    _stopButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self addSubview:_stopButton];
    _stopButton.frame = CGRectMake(selfViewWidth / 8 * 3, selfViewHeight - 180, selfViewWidth / 4, selfViewWidth / 4);
    [_stopButton setBackgroundImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
    [_stopButton addTarget:self action:@selector(pressStop) forControlEvents:UIControlEventTouchUpInside];
}

- (void)pressStop {
    [self.delegate stopRunning];
}

@end

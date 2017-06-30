//
//  RepairShopViewController.m
//  Tigrone
//
//  Created by ZhangGang on 15/11/13.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "RepairShopViewController.h"
#import "RepairShopDetailViewController.h"
#import "RepairShopCell.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "RepairPopView.h"
#import "RepairPointAnnotation.h"
#import "TigroneRequests.h"
#import "GlobalData.h"
#import "UIImageView+WebCache.h"
#import "NSString+Tigrone.h"

@interface RepairShopViewController()<BMKMapViewDelegate,BMKGeoCodeSearchDelegate>
{
    CLLocationCoordinate2D _currentCoor;
    BMKGeoCodeSearch* _geocodesearch;
    RepairPointAnnotation *currentAnnotation;
}

@property (nonatomic, weak)IBOutlet UITextField *localField;

@property (nonatomic, weak)IBOutlet UIButton *listBtn;
@property (nonatomic, weak)IBOutlet UIButton *mapBtn;
@property (nonatomic, weak)IBOutlet UIView *listView;
@property (nonatomic, weak)IBOutlet BMKMapView *mapView;

@property (nonatomic, weak)IBOutlet UITableView *tableView;

@property (nonatomic, weak)IBOutlet UITextField *searchField;

@property (nonatomic, strong)NSMutableArray *dataArr;

@property (nonatomic, strong)NSMutableArray *mapAnnotations;

@end

@implementation RepairShopViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    _mapAnnotations = [[NSMutableArray alloc] initWithCapacity:0];
    
    _mapView.delegate = self;
    [_mapView setZoomEnabled:YES];
    [_mapView setZoomLevel:16];
    
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    
    self.mapAnnotations = [[NSMutableArray alloc] initWithCapacity:0];
    
    _mapView.delegate = self;
    
    //默认地图显示
    [self mapBtnClip:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _geocodesearch.delegate = self;
    
    //刷新数据
    if ([GlobalData shareInstance].repairShops) {
        [_dataArr removeAllObjects];
        [_dataArr addObjectsFromArray:[GlobalData shareInstance].repairShops];
        [self.tableView reloadData];
        [self showAllAnnotations];
    }
    
    //显示当前位置
    if (USERLOC) {
        [_mapView updateLocationData:USERLOC];
        _mapView.showsUserLocation = YES;
        _mapView.centerCoordinate = CURRENTLOC;
        BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(CURRENTLOC, BMKCoordinateSpanMake(0.02f,0.02f));
        BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
        [_mapView setRegion:adjustedRegion animated:YES];
    }
    
    [self startReverseGeocode];
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _geocodesearch.delegate = nil;
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
    
    if (_geocodesearch) {
        _geocodesearch = nil;
    }
}

- (void)showAllAnnotations
{
    [_mapView removeAnnotations:_mapAnnotations];
    [_mapAnnotations removeAllObjects];
    
    if (_dataArr.count > 0) {
        for (RepairShopModel *model in _dataArr) {
            RepairPointAnnotation *annotation = [[RepairPointAnnotation alloc] init];
            annotation.repairModel = model;
            annotation.title = model.shopName;
            annotation.subtitle = [NSString stringWithFormat:@"%@%@%@",model.shopCity,model.shopCounty,model.shopAddr];
            
            CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(model.latitude, model.longtitude);
            annotation.coordinate = coor;
            
            [_mapAnnotations addObject:annotation];
        }
    }
    
    [_mapView addAnnotations:_mapAnnotations];
    
//    [self setMapRegion];
}

//计算地图可见区域
- (void)setMapRegion
{
    CLLocationDegrees minLat = 0;
    CLLocationDegrees maxLat = 0;
    CLLocationDegrees minLon = 0;
    CLLocationDegrees maxLon = 0;
    
    //解析数据
    for (int i= 0; i<_mapAnnotations.count; i++)
    {
        RepairPointAnnotation *annotation = _mapAnnotations[i];
        CLLocationCoordinate2D coor = annotation.coordinate;
        if (i==0) {
            //以第一个坐标点做初始值
            minLat = coor.latitude;
            maxLat = coor.latitude;
            minLon = coor.longitude;
            maxLon = coor.longitude;
        }
        else
        {
            //对比筛选出最小纬度，最大纬度；最小经度，最大经度
            minLat = MIN(minLat, coor.latitude);
            maxLat = MAX(maxLat, coor.latitude);
            minLon = MIN(minLon, coor.longitude);
            maxLon = MAX(maxLon, coor.longitude);
        }
    }
    
    //动态的根据坐标数据的区域，来确定地图的显示中心
    if (_mapAnnotations.count > 0) {
        //计算中心点
        CLLocationCoordinate2D centCoor;
        centCoor.latitude = (CLLocationDegrees)((maxLat + minLat) * 0.5f);
        centCoor.longitude = (CLLocationDegrees)((maxLon + minLon) * 0.5f);
        BMKCoordinateSpan span;
        
        //计算地理位置的跨度
        span.latitudeDelta = maxLat - minLat;
        span.longitudeDelta = maxLon - minLon;
        
        //得出数据的坐标区域
        BMKCoordinateRegion region = BMKCoordinateRegionMake(centCoor, span);
        [_mapView setRegion:region animated:YES];
    }
}

//反向地理编码
- (void)startReverseGeocode
{
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = CURRENTLOC;
    
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}

//正向地理编码
- (void)startGeocode
{
    BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geocodeSearchOption.city= _searchField.text;
    BOOL flag = [_geocodesearch geoCode:geocodeSearchOption];
    if(flag)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送失败");
    }
}

- (void)sortListView:(CLLocationCoordinate2D)coor
{
    //搜索的地点按照又近到远排序
//    [self listBtnClip:nil];
    
    if (_dataArr.count > 0) {
        for (RepairShopModel *model in _dataArr) {
            BMKMapPoint pstart = BMKMapPointForCoordinate(coor);
            BMKMapPoint pEnd = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(model.latitude, model.longtitude));
            CLLocationDistance distance = BMKMetersBetweenMapPoints(pstart, pEnd);
            model.distanceStr = [NSString stringWithFormat:@"%.1f",distance/1000];
        }
        
        if (_dataArr.count > 1) {
            NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"distanceStr" ascending:YES];
            [_dataArr sortUsingDescriptors:@[descriptor]];
        }
    }
    
    [self.tableView reloadData];
}

//导航
- (void)openNativeNavi
{
    //初始化调启导航时的参数管理类
    BMKNaviPara* para = [[BMKNaviPara alloc]init];
    
    //起点节点
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.pt = CURRENTLOC;
    start.name = @"我的位置";
    
    para.startPoint = start;
    
    //初始化终点节点
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    //指定终点经纬度
    end.pt = currentAnnotation.coordinate;
    //指定终点名称
    end.name = currentAnnotation.title;
    //指定终点
    para.endPoint = end;
    
    //指定返回自定义scheme
    para.appScheme = @"tigrone://tigrone.baidu.com";
    
    //调启百度地图客户端导航
    BMKOpenErrorCode errorCode = [BMKNavigation openBaiduMapNavigation:para];
    if (errorCode == BMK_OPEN_OPTION_NULL) {
        [MBProgressHUD showHUDAWhile:@"导航失败" toView:self.view duration:1];
    }
}

#pragma mark -button
- (IBAction)locationBtnClip:(id)sender
{
    //定位
    //反地理编码
    _currentCoor = CURRENTLOC;
    
    if (USERLOC) {
        [_mapView updateLocationData:USERLOC];
        _mapView.showsUserLocation = YES;
        _mapView.centerCoordinate = CURRENTLOC;
        BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(CURRENTLOC, BMKCoordinateSpanMake(0.02f,0.02f));
        BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
        [_mapView setRegion:adjustedRegion animated:YES];
    }
    [self startReverseGeocode];
}

- (IBAction)searchBtnClip:(id)sender
{
    [_searchField resignFirstResponder];
    //搜索
    if ([NSString isBlankString:_searchField.text]) {
//        [MBProgressHUD showHUDAWhile:@"请输入关键字" toView:self.navigationController.view duration:1.0];
        if ([GlobalData shareInstance].repairShops) {
            [_dataArr removeAllObjects];
            [_dataArr addObjectsFromArray:[GlobalData shareInstance].repairShops];
            [self.tableView reloadData];
            [self showAllAnnotations];
        }
    }
    else
    {
        if (_dataArr.count > 0) {
            NSMutableArray *resultArr = [[NSMutableArray alloc] initWithCapacity:0];
            for (RepairShopModel *model in _dataArr) {
                if ([model.shopName containsString:_searchField.text]) {
                    [resultArr addObject:model];
                }
            }
            
            [_dataArr removeAllObjects];
            [_dataArr addObjectsFromArray:resultArr];
            [self showAllAnnotations];
            [_tableView reloadData];
        }
    }
}

- (IBAction)listBtnClip:(id)sender
{
    //列表展示
    _listView.hidden = NO;
    [_listBtn setImage:IMAGE(@"main_list_Icon_on") forState:UIControlStateNormal];
    [_listBtn setTitleColor:ColorWithHexValue(0xF49500) forState:UIControlStateNormal];
    _mapView.hidden = YES;
    [_mapBtn setImage:IMAGE(@"main_map_icon_off") forState:UIControlStateNormal];
    [_mapBtn setTitleColor:ColorWithHexValue(0x999999) forState:UIControlStateNormal];
}

-(IBAction)mapBtnClip:(id)sender
{
    //地图展示
    _listView.hidden = YES;
    [_listBtn setImage:IMAGE(@"main_list_Icon_off") forState:UIControlStateNormal];
    [_listBtn setTitleColor:ColorWithHexValue(0x999999) forState:UIControlStateNormal];
    _mapView.hidden = NO;
    [_mapBtn setImage:IMAGE(@"main_map_icon_on") forState:UIControlStateNormal];
    [_mapBtn setTitleColor:ColorWithHexValue(0xF49500) forState:UIControlStateNormal];
}

- (IBAction)navBtnClip:(id)sender
{
    [self openNativeNavi];
}

#pragma mark - mapView & geoDelegate
//geo地理编码代理
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        if (result) {
            //编码成功
            CLLocationCoordinate2D coord = result.location;
            [self sortListView:coord];
            //排序显示列表
        }
    }
}


//反向地理编码
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        if (result) {
            _localField.text = result.address;
            [self sortListView:_currentCoor];
        }
    }
}


//地图上显示位置标签
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"annotationViewID";
    BMKAnnotationView *annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorPurple;
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    RepairPointAnnotation *annotationItem = (RepairPointAnnotation*)annotation;
    annotationView.annotation = annotationItem;
    
    annotationView.image = [UIImage imageNamed:@"main_map_pin_gray"];
    
    RepairPopView *popView = [[RepairPopView alloc] initWithFrame:CGRectMake(0, 0, 290, 77)];
    popView.titleLab.text = annotationItem.title;
    popView.subTitleLab.text = annotationItem.subtitle;
    [popView.navBtn addTarget:self action:@selector(navBtnClip:) forControlEvents:UIControlEventTouchUpInside];
    
    BMKActionPaopaoView *pView = [[BMKActionPaopaoView alloc] initWithCustomView:popView];
    [pView setFrame:CGRectMake(0, 0, 290, 77)];
    ((BMKPinAnnotationView*)annotationView).paopaoView = nil;
    ((BMKPinAnnotationView*)annotationView).paopaoView = pView;
    
    return annotationView;
}

/**
 * 当选中一个annotation views时，调用此接口
 * @param mapView 地图View
 * @param views 选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    view.image = [UIImage imageNamed:@"main_map_pin_blue"];
    currentAnnotation = view.annotation;
}

/**
 *当取消选中一个annotation views时，调用此接口
 *@param mapView 地图View
 *@param views 取消选中的annotation views
 */
- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view
{
    view.image = [UIImage imageNamed:@"main_map_pin_gray"];
}

/**
 *  选中气泡调用方法
 *  @param mapView 地图
 *  @param view    annotation
 */
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
        RepairPointAnnotation *annotation = (RepairPointAnnotation *)view.annotation;
    UIStoryboard *RepairShopStoryBoard   = [UIStoryboard storyboardWithName:@"RepairShop" bundle:nil];
    RepairShopDetailViewController *detailVc = [RepairShopStoryBoard instantiateViewControllerWithIdentifier:@"RepairShopDetailViewController"];
    detailVc.shopModel = annotation.repairModel;
    detailVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVc animated:YES];
}

#pragma mark -textField
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    [textField resignFirstResponder];
    [self searchBtnClip:nil];
    return YES;
}

#pragma mark UITableView&DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepairShopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RepairShopCell"];
    
    RepairShopModel *model = _dataArr[indexPath.row];
    [cell.shopIcon sd_setImageWithURL:[NSURL URLWithString:model.shopIcon] placeholderImage:IMAGE(@"main_defaultCarIcon")];
    [cell.nameLab setText:model.shopName];
    cell.starView.padding = 5;
    cell.starView.alignment = RateViewAlignmentLeft;
    cell.starView.editable = NO;
    [cell.starView setRate:[model.totalScore floatValue]];
    [cell.commentNumLab setText:[NSString stringWithFormat:@"(%@条)",model.commentNum]];
    [cell.addressLab setText:[NSString stringWithFormat:@"%@%@%@",model.shopCity,model.shopCounty,model.shopAddr]];
    cell.unitLab.hidden = YES;
    if (![NSString isBlankString:model.distanceStr]) {
        [cell.distanceLab setText:model.distanceStr];
        cell.unitLab.hidden = NO;
    }
    
    return cell;
}

//cell点击事件处理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RepairShopModel *model = _dataArr[indexPath.row];
    //进入维修店详情
    UIStoryboard *RepairShopStoryBoard   = [UIStoryboard storyboardWithName:@"RepairShop" bundle:nil];
    RepairShopDetailViewController *detailVc = [RepairShopStoryBoard instantiateViewControllerWithIdentifier:@"RepairShopDetailViewController"];
    detailVc.hidesBottomBarWhenPushed = YES;
    detailVc.shopModel = model;
    [self.navigationController pushViewController:detailVc animated:YES];
}

@end

//
//  RepairShopDetailViewController.m
//  Tigrone
//
//  Created by Mac on 15/12/24.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "RepairShopDetailViewController.h"
#import "HMSegmentedControl.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "RepairPointAnnotation.h"
#import "RepairPopView.h"
#import "MyCommentTableViewCell.h"
#import "ShopGoodsQuanlityCell.h"
#import "UIImageView+WebCache.h"
#import "TigroneRequests.h"

@interface RepairShopDetailViewController ()<BMKMapViewDelegate>
{
    RepairPointAnnotation *currentAnnotation;
}

@property (weak, nonatomic) IBOutlet HMSegmentedControl *shopSegmentControl;

@property (weak, nonatomic) IBOutlet UIView *shopMainView;
@property (weak, nonatomic) IBOutlet UIWebView *shopDetailView;
@property (weak, nonatomic) IBOutlet UIView *shopQualityView;
@property (weak, nonatomic) IBOutlet BMKMapView *shopMapView;

@property (weak, nonatomic) IBOutlet UILabel *mainTopAddressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainShopImageView;
@property (nonatomic, weak) IBOutlet DYRateView *totalScoreView;
@property (weak, nonatomic) IBOutlet UILabel *mainServiceLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainSkillLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainEnvironmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainDetailAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainCommentNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainPhotoNumLabel;
@property (weak, nonatomic) IBOutlet UITableView *mainCommentTableView;

@property (weak, nonatomic) IBOutlet UILabel *detailAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailDescLabel;

@property (weak, nonatomic) IBOutlet UILabel *qualityToTalScore;
@property (weak, nonatomic) IBOutlet UILabel *qualityAttitudeScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *qualityEnvironmentScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *qualityTechScoreLabel;
@property (weak, nonatomic) IBOutlet UITableView *qualityTableView;

@property (weak, nonatomic) IBOutlet DYRateView *totalRateView;

@property (strong, nonatomic)NSMutableArray *commentArr;

@end

@implementation RepairShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"维修店";
    
    _commentArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    [_shopSegmentControl setSectionTitles:@[@"首页", @"详情",@"评论",@"地图"]];
    
        __weak typeof(self) weakSelf = self;
    [_shopSegmentControl setIndexChangeBlock:^(NSInteger index) {
        
        switch (index) {
            case 0:
            {
                [weakSelf selectShopMainPage];
            }
                break;
            case 1:
            {
                [weakSelf selectShopDetail];
            }
                break;
            case 2:
            {
                [weakSelf selectShopQuality];
            }
                break;
            case 3:
            {
                [weakSelf selectShopMap];
            }
                break;
                
            default:
                break;
        }
    }];
    _shopSegmentControl.selectionIndicatorHeight = 2.0f;
    _shopSegmentControl.backgroundColor = ColorWithRGB(239, 250, 255);
    _shopSegmentControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:16]};
    _shopSegmentControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : Tigrone_SchemeColor,NSFontAttributeName:[UIFont systemFontOfSize:16]};
    _shopSegmentControl.selectionIndicatorColor = Tigrone_SchemeColor;
    
    _shopSegmentControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
    _shopSegmentControl.selectedSegmentIndex = 0;
    _shopSegmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;

    //
    [self selectShopMainPage];
    
    [self showViewContent];
    
    [self getRepairDetailRequest];
    [self getShopCommentRequest];
}

- (void)showMapView
{
    _shopMapView.delegate = self;
    
    [_shopMapView setZoomEnabled:YES];
    [_shopMapView setZoomLevel:16];
    
    [_shopMapView removeAnnotation:currentAnnotation];
    
    RepairPointAnnotation *annotation = [[RepairPointAnnotation alloc] init];
    annotation.title = _shopModel.shopName;
    annotation.subtitle = [NSString stringWithFormat:@"%@%@%@",_shopModel.shopCity,_shopModel.shopCounty,_shopModel.shopAddr];
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(_shopModel.latitude, _shopModel.longtitude);
    annotation.coordinate = coor;
    [_shopMapView addAnnotation:annotation];
    
    //得出数据的坐标区域
    BMKCoordinateRegion region = BMKCoordinateRegionMake(coor, BMKCoordinateSpanMake(0.2, 0.2));
    [_shopMapView setRegion:region animated:YES];
}

- (void)showViewContent
{
    //首页
    [_mainShopImageView sd_setImageWithURL:[NSURL URLWithString:_shopModel.shopIcon] placeholderImage:IMAGE(@"main_defaultCarIcon")];
    _mainTopAddressLabel.text = _shopModel.shopName;
    _totalRateView.padding = 5;
    _totalRateView.alignment = RateViewAlignmentLeft;
    _totalRateView.editable = NO;
    [_totalRateView setRate:[_shopModel.totalScore floatValue]];
    _mainServiceLabel.text = [NSString stringWithFormat:@"服务：%@",_shopModel.serviceScore];
    _mainSkillLabel.text = [NSString stringWithFormat:@"技术：%@",_shopModel.skillScore];
    _mainEnvironmentLabel.text = [NSString stringWithFormat:@"环境：%@",_shopModel.envirScore];
    _mainDetailAddressLabel.text = [NSString stringWithFormat:@"%@%@%@",_shopModel.shopCity,_shopModel.shopCounty,_shopModel.shopAddr];
    _mainPhotoNumLabel.text = _shopModel.shopPhone;
    _mainTimeLabel.text = _shopModel.businessTime;
    _mainCommentNumberLabel.text = [NSString stringWithFormat:@"用户评价(%@)",_shopModel.commentNum];
    
    //详情
    _detailAddressLabel.text = _shopModel.shopName;
    
    //商品质量
    _totalRateView.padding = 0;
    _totalRateView.alignment = RateViewAlignmentLeft;
    _totalRateView.editable = NO;
    _totalRateView.backgroundColor = [UIColor clearColor];
    [_totalRateView setRate:4];
    
    _qualityToTalScore.text = _shopModel.totalScore;
    _qualityAttitudeScoreLabel.text = _shopModel.serviceScore;
    _qualityEnvironmentScoreLabel.text = _shopModel.envirScore;
    _qualityTechScoreLabel.text = _shopModel.skillScore;
    
    [_shopDetailView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[_shopModel.detailUrl URLEncodedString]]]];
    
    //地图
    [self showMapView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    _shopMapView.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    _shopMapView.delegate = nil;
}

- (void)dealloc {
    if (_shopMapView) {
        _shopMapView = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - segmentControl  slect Methods
- (void)selectShopMainPage
{
    _shopMainView.hidden    = NO;
    _shopDetailView.hidden  = YES;
    _shopQualityView.hidden = YES;
    _shopMapView.hidden     = YES;
}

- (void)selectShopDetail
{
    _shopDetailView.hidden  = NO;
    _shopMainView.hidden    = YES;
    _shopQualityView.hidden = YES;
    _shopMapView.hidden     = YES;
}

- (void)selectShopQuality
{
    _shopQualityView.hidden = NO;
    _shopMainView.hidden    = YES;
    _shopDetailView.hidden  = YES;
    _shopMapView.hidden     = YES;
}

- (void)selectShopMap
{
    _shopMapView.hidden     = NO;
    _shopMainView.hidden    = YES;
    _shopDetailView.hidden  = YES;
    _shopQualityView.hidden = YES;
}


#pragma mark - IBAction Methods

- (IBAction)addressClicked:(id)sender {
    
    [_shopSegmentControl setSelectedSegmentIndex:3 animated:YES];
    [self selectShopMap];
}


- (IBAction)telClicked:(id)sender {
    //打电话
    if ([NSString isBlankString:_shopModel.shopPhone]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://021-65627585"]];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_shopModel.shopPhone]]];
    }
}


- (IBAction)moreCommentsClicked:(id)sender {
    
    [_shopSegmentControl setSelectedSegmentIndex:2 animated:YES];
    [self selectShopQuality];
}

- (IBAction)defaultShopBtnClip:(id)sender
{
    //设为默认维修店
    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    [TigroneRequests setUserDefaultShopWithBlock:^(NSString *errorStr, BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        [MBProgressHUD showHUDAWhile:errorStr toView:self.navigationController.view duration:1];
    } paramDic:@{@"phone":PhoneNum,
                 @"token":Token,
                 @"shopId":_shopModel.shopId}];
}

#pragma mark - UITableViewDataSource  & UITableViewDelegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight = 44;
    if (tableView == self.mainCommentTableView) {
        cellHeight = 88;
    }
    else if(tableView == self.qualityTableView)
    {
        cellHeight = 110;
    }
    return cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.mainCommentTableView) {
        if (_commentArr.count > 3) {
            return 3;
        }
        return _commentArr.count;
    }
    else if(tableView == self.qualityTableView)
    {
        return _commentArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.mainCommentTableView) {
        
        static NSString *cellIdentifier = @"MyCommentTableViewCell";
        MyCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        ShopCommentModel *model = _commentArr[indexPath.row];
        
        cell.repairShopLabel.text = model.commentTitle;
        cell.commentLabel.text = model.commentContent;
        
        cell.commentStarView.padding = 2;
        cell.commentStarView.alignment = RateViewAlignmentLeft;
        cell.commentStarView.editable = NO;
        [cell.commentStarView setRate:[model.commentScore floatValue]];
        cell.commentStarView.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
    else if(tableView == self.qualityTableView)
    {
        static NSString *cellIdentifier = @"ShopGoodsQuanlityCell";
        ShopGoodsQuanlityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        ShopCommentModel *model = _commentArr[indexPath.row];
        cell.model = model;
        
        return cell;
    }

    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - mapView
- (void)openMapNav
{
    //初始化调启导航时的参数管理类
    BMKNaviPara* para = [[BMKNaviPara alloc]init];
    
    //起点节点
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.pt = CURRENTLOC;
    start.name = @"我的位置";
    
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
        [MBProgressHUD showHUDAWhile:@"导航失败" toView:self.navigationController.view duration:1];
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
    [popView.navBtn addTarget:self action:@selector(openMapNav) forControlEvents:UIControlEventTouchUpInside];
    
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
    // clip popview
}


#pragma mark -request
- (void)getShopCommentRequest
{
//    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    [TigroneRequests getShopCommentListWithBlock:^(NSArray *resultArr, NSString *errorStr) {
//        [MBProgressHUD hideHUDForView:self.navigationController.view];
        if (errorStr) {
//            [MBProgressHUD showHUDAWhile:errorStr toView:self.navigationController.view duration:1];
        }
        else
        {
            //获取评论成功
            [_commentArr removeAllObjects];
            [_commentArr addObjectsFromArray:resultArr];
            _mainCommentNumberLabel.text = [NSString stringWithFormat:@"用户评价(%@)",@(resultArr.count)];
            [_mainCommentTableView reloadData];
            [_qualityTableView reloadData];
        }
    } paramDic:@{@"shopId":_shopModel.shopId}];
}

- (void)getRepairDetailRequest
{
    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    [TigroneRequests getShopDetailWithBlock:^(RepairShopModel *shopModel, NSString *errorStr) {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        if (errorStr) {
            [MBProgressHUD showHUDAWhile:errorStr toView:self.navigationController.view duration:1];
        }
        else
        {
            self.shopModel = shopModel;
            [self showViewContent];
        }
    } paramDic:@{@"phone":PhoneNum,
                 @"token":Token,
                 @"shopId":_shopModel.shopId}];
}

@end

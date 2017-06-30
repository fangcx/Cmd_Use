//
//  FirstPageViewContoller.m
//  Tigrone
//
//  Created by ZhangGang on 15/11/13.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "FirstPageViewContoller.h"
#import "GoodsDetailViewController.h"
#import "RepairShopDetailViewController.h"
#import "SelectCityViewController.h"
#import "RepairShopCell.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "RepairPointAnnotation.h"
#import "NSString+Tigrone.h"
#import "RepairPopView.h"
#import "AreaOperations.h"
#import "TigroneRequests.h"
#import "UIImageView+WebCache.h"
#import "CarBrandCell.h"
#import "SelectBrandViewController.h"
#import "BrandDetailViewController.h"
#import "ImageDetailViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "ImageModel.h"

@interface FirstPageViewContoller()<BMKLocationServiceDelegate,UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,BMKGeoCodeSearchDelegate>
{
    BMKLocationService* _locService;
    AreaModel *currentCity;
    
    NSUInteger _currentPage;
    NSUInteger _totalNum;
    NSTimer *_adTimer;
    
    BMKGeoCodeSearch* _geocodesearch;
    NSString *localCity;
    
    NSArray *provinces;
}

@property(nonatomic, weak)IBOutlet UIPageControl *pageControl;
@property(nonatomic, weak)IBOutlet UIScrollView *imgScrollView;
@property(nonatomic, strong) UIButton *cityBtn;
@property(nonatomic, weak)IBOutlet UIButton *rightBtn;
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong)NSArray *brandArr;
@property (nonatomic, strong)NSArray *brandIdArr;

@property (nonatomic, strong)NSMutableArray *imagesArr;

@end

@implementation FirstPageViewContoller

- (void)viewDidLoad
{
    [super viewDidLoad];
    _cityBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth/2, 44)];
    _cityBtn.backgroundColor = [UIColor clearColor];
    [_cityBtn setImage:IMAGE(@"main_cityIcon.png") forState:UIControlStateNormal];
    [_cityBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    _cityBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    _cityBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_cityBtn setTitle:@"" forState:UIControlStateNormal];
    [_cityBtn addTarget:self action:@selector(selectCityBtnClip:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_cityBtn];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    
    self.dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    self.imagesArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.brandIdArr = @[@"32",
                        @"33",
                        @"34",
                        @"35",
                        @"36",
                        @"37",
                        @"38",
                        @"39"];
    self.brandArr = @[IMAGE(@"car_dazhong_icon"),
                      IMAGE(@"car_shjt_icon"),
                      IMAGE(@"car_shty_icon"),
                      IMAGE(@"car_shwl_icon"),
                      IMAGE(@"car_yqdz_icon"),
                      IMAGE(@"car_qrqc_icon"),
                      IMAGE(@"car_slgs_icon"),
                      IMAGE(@"car_hcjt_icon")];
    _currentPage = 0;
    _totalNum = 0;
    
    currentCity = [[AreaModel alloc] init];
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    
    NSString *addressPlist = [[NSBundle mainBundle] pathForResource:@"addressInfo" ofType:@"plist"];
    NSMutableDictionary *plistDic = [[NSMutableDictionary alloc] initWithContentsOfFile:addressPlist];
    
    if (plistDic) {
        provinces = plistDic[@"provinces"];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkToken) name:CheckTokenNof object:nil];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getImagesRequest];
    
    [self updateCurrentCity];
    [_locService startUserLocationService];
    
    _geocodesearch.delegate = self;
    
    if (_adTimer)
    {
        [_adTimer invalidate];
        _adTimer = nil;
    }
    
    _adTimer = [NSTimer timerWithTimeInterval:3.0
                                       target:self
                                     selector:@selector(adImgChanged)
                                     userInfo:nil
                                      repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_adTimer forMode:NSRunLoopCommonModes];
    
    if (TIsLogin) {
        //已经登录
        [self.rightBtn setHidden:YES];
    }
    else
    {
        [self.rightBtn setHidden:NO];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_adTimer)
    {
        [_adTimer invalidate];
        _adTimer = nil;
    }
    
    _geocodesearch.delegate = nil;
}

- (void)checkToken
{
    if (TIsLogin) {
        //已经登录
        [self.rightBtn setHidden:YES];
    }
    else
    {
        [self.rightBtn setHidden:NO];
    }
}

- (void)dealloc {
    if (_locService) {
        _locService.delegate = nil;
        _locService = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)adImgChanged
{
    if (_currentPage >= (_totalNum - 1)) {
        _currentPage = 0;
    }
    else
    {
        _currentPage ++;
    }
    
    [_pageControl setCurrentPage:_currentPage];
    [_imgScrollView setContentOffset:CGPointMake(kMainScreenWidth*_currentPage, 0) animated:YES];
}

- (void)updateCurrentCity
{
    currentCity = [AreaOperations getCurrentCity];
    if ([NSString isBlankString:currentCity.areaName]) {
        //默认显示上海市
        currentCity.areaId = @"2";
        currentCity.areaName = @"上海市";
    }

    [self.cityBtn setTitle:currentCity.areaName forState:UIControlStateNormal];
}

- (void)initAdImages
{
    _totalNum = _imagesArr.count;
    [_pageControl setNumberOfPages:_totalNum];
    [_pageControl setCurrentPage:_currentPage];
    [_imgScrollView setContentSize:CGSizeMake(kMainScreenWidth*_totalNum, 156)];
    
    for (UIView *view in _imgScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    if (_totalNum > 0) {
        for (NSUInteger i = 0; i < _totalNum; i ++) {
            UIImageView *tmpImg = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth*i, 0, kMainScreenWidth, 156)];
            tmpImg.userInteractionEnabled = YES;
            ImageModel *model = _imagesArr[i];
            NSString *imgUrlStr = model.imgUrl;
            [tmpImg sd_setImageWithURL:[NSURL URLWithString:[imgUrlStr URLEncodedString]] placeholderImage:IMAGE(@"goods_default_img")];
            tmpImg.tag = i;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleRecognizer:)];
            tapGesture.numberOfTapsRequired = 1;
            [tmpImg addGestureRecognizer:tapGesture];
            [_imgScrollView addSubview:tmpImg];
        }
    }
}

- (void)handleSingleRecognizer:(UITapGestureRecognizer *)recognizer
{
    UIView *view = recognizer.view;
    NSUInteger tag = view.tag;
    if (_imagesArr.count > tag) {
        ImageModel *model = _imagesArr[tag];
        if ([model.imgType isEqualToString:@"sku"]) {
            //跳到商品详情页面
            GoodsModel *tempModel = [[GoodsModel alloc] init];
            tempModel.goodsId = model.skuId;
            UIStoryboard *mainBoard = [UIStoryboard storyboardWithName:@"FirstPage" bundle:nil];
            GoodsDetailViewController *detailVc = [mainBoard instantiateViewControllerWithIdentifier:@"GoodsDetailViewController"];
            detailVc.goodsModel = tempModel;
            [self.navigationController pushViewController:detailVc animated:YES];
//            [self GoToGoodsDetail:model];
        }
        else
        {
            //跳到图片web页面
            UIStoryboard *mainBoard = [UIStoryboard storyboardWithName:@"FirstPage" bundle:nil];
            ImageDetailViewController *detailVc = [mainBoard instantiateViewControllerWithIdentifier:@"ImageDetailViewController"];
            detailVc.htmlUrl = model.htmlUrl;
            [self.navigationController pushViewController:detailVc animated:YES];
        }
    }
}

- (void)GoToGoodsDetail:(ImageModel *)imgModel
{
    [self getGoodsRequest:imgModel.skuId Car:nil];
}



#pragma mark - request

//获取轮播图
- (void)getImagesRequest
{
    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    [TigroneRequests getFirstImagesWithBlock:^(NSArray *resultArr, NSString *errorStr) {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        if (errorStr) {
            [MBProgressHUD showHUDAWhile:errorStr toView:self.navigationController.view duration:1];
        }
        else
        {
            //获取图片成功
            [_imagesArr removeAllObjects];
            [_imagesArr addObjectsFromArray:resultArr];
            [self initAdImages];
        }
    } paramDic:nil];
}

- (void)getGoodsRequest:(NSString *)skuId Car:(CarModel *)carModel
{
    //获取商品请求
    if ([NSString isBlankString:skuId]) {
        skuId = @"";
    }
    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    [TigroneRequests getGoodsWithBlock:^(GoodsModel *model, NSString *errorStr) {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        if (!errorStr) {
            if (model) {
//                model.suitCarId = carModel.carId;
//                model.suitCar = carModel.allName;
                
                //进入商品详情
                UIStoryboard *mainBoard = [UIStoryboard storyboardWithName:@"FirstPage" bundle:nil];
                GoodsDetailViewController *detailVc = [mainBoard instantiateViewControllerWithIdentifier:@"GoodsDetailViewController"];
                detailVc.goodsModel = model;
                [self.navigationController pushViewController:detailVc animated:YES];
            }
        }
        else
        {
            [MBProgressHUD showHUDAWhile:errorStr toView:self.navigationController.view duration:1];
        }
    } paramDic:@{@"skuId":skuId}];
}


#pragma mark -button
- (IBAction)loginBtnClip:(id)sender
{
    //登录
    UIStoryboard *AuthStoryBoard    = [UIStoryboard storyboardWithName:@"AuthStoryboard" bundle:nil];
    LoginViewController *loginVC = [AuthStoryBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:loginVC animated:YES];
}

//new code
- (IBAction)leftBtnClip:(id)sender
{
    //进入汽车品牌选择
    SelectBrandViewController *sVc = (SelectBrandViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"SelectBrandViewController"];
    [self.navigationController pushViewController:sVc animated:YES];
}

- (IBAction)rightBtnClip:(id)sender
{
    //进入维修店
    [APPDELEGATE.mainTabBarViewController setSelectedIndex:1];
}


- (IBAction)selectCityBtnClip:(id)sender
{
    UIStoryboard *mainBoard = [UIStoryboard storyboardWithName:@"FirstPage" bundle:nil];
    SelectCityViewController *selectVC = [mainBoard instantiateViewControllerWithIdentifier:@"SelectCityViewController"];
    selectVC.dataArr = provinces;
    selectVC.isHeader = YES;
    selectVC.localCity = localCity;
    [self.navigationController pushViewController:selectVC animated:YES];
}

#pragma mark - baiduMapDelegate
/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    //定位失败提示
    [_locService startUserLocationService];
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    USERLOC = userLocation;
    CLLocation *location = userLocation.location;
    if (!location || location.coordinate.longitude == 0 || location.coordinate.latitude == 0) {
        //定位失败提示
        [_locService startUserLocationService];
    }
    else
    {
        //定位成功
        CURRENTLOC = location.coordinate;
        [self startReverseGeocode];
    }
}

//反向地理编码
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        if (result) {
            if ([NSString isBlankString:result.addressDetail.city]) {
                localCity = result.addressDetail.province;
            }
            else
            {
                localCity = result.addressDetail.city;
            }
            
            if (![NSString isBlankString:localCity]) {
                [_locService stopUserLocationService];
            }
            else
            {
                [_locService startUserLocationService];
            }
            
            if (!currentCity) {
                currentCity = [[AreaModel alloc] init];
            }
            currentCity.areaId = @"1";
            currentCity.areaName = localCity;
            [AreaOperations setCurrentCity:currentCity];
            [self updateCurrentCity];
        }
    }
}

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
        [self updateCurrentCity];
    }
}

//new code
#pragma mark - collectionViewDelegate & dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.brandArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierCell = @"CarBrandCell";
    CarBrandCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierCell forIndexPath:indexPath];
    cell.brandImg.image = self.brandArr[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kMainScreenWidth/4, 69);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSString *brandId = self.brandIdArr[indexPath.row];
    UIImage *carImage = self.brandArr[indexPath.row];
    
    CarModel *carModel = [[CarModel alloc] init];
    carModel.brandId = brandId;
    carModel.brands = @"";
    carModel.carIcon = @"";
    carModel.carImg = carImage;
    
    BrandDetailViewController *bVc = (BrandDetailViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"BrandDetailViewController"];
    bVc.carModel = carModel;
    [self.navigationController pushViewController:bVc animated:YES];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - uiScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    if (scrollView == _imgScrollView) {
        CGFloat pageWidth = scrollView.frame.size.width;
        if (scrollView.contentOffset.x > (_totalNum - 1)*pageWidth + pageWidth/4) {
            _currentPage = 0;
            [_pageControl setCurrentPage:_currentPage];
            [_imgScrollView setContentOffset:CGPointMake(kMainScreenWidth*_currentPage, 0) animated:YES];
        }
        else
        {
            _currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
            [_pageControl setCurrentPage:_currentPage];
        }
    }
}

@end

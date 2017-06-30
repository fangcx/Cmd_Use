//
//  SetCarTypeViewController.m
//  Tigrone
//
//  Created by 张蒙蒙 on 15/12/28.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "SetCarTypeViewController.h"
#import "BrandDetailTableViewCell.h"
#import "SureCarViewController.h"
#import "CarListViewController.h"
#import "GoodsDetailViewController.h"
#import "BrandsModel.h"
#import "TigroneRequests.h"
#import "VolumesModel.h"
#import "GoodsListViewController.h"

@interface SetCarTypeViewController ()
{
    VolumesModel *currentModel;
    NSMutableArray *_dataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SetCarTypeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"选择排量";
    
    _dataArray = [[NSMutableArray alloc]init];

    [self initData];
}

-(void)initData
{
    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    
    [TigroneRequests getVolumesByModelId:^(NSString *retcode, NSString *retmessage, NSMutableArray *resultArray, NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.navigationController.view];
         
         if ([retcode isEqualToString:kSuccessCode])
         {
             _dataArray = resultArray;
             
             [_tableView reloadData];
         }
         else
         {
             [MBProgressHUD showHUDAWhile:retmessage toView:self.navigationController.view duration:1];
         }
         
     } paramDic:@{@"modelId":_carModel.modelsId}];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BrandDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrandDetailTableViewCell" forIndexPath:indexPath];
    
    VolumesModel *model = [_dataArray objectAtIndex:indexPath.row];
    [cell setVolumesModelWithModel:model];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *white = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 40)];
    white.backgroundColor = UIColorFromRGB(0Xeaeaea);
    
    UILabel *textLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kMainScreenWidth, 40)];
    textLab.text = [NSString stringWithFormat:@"%@ > %@",_carModel.brands,_carModel.models];
    textLab.font = [UIFont fontWithName:@"Helvetica" size:20];
    [white addSubview:textLab];
    
    return white;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    if (indexPath.row < _dataArray.count)
    {
        VolumesModel *model = [_dataArray objectAtIndex:indexPath.row];
        
        _carModel.volumeId = model._id;
        _carModel.volumes = model.name;
        
        //modify 更改为进入商品列表 2016.6.28 by fcx
        //进入商品列表
        UIStoryboard *mainBoard = [UIStoryboard storyboardWithName:@"FirstPage" bundle:nil];
        GoodsListViewController *listVc = [mainBoard instantiateViewControllerWithIdentifier:@"GoodsListViewController"];
        listVc.carModel = _carModel;
        [self.navigationController pushViewController:listVc animated:YES];
        //end by 2016.6.28 by fcx
        
//        currentModel = model;
//        if (![NSString isBlankString:_carModel.carId]) {
//            NSString *carInfo = [NSString getJsonStringWith:@{@"volumeId":model._id,
//                                                              @"id":_carModel.carId}];
//            [self addOrUpdateCar:carInfo isUpdate:YES];
//        }
//        else
//        {
//            NSString *carInfo = [NSString getJsonStringWith:@{@"volumeId":model._id}];
//            [self addOrUpdateCar:carInfo isUpdate:NO];
//        }
    }
    
}

//添加/更新车辆
- (void)addOrUpdateCar:(NSString *)carStr isUpdate:(BOOL)isUpdate
{
    [self getGoodsDetailRequest:nil];
//    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
//    if (!isUpdate) {
//        //添加
//        [TigroneRequests addCarWithBlock:^(CarModel *model, NSString *errorStr) {
//            [MBProgressHUD hideHUDForView:self.navigationController.view];
//            if (errorStr) {
////                [MBProgressHUD showHUDAWhile:errorStr toView:self.navigationController.view duration:1];
//                [MBProgressHUD showHUDAWhile:@"获取详情失败" toView:self.navigationController.view duration:1];
//            }
//            else
//            {
////                for (UIViewController *vc in self.navigationController.viewControllers) {
////                    if ([vc isKindOfClass:[CarListViewController class]]) {
////                        [self.navigationController popToViewController:vc animated:YES];
////                    }
////                }
//                //进入详情页面
//                [self getGoodsDetailRequest:model];
//            }
//        } paramDic:@{@"phone":PhoneNum,
//                     @"token":Token,
//                     @"car":carStr}];
//    }
//    else
//    {
//        //更新
//        [TigroneRequests updateCarWithBlock:^(NSString *errorStr) {
//            [MBProgressHUD hideHUDForView:self.navigationController.view];
//            if (errorStr) {
//                [MBProgressHUD showHUDAWhile:errorStr toView:self.navigationController.view duration:1];
//            }
//            else
//            {
//                for (UIViewController *vc in self.navigationController.viewControllers) {
//                    if ([vc isKindOfClass:[CarListViewController class]]) {
//                        [self.navigationController popToViewController:vc animated:YES];
//                    }
//                }
//            }
//        } paramDic:@{@"phone":PhoneNum,
//                     @"token":Token,
//                     @"car":carStr}];
//    }
}

- (void)getGoodsDetailRequest:(CarModel *)carModel
{
    [TigroneRequests getGoodsByVolumeIdWithBlock:^(GoodsModel *model, NSString *errorStr) {
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
            [MBProgressHUD showHUDAWhile:@"获取详情失败" toView:self.navigationController.view duration:1];
        }
    } paramDic:@{@"volumeId":currentModel._id}];
}

@end

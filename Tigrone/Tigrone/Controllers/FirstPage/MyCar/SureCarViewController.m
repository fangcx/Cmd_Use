//
//  SureCarViewController.m
//  Tigrone
//
//  Created by 张蒙蒙 on 15/12/28.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "SureCarViewController.h"
#import "CarListViewController.h"
#import "BrandDetailTableViewCell.h"
#import "TigroneRequests.h"
#import "YearModel.h"

@interface SureCarViewController ()
{
    NSMutableArray *_dataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SureCarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"选择年份";
    
    _dataArray = [[NSMutableArray alloc]init];
    
    [self initData];
    
}

-(void)initData
{
    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    
    [TigroneRequests getYearsByVolumeId:^(NSString *retcode, NSString *retmessage, NSMutableArray *resultArray, NSError *error)
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
         
     } paramDic:@{@"phone":PhoneNum,@"token":Token,@"volumeId":_carModel.volumeId}];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count] + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _dataArray.count)
    {
        BrandDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrandDetailTableViewCell" forIndexPath:indexPath];
        
        YearModel *model = [_dataArray objectAtIndex:indexPath.row];
        [cell setYearModeltWithModel:model];
        
        return cell;
    }
    else
    {
        static NSString *identifier = @"identifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *textLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 40)];
        textLab.text = @"如何查看爱车生产年份";
        textLab.textAlignment = NSTextAlignmentCenter;
        textLab.font = [UIFont fontWithName:@"Helvetica" size:16];
        textLab.backgroundColor = UIColorFromRGB(0Xeaeaea);
        [cell.contentView addSubview:textLab];
        
        UIView *otherView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, kMainScreenWidth, 400-40)];
        otherView.backgroundColor = [UIColor yellowColor];
        [cell.contentView addSubview:otherView ];
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _dataArray.count)
    {
        return 50;
    }
    else
    {
        return 400;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 40)];
    headView.backgroundColor = UIColorFromRGB(0Xeaeaea);
    
    UILabel *textLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kMainScreenWidth, 40)];
    textLab.text = [NSString stringWithFormat:@"%@ > %@ > %@",_carModel.brands,_carModel.models,_carModel.volumes];
    textLab.font = [UIFont fontWithName:@"Helvetica" size:16];
    [headView addSubview:textLab];
    
    return headView;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < _dataArray.count)
    {
        YearModel *model = [_dataArray objectAtIndex:indexPath.row];
        
        if (![NSString isBlankString:_carModel.carId]) {
            NSString *carInfo = [NSString stringWithFormat:@"{\"yearId\":%@,\"id\":%@}",model._id,_carModel.carId];
            [self addOrUpdateCar:carInfo isUpdate:YES];
        }
        else
        {
            NSString *carInfo = [NSString stringWithFormat:@"{\"yearId\":%@}",model._id];
            [self addOrUpdateCar:carInfo isUpdate:NO];
        }
    }
}

//添加/更新车辆
- (void)addOrUpdateCar:(NSString *)carStr isUpdate:(BOOL)isUpdate
{
    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    if (!isUpdate) {
        //添加
        [TigroneRequests addCarWithBlock:^(CarModel *model, NSString *errorStr) {
            [MBProgressHUD hideHUDForView:self.navigationController.view];
            if (errorStr) {
                [MBProgressHUD showHUDAWhile:errorStr toView:self.navigationController.view duration:1];
            }
            else
            {
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[CarListViewController class]]) {
                        [self.navigationController popToViewController:vc animated:YES];
                    }
                }
            }
        } paramDic:@{@"phone":PhoneNum,
                     @"token":Token,
                     @"car":carStr}];
    }
    else
    {
        //更新
        [TigroneRequests updateCarWithBlock:^(NSString *errorStr) {
            [MBProgressHUD hideHUDForView:self.navigationController.view];
            if (errorStr) {
                [MBProgressHUD showHUDAWhile:errorStr toView:self.navigationController.view duration:1];
            }
            else
            {
                for (UIViewController *vc in self.navigationController.viewControllers) {
                    if ([vc isKindOfClass:[CarListViewController class]]) {
                        [self.navigationController popToViewController:vc animated:YES];
                    }
                }
            }
        } paramDic:@{@"phone":PhoneNum,
                     @"token":Token,
                     @"car":carStr}];
    }
}

@end

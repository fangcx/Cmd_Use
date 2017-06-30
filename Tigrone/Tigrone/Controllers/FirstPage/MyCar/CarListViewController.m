//
//  CarListViewController.m
//  Tigrone
//
//  Created by Mac on 15/12/23.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "CarListViewController.h"
#import "SelectBrandViewController.h"
#import "MyCarTableViewCell.h"
#import "TigroneRequests.h"

@interface CarListViewController ()<MyCarTableViewCellDelegate>
{
    NSMutableArray *_dataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)CarModel *preCarModel;
@property (nonatomic, strong)CarModel *selectModel;

@end

@implementation CarListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"我的车辆";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addMyCar)];
    self.navigationItem.rightBarButtonItem = item;
    
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getCarListRequest];
}

-(void)initData
{
    _dataArray = [[NSMutableArray alloc]init];
}


#pragma mark - request
- (void)getCarListRequest
{
    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    
    [TigroneRequests getCarListWithBlock:^(NSArray *resultArray, NSString *errorStr) {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        if (errorStr) {
            [MBProgressHUD showHUDAWhile:errorStr toView:self.navigationController.view duration:1];
        }
        else
        {
            [_dataArray removeAllObjects];
            [_dataArray addObjectsFromArray:resultArray];
            [self.tableView reloadData];
        }
    } paramDic:@{@"phone":PhoneNum,
                 @"token":Token}];
}

- (void)changeCarRequest
{
    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    [TigroneRequests changeCarWithBlock:^(NSString *retcode, NSString *retmessage, NSError *error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        if (error) {
            [MBProgressHUD showHUDAWhile:retmessage toView:self.navigationController.view duration:1];
        }
        else
        {
            _preCarModel.isActive = NO;
            _selectModel.isActive  = YES;
            [_tableView reloadData];
        }
    } paramDic:@{@"phone":PhoneNum,
                 @"token":Token,
                 @"carId":_selectModel.carId}];
}

- (void)deleteCarRequest
{
    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    [TigroneRequests deleteCarWithBlock:^(NSString *retcode, NSString *retmessage, NSError *error) {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        if (error) {
            [MBProgressHUD showHUDAWhile:retmessage toView:self.navigationController.view duration:1];
        }
        else
        {
            if (_dataArray.count > 0) {
                for (CarModel *model in _dataArray) {
                    if ([model.carId isEqualToString:_selectModel.carId]) {
                        [_dataArray removeObject:model];
                        [_tableView reloadData];
                        break;
                    }
                }
            }
        }
    } paramDic:@{@"phone":PhoneNum,
                 @"token":Token,
                 @"carId":_selectModel.carId}];
}

-(void)addMyCar
{
    SelectBrandViewController *sVc = (SelectBrandViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"SelectBrandViewController"];
    [self.navigationController pushViewController:sVc animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCarCellIdentifier" forIndexPath:indexPath];
    
    CarModel *model = [_dataArray objectAtIndex:indexPath.row];
    
    [cell setContentWithCarModelModel:model withIndex:indexPath.row];
    cell.delegate = self;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CarModel *model = [_dataArray objectAtIndex:indexPath.row];
    
    SelectBrandViewController *sVc = (SelectBrandViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"SelectBrandViewController"];
    sVc.carModel = model;
    [self.navigationController pushViewController:sVc animated:YES];    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:
(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:
(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        _selectModel = _dataArray[indexPath.row];
        [self deleteCarRequest];
    }
}

-(void)selectMyCarWithIndex:(NSInteger)index
{
    MyCarTableViewCell *selectCell = (MyCarTableViewCell*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    if (!selectCell.selectBtn.selected)
    {
        _selectModel = [_dataArray objectAtIndex:index];
        
        for (CarModel *model in _dataArray)
        {
            if (model != _selectModel && model.isActive)
            {
                _preCarModel = model;
                
                [self changeCarRequest];
                break;
            }
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

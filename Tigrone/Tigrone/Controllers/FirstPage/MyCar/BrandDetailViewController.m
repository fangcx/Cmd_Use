//
//  BrandDetailViewController.m
//  Tigrone
//
//  Created by 张蒙蒙 on 15/12/28.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "BrandDetailViewController.h"
#import "BrandDetailTableViewCell.h"
#import "SetCarTypeViewController.h"
#import "TigroneRequests.h"
#import "ModelsModel.h"

@interface BrandDetailViewController ()
{
    NSMutableArray *_indexArray;
    NSMutableArray *_dataArray;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BrandDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"选择车型";
    
    _titleLab.text = [NSString stringWithFormat:@"   %@",_carModel.brands];
    
    _indexArray = [[NSMutableArray alloc]init];
    
    _dataArray = [[NSMutableArray alloc]init];
    
    [self initData];
    
}

-(void)initData
{
    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    
    [TigroneRequests getCarListByBrand:^(NSString *retcode, NSString *retmessage, NSMutableArray *chinaArray,NSMutableArray *abroadArray, NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.navigationController.view];
         
         if ([retcode isEqualToString:kSuccessCode])
         {
             if (chinaArray && chinaArray.count > 0) {
                 [_dataArray addObject:chinaArray];
                 [_indexArray addObject:@"国产"];
             }
             
             if (abroadArray && abroadArray.count > 0) {
                 [_dataArray addObject:abroadArray];
                 [_indexArray addObject:@"进口"];
             }
                          
             [_tableView reloadData];
         }
         else
         {
             [MBProgressHUD showHUDAWhile:retmessage toView:self.navigationController.view duration:1];
         }
         
     } paramDic:@{@"brandId":_carModel.brandId}];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_indexArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_dataArray objectAtIndex:section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BrandDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BrandDetailTableViewCell" forIndexPath:indexPath];
    
    ModelsModel *model = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cell setCarModelsWithModel:model];
    
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
    textLab.text = [_indexArray objectAtIndex:section];
    textLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    [white addSubview:textLab];
    
    return white;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ModelsModel *model = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    _carModel.modelsId = model._id;
    _carModel.models = model.name;
    SetCarTypeViewController *bVc = (SetCarTypeViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"SetCarTypeViewController"];
    bVc.carModel = self.carModel;
    [self.navigationController pushViewController:bVc animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

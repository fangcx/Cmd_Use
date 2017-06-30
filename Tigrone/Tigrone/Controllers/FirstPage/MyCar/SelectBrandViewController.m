//
//  SelectBrandViewController.m
//  Tigrone
//
//  Created by 张蒙蒙 on 15/12/26.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "SelectBrandViewController.h"
#import "SelectBrandTableViewCell.h"
#import "BrandDetailViewController.h"
#import "TigroneRequests.h"
#import "NSString+PinYin.h"
#import "BrandsModel.h"

@interface SelectBrandViewController ()
{
    NSMutableArray *_indexArray;
    NSMutableArray *_dataArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SelectBrandViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"选择品牌";
    
    [self initData];
    
    _indexArray = [[NSMutableArray alloc]init];
    
    _dataArray  = [[NSMutableArray alloc]init];
}

-(void)initData
{
    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    
    [TigroneRequests getCarBrandsList:^(NSString *retcode, NSString *retmessage, NSMutableArray *resultArray, NSError *error)
    {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        
        if ([retcode isEqualToString:kSuccessCode])
        {
            [self doWithArray:resultArray];
            
            [_tableView reloadData];
        }
        else
        {
            [MBProgressHUD showHUDAWhile:retmessage toView:self.navigationController.view duration:1];
        }
        
    } paramDic:nil];
}


-(void)doWithArray:(NSMutableArray *)array
{
    NSArray* orderArray = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
                           {
                               BrandsModel *model1 = (BrandsModel *)obj1;
                               
                               NSString* str1 = [model1.name getFirstLetter];
                               
                               BrandsModel *model2 = (BrandsModel *)obj2;
                               
                               NSString* str2 = [model2.name getFirstLetter];
                               
                               return [str1 compare:str2];
                           }];
    
    NSMutableArray* dataArray = [[NSMutableArray alloc]init];
    NSString* lastFirstLetter = @"";
    
    for (BrandsModel *tempModel in orderArray)
    {
        NSString* firstLetter = [tempModel.name  getFirstLetter];
        if ([firstLetter isEqualToString:lastFirstLetter])
        {
            NSMutableArray* sectionData = [dataArray lastObject];
            [sectionData addObject:tempModel];
        }
        else
        {
            lastFirstLetter = firstLetter;
            [_indexArray addObject:firstLetter];
            
            NSMutableArray* sectionData = [[NSMutableArray alloc]initWithObjects:tempModel, nil];
            [dataArray addObject:sectionData];
        }
    }
    
    _dataArray = dataArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_dataArray objectAtIndex:section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"brandCellIdentifier" forIndexPath:indexPath];
    
    BrandsModel *model = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cell setContentWithBrandsModelModel:model];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
    textLab.font = [UIFont fontWithName:@"Helvetica" size:20];
    [white addSubview:textLab];
    
    return white;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BrandsModel *model = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if (!_carModel) {
        _carModel = [[CarModel alloc] init];
    }
    
    _carModel.brandId = model._id;
    _carModel.brands = model.name;
    _carModel.carIcon = model.icon;
    
    BrandDetailViewController *bVc = (BrandDetailViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"BrandDetailViewController"];
    bVc.carModel = self.carModel;
    [self.navigationController pushViewController:bVc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

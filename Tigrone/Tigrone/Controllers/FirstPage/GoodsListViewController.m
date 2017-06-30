//
//  GoodsListViewController.m
//  Tigrone
//
//  Created by Mac on 16/6/27.
//  Copyright © 2016年 iOS Team. All rights reserved.
//

#import "GoodsListViewController.h"
#import "GoodsCell.h"
#import "TigroneRequests.h"
#import "GlobalData.h"
#import "UIImageView+WebCache.h"
#import "GoodsModel.h"
#import "GoodsDetailViewController.h"

@interface GoodsListViewController ()

@property (nonatomic, weak)IBOutlet UIImageView *carIcon;
@property (nonatomic, weak)IBOutlet UILabel *carNameLab;

@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, weak)IBOutlet UITableView *dataTableView;

@end

@implementation GoodsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商品列表";
    
    _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    if (_carModel) {
        if (_carModel.carImg) {
            [_carIcon setImage:_carModel.carImg];
        }
        else
        {
            [_carIcon sd_setImageWithURL:[NSURL URLWithString:_carModel.carIcon] placeholderImage:IMAGE(@"main_defaultCarIcon")];
        }
        [_carNameLab setText:[NSString stringWithFormat:@"%@ %@ %@",_carModel.brands,_carModel.models,_carModel.volumes]];
    }
    
    [self getGoodsListRequest];
}

#pragma  mark - request
-(void)getGoodsListRequest
{
    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    [TigroneRequests getGoodsListWithBlock:^(NSArray *resultArray, NSString *errorStr) {
        
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        if (errorStr) {
            //请求失败
            [MBProgressHUD showHUDAWhile:errorStr toView:self.navigationController.view duration:1];
        }
        else
        {
            //请求成功
            [_dataArr removeAllObjects];
            [_dataArr addObjectsFromArray:resultArray];
            [_dataTableView reloadData];
        }
    } paramDic:@{@"volumeId":_carModel.volumeId}];
}

#pragma mark - UITableViewDelegate
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
    GoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsCell" forIndexPath:indexPath];
    
    GoodsModel *model = _dataArr[indexPath.row];
    
    [cell.skuIcon sd_setImageWithURL:[NSURL URLWithString:model.goodsIcon] placeholderImage:IMAGE(@"main_defaultCarIcon")];
    cell.nameLab.text = model.goodsName;
    cell.starView.padding = 5;
    cell.starView.alignment = RateViewAlignmentLeft;
    cell.starView.editable = NO;
    [cell.starView setRate:[model.commentScore floatValue]];
    cell.commentNumLab.text = [NSString stringWithFormat:@"(%@条)",model.commentNum];
    cell.priceLab.text = [NSString stringWithFormat:@"￥%@",model.goodsPrice];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GoodsModel *model = _dataArr[indexPath.row];
    //进入商品详情
    UIStoryboard *mainBoard = [UIStoryboard storyboardWithName:@"FirstPage" bundle:nil];
    GoodsDetailViewController *detailVc = [mainBoard instantiateViewControllerWithIdentifier:@"GoodsDetailViewController"];
    detailVc.goodsModel = model;
    [self.navigationController pushViewController:detailVc animated:YES];
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

@end

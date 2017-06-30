//
//  ShoppingNewCartViewController.m
//  Tigrone
//
//  Created by Mac on 16/6/27.
//  Copyright © 2016年 iOS Team. All rights reserved.
//

#import "ShoppingNewCartViewController.h"
#import "ShoppingNewCartCell.h"
#import "CartOperations.h"
#import "BookOrderViewController.h"
#import "GoodsDetailViewController.h"


@interface ShoppingNewCartViewController ()<UITableViewDelegate,UITableViewDataSource,ShoppingNewCartDelegate>
{
    BOOL _isEdit;       //是否编辑状态
    
    BOOL isSelectAll;   //全选
}

@property(nonatomic, strong)GoodsModel *selectModel;
@property(nonatomic, strong)NSMutableArray *dataArr;
@property(nonatomic, strong)NSMutableArray *selectArr;
@property(nonatomic, weak)IBOutlet UITableView *dataTableView;
@property(nonatomic, weak)IBOutlet UIButton *editBtn;
@property(nonatomic, weak)IBOutlet UIButton *selectAllBtn;
@property(nonatomic, weak)IBOutlet UILabel *totalLab;
@property(nonatomic, weak)IBOutlet UIButton *orderBtn;
@property(nonatomic, weak)IBOutlet UIView *orderView;

@end

@implementation ShoppingNewCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.editBtn];
    _isEdit = NO;
    isSelectAll = NO;
    self.dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    self.selectArr = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![NSString isBlankString:PhoneNum] && ![NSString isBlankString:Token]) {
        _dataArr = [CartOperations selectAllGoodsOfCart];
    }
    
    [_selectArr removeAllObjects];
    
    [self updateUI];
}

- (void)updateUI
{
    [_dataTableView reloadData];
    
    if (_dataArr.count == 0) {
        _orderView.hidden = YES;
        _editBtn.hidden = YES;
    }
    else
    {
        _orderView.hidden = NO;
        _editBtn.hidden = NO;
    }
    
    if (_selectArr.count > 0 && _selectArr.count == _dataArr.count) {
        [_selectAllBtn setImage:IMAGE(@"bill_button_select") forState:UIControlStateNormal];
        [_selectAllBtn setTitle:@"全不选" forState:UIControlStateNormal];
        isSelectAll = YES;
    }
    else
    {
        [_selectAllBtn setImage:IMAGE(@"bill_btn_normal") forState:UIControlStateNormal];
        [_selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        isSelectAll = NO;
    }
    
    NSUInteger style = 0;
    CGFloat sumPrice = 0;
    for (GoodsModel *model in _dataArr) {
        if (model.isSelected) {
            style ++;
            sumPrice += [model.goodsPrice floatValue] * model.goodsNum;
        }
    }
    
    [_orderBtn setTitle:[NSString stringWithFormat:@"去结算(%ld)",style] forState:UIControlStateNormal];
    
    //合计
    [_totalLab setText:[NSString stringWithFormat:@"%.2f",sumPrice]];
}

#pragma mark - button
-(IBAction)editBtnClip:(id)sender
{
    if (!_isEdit) {
        [_editBtn setTitle:@"完成" forState:UIControlStateNormal];
    }
    else
    {
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    }
    _isEdit = !_isEdit;
    
    [_dataTableView reloadData];
}

- (IBAction)selectAllBtnClip:(id)sender
{
    //全不选
    if (isSelectAll) {
        if (_dataArr.count > 0 ) {
            for (GoodsModel *model in _dataArr) {
                model.isSelected = NO;
            }
        }
        
        [_selectArr removeAllObjects];
    }
    else
    {
        //全选
        if (_dataArr.count > 0) {
            for (GoodsModel *model in _dataArr) {
                model.isSelected = YES;
            }
        }
        
        [_selectArr removeAllObjects];
        [_selectArr addObjectsFromArray:_dataArr];
    }
    [self updateUI];
}

- (IBAction)orderBtnClip:(id)sender
{
    if (_selectArr.count > 0) {
        //去结算
        //预约订单
        UIStoryboard *firstStoryBoard = [UIStoryboard storyboardWithName:@"FirstPage" bundle:nil];
        BookOrderViewController *bookVc = [firstStoryBoard instantiateViewControllerWithIdentifier:@"BookOrderViewController"];
        bookVc.orderArr = self.selectArr;
        [self.navigationController pushViewController:bookVc animated:YES];
    }
    else
    {
        //请选择商品
        [MBProgressHUD showHUDAWhile:@"请选择商品" toView:self.navigationController.view duration:1];
    }
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
    ShoppingNewCartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShoppingNewCartCell" forIndexPath:indexPath];
    cell.delegate = self;
    
    cell.goodsModel = _dataArr[indexPath.row];
    if (_isEdit) {
        cell.nameLab.hidden = YES;
        cell.desLab.hidden = YES;
        cell.priceLab.hidden = YES;
        cell.numberLab.hidden = YES;
        
        cell.editView.hidden = NO;
        cell.deleteBtn.hidden = NO;
    }
    else
    {
        cell.nameLab.hidden = NO;
        cell.desLab.hidden = NO;
        cell.priceLab.hidden = NO;
        cell.numberLab.hidden = NO;
        
        cell.editView.hidden = YES;
        cell.deleteBtn.hidden = YES;
    }
    
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

#pragma mark -cellDelegate
//选择
-(void)goodsDidSelected:(id)sender cell:(id)obj
{
    ShoppingNewCartCell *cell = (ShoppingNewCartCell *)obj;
    _selectModel = cell.goodsModel;
    
    _selectModel.isSelected = !_selectModel.isSelected;
    
    if (_selectModel.isSelected) {
        [_selectArr addObject:_selectModel];
    }
    else
    {
        if ([_selectArr containsObject:_selectModel]) {
            [_selectArr removeObject:_selectModel];
        }
    }
    
    [self updateUI];
}

//减数目
- (void)goodsDidMinus:(id)sender cell:(id)obj
{
    ShoppingNewCartCell *cell = (ShoppingNewCartCell *)obj;
    _selectModel = cell.goodsModel;
    
    if (_selectModel.goodsNum > 1) {
        if ([CartOperations minusGoodsNUmOfCart:_selectModel]) {
            _selectModel.goodsNum --;
            [self updateUI];
        }
    }
    else
    {
        [MBProgressHUD showHUDAWhile:@"商品数目已经是最少了" toView:self.navigationController.view duration:1];
    }
}

//加数目
- (void)goodsDidAdd:(id)sender cell:(id)obj
{
    ShoppingNewCartCell *cell = (ShoppingNewCartCell *)obj;
    _selectModel = cell.goodsModel;
    
    if (_selectModel.maxValue > 0) {
        if (_selectModel.goodsNum >= _selectModel.maxValue) {
            [MBProgressHUD showHUDAWhile:@"商品数量已达上限" toView:self.navigationController.view duration:1];
            
            return;
        }
    }
    
    if ([CartOperations addGoodsNumOfCart:_selectModel]) {
        _selectModel.goodsNum ++;
        [self updateUI];
    }
}

//删除
- (void)goodsDidDeleted:(id)sender cell:(id)obj
{
    ShoppingNewCartCell *cell = (ShoppingNewCartCell *)obj;
    _selectModel = cell.goodsModel;
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:@"是否删除？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BOOL isDelete = [CartOperations deleteGoodsOfCart:_selectModel];
        if (isDelete) {
            [MBProgressHUD showHUDAWhile:@"删除成功" toView:self.navigationController.view duration:1];
            if ([_dataArr containsObject:_selectModel]) {
                [_dataArr removeObject:_selectModel];
            }
            
            if ([_selectArr containsObject:_selectModel]) {
                [_selectArr removeObject:_selectModel];
            }
            
            [self updateUI];
        }
        else
        {
            [MBProgressHUD showHUDAWhile:@"删除失败" toView:self.navigationController.view duration:1];
        }
    }];
    
    [alertView addAction:cancel];
    [alertView addAction:confirm];
    [self presentViewController:alertView animated:YES completion:nil];
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

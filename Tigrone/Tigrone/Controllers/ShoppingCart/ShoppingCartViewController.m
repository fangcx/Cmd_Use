//
//  ShoppingCartViewController.m
//  Tigrone
//
//  Created by ZhangGang on 15/11/13.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "ShopTableViewCell.h"
#import "OrderDetailViewController.h"
#import "PaymentViewController.h"
#import "TigroneRequests.h"
#import "RefundViewController.h"
#import "UIImageView+WebCache.h"

@interface ShoppingCartViewController()
{
    NSMutableArray *_dataArray;
}



@end

@implementation ShoppingCartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    
    _shoppingTabeleView.rowHeight = UITableViewAutomaticDimension;
    _shoppingTabeleView.estimatedRowHeight = 130.0f;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getTradeListRequest];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShoppingCellIdentifier" forIndexPath:indexPath];
    
    OrderModel *model = _dataArray[indexPath.row];
    [cell.cellHeadImageView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:IMAGE(@"main_defaultCarIcon")];
    cell.goodsDetailsLabel.text = model.skuName;
    cell.serviceShopNameLabel.text = model.shopName;
    cell.timeLabel.text = model.reDate;
    cell.addressLabel.text = model.shopAddr;
    cell.purchaseButton.tag = 1000+indexPath.row;
    
    cell.purchaseButton.userInteractionEnabled = YES;
    
    if (model.payStatus == 1) {
        [cell.purchaseButton setTitle:@"申请退款" forState:UIControlStateNormal];
    }
    else if (model.payStatus == 2) {
        cell.purchaseButton.userInteractionEnabled = NO;
        [cell.purchaseButton setTitle:@"退款中" forState:UIControlStateNormal];
    }
    else if(model.payStatus == 3)
    {
        cell.purchaseButton.userInteractionEnabled = NO;
        [cell.purchaseButton setTitle:@"退款完成" forState:UIControlStateNormal];
    }
    else
    {
        [cell.purchaseButton setTitle:@"支付" forState:UIControlStateNormal];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *MeStoryBoard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    OrderDetailViewController *orderDetailVc = [MeStoryBoard instantiateViewControllerWithIdentifier:@"OrderDetailViewController"];
    orderDetailVc.orderModel = _dataArray[indexPath.row];
    [self.navigationController pushViewController:orderDetailVc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat maxWidth = kMainScreenWidth - (10+73+10)-80-10;
    
    OrderModel *model = _dataArray[indexPath.row];
    
    CGFloat goodsDetailsLabelHeight = [self heightForWidth:maxWidth withFont:[UIFont systemFontOfSize:16] str:model.skuName];
    
    CGFloat serviceShopNameLabelHeight = [self heightForWidth:maxWidth withFont:[UIFont systemFontOfSize:16] str:model.shopName];
    
    CGFloat timeLabelHeight = [self heightForWidth:maxWidth withFont:[UIFont systemFontOfSize:16] str:model.reDate];
    
    CGFloat addressLabelHeight = [self heightForWidth:kMainScreenWidth - (10+73+10)-80-10-55 withFont:[UIFont systemFontOfSize:16] str:@"南京市雨花台"];
    
    return 10+10+goodsDetailsLabelHeight+serviceShopNameLabelHeight+timeLabelHeight+addressLabelHeight+15;
}

- (CGFloat)heightForWidth:(CGFloat)width withFont:(UIFont*)font str:(NSString *)string
{
    NSAssert(font, @"heightForWidth:方法必须传进font参数");
    
    CGSize size = CGSizeZero;
    NSDictionary *attribute = @{NSFontAttributeName: font};
    size = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                              options: NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return ceilf(size.height)+1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderModel *model = _dataArray[indexPath.row];
    if (model.payStatus == 0) {
        return YES;
    }
    return NO;
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
        OrderModel *model = _dataArray[indexPath.row];
        [self deleteTradeRequest:model];
    }
}

- (IBAction)clickPurchaseButton:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    
    NSInteger tag = btn.tag-1000;
    
    OrderModel *model = _dataArray[tag];
    
    if (model.payStatus == 1) {
        //进入退款页面
        UIStoryboard *meBoard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
        RefundViewController *refundVc = [meBoard instantiateViewControllerWithIdentifier:@"RefundViewController"];
        refundVc.orderModel = model;
        [self.navigationController pushViewController:refundVc animated:YES];
    }
    else
    {
        //进入支付页面
        UIStoryboard *shopCardBoard   = [UIStoryboard storyboardWithName:@"ShoppingCart" bundle:nil];
        PaymentViewController *paymentlVc = [shopCardBoard instantiateViewControllerWithIdentifier:@"PaymentViewController"];
        paymentlVc.orderModel = model;
        [self.navigationController pushViewController:paymentlVc animated:YES];
    }
}

#pragma mark - request
- (void)getTradeListRequest
{
    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    [TigroneRequests getTradeListWithBlock:^(NSArray *resultArr, NSString *errorStr) {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        if (errorStr) {
            [MBProgressHUD showHUDAWhile:errorStr toView:self.navigationController.view duration:1];
        }
        else
        {
            //获取订单列表成功
            [_dataArray removeAllObjects];
            [_dataArray addObjectsFromArray:resultArr];
            [_shoppingTabeleView reloadData];
        }
    } paramDic:@{@"phone":PhoneNum,
                 @"token":Token}];
}

- (void)deleteTradeRequest:(OrderModel *)model
{
    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    [TigroneRequests deleteTradeWithBlock:^(NSString *errorStr,BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        [MBProgressHUD showHUDAWhile:errorStr toView:self.navigationController.view duration:1];
        if (isSuccess) {
            [_dataArray removeObject:model];
            [_shoppingTabeleView reloadData];
        }
    } paramDic:@{@"phone":PhoneNum,
                 @"token":Token,
                 @"tradeId":model.tradeNO}];
}


@end

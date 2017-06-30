//
//  OrderViewController.m
//  Tigrone
//
//  Created by 张亮 on 15/12/25.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "OrderViewController.h"
#import "FinishOrderTableViewCell.h"
#import "UnfinishOrderTableViewCell.h"
#import "HMSegmentedControl.h"
#import "OrderDetailViewController.h"
#import "TigroneRequests.h"
#import "RefundViewController.h"
#import "PaymentViewController.h"
#import "GoodsCommentViewContoller.h"
#import "UIImageView+WebCache.h"

@interface OrderViewController ()

@property (weak, nonatomic) IBOutlet HMSegmentedControl *orderSegmentControl;

@property (weak, nonatomic) IBOutlet UITableView *finishOrderTableView;
@property (weak, nonatomic) IBOutlet UITableView *unfinishOrderTableView;

@property (nonatomic, strong)NSMutableArray *unfinishOrderArr;
@property (nonatomic, strong)NSMutableArray *finishOrderArr;

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单";
    self.view.backgroundColor = ColorWithRGB(239, 250, 254);
    
    _unfinishOrderArr = [[NSMutableArray alloc] initWithCapacity:0];
    _finishOrderArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    [_orderSegmentControl initFromStoryboard];
    
    [_orderSegmentControl setSectionTitles:@[@"已完成订单", @"未完成订单"]];
    
        __weak typeof(self) weakSelf = self;
    [_orderSegmentControl setIndexChangeBlock:^(NSInteger index) {
        switch (index) {
            case 0:
                [weakSelf finishOrder];
                break;
            case 1:
                [weakSelf unfinishOrder];
            default:
                break;
        }
    }];
    _orderSegmentControl.selectionIndicatorHeight = 2.0f;
    _orderSegmentControl.backgroundColor = [UIColor whiteColor];
    _orderSegmentControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:16]};
    
    _orderSegmentControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : Tigrone_SchemeColor,NSFontAttributeName:[UIFont systemFontOfSize:16]};
    _orderSegmentControl.selectionIndicatorColor = Tigrone_SchemeColor;
    
    _orderSegmentControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
    _orderSegmentControl.selectedSegmentIndex = 0;
    _orderSegmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getTradeListRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)finishOrder
{
    self.finishOrderTableView.hidden = NO;
    self.unfinishOrderTableView.hidden = YES;
}

- (void)unfinishOrder
{
    self.finishOrderTableView.hidden = YES;
    self.unfinishOrderTableView.hidden = NO;
}

#pragma mark -button
- (IBAction)clickPayButton:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    
    NSInteger tag = btn.tag-1000;
    
    OrderModel *model = _unfinishOrderArr[tag];
    
//    if (model.payStatus == 1) {
//        //进入退款页面
//        UIStoryboard *meBoard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
//        RefundViewController *refundVc = [meBoard instantiateViewControllerWithIdentifier:@"RefundViewController"];
//        refundVc.orderModel = model;
//        [self.navigationController pushViewController:refundVc animated:YES];
//    }
//    else
//    {
//        //进入支付页面
//        UIStoryboard *shopCardBoard   = [UIStoryboard storyboardWithName:@"ShoppingCart" bundle:nil];
//        PaymentViewController *paymentlVc = [shopCardBoard instantiateViewControllerWithIdentifier:@"PaymentViewController"];
//        paymentlVc.orderModel = model;
//        [self.navigationController pushViewController:paymentlVc animated:YES];
//    }
    
    //进入支付页面
    UIStoryboard *shopCardBoard   = [UIStoryboard storyboardWithName:@"ShoppingCart" bundle:nil];
    PaymentViewController *paymentlVc = [shopCardBoard instantiateViewControllerWithIdentifier:@"PaymentViewController"];
    paymentlVc.orderModel = model;
    [self.navigationController pushViewController:paymentlVc animated:YES];
}

- (IBAction)commentBtnClip:(id)sender
{
    //写评论
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag-1000;
    OrderModel *model = _finishOrderArr[tag];
    
    UIStoryboard *meBoard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    GoodsCommentViewContoller *commentVc = [meBoard instantiateViewControllerWithIdentifier:@"GoodsCommentViewContoller"];
    commentVc.orderModel = model;
    [self.navigationController pushViewController:commentVc animated:YES];
}

- (IBAction)refundBtn:(id)sender
{
    //申请退款
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag-1000;
    OrderModel *model = _unfinishOrderArr[tag];
    UIStoryboard *meBoard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    RefundViewController *refundVc = [meBoard instantiateViewControllerWithIdentifier:@"RefundViewController"];
    refundVc.orderModel = model;
    [self.navigationController pushViewController:refundVc animated:YES];
}

#pragma mark - TableView DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.unfinishOrderTableView) {
        return _unfinishOrderArr.count;
    }
    else
    {
        return _finishOrderArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier;
    if (tableView == self.unfinishOrderTableView) {
        identifier = @"unfinishOrder";
        UnfinishOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        OrderModel *model = _unfinishOrderArr[indexPath.row];
        
        [cell.unfinishOrderImageView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:IMAGE(@"main_defaultCarIcon")];
        cell.timeLabel.text = model.skuName;
        cell.goodsLabel.text = [NSString stringWithFormat:@"￥%@",model.priceStr];
        cell.retailPriceLabel.text = model.reDate;
        
        cell.payButton.tag = 1000+indexPath.row;
        
//        cell.payButton.userInteractionEnabled = YES;
//        if (model.payStatus == 1) {
//            [cell.payButton setTitle:@"申请退款" forState:UIControlStateNormal];
//        }
//        else if (model.payStatus == 2) {
//            cell.payButton.userInteractionEnabled = NO;
//            [cell.payButton setTitle:@"退款中" forState:UIControlStateNormal];
//        }
//        else if(model.payStatus == 3)
//        {
//            cell.payButton.userInteractionEnabled = NO;
//            [cell.payButton setTitle:@"退款完成" forState:UIControlStateNormal];
//        }
//        else
//        {
//            [cell.payButton setTitle:@"支付" forState:UIControlStateNormal];
//        }
        
        if (model.payStatus == 0) {
            [cell.payButton setTitle:@"支付" forState:UIControlStateNormal];
        }
        else
        {
            cell.payButton.hidden = YES;
        }
        
        return cell;
    }
    else if (tableView == self.finishOrderTableView)
    {
        identifier = @"finishOrder";
        FinishOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        OrderModel *model = _finishOrderArr[indexPath.row];
        [cell.orderCellImageView sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:IMAGE(@"main_defaultCarIcon")];
        
        cell.timeLabel.text = model.skuName;
        cell.serviceShopLabel.text = [NSString stringWithFormat:@"￥%@",model.priceStr];
        cell.addressLabel.text = model.reDate;
        
        [cell.commentButton setImage:[UIImage imageNamed:@"order_pencil"] forState:UIControlStateNormal];
        [cell.commentButton setTitle:@"评论" forState:UIControlStateNormal];
        
        [cell.refundButton setBackgroundImage:[UIImage imageNamed:@"order_refund"] forState:UIControlStateNormal];
        
        [cell.refundButton setTitle:@"申请退款" forState:UIControlStateNormal];
        
        cell.commentButton.tag = 1000+indexPath.row;
        cell.refundButton.tag = 1000+indexPath.row;
        
        cell.refundButton.hidden = YES;
//        cell.refundButton.userInteractionEnabled = YES;
//        if (model.payStatus == 1) {
//            [cell.refundButton setTitle:@"申请退款" forState:UIControlStateNormal];
//        }
//        else if (model.payStatus == 2) {
//            cell.refundButton.userInteractionEnabled = NO;
//            [cell.refundButton setTitle:@"退款中" forState:UIControlStateNormal];
//        }
//        else
//        {
//            cell.refundButton.userInteractionEnabled = NO;
//            [cell.refundButton setTitle:@"退款完成" forState:UIControlStateNormal];
//        }
        
        return cell;
    }

    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *MeStoryBoard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    OrderDetailViewController *orderDetailVc = [MeStoryBoard instantiateViewControllerWithIdentifier:@"OrderDetailViewController"];
    if (tableView == _unfinishOrderTableView) {
        orderDetailVc.orderModel = _unfinishOrderArr[indexPath.row];
    }
    else
    {
        orderDetailVc.orderModel = _finishOrderArr[indexPath.row];
        orderDetailVc.isFinish = YES;
    }
    [self.navigationController pushViewController:orderDetailVc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _unfinishOrderTableView) {
        OrderModel *model = _unfinishOrderArr[indexPath.row];
        
        if (model.payStatus == 0) {
            return YES;
        }
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
        if (tableView == _unfinishOrderTableView) {
            OrderModel *model = _unfinishOrderArr[indexPath.row];
            [self deleteTradeRequest:model];
        }
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
            [self reloadOrderView:resultArr];
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
            if ([_unfinishOrderArr containsObject:model]) {
                [_unfinishOrderArr removeObject:model];
                [_unfinishOrderTableView reloadData];
            }
        }
    } paramDic:@{@"phone":PhoneNum,
                 @"token":Token,
                 @"tradeId":model.tradeNO}];
}

- (void)reloadOrderView:(NSArray *)array
{
    [_unfinishOrderArr removeAllObjects];
    [_finishOrderArr removeAllObjects];
    
    if (array.count > 0) {
        for (OrderModel *model in array) {
            if (model.orderStatus == 3) {
                //完成的订单
                [_finishOrderArr addObject:model];
            }
            else if (model.orderStatus == 0)
            {
                //未完成的订单
                [_unfinishOrderArr addObject:model];
            }
        }
    }
    
//    if (_finishOrderArr.count == 0) {
//        OrderModel *model = [[OrderModel alloc] init];
//        model.tradeNO = @"4";
//        model.skuId = @"16";
//        model.shopId = @"1";
//        model.shopName = @"浦东新区金坷路店";
//        model.userCarId = @"15";
//        model.userCarName = @"上海荣威7501.8L";
//        model.skuName = @"离合器";
//        model.orderStatus = 3;
//        model.payStatus = 3;
//        model.shopAddr = @"金坷路111号";
//        model.reDate = @"2016-01-10 15:00:00";
//        model.priceStr = @"0.2";
//        
//        [_finishOrderArr addObject:model];
//    }
    
    [_unfinishOrderTableView reloadData];
    [_finishOrderTableView reloadData];
}

@end

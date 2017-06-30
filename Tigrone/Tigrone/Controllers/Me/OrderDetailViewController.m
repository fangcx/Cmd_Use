//
//  OrderDetailViewController.m
//  Tigrone
//
//  Created by fangchengxiang on 2017/6/23.
//  Copyright © 2017年 iOS Team. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "CommonMacro.h"
#import "GoodsDetailViewController.h"
#import "RepairShopDetailViewController.h"
#import "PaymentViewController.h"
#import "TigroneRequests.h"
#import "RefundViewController.h"
#import "BillViewController.h"
#import "OrderGoodsCell.h"
#import "UIImageView+WebCache.h"

@interface OrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet NSLayoutConstraint *wuliuHeigh;
    IBOutlet NSLayoutConstraint *billWuliuHeigh;
}

@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UILabel *invoiceLab;

@property (weak, nonatomic) IBOutlet UILabel *carNameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@property (nonatomic, weak)IBOutlet UITableView *goodsTableView;
@property (nonatomic, weak)NSArray *goodsArr;

@property (nonatomic, weak)IBOutlet UILabel *receiverLab;
@property (nonatomic, weak)IBOutlet UILabel *phoneLab;
@property (nonatomic, weak)IBOutlet UILabel *addressLab;

@property (nonatomic, weak)IBOutlet UILabel *wuliusnLab;
@property (nonatomic, weak)IBOutlet UILabel *billsnLab;

@property (nonatomic, weak)IBOutlet UIView *billWuliuView;
@property (nonatomic, weak)IBOutlet UIView *wuliuView;

@end

@implementation OrderDetailViewController

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    if ([NSString isBlankString:_orderModel.goodWuliusn]) {
        if ([NSString isBlankString:_orderModel.billWulius]) {
            wuliuHeigh.constant = 0;
            billWuliuHeigh.constant = 0;
            _wuliuView.hidden = YES;
            _billWuliuView.hidden = YES;
            
        }
        else
        {
            wuliuHeigh.constant = 40;
            billWuliuHeigh.constant = 0;
            _wuliuView.hidden = YES;
            _billWuliuView.hidden = NO;
        }
    }
    else
    {
        if ([NSString isBlankString:_orderModel.billWulius]) {
            wuliuHeigh.constant = 40;
            billWuliuHeigh.constant = 0;
            _wuliuView.hidden = NO;
            _billWuliuView.hidden = YES;
        }
        else
        {
            wuliuHeigh.constant = 40;
            billWuliuHeigh.constant = 40;
            _wuliuView.hidden = NO;
            _billWuliuView.hidden = NO;
        }
    }
}

- (void)viewDidLoad
{
    self.title = @"订单详情";
    _goodsArr = _orderModel.goodsArr;
    
    if (![NSString isBlankString:_orderModel.goodWuliusn]) {
        _wuliusnLab.text = [NSString stringWithFormat:@"物流单号：%@",_orderModel.goodWuliusn];
    }
    
    if (![NSString isBlankString:_orderModel.billWulius]) {
        _billsnLab.text = [NSString stringWithFormat:@"发票物流单号：%@",_orderModel.billWulius];
    }
    
    _payBtn.userInteractionEnabled = YES;
    [_payBtn setBackgroundColor:UIColorFromRGB(0x036FB7)];
    _payBtn.hidden = NO;
    _invoiceLab.hidden = YES;
    if (self.isFinish) {
        switch (_orderModel.invoiceStatus) {
            case 0:
            {
                //距离完成订单时间
                NSUInteger diffrenceDay = [self getDifferenceByDate:_orderModel.reDate];
                if (diffrenceDay > 30) {
                    //超过一个月不显示索要发票按钮
                    _payBtn.hidden = YES;
                    _invoiceLab.hidden = NO;
                    _invoiceLab.text = @"已经超过一个月，无法索要发票";
                }
                else
                {
                    [_payBtn setTitle:@"索要发票" forState:UIControlStateNormal];
                }
            }
                break;
            case 1:
            {
                _payBtn.hidden = YES;
                _invoiceLab.hidden = NO;
                _invoiceLab.text = @"发票状态：待开票";
            }
                break;
            case 2:
            {
                _payBtn.hidden = YES;
                _invoiceLab.hidden = NO;
                _invoiceLab.text = @"发票状态：已开票，等待收件";
            }
                break;
            case 3:
            {
                _payBtn.hidden = YES;
                _invoiceLab.hidden = NO;
                _invoiceLab.text = @"发票状态：已发出";
            }
                break;
            case 4:
            {
                _payBtn.hidden = YES;
                _invoiceLab.hidden = NO;
                _invoiceLab.text = @"发票状态：已收到";
            }
                break;
                
            default:
                break;
        }
    }
    else
    {
        if (_orderModel.payStatus == 0) {
            [_payBtn setTitle:@"支付" forState:UIControlStateNormal];
        }
        else if(_orderModel.payStatus == 1 && (_orderModel.wuliuStatus == 1 || _orderModel.wuliuStatus == 2))
        {
            [_payBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        }
        else
        {
            _payBtn.hidden = YES;
        }
    }
    _carNameLab.text = _orderModel.userCarName;
    _timeLab.text = [NSString stringWithFormat:@"完成时间：%@",_orderModel.reDate];
    
    _receiverLab.text = _orderModel.wuliuName;
    _phoneLab.text = _orderModel.wuliuPhone;
    _addressLab.text = [NSString stringWithFormat:@"地址：%@%@%@",_orderModel.province,_orderModel.city,_orderModel.detailAddr];
    
    if ([_orderModel.province isEqualToString:_orderModel.city]) {
        _addressLab.text = [NSString stringWithFormat:@"%@%@",_orderModel.city,_orderModel.detailAddr];
    }
    
    _priceLab.text = [NSString stringWithFormat:@"价格：￥%@",_orderModel.priceStr];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentSuccess) name:@"PaymentSuccess" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendBillSuccess) name:@"SendBillSuccess" object:nil];
}

- (void)paymentSuccess
{
    _payBtn.hidden = YES;
    _invoiceLab.hidden = NO;
    _invoiceLab.text = @"支付完成";
}

- (void)sendBillSuccess
{
    _payBtn.hidden = YES;
    _invoiceLab.hidden = NO;
    _invoiceLab.text = @"发票状态：待开票";
}

//计算旧的时间距离当前时间差
- (NSUInteger)getDifferenceByDate:(NSString *)oldDateStr
{
    NSDate *nowDate = [NSDate date];
    
    NSDateFormatter *dateFormatter =  [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *oldDate = [dateFormatter dateFromString:oldDateStr];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar components:NSCalendarUnitDay fromDate:oldDate toDate:nowDate options:0];
    
    return comps.day;
}

#pragma mark - button
- (IBAction)payBtnClip:(id)sender
{
    //退款或者支付按钮
    
    if (self.isFinish) {
        //索要发票
        UIStoryboard *firstStoryBoard = [UIStoryboard storyboardWithName:@"FirstPage" bundle:nil];
        BillViewController *billVc = [firstStoryBoard instantiateViewControllerWithIdentifier:@"BillViewController"];
        billVc.orderModel = _orderModel;
        [self.navigationController pushViewController:billVc animated:YES];
    }
    else
    {
        if (_orderModel.payStatus == 0) {
            //进入支付页面
            UIStoryboard *shopCardBoard   = [UIStoryboard storyboardWithName:@"ShoppingCart" bundle:nil];
            PaymentViewController *paymentlVc = [shopCardBoard instantiateViewControllerWithIdentifier:@"PaymentViewController"];
            paymentlVc.orderModel = _orderModel;
            [self.navigationController pushViewController:paymentlVc animated:YES];
        }
        else
        {
            //确认收货
            [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
            [TigroneRequests confirmTradeWithBlock:^(NSString *errorStr, BOOL isSuccess) {
                [MBProgressHUD hideHUDForView:self.navigationController.view];
                if (isSuccess) {
                    //成功
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    [MBProgressHUD showHUDAWhile:errorStr toView:self.navigationController.view duration:1];
                }
                
            } paramDic:@{@"phone":PhoneNum,
                         @"token":Token,
                         @"tradeId":_orderModel.tradeNO}];
            
        }
        
    }
    
    //    if (_orderModel.payStatus == 1) {
    //        //进入退款页面
    //        UIStoryboard *meBoard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    //        RefundViewController *refundVc = [meBoard instantiateViewControllerWithIdentifier:@"RefundViewController"];
    //        refundVc.orderModel = _orderModel;
    //        [self.navigationController pushViewController:refundVc animated:YES];
    //    }
    //    else
    //    {
    //        //进入支付页面
    //        UIStoryboard *shopCardBoard   = [UIStoryboard storyboardWithName:@"ShoppingCart" bundle:nil];
    //        PaymentViewController *paymentlVc = [shopCardBoard instantiateViewControllerWithIdentifier:@"PaymentViewController"];
    //        paymentlVc.orderModel = _orderModel;
    //        [self.navigationController pushViewController:paymentlVc animated:YES];
    //    }
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_goodsArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderGoodsCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GoodsModel *model = _goodsArr[indexPath.row];
    
    [cell.skuImg sd_setImageWithURL:[NSURL URLWithString:model.goodsIcon] placeholderImage:IMAGE(@"main_defaultCarIcon")];
    cell.nameLab.text = model.goodsName;
    cell.priceLab.text = [NSString stringWithFormat:@"￥%@",model.goodsPrice];
    cell.numberLab.text = [NSString stringWithFormat:@"X%ld",model.goodsNum];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

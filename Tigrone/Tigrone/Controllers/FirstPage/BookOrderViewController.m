//
//  BookOrderViewController.m
//  Tigrone
//
//  Created by Mac on 15/12/28.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "BookOrderViewController.h"
#import "GoodsDetailViewController.h"
#import "SelectRepairViewController.h"
#import "AddressListViewController.h"
#import "SelectData.h"
#import "TigroneRequests.h"
#import "NSString+Tigrone.h"
#import "PaymentViewController.h"
#import "MBProgressHUD+Tigrone.h"
#import "OrderGoodsCell.h"
#import "UIImageView+WebCache.h"
#import "CartOperations.h"

@interface BookOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet NSLayoutConstraint *tableHeigh;
    IBOutlet NSLayoutConstraint *view1Heigh;
    IBOutlet NSLayoutConstraint *tipViewHeigh;
    IBOutlet NSLayoutConstraint *contentHeigh;
    
    RepairShopModel *_repairShop;
    
    OrderModel *currentOrder;
    
    BOOL isFirstPrice;
    BOOL isOrderSuccess;
    
    CGFloat _totalPrice;
    
    CGFloat _volPrice;          //优惠价格
    CGFloat _discountPrice;     //首单减免的价格
}

@property (nonatomic, strong)NSMutableArray *volsArray;
@property (nonatomic, weak)IBOutlet UITableView *goodsTableView;
@property (nonatomic, weak)IBOutlet UILabel *nameLab;
@property (nonatomic, weak)IBOutlet UILabel *suitLab;

@property (nonatomic, weak)IBOutlet UILabel *billLab;
@property (nonatomic, weak)IBOutlet UILabel *priceLab;
@property (nonatomic, weak)IBOutlet UILabel *tipLab;

@property (nonatomic, weak)IBOutlet UILabel *receiverLab;
@property (nonatomic, weak)IBOutlet UILabel *phoneLab;
@property (nonatomic, weak)IBOutlet UILabel *addressLab;

@property (nonatomic, weak)IBOutlet UILabel * emptyAddressLab;

@property (nonatomic, strong)AddressModel *addressModel;
@property (nonatomic, weak)IBOutlet UIButton *orderBtn;

@end

@implementation BookOrderViewController

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    tableHeigh.constant = 0;
    if (_orderArr.count > 0) {
        tableHeigh.constant = _orderArr.count*90;
    }
    
    view1Heigh.constant = 74 + 10 + tableHeigh.constant;
    tipViewHeigh.constant = 12 + _tipLab.frame.size.height + 25;
    contentHeigh.constant = view1Heigh.constant + 25 + 40 + 30 + 40 + tipViewHeigh.constant;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"下单";
    _volsArray = [[NSMutableArray alloc] init];
    
    _orderBtn.enabled = YES;
    _orderBtn.userInteractionEnabled = YES;
    isOrderSuccess = NO;
    isFirstPrice = NO;
    
    _totalPrice = 0.00;
    _volPrice = 0.00;
    _discountPrice = 0;
    
    [self setLabTextColor:NSMakeRange(0, 3) rangeColor:ColorWithHexValue(0xfdb400) spacing:10 label:_tipLab];
    
    for (GoodsModel *model in _orderArr) {
        _totalPrice += [model.goodsPrice floatValue] * model.goodsNum;
        _discountPrice += model.priceFirstDiscount;
    }
    
    GoodsModel *firstModel = _orderArr[0];
    
    self.nameLab.text = firstModel.suitCar;
    self.suitLab.text = firstModel.goodsName;
    self.priceLab.text = [NSString stringWithFormat:@"￥%.2f",_totalPrice];
    
//    if (_repairShop) {
//        self.repairLab.text = _repairShop.shopName;
//        self.addressLab.text = _repairShop.shopAddr;
//        
//        [self judgeFirstOrderRequest];
//    }
    
    //获取价格对照表
    [self getDiscountReqeust];
    
    //监听支付结果
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentSuccess) name:@"PaymentSuccess" object:nil];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _totalPrice = 0;
    for (GoodsModel *model in _orderArr) {
        _totalPrice += [model.goodsPrice floatValue] * model.goodsNum;
    }
    
    //获取常用地址
    [self getDefaultAddressRequest];
}

- (void)paymentSuccess
{
    _orderBtn.enabled = NO;
    _orderBtn.userInteractionEnabled = NO;
    [_orderBtn setTitle:@"支付完成" forState:UIControlStateNormal];
}

#pragma mark - button
- (IBAction)addressBtnClip:(id)sender
{
    //收货地址
    UIStoryboard *firstStoryBoard = [UIStoryboard storyboardWithName:@"FirstPage" bundle:nil];
    AddressListViewController *addressVc = [firstStoryBoard instantiateViewControllerWithIdentifier:@"AddressListViewController"];
    [self.navigationController pushViewController:addressVc animated:YES];
    
}

- (IBAction)orderBtnClip:(id)sender
{
    if (isOrderSuccess) {
        //进入支付页面
        UIStoryboard *shopCardBoard   = [UIStoryboard storyboardWithName:@"ShoppingCart" bundle:nil];
        PaymentViewController *paymentlVc = [shopCardBoard instantiateViewControllerWithIdentifier:@"PaymentViewController"];
        paymentlVc.orderModel = currentOrder;
        [self.navigationController pushViewController:paymentlVc animated:YES];
    }
    else
    {
        UIButton *orderBtn = (UIButton *)sender;
        
        [self startOrderRequest:orderBtn];
        
    }
}


#pragma mark - request
//获取常用地址
- (void)getDefaultAddressRequest
{
    _emptyAddressLab.hidden = NO;
    [TigroneRequests getDefaultAddressWithBlock:^(NSString *errorStr, AddressModel *defaultModel) {
        if (errorStr) {
            //失败
        }
        else
        {
            //获取成功
            self.addressModel = defaultModel;
            if (![NSString isBlankString:defaultModel.addressId]) {
                _emptyAddressLab.hidden = YES;
                _receiverLab.text = defaultModel.name;
                _phoneLab.text = defaultModel.phone;
                
                _addressLab.text = [NSString stringWithFormat:@"%@%@%@",defaultModel.province,defaultModel.city,defaultModel.detailAddr];
                
                if ([defaultModel.province isEqualToString:defaultModel.city]) {
                    _addressLab.text = [NSString stringWithFormat:@"%@%@",defaultModel.city,defaultModel.detailAddr];
                }
                
            }
        }
        
    } paramDic:@{@"phone":PhoneNum,
                 @"token":Token}];
}

//下单
- (void)startOrderRequest:(UIButton *)orderBtn
{
    NSDictionary *tradeDic = nil;
    //生成订单的价格
    NSString *orderPrice = [NSString stringWithFormat:@"%.2f",_totalPrice];
    
    NSMutableArray *skusArr = [[NSMutableArray alloc] init];
    
    for (GoodsModel *goodsModel in _orderArr) {
        NSMutableDictionary *goodsDic = [[NSMutableDictionary alloc] init];
        [goodsDic setObject:goodsModel.goodsIcon forKey:@"icon"];
        [goodsDic setObject:[NSString stringWithFormat:@"%ld",goodsModel.goodsNum] forKey:@"num"];
        [goodsDic setObject:goodsModel.goodsPrice forKey:@"price"];
        [goodsDic setObject:goodsModel.goodsId forKey:@"skuId"];
        [goodsDic setObject:goodsModel.goodsName forKey:@"skuName"];
        [skusArr addObject:goodsDic];
    }
    
    NSString *addressId = @"";
    if (![NSString isBlankString:_addressModel.addressId]) {
        addressId = _addressModel.addressId;
    }
    else
    {
        [MBProgressHUD showHUDAWhile:@"请添加收货地址" toView:self.navigationController.view duration:1];
        return;
    }
    tradeDic = @{@"addressId":addressId,
                 @"skus":skusArr,
                 @"userCarId":@"13",
                 @"num":@"1",
                 @"amount":orderPrice,
                 @"discount":[NSString stringWithFormat:@"%.f",_discountPrice],
                 @"source":@"iOS"};
    
    [TigroneRequests addNewTradeWithBlock:^(OrderModel *model, NSString *errorStr) {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        if (errorStr) {
            [MBProgressHUD showHUDAWhile:errorStr toView:self.navigationController.view duration:1];
        }
        else
        {
            //成功
            [MBProgressHUD showHUDAWhile:@"下单成功" toView:self.navigationController.view duration:1];
            [orderBtn setTitle:@"支付" forState:UIControlStateNormal];
            isOrderSuccess = YES;
            currentOrder = model;
            
            //下单成功 减去购物车数据
            for (GoodsModel *model in _orderArr) {
                [CartOperations deleteGoodsOfCart:model];
            }
            
        }
    } paramDic:@{@"phone":PhoneNum,
                 @"token":Token,
                 @"trade":[NSString getJsonStringWith:tradeDic]}];
}


//判断是否首单
- (void)judgeFirstOrderRequest
{
    [TigroneRequests judgeIsFirstTradeWithBlock:^(BOOL isSuccess, NSString *errorStr) {
        isFirstPrice = isSuccess;
        if (isFirstPrice) {
            
            _totalPrice -= _discountPrice;
            NSString *coupon = [self calVolPrice];
            if (![[NSString stringWithFormat:@"%.f",_volPrice] isEqualToString:@"0"]) {
                [MBProgressHUD showHUDAWhile:[NSString stringWithFormat:@"满%@元，减%.f元",coupon,_volPrice] toView:self.navigationController.view duration:1];
                _totalPrice -= _volPrice;
            }
            
            self.priceLab.text = [NSString stringWithFormat:@"￥%.2f",_totalPrice];
        }
        else
        {            
            NSString *coupon = [self calVolPrice];
            if (![[NSString stringWithFormat:@"%.f",_volPrice] isEqualToString:@"0"]) {
                [MBProgressHUD showHUDAWhile:[NSString stringWithFormat:@"满%@元，减%.f元",coupon,_volPrice] toView:self.navigationController.view duration:1];
                _totalPrice -= _volPrice;
                
                self.priceLab.text = [NSString stringWithFormat:@"￥%.2f",_totalPrice];
            }
        }
    } paramDic:@{@"phone":PhoneNum,
                 @"token":Token,
                 @"shopId":_repairShop.shopId}];
}

- (void)getDiscountReqeust
{
    [TigroneRequests getDicountListWithBlock:^(NSArray *resultArr, NSString *errorStr) {
        if (!errorStr) {
            //获取优惠列表成功
            [_volsArray removeAllObjects];
            [_volsArray addObjectsFromArray:resultArr];
            
            NSString *coupon = [self calVolPrice];
            if (![[NSString stringWithFormat:@"%.f",_volPrice] isEqualToString:@"0"]) {
                [MBProgressHUD showHUDAWhile:[NSString stringWithFormat:@"满%@元，减%.f元",coupon,_volPrice] toView:self.navigationController.view duration:1];
                _totalPrice -= _volPrice;
                
                self.priceLab.text = [NSString stringWithFormat:@"￥%.2f",_totalPrice];
            }
            else
            {
                self.priceLab.text = [NSString stringWithFormat:@"￥%.2f",_totalPrice];
            }
        }
        else
        {
            self.priceLab.text = [NSString stringWithFormat:@"￥%.2f",_totalPrice];
        }
    } paramDic:@{@"phone":PhoneNum,
                 @"token":Token}];
}

//计算优惠价格
- (NSString *)calVolPrice
{
    if (_volsArray.count > 0) {
        for (NSUInteger i = 0;i < _volsArray.count; i ++) {
            NSDictionary *item = _volsArray[i];
            NSString *coupon = [NSString stringWithFormat:@"%@",item[@"coupon"]];
            if (_totalPrice < [coupon floatValue]) {
                if (i > 0) {
                    NSDictionary *preItem = _volsArray[i - 1];
                    NSString *discount = [NSString stringWithFormat:@"%@",preItem[@"discount"]];
                    _volPrice = [discount floatValue];
                    coupon = [NSString stringWithFormat:@"%@",preItem[@"coupon"]];
                    return coupon;
                }
                break;
            }
        }
        
        NSDictionary *lastItem = _volsArray[_volsArray.count - 1];
        NSString *coupon = [NSString stringWithFormat:@"%@",lastItem[@"coupon"]];
        NSString *discount = [NSString stringWithFormat:@"%@",lastItem[@"discount"]];
        
        if (_totalPrice > [coupon floatValue]) {
            _volPrice = [discount floatValue];
        }
        
        return coupon;
    }
    
    return @"";
}


- (void)setLabTextColor:(NSRange)range rangeColor:(UIColor *)color spacing:(CGFloat)spacing label:(UILabel *)label
{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:label.text];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:spacing];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [label.text length])];
    
    [label setAttributedText:attributedString];
}


#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_orderArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderGoodsCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    GoodsModel *model = _orderArr[indexPath.row];
    
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

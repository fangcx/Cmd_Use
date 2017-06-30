//
//  PaymentViewController.m
//  Tigrone
//
//  Created by Mac on 16/2/1.
//  Copyright © 2016年 iOS Team. All rights reserved.
//

#import "PaymentViewController.h"
#import "PaymentResultViewController.h"
#import "TigroneRequests.h"
#import "OrderGoodsCell.h"
#import "Order.h"
#import "NSString+Tigrone.h"
#import "UIImageView+WebCache.h"
//#import "DataSigner.h"
#import "RSADataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

@interface PaymentViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak)IBOutlet UITableView *dataTableView;
@property (nonatomic, weak)NSArray *goodsArr;

@property (nonatomic, strong)IBOutlet UILabel *nameLab;
@property (nonatomic, strong)IBOutlet UILabel *priceLab;
@property (nonatomic, strong)IBOutlet UIButton *payBtn;

@property (nonatomic, strong)IBOutlet UILabel *recevierLab;
@property (nonatomic, strong)IBOutlet UILabel *phoneLab;
@property (nonatomic, strong)IBOutlet UILabel *addressLab;

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"支付";
    
    _nameLab.text = _orderModel.userCarName;
    _priceLab.text = [NSString stringWithFormat:@"￥%@",_orderModel.priceStr];
    
    _recevierLab.text = _orderModel.wuliuName;
    _phoneLab.text = _orderModel.wuliuPhone;
    _addressLab.text = [NSString stringWithFormat:@"地址：%@%@%@",_orderModel.province,_orderModel.city,_orderModel.detailAddr];
    
    if ([_orderModel.province isEqualToString:_orderModel.city]) {
        _addressLab.text = [NSString stringWithFormat:@"%@%@",_orderModel.city,_orderModel.detailAddr];
    }
    
    _goodsArr = _orderModel.goodsArr;
}

- (IBAction)payBtnClip:(id)sender
{
    //支付宝支付
    NSString *appID = @"2017050207078505";
    NSString *rsa2PrivateKey = @"MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCeKQj4SyWrtM3HRAswY3/ObSj8z5YiTGnoWM9pbnBjQlkDjMv2JtFXTvr2S1dZVboP8xDRVK26v/4PzMbjlyiGmn41fxuZSID0PhEr7gs4dE6i6WbilGONhJv9d4E0XypDaJRTcAHIdcCmMrWPbx5eHWhmN6XwGLkUwT3v8oxyKdKtIsDmv3ZJlMu75oy42d0e2ry0KHs3U9dVnMXQcO8kvZ3Z0cyvbY1KzVDOckZRve0Bg+W5rFH2M0e8fcE87VSxwyhRCw2415jNTmbIiixyXxQXlubBqlPox1p/CLONEslQ1uAHu6CIonKIpTydbxnSj4VLRyMiKCQTR07zW8YnAgMBAAECggEAJPRvnRxp6+nuHv4+IwtMpJ4K8q9KZC84m8qMhBUC+55YECVIzvYY+e6BYyUNftkyBWIE7vR7N2R+55AwdKMwG+tjS/qsJy+yud76win3wzQh35zrpkuHy1xN2nae4O7PgDqiVbCZKg6hefPlSmNrVBBJAYFFK4mLTVctsrAYst/GoGYMJuxOCnUh/0PvMhntxRQ0PQgwujyLT0lcKJTxrgyN4ld31zGANLq/rhC1cFfHMRTR5XPYrmt3gavk6TQoD9qCQ4XPO2pyhkjT6IwDAC3jdOijD5eWGei3dOev8eyZaomMylQSfk0ENCQpMzer3eEZvo2DsYpF6M72oIEg+QKBgQDVg2PaeqvdyrTqtyEs7RG8pz4ij4sKjrigbzbaHMKajfs2yNZGl74Dqije3S2P5Wui8ysF+1WD4BWH8wO2Ui+Rf8TWayRjJNcl923bymKvckDEIMNWTz5amRJ97I+hsgLLFRL/p0olu27+33I70QoaekyXIO4gbZ3eaaBmjhLzXQKBgQC9oebyYDuRj8pBVw6oTPVRN12WXGDkY5LpzNvbhR7A3s8tFzZeE2ItdVPGVk3uscfF7/zGoPhdIuciHnJcA3L2ZtzD6b6yt0geboFDzVKlAMWygJz234t9+cepvVXDo7emg0SQlaiNGfGooxdUVL9J+wsdplsuBSu1Zzv05ItrUwKBgQCPOitytRWzm7ZPOXe0xnc+gUYqMvaHp4Psg45dNCvLN/FMJ9+tzT73AF+YWPCmdbUFw2+Z/Ka550kqQHe+B1XHmdk2KPto0p7M5jU42oPmw5L0vjGrJU9jwQlplZYoVtyO1N1AyDzyINDtgoED5U+MwXu9aaaz9DSRrXOfODE4NQKBgAmb/7D+kWYx7CTdfX+nzrKb5KEu8zX/mb1BRU7dcw6A++ykBXxE7S+yh1lAnFhhJ+du3tdN5ugJUb8X3eGtxxCXa859tM0nnn70SJaf+/UikeIWxF16PH5YvvZqAsOUM0U716if/NeRnf5WrWL3nG3qS8jn2iz91BYwMgiZ4DrDAoGBAMJKU+O2WOwgeNrLgEJhxMls2eU7UPEnrOCu9339T0smS+JFFREGf57RuZpyPspaeVySmsHnrH/EgYP6D2HvAqnB3ZKLNu3eLt8LmKRZtl+x/tP+ajBi7Ol7z52m398ZssWDKv6nmJEmrvvzum2aH+X/e3PQkDRw+1KMl0wnn1/Q";
    NSString *rsaPrivateKey = @"";
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order* order = [Order new];
    
    // NOTE: app_id设置
    order.app_id = appID;
    order.notify_url = @"http://120.55.160.23/alipay/notify_url";
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type 根据商户设置的私钥来决定
    order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";
    
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = _orderModel.userCarName;
    order.biz_content.subject = _orderModel.skuName;
    order.biz_content.out_trade_no = _orderModel.tradeNO; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", [_orderModel.priceStr floatValue]]; //商品价格
    
    NSLog(@"支付价格：%@",order.biz_content.total_amount);
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    RSADataSigner* signer = [[RSADataSigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
    if ((rsa2PrivateKey.length > 1)) {
        signedString = [signer signString:orderInfo withRSA2:YES];
    } else {
        signedString = [signer signString:orderInfo withRSA2:NO];
    }
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"tigrone";
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                //支付成功
//                [MBProgressHUD showHUDAWhile:@"支付成功" toView:self.navigationController.view duration:1];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PaymentSuccess" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
//                UIStoryboard *shopCardBoard   = [UIStoryboard storyboardWithName:@"ShoppingCart" bundle:nil];
//                PaymentResultViewController *resultVc = [shopCardBoard instantiateViewControllerWithIdentifier:@"PaymentResultViewController"];
//                resultVc.resultDic = resultDic;
//                [self.navigationController pushViewController:resultVc animated:YES];
            }
            else
            {
                [MBProgressHUD showHUDAWhile:@"支付失败" toView:self.navigationController.view duration:1];
            }
        }];
    }
    
    
//    NSString *partner = @"2088511695150339";
//    NSString *seller = @"saihu_tmall@126.com";
//    NSString *privateKey = @"MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCeKQj4SyWrtM3HRAswY3/ObSj8z5YiTGnoWM9pbnBjQlkDjMv2JtFXTvr2S1dZVboP8xDRVK26v/4PzMbjlyiGmn41fxuZSID0PhEr7gs4dE6i6WbilGONhJv9d4E0XypDaJRTcAHIdcCmMrWPbx5eHWhmN6XwGLkUwT3v8oxyKdKtIsDmv3ZJlMu75oy42d0e2ry0KHs3U9dVnMXQcO8kvZ3Z0cyvbY1KzVDOckZRve0Bg+W5rFH2M0e8fcE87VSxwyhRCw2415jNTmbIiixyXxQXlubBqlPox1p/CLONEslQ1uAHu6CIonKIpTydbxnSj4VLRyMiKCQTR07zW8YnAgMBAAECggEAJPRvnRxp6+nuHv4+IwtMpJ4K8q9KZC84m8qMhBUC+55YECVIzvYY+e6BYyUNftkyBWIE7vR7N2R+55AwdKMwG+tjS/qsJy+yud76win3wzQh35zrpkuHy1xN2nae4O7PgDqiVbCZKg6hefPlSmNrVBBJAYFFK4mLTVctsrAYst/GoGYMJuxOCnUh/0PvMhntxRQ0PQgwujyLT0lcKJTxrgyN4ld31zGANLq/rhC1cFfHMRTR5XPYrmt3gavk6TQoD9qCQ4XPO2pyhkjT6IwDAC3jdOijD5eWGei3dOev8eyZaomMylQSfk0ENCQpMzer3eEZvo2DsYpF6M72oIEg+QKBgQDVg2PaeqvdyrTqtyEs7RG8pz4ij4sKjrigbzbaHMKajfs2yNZGl74Dqije3S2P5Wui8ysF+1WD4BWH8wO2Ui+Rf8TWayRjJNcl923bymKvckDEIMNWTz5amRJ97I+hsgLLFRL/p0olu27+33I70QoaekyXIO4gbZ3eaaBmjhLzXQKBgQC9oebyYDuRj8pBVw6oTPVRN12WXGDkY5LpzNvbhR7A3s8tFzZeE2ItdVPGVk3uscfF7/zGoPhdIuciHnJcA3L2ZtzD6b6yt0geboFDzVKlAMWygJz234t9+cepvVXDo7emg0SQlaiNGfGooxdUVL9J+wsdplsuBSu1Zzv05ItrUwKBgQCPOitytRWzm7ZPOXe0xnc+gUYqMvaHp4Psg45dNCvLN/FMJ9+tzT73AF+YWPCmdbUFw2+Z/Ka550kqQHe+B1XHmdk2KPto0p7M5jU42oPmw5L0vjGrJU9jwQlplZYoVtyO1N1AyDzyINDtgoED5U+MwXu9aaaz9DSRrXOfODE4NQKBgAmb/7D+kWYx7CTdfX+nzrKb5KEu8zX/mb1BRU7dcw6A++ykBXxE7S+yh1lAnFhhJ+du3tdN5ugJUb8X3eGtxxCXa859tM0nnn70SJaf+/UikeIWxF16PH5YvvZqAsOUM0U716if/NeRnf5WrWL3nG3qS8jn2iz91BYwMgiZ4DrDAoGBAMJKU+O2WOwgeNrLgEJhxMls2eU7UPEnrOCu9339T0smS+JFFREGf57RuZpyPspaeVySmsHnrH/EgYP6D2HvAqnB3ZKLNu3eLt8LmKRZtl+x/tP+ajBi7Ol7z52m398ZssWDKv6nmJEmrvvzum2aH+X/e3PQkDRw+1KMl0wnn1/Q";
//    
//    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
//    NSString *appScheme = @"tigrone";
//    
//    if (_orderModel) {
//        _orderModel.partner = partner;
//        _orderModel.seller = seller;
//        
//        //将商品信息拼接成字符串
//        NSString *orderSpec = [_orderModel description];
//        
//        //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//        id<DataSigner> signer = CreateRSADataSigner(privateKey);
//        NSString *signedString = [signer signString:orderSpec];
//        
//        //将签名成功字符串格式化为订单字符串,请严格按照该格式
//        NSString *orderString = nil;
//        if (signedString != nil) {
//            orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                           orderSpec, signedString, @"RSA"];
//            
//            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//                NSLog(@"result = %@",resultDic);
//                if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
//                    //支付成功
//                    UIStoryboard *shopCardBoard   = [UIStoryboard storyboardWithName:@"ShoppingCart" bundle:nil];
//                    PaymentResultViewController *resultVc = [shopCardBoard instantiateViewControllerWithIdentifier:@"PaymentResultViewController"];
//                    resultVc.resultDic = resultDic;
//                    [self.navigationController pushViewController:resultVc animated:YES];
//                }
//            }];
//        }
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

//
//  RefundViewController.m
//  Tigrone
//
//  Created by 张亮 on 15/12/25.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "RefundViewController.h"
#import "TigroneRequests.h"
#import "OrderViewController.h"
#import "ShoppingCartViewController.h"
#import "NSString+Tigrone.h"

@interface RefundViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UITextView *refundTextView;

@property (nonatomic, strong)IBOutlet UILabel *orderInfoLab;
@property (nonatomic, strong)IBOutlet UILabel *orderPriceLab;

@end

@implementation RefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"申请退款";
    
    self.view.backgroundColor = ColorWithRGB(239, 250, 254);
    _refundTextView.delegate = self;
    
    _orderInfoLab.text = _orderModel.skuName;
    _orderPriceLab.text = [NSString stringWithFormat:@"￥%@",_orderModel.priceStr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backgroundTap:(id)sender
{
    [self.refundTextView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (![text isEqualToString:@""]) {
        self.descriptionLabel.hidden = YES;
    }

    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
        self.descriptionLabel.hidden = NO;
    }

    return YES;
}

- (IBAction)onlineApplicationButtonClick:(UIButton *)sender
{
    if ([NSString isBlankString:_refundTextView.text]) {
        [MBProgressHUD showHUDAWhile:@"请输入退款原因" toView:self.navigationController.view duration:1];
        return;
    }
    [self tradeRefundRequest];
}

#pragma mark - request
//退款
- (void)tradeRefundRequest
{
    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    [TigroneRequests refundWithBlock:^(NSString *errorStr,BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        [MBProgressHUD showHUDAWhile:errorStr toView:self.navigationController.view duration:1];
        if (isSuccess) {
            //退款成功
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[OrderViewController class]]) {
                    OrderViewController *orderVc = (OrderViewController *)vc;
                    [self.navigationController popToViewController:orderVc animated:YES];
                    break;
                }
            }
            
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[ShoppingCartViewController class]]) {
                    ShoppingCartViewController *shoppingVc = (ShoppingCartViewController *)vc;
                    [self.navigationController popToViewController:shoppingVc animated:YES];
                    break;
                }
            }
        }
    } paramDic:@{@"phone":PhoneNum,
                 @"token":Token,
                 @"tradeId":_orderModel.tradeNO,
                 @"refundReason":_refundTextView.text}];
}

@end

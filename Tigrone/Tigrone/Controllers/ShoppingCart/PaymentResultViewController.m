//
//  PaymentResultViewController.m
//  Tigrone
//
//  Created by Mac on 16/2/1.
//  Copyright © 2016年 iOS Team. All rights reserved.
//

#import "PaymentResultViewController.h"

@interface PaymentResultViewController ()

@property (nonatomic, strong)IBOutlet UIImageView *resultImg;
@property (nonatomic, strong)IBOutlet UILabel *resultLab;

@end

@implementation PaymentResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"付款结果";
    
    _resultLab.text = @"支付完成,请在个人订单页面查看相关订单。";
//    _resultLab.text = @"支付完成,敬请准时前往相关维修店修理您的爱车。";
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

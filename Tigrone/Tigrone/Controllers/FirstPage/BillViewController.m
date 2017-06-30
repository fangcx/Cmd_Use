//
//  BillViewController.m
//  Tigrone
//
//  Created by Mac on 16/3/5.
//  Copyright © 2016年 iOS Team. All rights reserved.
//

#import "BillViewController.h"
#import "NSString+Tigrone.h"
#import "MBProgressHUD+Tigrone.h"
#import "TigroneRequests.h"
#import "AddressListViewController.h"
#import "EditBillViewController.h"

@interface BillViewController ()<EditBillViewDelegate,UITextFieldDelegate>
{
    NSString *_billType;   //发票抬头
    NSString *_billTitle;  //发票名称
    
    IBOutlet NSLayoutConstraint *taxHeigh;
}

@property (nonatomic,weak)IBOutlet UIButton *personalBtn;

@property (nonatomic,weak)IBOutlet UILabel *nameLab;
@property (nonatomic,weak)IBOutlet UILabel *phoneLab;
@property (nonatomic,weak)IBOutlet UILabel *addressLab;

@property (nonatomic,weak)IBOutlet UILabel *billLabel;
@property (nonatomic,weak)IBOutlet UITextField *billContentField;  //发票内容

@property (nonatomic,weak)IBOutlet UIView *taxView;
@property (nonatomic,weak)IBOutlet UITextField *taxField;  //税号

@end

@implementation BillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"索要发票";
    _billType = @"个人";
    _billTitle = @"";
    
    UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnClip:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:submitBtn];
    
    _billContentField.text = @"汽车零配件";
    _billLabel.text = [NSString stringWithFormat:@"发票抬头：%@",_billType];
    _nameLab.text = _orderModel.wuliuName;
    _phoneLab.text = _orderModel.wuliuPhone;
    _addressLab.text = [NSString stringWithFormat:@"%@%@%@",_orderModel.province,_orderModel.city,_orderModel.detailAddr];
    
    if ([_orderModel.province isEqualToString:_orderModel.city]) {
        _addressLab.text = [NSString stringWithFormat:@"%@%@",_orderModel.city,_orderModel.detailAddr];
    }
    
    if (![_billType isEqualToString:@"个人"]) {
        _taxView.hidden = NO;
        taxHeigh.constant = 47;
    }
    else
    {
        _taxView.hidden = YES;
        taxHeigh.constant = 0;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getDefaultRequest];
}


#pragma mark -button
- (void)submitBtnClip:(id)sender
{
    //提交发票
    [self sendBillRequest];
}

- (IBAction)personalBillBtnClip:(id)sender
{
    //发票抬头
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"发票抬头" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    __weak typeof(self) weakSelf = self;
    UIAlertAction *personalAction = [UIAlertAction actionWithTitle:@"个人" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        //点击个人
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        _billType = @"个人";
        taxHeigh.constant = 0;
        _taxView.hidden = YES;
        strongSelf.billLabel.text = [NSString stringWithFormat:@"发票抬头：%@",_billType];
    }];
    // 注意取消按钮只能添加一个
    UIAlertAction *companyAction = [UIAlertAction actionWithTitle:@"企业" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        _billType = @"企业";
        if ([NSString isBlankString:_billTitle]) {
            strongSelf.billLabel.text = [NSString stringWithFormat:@"发票抬头：%@",_billType];
        }
        else
        {
            strongSelf.billLabel.text = [NSString stringWithFormat:@"发票抬头：%@",_billTitle];
        }
        
        taxHeigh.constant = 47;
        _taxView.hidden = NO;
        
        UIStoryboard *firstStoryBoard = [UIStoryboard storyboardWithName:@"FirstPage" bundle:nil];
        EditBillViewController *editVc = [firstStoryBoard instantiateViewControllerWithIdentifier:@"EditBillViewController"];
        editVc.delegate = self;
        editVc.billTitle = _billTitle;
        [self.navigationController pushViewController:editVc animated:YES];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
    }];
    
    [alertController addAction:personalAction];
    [alertController addAction:companyAction];
    [alertController addAction:cancelAction];
    [self.navigationController presentViewController:alertController animated:YES completion:^{
        
    }];
}

- (IBAction)selectAddrBtnClip:(id)sender
{
    //选择收货地址
    UIStoryboard *firstStoryBoard = [UIStoryboard storyboardWithName:@"FirstPage" bundle:nil];
    AddressListViewController *addressVc = [firstStoryBoard instantiateViewControllerWithIdentifier:@"AddressListViewController"];
    [self.navigationController pushViewController:addressVc animated:YES];
}

#pragma mark - request
- (void)getDefaultRequest
{
    [TigroneRequests getDefaultAddressWithBlock:^(NSString *errorStr, AddressModel *defaultModel) {
        if (errorStr) {
            //失败
        }
        else
        {
            //获取成功
            if (![NSString isBlankString:defaultModel.addressId]) {
                _nameLab.text = defaultModel.name;
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

- (void)sendBillRequest
{
    //索要发票
    if ([_billType isEqualToString:@"企业"]) {
        if ([NSString isBlankString:_billTitle]) {
            [MBProgressHUD showHUDAWhile:@"请输入企业名称" toView:self.navigationController.view duration:1.0];
            return;
        }
        
        if ([NSString isBlankString:_taxField.text]) {
            [MBProgressHUD showHUDAWhile:@"请输入企业税号" toView:self.navigationController.view duration:1.0];
            return;
        }
    }
    else
    {
        _billTitle = @"";
    }
    
    if ([NSString isBlankString:_billContentField.text]) {
        [MBProgressHUD showHUDAWhile:@"请输入发票内容" toView:self.navigationController.view duration:1.0];
        return;
    }
    
    NSDictionary *tradeDic = @{@"id":_orderModel.tradeNO,
                               @"invoiceType":_billType,
                               @"InvoiceTitle":_billTitle,
                               @"invoiceContext":_billContentField.text,
                               @"invoiceEN":_taxField.text,
                               @"invoiceAddress":_addressLab.text,
                               @"invoiceUserName":_nameLab.text,
                               @"invoiceUserPhone":_phoneLab.text};
    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    [TigroneRequests sendBillInfoWithBlock:^(NSString *errorStr, BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        if (isSuccess) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SendBillSuccess" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [MBProgressHUD showHUDAWhile:errorStr toView:self.navigationController.view duration:1];
        }
    } paramDic:@{@"phone":PhoneNum,
                 @"token":Token,
                 @"trade":[NSString getJsonStringWith:tradeDic]}];
}

#pragma mark - EditBillViewDelegate
- (void)getBillTitle:(NSString *)billTitle
{
    _billTitle = billTitle;
    
    if ([NSString isBlankString:_billTitle]) {
        _billLabel.text = [NSString stringWithFormat:@"发票抬头：%@",_billType];
    }
    else
    {
        _billLabel.text = [NSString stringWithFormat:@"发票抬头：%@",_billTitle];
    }
}


#pragma mark - uitextfieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
////    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
////
////    _billTextField.text = str;
//
//    return YES;
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_billContentField resignFirstResponder];
    [_taxField resignFirstResponder];
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

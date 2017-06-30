//
//  EditBillViewController.m
//  Tigrone
//
//  Created by fangchengxiang on 2017/6/24.
//  Copyright © 2017年 iOS Team. All rights reserved.
//

#import "EditBillViewController.h"

@interface EditBillViewController ()<UITextFieldDelegate>

@property (nonatomic, weak)IBOutlet UITextField *billTextField;

@end

@implementation EditBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发票抬头";
    if (![NSString isBlankString:_billTitle]) {
        _billTextField.text = _billTitle;
    }
}

- (IBAction)saveBtnClip:(id)sender
{
    //保存
    if ([NSString isBlankString:_billTextField.text]) {
        [MBProgressHUD showHUDAWhile:@"请输入企业名称" toView:self.navigationController.view duration:1.0];
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(getBillTitle:)]) {
        [_delegate getBillTitle:_billTextField.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
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
    [_billTextField resignFirstResponder];
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

//
//  ResetPasswordViewController.m
//  Tigrone
//
//  Created by 张蒙蒙 on 15/12/22.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "NSString+Tigrone.h"
#import "AuthRequests.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface ResetPasswordViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *onePassWordTF;
@property (weak, nonatomic) IBOutlet UITextField *twoPassWordTF;

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_isRegister) {
        self.title = @"注册";
    }
    else
    {
        self.title = @"忘记密码";
    }
    
    self.view.backgroundColor   = ColorWithHexValue(0Xf3fbfe);
    
    _onePassWordTF.delegate = self;
    _twoPassWordTF.delegate = self;
    
}

- (IBAction)submitAction:(id)sender
{
    [self allResignAllFirstResponder];
    
    if ([NSString isBlankString:_onePassWordTF.text])
    {
        [MBProgressHUD showHUDAWhile:@"请输入新密码" toView:self.navigationController.view duration:1.0];
        return;
    }
    else if (_onePassWordTF.text.length < 6 || _onePassWordTF.text.length > 16)
    {
        [MBProgressHUD showHUDAWhile:@"您输入的新密码格式不正确，请重新输入" toView:self.navigationController.view duration:1.0];
        return;
    }
    
    if ([NSString isBlankString:_twoPassWordTF.text])
    {
        [MBProgressHUD showHUDAWhile:@"请再次输入新密码" toView:self.navigationController.view duration:1.0];
        return;
    }
    else if (_twoPassWordTF.text.length < 6 || _twoPassWordTF.text.length > 16)
    {
        [MBProgressHUD showHUDAWhile:@"您输入的新密码格式不正确，请重新输入" toView:self.navigationController.view duration:1.0];
        return;
    }
    
    if (![_onePassWordTF.text isEqualToString:_twoPassWordTF.text])
    {
        [MBProgressHUD showHUDAWhile:@"两次输入的新密码不一致，请重新输入" toView:self.navigationController.view duration:1.0];
        return;
    }
    
    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    
    [AuthRequests changePasswdRequestWithBlock:^(NSString *retcode, NSString *retmessage, NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.navigationController.view];
         
         if ([retcode isEqualToString:kSuccessCode])
         {
             if (_isRegister) {
                 BOOL isGoSucc = NO;
                 for (UIViewController *vc in self.navigationController.viewControllers) {
                     if ([vc isKindOfClass:[LoginViewController class]]) {
                         [self.navigationController popToViewController:vc animated:YES];
                         isGoSucc = YES;
                         return;
                     }
                 }
                 
                 if (!isGoSucc) {
                     if (_isCanceLogin) {
                         [APPDELEGATE goMainViewController];
                     }
                     else
                     {
                         [self.navigationController popToRootViewControllerAnimated:YES];
                     }
                 }
                 
                 return;
             }
             [self.navigationController popToRootViewControllerAnimated:YES];
         }
         else
         {
             [MBProgressHUD showHUDAWhile:retmessage toView:self.navigationController.view duration:1];
         }
     } paramDic:@{@"phone":PhoneNum,@"passwd":[NSString md5FromString:_twoPassWordTF.text],@"token":Token}];
}

-(void)allResignAllFirstResponder
{
    [_onePassWordTF resignFirstResponder];
    [_twoPassWordTF resignFirstResponder];
}

#pragma mark-  textFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

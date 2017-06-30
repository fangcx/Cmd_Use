//
//  RegisterViewController.m
//  Tigrone
//
//  Created by 张刚 on 15/12/18.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "RegisterViewController.h"
#import "NSString+Tigrone.h"
#import "UserAgreementViewController.h"
#import "AuthRequests.h"
#import "AppDelegate.h"
#import "NSUserDefaults+Tigrone.h"
#import "LoginViewController.h"
#import "ResetPasswordViewController.h"

@interface RegisterViewController()<UITextFieldDelegate>
{
    BOOL isAgree;
    NSTimer *timer;
    NSInteger countdown;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *checkCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *userAgreementBtn;

@end

@implementation RegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"注册";
    
    self.view.backgroundColor   = ColorWithHexValue(0Xf3fbfe);
    
    _phoneTF.delegate       = self;
    _checkCodeTF.delegate   = self;
    isAgree = YES;
    
    [_userAgreementBtn setTitleColor:Tigrone_SchemeColor forState:UIControlStateNormal];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self stopTimer];
}

#pragma mark- 获取验证码
- (IBAction)getCheckCodeAction:(id)sender
{
    [self allResignAllFirstResponder];
    
    if ([NSString isBlankString:_phoneTF.text])
    {
        [MBProgressHUD showHUDAWhile:@"请输入手机号" toView:self.navigationController.view duration:1.0];
        return;
    }
    else if (![NSString isPhoneNumber:_phoneTF.text])
    {
        [MBProgressHUD showHUDAWhile:@"您输入的手机号有误，请重新输入." toView:self.navigationController.view duration:1.0];
        return;
    }
    
    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    
    [AuthRequests getRegisterCheckCodeWithBlock:^(NSString *retcode, NSString *retmessage, NSError *error)
    {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        [MBProgressHUD showHUDAWhile:retmessage toView:self.navigationController.view duration:1];
        
        if ([retcode isEqualToString:kSuccessCode])
        {
            countdown = 60;
            
            [_getCodeBtn setTitle:[NSString stringWithFormat:@"%ldS",(long)countdown] forState:UIControlStateNormal];
            
            timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
            
            _getCodeBtn.enabled = NO;
        }
    } paramDic:@{@"phone":_phoneTF.text}];
}

-(void)timeChange
{
    countdown--;
    [_getCodeBtn setTitle:[NSString stringWithFormat:@"%ldS",(long)countdown] forState:UIControlStateNormal];
    _getCodeBtn.enabled = NO;
    
    if (countdown<=0)
    {
        [self stopTimer];
    }
}

#pragma mark- 点击“立即注册”
- (IBAction)registerAction:(id)sender
{
    [self allResignAllFirstResponder];
    
    if ([NSString isBlankString:_phoneTF.text])
    {
        [MBProgressHUD showHUDAWhile:@"请输入手机号" toView:self.navigationController.view duration:1.0];
        return;
    }
    else if (![NSString isPhoneNumber:_phoneTF.text])
    {
        [MBProgressHUD showHUDAWhile:@"您输入的手机号有误，请重新输入." toView:self.navigationController.view duration:1.0];
        return;
    }
    
    if ([NSString isBlankString:_checkCodeTF.text])
    {
        [MBProgressHUD showHUDAWhile:@"请输入验证码" toView:self.navigationController.view duration:1.0];
        return;
    }
    
    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    
    [AuthRequests registerRequestWithBlock:^(NSString *retcode, NSString *retmessage, NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.navigationController.view];
         
         if ([retcode isEqualToString:kSuccessCode])
         {
             [NSUserDefaults saveLoginWithPassword:NO];
             
             ResetPasswordViewController *resetPasswordViewController = (ResetPasswordViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"ResetPasswordViewController"];
             resetPasswordViewController.isCanceLogin = self.isCanceLogin;
             resetPasswordViewController.isRegister = YES;
             [self.navigationController pushViewController:resetPasswordViewController animated:YES];
             
//             if (_isCanceLogin) {
//                 [APPDELEGATE goMainViewController];
//             }
//             else
//             {
//                 [self.navigationController popToRootViewControllerAnimated:YES];
//             }
//             [APPDELEGATE goMainViewController];
         }
         else
         {
             [MBProgressHUD showHUDAWhile:retmessage toView:self.navigationController.view duration:1];
         }
     } paramDic:@{@"phone":_phoneTF.text,@"sms":_checkCodeTF.text}];
}

#pragma mark- 点击“同意”用户协议
- (IBAction)agreeAction:(id)sender
{
    [self allResignAllFirstResponder];
    
    isAgree = !isAgree;
    
    if (isAgree)
    {
        [_agreeBtn setBackgroundImage:[UIImage imageNamed:@"au_icon_select"] forState:UIControlStateNormal];
        [_registerBtn setBackgroundImage:[UIImage imageNamed:@"au_icon_submitBtn"] forState:UIControlStateNormal];
        _registerBtn.userInteractionEnabled = YES;
    }
    else
    {
        [_agreeBtn setBackgroundImage:[UIImage imageNamed:@"au_icon_noselect"] forState:UIControlStateNormal];
        [_registerBtn setBackgroundImage:[UIImage imageNamed:@"au_icon_submitHui"] forState:UIControlStateNormal];
        _registerBtn.userInteractionEnabled = NO;
    }
}

#pragma mark- 查看用户协议
- (IBAction)lookAgreementAction:(id)sender
{
    [self allResignAllFirstResponder];
    
    UIStoryboard *authBoard = [UIStoryboard storyboardWithName:@"AuthStoryboard" bundle:nil];
    UserAgreementViewController *uVC = [authBoard instantiateViewControllerWithIdentifier:@"UserAgreementViewController"];
    [self.navigationController pushViewController:uVC animated:YES];
}

-(void)allResignAllFirstResponder
{
    [_phoneTF resignFirstResponder];
    [_checkCodeTF resignFirstResponder];
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

-(void)stopTimer
{
    if (timer)
    {
        [timer invalidate];
        timer = nil;
    }
    
    [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _getCodeBtn.enabled = YES;
}

@end

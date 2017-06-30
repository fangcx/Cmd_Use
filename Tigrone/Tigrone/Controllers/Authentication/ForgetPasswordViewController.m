//
//  ForgetPasswordViewController.m
//  Tigrone
//
//  Created by 张刚 on 15/12/18.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "ResetPasswordViewController.h"
#import "NSString+Tigrone.h"
#import "AuthRequests.h"

@interface ForgetPasswordViewController()<UITextFieldDelegate>
{
    NSTimer *timer;
    NSInteger countdown;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *checkCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"忘记密码";
    
    self.view.backgroundColor   = ColorWithHexValue(0Xf3fbfe);
    
    _phoneTF.delegate       = self;
    _checkCodeTF.delegate   = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self stopTimer];
}

#pragma mark- 获取验证码
- (IBAction)getCheckCode:(id)sender
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
    
    [AuthRequests getForgetPasswordCheckCodeRequestWithBlock:^(NSString *retcode, NSString *retmessage, NSError *error)
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

#pragma mark- 下一步
- (IBAction)goNextAction:(id)sender
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
    
    [AuthRequests checkForgetPasswordCheckCodeRequestWithBlock:^(NSString *retcode, NSString *retmessage, NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.navigationController.view];
         
         if ([retcode isEqualToString:kSuccessCode])
         {
             ResetPasswordViewController *resetPasswordViewController = (ResetPasswordViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"ResetPasswordViewController"];
             [self.navigationController pushViewController:resetPasswordViewController animated:YES];
         }
         else
         {
             [MBProgressHUD showHUDAWhile:retmessage toView:self.navigationController.view duration:1];
         }
     } paramDic:@{@"phone":_phoneTF.text,@"sms":_checkCodeTF.text}];
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

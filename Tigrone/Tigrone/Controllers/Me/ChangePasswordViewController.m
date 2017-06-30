//
//  ChangePasswordViewController.m
//  Tigrone
//
//  Created by 张刚 on 15/12/21.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Tigrone.h"
#import "UIViewController+LeftBarButtonItem.h"
#import "AuthRequests.h"
#import "MyKeyChainHelper.h"

static const NSUInteger kMin_PwdLength = 6;
static const NSUInteger kMax_PwdLength = 16;

@interface ChangePasswordViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *Pwd;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"修改密码";
    self.view.backgroundColor = ColorWithRGB(239, 250, 254);
    
    self.Pwd.delegate = self;
    self.confirmPassword.delegate = self;
    
    [self setLeftNavigationBarButtonItemWithAction:@selector(popBackAction)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.Pwd becomeFirstResponder];
}

- (IBAction)textFieldDidEndOnExit
{
    [self.Pwd resignFirstResponder];
    [self.confirmPassword resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender
{
    [self.Pwd resignFirstResponder];
    [self.confirmPassword resignFirstResponder];
}

-(void)popBackAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)commitButtonClick:(UIButton *)sender
{
    if ([NSString isBlankString:self.Pwd.text])
    {
        [MBProgressHUD showHUDAWhile:@"请输入新密码" toView:self.navigationController.view duration:1.0];
        return;
    }
    else if (self.Pwd.text.length < kMin_PwdLength || self.Pwd.text.length > kMax_PwdLength)
    {
        [MBProgressHUD showHUDAWhile:@"您输入的新密码格式不正确，请重新输入" toView:self.navigationController.view duration:1.0];
        return;
    }
    
    if ([NSString isBlankString:self.confirmPassword.text])
    {
        [MBProgressHUD showHUDAWhile:@"请再次输入新密码" toView:self.navigationController.view duration:1.0];
        return;
    }
    else if (self.confirmPassword.text.length < kMin_PwdLength || self.confirmPassword.text.length > kMax_PwdLength)
    {
        [MBProgressHUD showHUDAWhile:@"您输入的新密码格式不正确，请重新输入" toView:self.navigationController.view duration:1.0];
        return;
    }
    
    if (![self.Pwd.text isEqualToString:self.confirmPassword.text])
    {
        [MBProgressHUD showHUDAWhile:@"两次输入的新密码不一致，请重新输入" toView:self.navigationController.view duration:1.0];
        return;
    }
    
    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    
    [AuthRequests changePasswdRequestWithBlock:^(NSString *retcode, NSString *retmessage, NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.navigationController.view];
         [MBProgressHUD showHUDAWhile:retmessage toView:self.navigationController.view duration:1];
         
         if ([retcode isEqualToString:kSuccessCode])
         {
             [self popBackAction];
         }
     } paramDic:@{@"phone":PhoneNum,@"passwd":[NSString md5FromString:self.Pwd.text],@"token":Token}];
}

#pragma mark - textField
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

@end

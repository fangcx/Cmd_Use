//
//  LoginViewController.m
//  Tigrone
//
//  Created by 张刚 on 15/12/18.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "LoginViewController.h"
#import "NSUserDefaults+Tigrone.h"
#import "IntroductionMasterView.h"
#import "AppDelegate.h"
#import "RegisterViewController.h"
#import "ForgetPasswordViewController.h"
#import "NSString+Tigrone.h"
#import "UserAgreementViewController.h"
#import "MyKeyChainHelper.h"
#import "NSUserDefaults+Tigrone.h"
#import "AuthRequests.h"

@interface LoginViewController()<IntroductionViewDelegate,UITextFieldDelegate>
{
    NSTimer *timer;
    NSInteger countdown;
    BOOL isAgree;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (weak, nonatomic) IBOutlet UIView *withAccountView;
@property (weak, nonatomic) IBOutlet UITextField *accountLoginTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTf;


@property (weak, nonatomic) IBOutlet UIView *withoutAccountView;
@property (weak, nonatomic) IBOutlet UITextField *phoneLoginTF;
@property (weak, nonatomic) IBOutlet UITextField *checkCodeTf;

@property (weak, nonatomic) IBOutlet UIButton *withoutAccountLoginBtn;

@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

@property (weak, nonatomic) IBOutlet UIButton *userAgreementBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor   = ColorWithHexValue(0Xf3fbfe);
    
    _accountLoginTF.delegate = self;
    _passwordTf.delegate     = self;
    _phoneLoginTF.delegate   = self;
    _checkCodeTf.delegate    = self;
   
    isAgree = YES;
    

    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica-Bold" size:18],NSFontAttributeName,[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [_segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [_segmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    
    [_userAgreementBtn setTitleColor:Tigrone_SchemeColor forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *tempAccount = [MyKeyChainHelper getUserNameWithService:KEY_USERNAME];
    NSString *tempPassword = [MyKeyChainHelper getUserNameWithService:KEY_PASSWORD];
    
    if (![NSString isBlankString:tempAccount])
    {
        _accountLoginTF.text = tempAccount;
    }
    else
    {
        _accountLoginTF.text = @"";
    }
    
    if (![NSString isBlankString:tempPassword])
    {
        _passwordTf.text = tempPassword;
    }
    else
    {
        _passwordTf.text = @"";
    }
    
//    if ([NSUserDefaults isNotFirstUse] == NO)
//    {
//        [self goInroductionView];
//    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self stopTimer];
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}


#pragma mark- 切换segment
- (IBAction)segmentChanges:(id)sender
{
    [self allResignAllFirstResponder];
    
    UISegmentedControl *paramSender = (UISegmentedControl*)sender;
    NSInteger selectedSegmentIndex  = [paramSender selectedSegmentIndex];
    
    if (selectedSegmentIndex == 0)
    {
        _withAccountView.hidden     = NO;
        _withoutAccountView.hidden  = YES;
    }
    else
    {
        _withAccountView.hidden     = YES;
        _withoutAccountView.hidden  = NO;
    }
}

#pragma mark- 点击开关
- (IBAction)changeSwitch:(id)sender
{
    [self allResignAllFirstResponder];
    
    UISwitch *tempSwitch            = (UISwitch*)sender;
    
    if (tempSwitch.on)
    {
        _passwordTf.enabled = NO;
        _passwordTf.secureTextEntry = YES;
        _passwordTf.enabled = YES;
    }
    else
    {
        _passwordTf.secureTextEntry = NO;
    }
}

#pragma mark- 获取验证码
- (IBAction)getCheckCodeAction:(id)sender
{
    [self allResignAllFirstResponder];
    
    if ([NSString isBlankString:_phoneLoginTF.text])
    {
        [MBProgressHUD showHUDAWhile:@"请输入手机号" toView:self.navigationController.view duration:1.0];
        return;
    }
    else if (![NSString isPhoneNumber:_phoneLoginTF.text])
    {
        [MBProgressHUD showHUDAWhile:@"您输入的手机号有误，请重新输入." toView:self.navigationController.view duration:1.0];
        return;
    }
    
    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    
    [AuthRequests getLoginCheckCodeWithBlock:^(NSString *retcode, NSString *retmessage, NSError *error)
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
     } paramDic:@{@"phone":_phoneLoginTF.text}];

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

#pragma mark- 有密码登录
- (IBAction)withAccountLogin:(id)sender
{
    [self allResignAllFirstResponder];
    
    if ([NSString isBlankString:_accountLoginTF.text])
    {
        [MBProgressHUD showHUDAWhile:@"请输入账号" toView:self.navigationController.view duration:1.0];
        return;
    }
    
    if ([NSString isBlankString:_passwordTf.text])
    {
        [MBProgressHUD showHUDAWhile:@"请输入密码" toView:self.navigationController.view duration:1.0];
        return;
    }
    
    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    
    [AuthRequests loginWithPasswordRequestWithBlock:^(NSString *retcode, NSString *retmessage, NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.navigationController.view];
         
         if ([retcode isEqualToString:kSuccessCode])
         {
             [MyKeyChainHelper saveUserName:_accountLoginTF.text userNameService:KEY_USERNAME psaaword:_passwordTf.text psaawordService:KEY_PASSWORD];
             
             [NSUserDefaults saveLoginWithPassword:YES];
             
             TIsLogin = YES;
             
             if (_isCanceLogin) {
                 [APPDELEGATE goMainViewController];
             }
             else
             {
                 [self.navigationController popViewControllerAnimated:YES];
             }
         }
         else
         {
             [MBProgressHUD showHUDAWhile:retmessage toView:self.navigationController.view duration:1];
         }
     } paramDic:@{@"phone":_accountLoginTF.text,@"passwd":[NSString md5FromString:_passwordTf.text],@"token":Token}];
}

#pragma mark- 无密码登录
- (IBAction)withoutAccountLoginAction:(id)sender
{
    [self allResignAllFirstResponder];
    
    if ([NSString isBlankString:_phoneLoginTF.text])
    {
        [MBProgressHUD showHUDAWhile:@"请输入手机号" toView:self.navigationController.view duration:1.0];
        return;
    }
    else if (![NSString isPhoneNumber:_phoneLoginTF.text])
    {
        [MBProgressHUD showHUDAWhile:@"您输入的手机号有误，请重新输入." toView:self.navigationController.view duration:1.0];
        return;
    }
    
    if ([NSString isBlankString:_checkCodeTf.text])
    {
        [MBProgressHUD showHUDAWhile:@"请输入验证码" toView:self.navigationController.view duration:1.0];
        return;
    }
    
    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    
    [AuthRequests loginWithCheckCodeRequestWithBlock:^(NSString *retcode, NSString *retmessage, NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.navigationController.view];
         [MBProgressHUD showHUDAWhile:retmessage toView:self.navigationController.view duration:1];
         
         if ([retcode isEqualToString:kSuccessCode])
         {
             [NSUserDefaults saveLoginWithPassword:NO];
             
             if (_isCanceLogin) {
                 [APPDELEGATE goMainViewController];
             }
             else
             {
                 [self.navigationController popViewControllerAnimated:YES];
             }
         }
     } paramDic:@{@"phone":_phoneLoginTF.text,@"sms":_checkCodeTf.text}];
}

#pragma mark- 点击“立即注册”
- (IBAction)registAction:(id)sender
{
    [self allResignAllFirstResponder];
    
    RegisterViewController *registerViewController = (RegisterViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    registerViewController.isCanceLogin = self.isCanceLogin;
    [self.navigationController pushViewController:registerViewController animated:YES];
}

#pragma mark- 点击“忘记密码”
- (IBAction)forgetPasswordAction:(id)sender
{
    [self allResignAllFirstResponder];
    
    ForgetPasswordViewController *forgetPasswordViewController = (ForgetPasswordViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"ForgetPasswordViewController"];
    [self.navigationController pushViewController:forgetPasswordViewController animated:YES];
}

#pragma mark- 点击“同意”用户协议
- (IBAction)agreeAction:(id)sender
{
    [self allResignAllFirstResponder];
    
    isAgree = !isAgree;
    
    if (isAgree)
    {
        [_agreeBtn setBackgroundImage:[UIImage imageNamed:@"au_icon_select"] forState:UIControlStateNormal];
        [_withoutAccountLoginBtn setBackgroundImage:[UIImage imageNamed:@"au_icon_submitBtn"] forState:UIControlStateNormal];
        _withoutAccountLoginBtn.userInteractionEnabled = YES;
    }
    else
    {
        [_agreeBtn setBackgroundImage:[UIImage imageNamed:@"au_icon_noselect"] forState:UIControlStateNormal];
        [_withoutAccountLoginBtn setBackgroundImage:[UIImage imageNamed:@"au_icon_submitHui"] forState:UIControlStateNormal];
        _withoutAccountLoginBtn.userInteractionEnabled = NO;
    }
}

#pragma mark- 查看用户协议
- (IBAction)lookAction:(id)sender
{
    [self allResignAllFirstResponder];
    
    UIStoryboard *authBoard = [UIStoryboard storyboardWithName:@"AuthStoryboard" bundle:nil];
    UserAgreementViewController *uVC = [authBoard instantiateViewControllerWithIdentifier:@"UserAgreementViewController"];
    [self.navigationController pushViewController:uVC animated:YES];
}

-(void)allResignAllFirstResponder
{
    [_accountLoginTF resignFirstResponder];
    [_passwordTf resignFirstResponder];
    [_phoneLoginTF resignFirstResponder];
    [_checkCodeTf resignFirstResponder];
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

#pragma mark - IntroductionViewDelegate & About Methods

- (void)introductionViewDidShow:(IntroductionMasterView *)view
{
    [NSUserDefaults saveisNotFirstUse:YES];
}

- (void)goInroductionView
{
    IntroductionMasterView *introductionView = [[IntroductionMasterView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    introductionView.delegate = self;
    [self.navigationController.view addSubview:introductionView];
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

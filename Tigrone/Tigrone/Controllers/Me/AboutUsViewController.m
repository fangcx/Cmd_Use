//
//  AboutUsViewController.m
//  Tigrone
//
//  Created by 张刚 on 15/12/21.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "AboutUsViewController.h"
#import "HMSegmentedControl.h"
#import "TigroneRequests.h"
#import "LoginViewController.h"

@interface AboutUsViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet HMSegmentedControl *aboutUsSegmentControl;
@property (weak, nonatomic) IBOutlet UIImageView *servicePointImageView;
@property (weak, nonatomic) IBOutlet UIView *aboutUsView;

@property (weak, nonatomic) IBOutlet UIView *feedbackView;

@property (weak, nonatomic) IBOutlet UITextView *feedbackTextView;

@property (weak, nonatomic) IBOutlet UILabel *opinionLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *aScrollView;

@end

@implementation AboutUsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"关于我们";
    self.aScrollView.showsVerticalScrollIndicator = NO;
    
    self.feedbackTextView.delegate = self;
    
    [_aboutUsSegmentControl initFromStoryboard];
    [_aboutUsSegmentControl setSectionTitles:@[@"服务网点", @"关于我们", @"意见反馈"]];
    
    __weak typeof(self) weakSelf = self;
    [_aboutUsSegmentControl setIndexChangeBlock:^(NSInteger index) {

        switch (index) {
            case 0:
            {
                [weakSelf servicePoint];
            }
                break;
            case 1:
            {
                [weakSelf aboutUs];
            }
                break;
            case 2:
            {
                [weakSelf feedback];
            }
                break;
                
            default:
                break;
        }
    }];
    _aboutUsSegmentControl.selectionIndicatorHeight = 2.0f;
    _aboutUsSegmentControl.backgroundColor = ColorWithRGB(239, 250, 255);
    _aboutUsSegmentControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor grayColor]};
    _aboutUsSegmentControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : Tigrone_SchemeColor};
    _aboutUsSegmentControl.selectionIndicatorColor = Tigrone_SchemeColor;
    
    _aboutUsSegmentControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
    _aboutUsSegmentControl.selectedSegmentIndex = 0;
    _aboutUsSegmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    
    [self servicePoint];
}

- (void)dealloc
{
    DDLogInfo(@"_________ AboutUsViewController dealloced ");
}

#pragma mark - select Methods

- (void)servicePoint
{
    self.servicePointImageView.hidden = NO;
    self.aboutUsView.hidden = YES;
    self.feedbackView.hidden = YES;
}

- (void)aboutUs
{
    self.servicePointImageView.hidden = YES;
    self.aboutUsView.hidden = NO;
    self.feedbackView.hidden = YES;
}

- (void)feedback
{
    self.servicePointImageView.hidden = YES;
    self.aboutUsView.hidden = YES;
    self.feedbackView.hidden = NO;
    
    self.feedbackView.backgroundColor = ColorWithRGB(239, 250, 255);
}

#pragma mark - UITextView Delegate Method

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (![text isEqualToString:@""]) {
        self.opinionLabel.hidden = YES;
    }
    
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
        self.opinionLabel.hidden = NO;
    }
    
    return YES;
}

- (IBAction)feedbackBtnClip:(id)sender
{
    //反馈
    if (!TIsLogin) {
        UIStoryboard *AuthStoryBoard    = [UIStoryboard storyboardWithName:@"AuthStoryboard" bundle:nil];
        LoginViewController *loginVC = [AuthStoryBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    [self.feedbackTextView resignFirstResponder];
    
    if ([NSString isBlankString:_feedbackTextView.text]) {
        [MBProgressHUD showHUDAWhile:@"请输入反馈内容" toView:self.navigationController.view duration:1];
        return;
    }
    
    NSString *contentStr = [NSString getJsonStringWith:@{@"context":_feedbackTextView.text,@"title":@"意见反馈"}];
    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    [TigroneRequests feedbackWithBlock:^(NSString *errorStr) {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        if (errorStr) {
            [MBProgressHUD showHUDAWhile:errorStr toView:self.navigationController.view duration:1];
        }
        else
        {
            [MBProgressHUD showHUDAWhile:@"反馈成功" toView:self.navigationController.view duration:1];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } paramDic:@{@"phone":PhoneNum,
                 @"token":Token,
                 @"tellme":contentStr}];
}

#pragma mark - hide Keyboard Method

- (IBAction)backgroundTap:(id)sender
{
    [self.feedbackTextView resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.feedbackTextView endEditing:YES];
}

@end

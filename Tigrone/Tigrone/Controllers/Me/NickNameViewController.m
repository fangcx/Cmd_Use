//
//  nickNameViewController.m
//  Tigrone
//
//  Created by 张亮 on 15/12/23.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "NickNameViewController.h"
#import "TigroneRequests.h"

@interface NickNameViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nickNameField;
@end

@implementation NickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"昵称";
    self.nickNameField.delegate = self;
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(modifyNickName)];
    buttonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = buttonItem;
    
    self.view.backgroundColor = ColorWithRGB(239, 250, 254);
    
    if (![NSString isBlankString:_nickName]) {
        _nickNameField.text = _nickName;
    }
}

- (void)modifyNickName
{
    [_nickNameField resignFirstResponder];
    
    if ([NSString isBlankString:_nickNameField.text]) {
        [MBProgressHUD showHUDAWhile:@"请输入昵称" toView:self.navigationController.view duration:1];
        return;
    }
    //修改昵称
    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    [TigroneRequests modifyNickNameWithBlock:^(NSString *errorStr) {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        if (errorStr) {
            [MBProgressHUD showHUDAWhile:errorStr toView:self.navigationController.view duration:1];
        }
        else
        {
//            [MBProgressHUD showHUDAWhile:@"修改成功" toView:self.navigationController.view duration:1];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } parmaDic:@{@"phone":PhoneNum,
                 @"token":Token,
                 @"name":_nickNameField.text}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backgroundTap:(id)sender
{
    [self.nickNameField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end

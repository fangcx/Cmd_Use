//
//  EmailModifyViewController.m
//  Tigrone
//
//  Created by 张亮 on 15/12/25.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "EmailModifyViewController.h"
#import "TigroneRequests.h"

@interface EmailModifyViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailModifyField;
@end

@implementation EmailModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"邮箱";
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(modifyEmailName)];
    buttonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = buttonItem;
        
    self.view.backgroundColor = ColorWithRGB(239, 250, 254);
    
    if (![NSString isBlankString:_emailStr]) {
        _emailModifyField.text = _emailStr;
    }
}

- (void)modifyEmailName
{
    [self.emailModifyField resignFirstResponder];
    
    if ([NSString isBlankString:_emailModifyField.text]) {
        [MBProgressHUD showHUDAWhile:@"请输入邮箱" toView:self.navigationController.view duration:1];
        return;
    }
    
    if (![NSString isMailAddress:_emailModifyField.text]) {
        [MBProgressHUD showHUDAWhile:@"请输入正确的邮箱" toView:self.navigationController.view duration:1];
        return;
    }
    
    //修改昵称
    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    [TigroneRequests modifyEmailWithBlock:^(NSString *errorStr) {
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
                 @"email":_emailModifyField.text}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didEndOnExit
{
    [self.emailModifyField resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender
{
    [self.emailModifyField resignFirstResponder];
}

@end

//
//  MeViewController.m
//  Tigrone
//
//  Created by ZhangGang on 15/11/13.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "MeViewController.h"
#import "ShoppingCartViewController.h"
#import "FirstPageViewContoller.h"
#import "AppDelegate.h"
#import "AuthRequests.h"
#import "MyKeyChainHelper.h"
#import "GlobalData.h"
#import "TigroneRequests.h"
#import "UIButton+AFNetworking.h"
#import "LoginViewController.h"
#import "MyCommentViewController.h"
#import "AboutUsViewController.h"
#import "OrderViewController.h"
#import "ChangePasswordViewController.h"
#import "SelfInfoViewController.h"

@interface MeViewController () <UITableViewDelegate>
{
    UserInfoModel *_userModel;
}

@property (weak, nonatomic) IBOutlet UILabel *userNameLab;
@property (weak, nonatomic) IBOutlet UIButton *personalButton;

@property (weak, nonatomic) IBOutlet UIButton *shoppingCartButton;

@property (weak, nonatomic) IBOutlet UIButton *orderButton;

@property (weak, nonatomic) IBOutlet UIButton *chooseCarButton;

@property (weak, nonatomic) IBOutlet UIButton *changePasswordButton;
@property (weak, nonatomic) IBOutlet UITableViewCell *meCell;

@end

@implementation MeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    self.meCell.backgroundColor = Tigrone_SchemeColor;
    self.view.backgroundColor = ColorWithRGB(239, 250, 254);
    
    [self.view layoutIfNeeded];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(-2, 0, 0, 0)];

    [self.personalButton.layer setMasksToBounds:YES];
    [self.personalButton.layer setCornerRadius:self.personalButton.frame.size.width * 0.5];
    [self.personalButton.layer setBorderWidth:2];
    [self.personalButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    [self.shoppingCartButton.layer setMasksToBounds:YES];
    [self.shoppingCartButton.layer setCornerRadius:self.shoppingCartButton.frame.size.width * 0.5];
    
    [self.orderButton.layer setMasksToBounds:YES];
    [self.orderButton.layer setCornerRadius:self.orderButton.frame.size.width * 0.5];
    
    [self.chooseCarButton.layer setMasksToBounds:YES];
    [self.chooseCarButton.layer setCornerRadius:self.chooseCarButton.frame.size.width * 0.5];
    
    [self.changePasswordButton.layer setMasksToBounds:YES];
    [self.changePasswordButton.layer setCornerRadius:self.changePasswordButton.frame.size.width * 0.5];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getPersonalInfoRequest];
}

#pragma mark - Button IBAction Methods
- (IBAction)userInfoBtnClicked:(id)sender
{
    if (!TIsLogin) {
        UIStoryboard *AuthStoryBoard    = [UIStoryboard storyboardWithName:@"AuthStoryboard" bundle:nil];
        LoginViewController *loginVC = [AuthStoryBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    UIStoryboard *MeStoryBoard    = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    SelfInfoViewController *selfVC = [MeStoryBoard instantiateViewControllerWithIdentifier:@"SelfInfoViewController"];
    [self.navigationController pushViewController:selfVC animated:YES];
}

- (IBAction)shoppingCartButtonClicked:(id)sender
{
    if (!TIsLogin) {
        UIStoryboard *AuthStoryBoard    = [UIStoryboard storyboardWithName:@"AuthStoryboard" bundle:nil];
        LoginViewController *loginVC = [AuthStoryBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    UIStoryboard *shoppingCar = [UIStoryboard storyboardWithName:@"ShoppingCart" bundle:nil];
    ShoppingCartViewController *shopVc = [shoppingCar instantiateViewControllerWithIdentifier:@"ShoppingNewCartViewController"];
    [self.navigationController pushViewController:shopVc animated:YES];
}

- (IBAction)chooseCarButtonClicked:(id)sender
{
    if (!TIsLogin) {
        UIStoryboard *AuthStoryBoard    = [UIStoryboard storyboardWithName:@"AuthStoryboard" bundle:nil];
        LoginViewController *loginVC = [AuthStoryBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    UIStoryboard *shoppingCar = [UIStoryboard storyboardWithName:@"FirstPage" bundle:nil];
    FirstPageViewContoller *firstVc = [shoppingCar instantiateViewControllerWithIdentifier:@"CarListViewController"];
    [self.navigationController pushViewController:firstVc animated:YES];
}

- (IBAction)orderButtonClicked:(id)sender
{
    if (!TIsLogin) {
        UIStoryboard *AuthStoryBoard    = [UIStoryboard storyboardWithName:@"AuthStoryboard" bundle:nil];
        LoginViewController *loginVC = [AuthStoryBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    UIStoryboard *MeStoryBoard    = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    OrderViewController *orderVC = [MeStoryBoard instantiateViewControllerWithIdentifier:@"OrderViewController"];
    [self.navigationController pushViewController:orderVC animated:YES];
}

- (IBAction)changePwdButtonClicked:(id)sender
{
    if (!TIsLogin) {
        UIStoryboard *AuthStoryBoard    = [UIStoryboard storyboardWithName:@"AuthStoryboard" bundle:nil];
        LoginViewController *loginVC = [AuthStoryBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    UIStoryboard *MeStoryBoard    = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    ChangePasswordViewController *changePwdVC = [MeStoryBoard instantiateViewControllerWithIdentifier:@"ChangePasswordViewController"];
    [self.navigationController pushViewController:changePwdVC animated:YES];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 1)
    {
        switch (indexPath.row) {
            case 0:
            {
                //我的评论
                if (!TIsLogin) {
                    UIStoryboard *AuthStoryBoard    = [UIStoryboard storyboardWithName:@"AuthStoryboard" bundle:nil];
                    LoginViewController *loginVC = [AuthStoryBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                    [self.navigationController pushViewController:loginVC animated:YES];
                    return;
                }
                
                UIStoryboard *MeStoryBoard    = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
                MyCommentViewController *meVC = [MeStoryBoard instantiateViewControllerWithIdentifier:@"MyCommentViewController"];
                [self.navigationController pushViewController:meVC animated:YES];
            }
                break;
            case 1:
            {
                //关于我们
                UIStoryboard *MeStoryBoard    = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
                AboutUsViewController *aboutVC = [MeStoryBoard instantiateViewControllerWithIdentifier:@"AboutUsViewController"];
                [self.navigationController pushViewController:aboutVC animated:YES];
            }
                break;
            case 2:
            {
                //退出登录
                [AuthRequests loginOutRequestWithBlock:^(NSString *retcode, NSString *retmessage, NSError *error)
                 {
                     [MyKeyChainHelper clearUserPasswordWithpsaawordKeyChain:KEY_PASSWORD];
                     Token = @"";
                     
                     UIStoryboard *AuthStoryBoard    = [UIStoryboard storyboardWithName:@"AuthStoryboard" bundle:nil];
                     LoginViewController *loginVC = [AuthStoryBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                     [self.navigationController pushViewController:loginVC animated:YES];
                 } paramDic:@{@"phone":PhoneNum,@"token":Token}];
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - reuquest
-(void)getPersonalInfoRequest
{
    //获取个人信息
//    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    [TigroneRequests getUserInformation:^(UserInfoModel *userModel, NSString *errorStr) {
//        [MBProgressHUD hideHUDForView:self.navigationController.view];
        if (!errorStr) {
            //获取成功
            _userModel = userModel;
            _userNameLab.text = [NSString stringWithFormat:@"用户名：%@",userModel.userName];
            
            if (![NSString isBlankString:userModel.userIcon]) {
                [_personalButton setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:[userModel.userIcon URLEncodedString]] placeholderImage:IMAGE(@"me_self_info")];
            }
        }
    } paramDic:@{@"phone":PhoneNum,
                 @"token":Token}];
}

@end

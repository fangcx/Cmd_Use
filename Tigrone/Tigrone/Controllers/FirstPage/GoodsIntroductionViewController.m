//
//  GoodsIntroductionViewController.m
//  Tigrone
//
//  Created by Mac on 15/12/28.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "GoodsIntroductionViewController.h"
#import "HMSegmentedControl.h"
#import "SelectRepairViewController.h"
#import "BookOrderViewController.h"
#import "LoginViewController.h"
#import "TigroneRequests.h"
#import "CartOperations.h"

@interface GoodsIntroductionViewController ()<SelectRepairShopDelegate>
{
    IBOutlet NSLayoutConstraint *contentHeigh;
}

@property(nonatomic, weak)IBOutlet HMSegmentedControl *segmentControl;
@property(nonatomic, weak)IBOutlet UIWebView *introductionView;
@property(nonatomic, weak)IBOutlet UIWebView *standardView;
@property(nonatomic, weak)IBOutlet UIWebView *billView;
@property(nonatomic, weak)IBOutlet UIWebView *serverView;

//@property(nonatomic, weak)IBOutlet UILabel *introductionLab;
//@property(nonatomic, weak)IBOutlet UILabel *serverLab;
//@property(nonatomic, weak)IBOutlet UILabel *statementLab;

@property(nonatomic, weak)IBOutlet UIButton *orderBtn;

@property(nonatomic, weak)IBOutlet UIView *editView;
@property(nonatomic, weak)IBOutlet UILabel *goodsNumLab;

@end

@implementation GoodsIntroductionViewController

//- (void)updateViewConstraints
//{
//    [super updateViewConstraints];
//    if (!_introductionView.isHidden)
//    {
//        CGFloat labHeigh = _introductionLab.frame.size.height;
//        contentHeigh.constant = 40 + labHeigh + 10 + 378;
//    }
//    else if (!_serverView.isHidden)
//    {
//        CGFloat serverHeigh = _serverLab.frame.size.height;
//        CGFloat statementHeigh = _statementLab.frame.size.height;
//        contentHeigh.constant = 215 + 21 + 10 + serverHeigh + 20 + statementHeigh + 40;
//    }
//    else
//    {
//        //显示的服务承诺
//        contentHeigh.constant = 180;
//    }
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商品详情";
    
    [_segmentControl setSectionTitles:@[@"商品介绍", @"规格参数", @"包装清单", @"售后服务"]];
    
    __weak typeof(self) weakSelf = self;
    [_segmentControl setIndexChangeBlock:^(NSInteger index) {
        
        switch (index) {
            case 0:
            {
                [weakSelf selectIntroductionView];
            }
                break;
            case 1:
            {
                [weakSelf selectStandardView];
            }
                break;
            case 2:
            {
                [weakSelf selectBillView];
            }
                break;
            case 3:
            {
                [weakSelf selectServerView];
            }
                break;
                
            default:
                break;
        }
        [self updateViewConstraints];
    }];
    _segmentControl.selectionIndicatorHeight = 2.0f;
    _segmentControl.backgroundColor = ColorWithRGB(239, 250, 255);
    _segmentControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:16]};
    _segmentControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : ColorWithHexValue(0x036eb7),NSFontAttributeName:[UIFont systemFontOfSize:16]};
    _segmentControl.selectionIndicatorColor = ColorWithHexValue(0x036eb7);
    
    _segmentControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
    _segmentControl.selectedSegmentIndex = 0;
    _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    
//    [self setLabTextColor:NSMakeRange(0, 5) rangeColor:ColorWithHexValue(0xf4a000) spacing:5 label:_introductionLab];
//    
//    [self setLabTextColor:NSMakeRange(0, 3) rangeColor:ColorWithHexValue(0x036eb7) spacing:5 label:_statementLab];
//    
//    
//    [self setLineSpacing:5 label:_serverLab];
    [self selectIntroductionView];
    
    [self showViewContent];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self getPersonalInfoRequest];
}

- (void)selectIntroductionView
{
    //商品介绍
    _introductionView.hidden = NO;
    _standardView.hidden = YES;
    _billView.hidden = YES;
    _serverView.hidden = YES;
}

- (void)selectStandardView
{
    //规格参数
    _introductionView.hidden = YES;
    _standardView.hidden = NO;
    _billView.hidden = YES;
    _serverView.hidden = YES;
}

- (void)selectBillView
{
    //包装清单
    _introductionView.hidden = YES;
    _standardView.hidden = YES;
    _billView.hidden = NO;
    _serverView.hidden = YES;
}

- (void)selectServerView
{
    //售后服务
    _introductionView.hidden = YES;
    _standardView.hidden = YES;
    _billView.hidden = YES;
    _serverView.hidden = NO;
}

//行间距
- (void)setLineSpacing:(CGFloat)spacing label:(UILabel *)label
{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:label.text];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:spacing];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [label.text length])];
    [label setAttributedText:attributedString];
}

- (void)setLabTextColor:(NSRange)range rangeColor:(UIColor *)color spacing:(CGFloat)spacing label:(UILabel *)label
{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:label.text];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:spacing];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [label.text length])];
    
    [label setAttributedText:attributedString];
}

- (void)showViewContent
{
//    if (_repairShop) {
//        [_orderBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
//    }
//    else
//    {
//        [_orderBtn setTitle:@"选择维修店" forState:UIControlStateNormal];
//    }
    
    [_introductionView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[_goodsModel.intr URLEncodedString]]]];
    [_standardView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[_goodsModel.parameters URLEncodedString]]]];
    [_billView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[_goodsModel.packageList URLEncodedString]]]];
    [_serverView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[_goodsModel.afterSales URLEncodedString]]]];
}

#pragma mark - button
//减数目
- (IBAction)minusBtnClip:(id)sender
{
    if (_goodsModel.goodsNum > 1) {
        _goodsModel.goodsNum --;
        _goodsNumLab.text = [NSString stringWithFormat:@"%ld",_goodsModel.goodsNum];
    }
    else
    {
        [MBProgressHUD showHUDAWhile:@"商品数目已经是最少了" toView:self.navigationController.view duration:1];
    }
}

//加数目
- (IBAction)addBtnClip:(id)sender
{
    if (_goodsModel.maxValue > 0) {
        if (_goodsModel.goodsNum >= _goodsModel.maxValue) {
            [MBProgressHUD showHUDAWhile:@"商品数量已达上限" toView:self.navigationController.view duration:1];
            return;
        }
    }
    
    _goodsModel.goodsNum ++;
    _goodsNumLab.text = [NSString stringWithFormat:@"%ld",_goodsModel.goodsNum];
}

- (IBAction)oderBtnClip:(id)sender
{
    if (!TIsLogin) {
        UIStoryboard *AuthStoryBoard    = [UIStoryboard storyboardWithName:@"AuthStoryboard" bundle:nil];
        LoginViewController *loginVC = [AuthStoryBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    
    BOOL isAddSuccess = [CartOperations insertGoodsToCart:self.goodsModel];
    
    if (isAddSuccess) {
        [MBProgressHUD showHUDAWhile:@"加入购车成功" toView:self.navigationController.view duration:1];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [MBProgressHUD showHUDAWhile:@"加入购车失败" toView:self.navigationController.view duration:1];
    }
    
//    if (_repairShop) {
//        //预约订单
//        UIStoryboard *firstStoryBoard = [UIStoryboard storyboardWithName:@"FirstPage" bundle:nil];
//        BookOrderViewController *bookVc = [firstStoryBoard instantiateViewControllerWithIdentifier:@"BookOrderViewController"];
//        bookVc.goodsModel = self.goodsModel;
//        bookVc.repairShop = self.repairShop;
//        [self.navigationController pushViewController:bookVc animated:YES];
//    }
//    else
//    {
//        //选择服务店
//        UIStoryboard *firstStoryBoard = [UIStoryboard storyboardWithName:@"FirstPage" bundle:nil];
//        SelectRepairViewController *selectRepairVc = [firstStoryBoard instantiateViewControllerWithIdentifier:@"SelectRepairViewController"];
//        selectRepairVc.selectModel = _repairShop;
//        selectRepairVc.delegate = self;
//        [self.navigationController pushViewController:selectRepairVc animated:YES];
//    }
}

//- (void)getPersonalInfoRequest
//{
//    [TigroneRequests getUserInformation:^(UserInfoModel *userModel, NSString *errorStr) {
//        if (!errorStr) {
//            //获取成功
//            if (userModel && ![NSString isBlankString:userModel.shopId]) {
//                if (!_repairShop) {
//                    _repairShop = [[RepairShopModel alloc] init];
//                }
//                _repairShop.shopId = userModel.shopId;
//                _repairShop.shopName = userModel.shopName;
//                _repairShop.shopAddr = userModel.shopAddr;
//                [_orderBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
//            }
//        }
//    } paramDic:@{@"phone":PhoneNum,
//                 @"token":Token}];
//}

#pragma mark - SelectRepairShopDelegate
- (void)didSelectRepairShop:(RepairShopModel *)model
{
//    if (model) {
//        _repairShop = model;
//        [_orderBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
//    }
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

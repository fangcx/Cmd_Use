//
//  MaintainPointViewController.m
//  Tigrone
//
//  Created by 张亮 on 15/12/27.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "RepairPointViewController.h"
#import "DYRateView.h"
#import "NSString+Tigrone.h"
#import "TigroneRequests.h"
#import "OrderViewController.h"

@interface RepairPointViewController () <UITextViewDelegate,DYRateViewDelegate>
{
    NSUInteger serverScore;
    NSUInteger skillScore;
    NSUInteger envirScore;
}

@property (weak, nonatomic) IBOutlet UILabel *mCommentLabel;
@property (weak, nonatomic) IBOutlet UITextView *mCommentTextView;

@property (weak, nonatomic) IBOutlet DYRateView *starView1;
@property (weak, nonatomic) IBOutlet DYRateView *starView2;
@property (weak, nonatomic) IBOutlet DYRateView *starView3;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *shopLab;
@property (weak, nonatomic) IBOutlet UILabel *shopAddr;

@end

@implementation RepairPointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的评论";
    self.view.backgroundColor = ColorWithRGB(239, 250, 254);
    self.mCommentTextView.delegate = self;
    
    self.starView1.padding = 5;
    self.starView2.alignment = RateViewAlignmentLeft;
    self.starView1.editable = YES;
    [self.starView1 setRate:0];
    self.starView1.delegate = self;
    
    self.starView2.padding = 5;
    self.starView2.alignment = RateViewAlignmentLeft;
    self.starView2.editable = YES;
    [self.starView2 setRate:0];
    self.starView2.delegate = self;
    
    self.starView3.padding = 5;
    self.starView3.alignment = RateViewAlignmentLeft;
    self.starView3.editable = YES;
    [self.starView3 setRate:0];
    self.starView3.delegate = self;
    
    _timeLab.text = _orderModel.reDate;
    _shopLab.text = _orderModel.shopName;
    _shopAddr.text = _orderModel.shopAddr;
    
    serverScore = 0;
    skillScore = 0;
    envirScore = 0;
}

#pragma mark - uibutton
- (IBAction)backgroundTap
{
    [self.mCommentTextView resignFirstResponder];
}

- (IBAction)submitBtnClip:(id)sender
{
    if ([NSString isBlankString:_mCommentTextView.text]) {
        [MBProgressHUD showHUDAWhile:@"请输入评论内容" toView:self.navigationController.view duration:1];
        return;
    }
    //提交评论
    [self submitCommentReqeust];
}

#pragma mark -delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (![text isEqualToString:@""]) {
        self.mCommentLabel.hidden = YES;
    }
    
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
        self.mCommentLabel.hidden = NO;
    }
    
    return YES;
}

//RateDelegate
- (void)rateView:(DYRateView *)rateView changedToNewRate:(NSNumber *)rate
{
    if (rateView == _starView1) {
        //服务
        serverScore = [rate integerValue];
    }
    else if (rateView == _starView2)
    {
        //技术
        skillScore = [rate integerValue];
    }
    else
    {
        //环境
        envirScore = [rate integerValue];
    }
}

#pragma mark -request
- (void)submitCommentReqeust
{
    NSDictionary *commentDic = @{@"contextShop":_mCommentTextView.text,
                                 @"contextSku":_commentStr,
                                 @"score":@(serverScore),
                                 @"score1":@(serverScore),
                                 @"score2":@(skillScore),
                                 @"score3":@(envirScore),
                                 @"score4":@(_goodScore),
                                 @"scoreShop":@(_goodScore),
                                 @"shopId":_orderModel.shopId,
                                 @"skuId":_orderModel.skuId,
                                 @"title":@"评论",
                                 @"tradeId":_orderModel.tradeNO,
                                 @"userId":TUserId};
    
    NSString *commentStr = [NSString getJsonStringWith:commentDic];
    if ([NSString isBlankString:commentStr]) {
        commentStr = @"";
    }
    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    [TigroneRequests submitCommitWithBlock:^(NSString *errorStr,BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        [MBProgressHUD showHUDAWhile:errorStr toView:self.navigationController.view duration:1];
        if (isSuccess) {
            //评论成功
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[OrderViewController class]]) {
                    OrderViewController *orderVc = (OrderViewController *)vc;
                    [self.navigationController popToViewController:orderVc animated:YES];
                    break;
                }
            }
        }
    } paramDic:@{@"phone":PhoneNum,
                 @"token":Token,
                 @"comment":commentStr}];
}

@end

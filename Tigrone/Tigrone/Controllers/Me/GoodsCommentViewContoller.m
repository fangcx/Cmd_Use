//
//  GoodsCommentViewContoller.m
//  Tigrone
//
//  Created by ZhangGang on 15/12/27.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "GoodsCommentViewContoller.h"
#import "DYRateView.h"
#import "NSString+Tigrone.h"
#import "RepairPointViewController.h"

@interface GoodsCommentViewContoller () <UITextViewDelegate,DYRateViewDelegate>
{
    NSUInteger commentScore;
}

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet DYRateView *goodsStarView;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *goodsLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@end

@implementation GoodsCommentViewContoller

- (void)viewDidLoad
{
    self.title = @"我的评论";
    
    self.view.backgroundColor = ColorWithRGB(239, 250, 254);
    self.commentTextView.delegate = self;
    
    self.goodsStarView.padding = 5;
    self.goodsStarView.alignment = RateViewAlignmentLeft;
    self.goodsStarView.editable = YES;
    self.goodsStarView.delegate = self;
    [self.goodsStarView setRate:0];
    
    commentScore = 0;
    _timeLab.text = _orderModel.reDate;
    _goodsLab.text = _orderModel.skuName;
    _priceLab.text = [NSString stringWithFormat:@"￥%@",_orderModel.priceStr];
}

#pragma mark - uibutton
- (IBAction)backgroundTap
{
    [self.commentTextView resignFirstResponder];
}

- (IBAction)nextBtnClip:(id)sender
{
    if ([NSString isBlankString:_commentTextView.text]) {
        [MBProgressHUD showHUDAWhile:@"请输入评论内容" toView:self.navigationController.view duration:1];
        return;
    }
    
    //去下一层评论
    UIStoryboard *meBoard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    RepairPointViewController *commentVc = [meBoard instantiateViewControllerWithIdentifier:@"RepairPointViewController"];
    commentVc.orderModel = self.orderModel;
    commentVc.commentStr = _commentTextView.text;
    commentVc.goodScore = commentScore;
    [self.navigationController pushViewController:commentVc animated:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (![text isEqualToString:@""]) {
        self.commentLabel.hidden = YES;
    }
    
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
        self.commentLabel.hidden = NO;
    }
    
    return YES;
}

- (void)rateView:(DYRateView *)rateView changedToNewRate:(NSNumber *)rate
{
    //打分的分数
    commentScore = [rate integerValue];
}

@end

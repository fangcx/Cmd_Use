
//
//  ShopGoodsQuanlityCell.m
//  Tigrone
//
//  Created by 张刚 on 15/12/29.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "ShopGoodsQuanlityCell.h"
#import "DYRateView.h"
@interface ShopGoodsQuanlityCell()
@property (weak, nonatomic) IBOutlet UIImageView *commentAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *attitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *techLabel;
@property (weak, nonatomic) IBOutlet UILabel *environmentLabel;

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@end

@implementation ShopGoodsQuanlityCell

- (void)setModel:(ShopCommentModel *)model
{
    _model = model;
    
    //星星控件
    self.commentRateView.padding = 1;
    self.commentRateView.alignment = RateViewAlignmentLeft;
    self.commentRateView.editable = NO;
    [self.commentRateView setRate:[model.commentScore floatValue]];
    self.commentRateView.backgroundColor = [UIColor clearColor];
    
    _nameLabel.text = model.commentTitle;
    _timeLabel.text = @"";
    _attitudeLabel.text = model.serverScore;
    _techLabel.text = model.skillScore;
    _environmentLabel.text = model.enviScore;
    _commentLabel.text = model.commentContent;
}

@end

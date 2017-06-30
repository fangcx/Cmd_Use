//
//  ShoppingNewCartCell.m
//  Tigrone
//
//  Created by Mac on 16/6/27.
//  Copyright © 2016年 iOS Team. All rights reserved.
//

#import "ShoppingNewCartCell.h"
#import "CommonMacro.h"

@implementation ShoppingNewCartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setGoodsModel:(GoodsModel *)goodsModel
{
    _goodsModel = goodsModel;
    self.nameLab.text = goodsModel.goodsName;
    self.desLab.text = goodsModel.goodsDec;
    self.priceLab.text = [NSString stringWithFormat:@"￥%@",goodsModel.goodsPrice];
    self.numberLab.text = [NSString stringWithFormat:@"X%ld",goodsModel.goodsNum];
    self.totalLab.text = [NSString stringWithFormat:@"%ld",goodsModel.goodsNum];
    
    if (goodsModel.isSelected) {
        [self.leftBtn setImage:IMAGE(@"bill_button_select") forState:UIControlStateNormal];
    }
    else
    {
        [self.leftBtn setImage:IMAGE(@"bill_btn_normal") forState:UIControlStateNormal];
    }
}

#pragma mark - uibutton

- (IBAction)leftBtnClip:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(goodsDidSelected:cell:)]) {
        [_delegate goodsDidSelected:sender cell:self];
    }
}

- (IBAction)minusBtnClip:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(goodsDidMinus:cell:)]) {
        [_delegate goodsDidMinus:sender cell:self];
    }
}

- (IBAction)addBtnClip:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(goodsDidAdd:cell:)]) {
        [_delegate goodsDidAdd:sender cell:self];
    }
}

- (IBAction)deleteBtnClip:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(goodsDidDeleted:cell:)]) {
        [_delegate goodsDidDeleted:sender cell:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

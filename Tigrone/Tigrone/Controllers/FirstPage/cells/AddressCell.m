//
//  AddressCell.m
//  Tigrone
//
//  Created by fangchengxiang on 2017/6/22.
//  Copyright © 2017年 iOS Team. All rights reserved.
//

#import "AddressCell.h"

@implementation AddressCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setAddressModel:(AddressModel *)addressModel
{
    _addressModel = addressModel;
    self.defalutLab.hidden = YES;
    if (addressModel) {
        self.nameLab.text = addressModel.name;
        self.phoneLab.text = addressModel.phone;
        self.addressLab.text = [NSString stringWithFormat:@"%@%@%@",addressModel.province,addressModel.city,addressModel.detailAddr];
        if ([addressModel.province isEqualToString:addressModel.city]) {
            self.addressLab.text = [NSString stringWithFormat:@"%@%@",addressModel.city,addressModel.detailAddr];
        }
        
        if (addressModel.isDefault) {
            self.defalutLab.hidden = NO;
        }
    }
}

- (IBAction)editBtnClip:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(tapEditBtn:cell:)]) {
        [_delegate tapEditBtn:sender cell:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

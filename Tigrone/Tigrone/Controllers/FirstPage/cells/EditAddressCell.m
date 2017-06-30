//
//  EditAddressCell.m
//  Tigrone
//
//  Created by fangchengxiang on 2017/6/22.
//  Copyright © 2017年 iOS Team. All rights reserved.
//

#import "EditAddressCell.h"

@implementation EditAddressCell

- (void)awakeFromNib {
    // Initialization code
}


#pragma mark - uitextfieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (_delegate && [_delegate respondsToSelector:@selector(rightFieldStart:)]) {
        [_delegate rightFieldStart:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (_delegate && [_delegate respondsToSelector:@selector(rightTextDidChanged:text:)]) {
        [_delegate rightTextDidChanged:textField text:str];
    }
    
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

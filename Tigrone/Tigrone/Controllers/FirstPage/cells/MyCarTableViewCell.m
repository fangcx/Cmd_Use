//
//  MyCarTableViewCell.m
//  Tigrone
//
//  Created by 张蒙蒙 on 15/12/26.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "MyCarTableViewCell.h"
#import "CarModel.h"
#import "UIImageView+Icon.h"

@implementation MyCarTableViewCell

-(void)setContentWithCarModelModel:(CarModel*)model withIndex:(NSInteger)index
{
    [_logoImageView setCarLogoWithUrlSting:model.carIcon placeholderImage:[UIImage imageNamed:@"main_defaultCarIcon"]];
    _titleLab.text = model.allName;
    _selectBtn.selected = model.isActive;
    _selectBtn.tag = index;
}

- (IBAction)clickSelectBtn:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectMyCarWithIndex:)])
    {
        [_delegate selectMyCarWithIndex:btn.tag];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

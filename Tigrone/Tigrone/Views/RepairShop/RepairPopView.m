//
//  RepairPopView.m
//  Tigrone
//
//  Created by Mac on 15/12/25.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "RepairPopView.h"
#import "CommonMacro.h"

@implementation RepairPopView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"main_map_nav_bg"]];
        [self addSubview:imageView];
        
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 205, 14)];
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.font = [UIFont systemFontOfSize:14];
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_titleLab];
        
        _subTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 36, 205, 12)];
        _subTitleLab.backgroundColor = [UIColor clearColor];
        _subTitleLab.font = [UIFont systemFontOfSize:12];
        _subTitleLab.textColor = [UIColor whiteColor];
        _subTitleLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_subTitleLab];
        
        _navBtn = [[UIButton alloc]initWithFrame:CGRectMake(220, 0, 70, 63)];
        [_navBtn setBackgroundColor:ColorWithHexValue(0xf4a000)];
        [_navBtn.titleLabel setFont:[UIFont systemFontOfSize:28]];
        [_navBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_navBtn setTitle:@"导航" forState:UIControlStateNormal];
        _navBtn.titleLabel.numberOfLines = 0;
        [self addSubview:_navBtn];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

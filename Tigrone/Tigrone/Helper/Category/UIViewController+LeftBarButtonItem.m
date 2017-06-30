//
//  UIViewController+LeftBarButtonItem.m
//  Tigrone
//
//  Created by 张蒙蒙 on 16/1/11.
//  Copyright © 2016年 iOS Team. All rights reserved.
//

#import "UIViewController+LeftBarButtonItem.h"

@implementation UIViewController (LeftBarButtonItem)

- (void)setLeftNavigationBarButtonItemWithAction:(SEL)action
{
    UIButton* leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 12, 20)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"doctor_back.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

@end

//
//  PhoneNumberViewController.m
//  Tigrone
//
//  Created by 张亮 on 15/12/25.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "PhoneNumberViewController.h"

@interface PhoneNumberViewController ()

@property (nonatomic, weak)IBOutlet UILabel *phoneLab;

@end

@implementation PhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"手机";
    self.view.backgroundColor = ColorWithRGB(239, 250, 254);
    
    NSString *preThree = [PhoneNum substringToIndex:3];
    NSString *endFour = [PhoneNum substringFromIndex:7];
    _phoneLab.text = [NSString stringWithFormat:@"%@****%@",preThree,endFour];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

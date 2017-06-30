//
//  SettingViewController.m
//  Tigrone
//
//  Created by 张亮 on 15/12/19.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "SettingViewController.h"
#import "MBProgressHUD+Tigrone.h"
#import "CommonMacro.h"

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UILabel *versionNumberLabel;
@property (weak, nonatomic) IBOutlet UISwitch *pushSwitch;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"系统设置";
    self.view.backgroundColor = ColorWithRGB(239, 250, 254);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  UserAgreementViewController.m
//  Tigrone
//
//  Created by 张蒙蒙 on 15/12/23.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "UserAgreementViewController.h"

@interface UserAgreementViewController ()

@property (nonatomic, strong)IBOutlet UIWebView *webView;

@end

@implementation UserAgreementViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    self.title = @"用户协议";
    
    self.view.backgroundColor  = ColorWithHexValue(0Xf3fbfe);
    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"userAgreement" ofType:@"docx"];
//    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://120.55.160.23/web/agreed"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

//
//  ImageDetailViewController.m
//  Tigrone
//
//  Created by Mac on 16/3/7.
//  Copyright © 2016年 iOS Team. All rights reserved.
//

#import "ImageDetailViewController.h"
#import "NSString+Tigrone.h"

@interface ImageDetailViewController ()

@property(nonatomic, weak)IBOutlet UIWebView *imgWebView;

@end

@implementation ImageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"图文详情";
    
    if (![NSString isBlankString:self.htmlUrl]) {
        [self.imgWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self.htmlUrl URLEncodedString]]]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

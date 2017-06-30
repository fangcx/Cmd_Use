//
//  MaintainPointViewController.m
//  Tigrone
//
//  Created by 张亮 on 15/12/27.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "MaintainPointViewController.h"

@interface MaintainPointViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *mCommentLabel;
@property (weak, nonatomic) IBOutlet UITextView *mCommentTextView;

@end

@implementation MaintainPointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ColorWithRGB(239, 250, 254);
    self.mCommentTextView.delegate = self;
}

- (IBAction)backgroundTap
{
    [self.mCommentTextView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (![text isEqualToString:@""]) {
        self.mCommentLabel.hidden = YES;
    }
    
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
        self.mCommentLabel.hidden = NO;
    }
    
    return YES;
}

@end

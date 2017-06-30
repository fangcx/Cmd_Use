//
//  YGuideView.m
//  Fruit
//
//  Created by fangchengxiang on 15/5/12.
//  Copyright (c) 2015年 Fruit. All rights reserved.
//

#import "YGuideView.h"
#import "CommonMacro.h"

@interface YGuideView()
{
    NSUInteger _currentPage;
    NSTimer *_imgTimer;
}

@end

@implementation YGuideView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _currentPage = 0;
        _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setPagingEnabled:YES];
        _scrollView.delegate = self;
        [_scrollView setContentSize:CGSizeMake(kMainScreenWidth*3, 0)];
        _scrollView.backgroundColor=[UIColor clearColor];
        [self addSubview:_scrollView];
        for (int i = 0; i<3; i++)
        {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kMainScreenWidth*i,0,kMainScreenWidth, kMainScreenHeight)];
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"common_welcome_%d.png",i+1]];
            [_scrollView addSubview:imageView];
        }
        [self startImagesTimer];
    }
    return self;
}

- (void)startImagesTimer
{
    if (_imgTimer) {
        [_imgTimer invalidate];
        _imgTimer = nil;
    }
    
    _imgTimer = [NSTimer timerWithTimeInterval:3.0
                                       target:self
                                     selector:@selector(imagesChanged)
                                     userInfo:nil
                                      repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_imgTimer forMode:NSRunLoopCommonModes];
}

- (void)imagesChanged
{
    if (_currentPage >= 3) {
        [self removeGuideView];
    }
    else
    {
        _currentPage ++;
        
    }
    [_scrollView setContentOffset:CGPointMake(kMainScreenWidth*_currentPage, 0) animated:YES];
}

- (void)stopImagesTimer
{
    if (_imgTimer) {
        [_imgTimer invalidate];
        _imgTimer = nil;
    }
}

-(void)removeGuideView
{
    [self stopImagesTimer];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:FIRST_USER_NO];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [UIView animateWithDuration:0.5f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn animations:^{
                            self.alpha = 0.6f;
                            CGRect selfFrame = self.frame;
                            selfFrame.origin.x = -kMainScreenWidth;
                            self.frame = selfFrame;
                        } completion:^(BOOL finished) {
                            
                            [self removeFromSuperview];
                        }];
    
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
    
}

-(void)scrollViewDidScroll:(UIScrollView*)ascrollView
{
    CGFloat pageWidth = ascrollView.frame.size.width;
    _currentPage = floor((ascrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    CGFloat offsetX = ascrollView.contentOffset.x;
    if (offsetX > (pageWidth*2 +pageWidth/6)) {
        [self removeGuideView];
    }
}

@end

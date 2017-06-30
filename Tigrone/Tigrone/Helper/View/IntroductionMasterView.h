//
//  IntroductionMasterView.h
//  Damon
//
//  Created by Zhang Gang on 11/6/14.
//  Copyright (c) 2014 Razorfish WH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IntroductionMasterView;
@protocol IntroductionViewDelegate <NSObject>

- (void)introductionViewDidShow:(IntroductionMasterView *)view;

@end

@interface IntroductionMasterView : UIView

@property(nonatomic, strong)UIScrollView  *masterScrollView;
@property(nonatomic, strong)UIPageControl *pageControl;
@property(nonatomic, strong)UIButton      *skipButton;
@property(nonatomic, strong)UIButton      *experienceButton;
@property(nonatomic, assign)NSUInteger     currentPanelIndex;

@property(nonatomic, weak)id <IntroductionViewDelegate>delegate;

@end

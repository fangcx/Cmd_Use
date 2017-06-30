//
//  IntroductionMasterView.m
//  Damon
//
//  Created by Zhang Gang on 11/6/14.
//  Copyright (c) 2014 Razorfish WH. All rights reserved.
//

#import "IntroductionMasterView.h"
#import "IntroductionPanelView.h"
#import "CoreUtils.h"

static const CGFloat kPageControlWidth = 148;
static const CGFloat kLeftRightSkipPadding = 10;

@interface IntroductionMasterView ()<UIScrollViewDelegate>

@property(nonatomic, strong)NSArray *panelArray;

@end

@implementation IntroductionMasterView

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        [self initializeViewComponents];
    }
    return self;
}

- (void)dealloc
{
    self.masterScrollView.delegate = nil;
}

#pragma mark - Initializes Methods
-(void)initializeViewComponents
{
    //Master Scroll View
    self.masterScrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    self.masterScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.masterScrollView.pagingEnabled = YES;
    self.masterScrollView.delegate = self;
    self.masterScrollView.showsHorizontalScrollIndicator = NO;
    self.masterScrollView.showsVerticalScrollIndicator = NO;
    self.masterScrollView.bounces = NO;
    [self addSubview:self.masterScrollView];
    
    //Page Control
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((self.frame.size.width - kPageControlWidth)/2, self.frame.size.height - 48, kPageControlWidth, 37)];
    self.pageControl.currentPage = 0;
    self.pageControl.enabled = NO;
    [self addSubview:self.pageControl];
    
    //Get skipString dimensions
    NSString *skipString = NSLocalizedString(@"Skip", nil);
    CGFloat skipStringWidth = 0;
    UIFont *kSkipButtonFont = [UIFont systemFontOfSize:16];
    
    //Get skipString length
    NSDictionary *titleAttributes = [NSDictionary dictionaryWithObject:kSkipButtonFont forKey: NSFontAttributeName];
    skipStringWidth = [skipString boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleAttributes context:nil].size.width;
    skipStringWidth = ceilf(skipStringWidth);
    
    //Skip Button
    self.skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.skipButton.frame = CGRectMake(self.frame.size.width - skipStringWidth - kLeftRightSkipPadding, self.frame.size.height - 48, skipStringWidth, 37);
    [self.skipButton.titleLabel setFont:kSkipButtonFont];
    [self.skipButton setTitle:skipString forState:UIControlStateNormal];
    [self.skipButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.skipButton addTarget:self action:@selector(didPressSkipButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.skipButton];
    
    //Get experienceString dimensions
    NSString *experienceString = NSLocalizedString(@"Experience Now", nil);
    CGFloat  experienceWidth = 0;
    UIFont *kExperienceFont = [UIFont systemFontOfSize:16];
    
    //Get experienceString length
    NSDictionary *ExpAttributes = [NSDictionary dictionaryWithObject:kExperienceFont forKey:NSFontAttributeName];
    experienceWidth = [experienceString boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:ExpAttributes context:nil].size.width;
    experienceWidth = ceilf(experienceWidth);
    
    //Experience Button
    self.experienceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.experienceButton.frame = CGRectMake( (self.frame.size.width - experienceWidth)/2,self.frame.size.height - 48 - 37 -10, experienceWidth, 37);
    [self.experienceButton.titleLabel setFont:kExperienceFont];
    [self.experienceButton setTitle:experienceString forState:UIControlStateNormal];
    [self.experienceButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.experienceButton addTarget:self action:@selector(didPressExperienceButton) forControlEvents:UIControlEventTouchUpInside];
    
    //Build Introduction Panel
    IntroductionPanelView *panelViewFirst = [[IntroductionPanelView alloc] initWithFrame:self.frame image:[UIImage imageNamed:@"Intro_bg"]];
    UILabel *labelFirst = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2.5, self.frame.size.width, 20)];
    [labelFirst setTextAlignment:NSTextAlignmentCenter];
    [labelFirst setText:@"第一次看到我们?"];
    [labelFirst setTextColor:[UIColor lightGrayColor]];
    [panelViewFirst addSubview:labelFirst];
    
    
    IntroductionPanelView *panelViewSec   = [[IntroductionPanelView alloc] initWithFrame:self.frame image:[UIImage imageNamed:@"Intro_bg"]];
    UILabel *labelSec = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2.5, self.frame.size.width, 20)];
    [labelSec setTextAlignment:NSTextAlignmentCenter];
    [labelSec setText:@"知道我们的新技能吗？"];
    [labelSec setTextColor:[UIColor lightGrayColor]];
    [panelViewSec addSubview:labelSec];
    
    IntroductionPanelView *panelViewThree   = [[IntroductionPanelView alloc] initWithFrame:self.frame image:[UIImage imageNamed:@"Intro_bg"]];
    UILabel *labelThree = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2.5, self.frame.size.width, 20)];
    [labelThree setTextAlignment:NSTextAlignmentCenter];
    [labelThree setText:@"从这里开始"];
    [labelThree setTextColor:[UIColor lightGrayColor]];
    [panelViewThree addSubview:labelThree];
    
    [panelViewThree addSubview:self.experienceButton];
    [self buildIntroductionWithPanels:@[panelViewFirst,panelViewSec,panelViewThree]];
}

-(void)buildIntroductionWithPanels:(NSArray *)panels
{
    NSAssert(panels.count > 0, @"introductino View  without  Pannels !");
    
    self.panelArray = panels;
    
    //Set page control number of pages
    self.pageControl.numberOfPages = self.panelArray.count;
    
    CGFloat panelXOffset = 0;
    for (IntroductionPanelView *panelView in self.panelArray)
    {
        panelView.frame = CGRectMake(panelXOffset, 0, self.frame.size.width, self.frame.size.height);
        [self.masterScrollView addSubview:panelView];
        
        //Update panelXOffset to next view origin location
        panelXOffset += panelView.frame.size.width;
    }
    
    [self appendCloseViewAtXIndex:&panelXOffset];
    
    [self.masterScrollView setContentSize:CGSizeMake(panelXOffset, self.frame.size.height)];
}

-(void)appendCloseViewAtXIndex:(CGFloat*)xIndex
{
    UIView *closeView = [[UIView alloc] initWithFrame:CGRectMake(*xIndex, 0, self.frame.size.width, self.frame.size.height)];
    
    closeView.backgroundColor = [UIColor clearColor];
    
    [self.masterScrollView addSubview:closeView];
    
    *xIndex += self.masterScrollView.frame.size.width;
}

#pragma mark - Interaction Methods
- (void)didPressSkipButton
{
    [self hideWithFadeOutDuration:0.3f];
}

- (void)didPressExperienceButton
{
    [self hideWithFadeOutDuration:0.3f];
}

-(void)hideWithFadeOutDuration:(CGFloat)duration
{
    //Fade out
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished)
    {
        if (finished)
        {
            [self leaveIntroductionView];
        }
        
    }];
}

- (void)leaveIntroductionView
{
//    [UserDefaultsUtils saveBoolValue:YES withKey:NOT_FIRST_USE];
    if (self.delegate && [self.delegate respondsToSelector:@selector(introductionViewDidShow:)]) {
        
        [self.delegate introductionViewDidShow:self];
    }
    [self removeFromSuperview];
}

#pragma mark - UIScrollView Delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.masterScrollView.frame.size.width;
    self.currentPanelIndex = floor((self.masterScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if (self.currentPanelIndex == self.panelArray.count)
    {
        [self leaveIntroductionView];
    }
}

//This will handle our changing opacity at the end of the introduction
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.masterScrollView.frame.size.width;
    self.currentPanelIndex = floor((self.masterScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    //Update Page Control
    self.pageControl.currentPage = self.currentPanelIndex;
    
    if (self.currentPanelIndex == (self.panelArray.count - 1))
    {
        self.alpha = ((self.masterScrollView.frame.size.width*(float)self.panelArray.count)-self.masterScrollView.contentOffset.x)/self.masterScrollView.frame.size.width;
    }
    
    if (self.currentPanelIndex >= (self.panelArray.count - 1))
    {
        self.skipButton.hidden = YES;
    }
    else
    {
        self.skipButton.hidden = NO;
    }
    
}

@end

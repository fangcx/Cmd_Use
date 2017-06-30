//
//  IntroductionPanelView.m
//  Damon
//
//  Created by Zhang Gang on 11/6/14.
//  Copyright (c) 2014 Razorfish WH. All rights reserved.
//

#import "IntroductionPanelView.h"

@interface IntroductionPanelView ()

@property(nonatomic, strong)UIImage *backgroundImage;

@end

@implementation IntroductionPanelView

-(id)initWithFrame:(CGRect)frame image:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundImage = image;
        [self initializeConstants];
    }
    return self;
}

-(void)initializeConstants
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.backgroundImage];
    imageView.frame = self.frame;
    
    [self addSubview:imageView];
}

@end

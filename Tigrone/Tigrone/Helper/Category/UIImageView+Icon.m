//
//  UIImageView+Icon.m
//  Tigrone
//
//  Created by 张刚 on 16/1/4.
//  Copyright © 2016年 iOS Team. All rights reserved.
//

#import "UIImageView+Icon.h"
#import "UIImageView+WebCache.h"
@implementation UIImageView (Icon)

- (void)setCarLogoWithUrlSting:(NSString *)urlString placeholderImage:(UIImage *)placeholder
{
    [self sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:placeholder];
}

@end

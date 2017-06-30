//
//  EditBillViewController.h
//  Tigrone
//
//  Created by fangchengxiang on 2017/6/24.
//  Copyright © 2017年 iOS Team. All rights reserved.
//

#import "BaseViewContoller.h"

@protocol EditBillViewDelegate <NSObject>

- (void)getBillTitle:(NSString *)billTitle;

@end

@interface EditBillViewController : BaseViewContoller

@property (nonatomic, strong)NSString *billTitle;

@property(nonatomic, assign)id<EditBillViewDelegate>delegate;

@end

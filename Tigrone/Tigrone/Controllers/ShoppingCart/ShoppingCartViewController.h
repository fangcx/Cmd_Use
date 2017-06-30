//
//  ShoppingCartViewController.h
//  Tigrone
//
//  Created by ZhangGang on 15/11/13.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "BaseViewContoller.h"

@interface ShoppingCartViewController : BaseViewContoller<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *shoppingTabeleView;

@end

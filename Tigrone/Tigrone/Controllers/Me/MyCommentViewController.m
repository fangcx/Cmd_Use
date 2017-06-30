//
//  MyCommentViewController.m
//  Tigrone
//
//  Created by 张刚 on 15/12/21.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "MyCommentViewController.h"
#import "MyCommentTableViewCell.h"
#import "TigroneRequests.h"
#import "MyCommentModel.h"

@interface MyCommentViewController() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray *commentArr;
@property (weak, nonatomic) IBOutlet UITableView *myCommentTableView;

@end

@implementation MyCommentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的评论";
    
    _commentArr = [[NSMutableArray alloc] init];
    self.view.backgroundColor = ColorWithRGB(239, 250, 254);
    self.myCommentTableView.showsVerticalScrollIndicator = NO;
    
    [self getUserCommentRequest];
}

- (void)dealloc
{
    DDLogInfo(@"________   MyCommentViewController dealloced");
}

#pragma mark - TableView DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _commentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myComment"];
    
    MyCommentModel *model = _commentArr[indexPath.row];
    
    cell.commentImageView.image = [UIImage imageNamed:@"common_main_icon_off"];
    cell.repairShopLabel.text = model.commentName;
    cell.commentLabel.text = model.commentContent;
    
    cell.commentStarView.padding = 5;
    cell.commentStarView.alignment = RateViewAlignmentLeft;
    cell.commentStarView.editable = NO;
    [cell.commentStarView setRate:[model.commentScore floatValue]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

#pragma mark -request
- (void)getUserCommentRequest
{
    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    [TigroneRequests getUserCommentListWithBlock:^(NSArray *resultArr, NSString *errorStr) {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        if (errorStr) {
            [MBProgressHUD showHUDAWhile:errorStr toView:self.navigationController.view duration:1];
        }
        else
        {
            //获取评论成功
            [_commentArr removeAllObjects];
            [_commentArr addObjectsFromArray:resultArr];
            [_myCommentTableView reloadData];
        }
    } paramDic:@{@"phone":PhoneNum,
                 @"token":Token}];
}

@end

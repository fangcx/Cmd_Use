//
//  GoodsDetailViewController.m
//  Tigrone
//
//  Created by Mac on 15/12/23.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "GoodsDetailViewController.h"
#import "HMSegmentedControl.h"
#import "GoodsCommentCell.h"
#import "GoodsIntroductionViewController.h"
#import "SelectRepairViewController.h"
#import "BookOrderViewController.h"
#import "RepairShopModel.h"
#import "TigroneRequests.h"
#import "GoodsCommentModel.h"
#import "UIImageView+WebCache.h"
#import "LoginViewController.h"
#import "CartOperations.h"

@interface GoodsDetailViewController ()<SelectRepairShopDelegate,UIScrollViewDelegate>
{
    IBOutlet NSLayoutConstraint *commentHeigh;
    IBOutlet NSLayoutConstraint *contentHeigh;
    
//    RepairShopModel *repairModel;
    NSUInteger _currentPage;
    NSUInteger _totalNum;
    NSTimer *_adTimer;
}

@property(nonatomic, weak)IBOutlet UIPageControl *pageControl;
@property(nonatomic, weak)IBOutlet UIScrollView *imgScrollView;
@property(nonatomic, weak)IBOutlet UILabel *suitLab;
@property(nonatomic, weak)IBOutlet UILabel *goodsLab;
@property(nonatomic, weak)IBOutlet UILabel *goodsDesLab;
@property(nonatomic, weak)IBOutlet UILabel *originPriceLab;
@property(nonatomic, weak)IBOutlet UILabel *goodsPriceLab;
@property(nonatomic, weak)IBOutlet UILabel *goodsStockLab;
@property(nonatomic, weak)IBOutlet UIButton *orderBtn;

@property(nonatomic, weak)IBOutlet HMSegmentedControl *segmentControl;
@property(nonatomic, weak)IBOutlet UIView *leftView;
@property(nonatomic, weak)IBOutlet UIView *rightView;
@property(nonatomic, weak)IBOutlet UILabel *scoreLab;
@property(nonatomic, weak)IBOutlet UITableView *commentView;
@property(nonatomic, weak)IBOutlet UILabel *serverLab;

@property(nonatomic, weak)IBOutlet UIView *editView;
@property(nonatomic, weak)IBOutlet UILabel *goodsNumLab;

@property(nonatomic, strong)NSMutableArray *commentArr;

@end

@implementation GoodsDetailViewController

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    if (!_leftView.isHidden) {
        //显示的评论
        commentHeigh.constant = 45 + _commentArr.count*86;
        contentHeigh.constant = 342 + 60 + 133 + 60 + 48 + commentHeigh.constant + 40;
    }
    else
    {
        //显示的服务承诺
        contentHeigh.constant = 342 + 60 + 133 + 60 + 48 + 180;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商品详情";
    _currentPage = 0;
    _totalNum = 0;
    
    _goodsNumLab.text = [NSString stringWithFormat:@"%ld",_goodsModel.goodsNum];
    _commentArr = [[NSMutableArray alloc] initWithCapacity:0];
    [_segmentControl setSectionTitles:@[@"用户评论(0)", @"服务承诺"]];
    
    __weak typeof(self) weakSelf = self;
    [_segmentControl setIndexChangeBlock:^(NSInteger index) {
        
        switch (index) {
            case 0:
            {
                [weakSelf selectCommentView];
            }
                break;
            case 1:
            {
                [weakSelf selectServerView];
            }
                break;
                
            default:
                break;
        }
        [self updateViewConstraints];
    }];
    _segmentControl.selectionIndicatorHeight = 2.0f;
    _segmentControl.backgroundColor = ColorWithRGB(239, 250, 255);
    _segmentControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:16]};
    _segmentControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : ColorWithHexValue(0x036eb7),NSFontAttributeName:[UIFont systemFontOfSize:16]};
    _segmentControl.selectionIndicatorColor = ColorWithHexValue(0x036eb7);
    
    _segmentControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
    _segmentControl.selectedSegmentIndex = 0;
    _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;

    [self setLineSpacing:10 label:_serverLab];

    [self selectCommentView];
    
    [self showViewContent];
    
    [self getGoodsDetailRequest];
    [self getGoodsCommentRequest];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    //获取个人信息
//    [self getPersonalInfoRequest];
    
    if (_adTimer)
    {
        [_adTimer invalidate];
        _adTimer = nil;
    }
    
    _adTimer = [NSTimer timerWithTimeInterval:3.0
                                       target:self
                                     selector:@selector(adImgChanged)
                                     userInfo:nil
                                      repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_adTimer forMode:NSRunLoopCommonModes];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_adTimer)
    {
        [_adTimer invalidate];
        _adTimer = nil;
    }
}

- (void)adImgChanged
{
    if (_currentPage >= (_totalNum - 1)) {
        _currentPage = 0;
    }
    else
    {
        _currentPage ++;
    }
    
    [_pageControl setCurrentPage:_currentPage];
    [_imgScrollView setContentOffset:CGPointMake(kMainScreenWidth*_currentPage, 0) animated:YES];
}

- (void)selectCommentView
{
    _leftView.hidden = NO;
    _rightView.hidden = YES;
}

- (void)selectServerView
{
    _rightView.hidden = NO;
    _leftView.hidden = YES;
}

- (void)setLineSpacing:(CGFloat)spacing label:(UILabel *)label
{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:label.text];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:spacing];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [label.text length])];
    [label setAttributedText:attributedString];
}

- (void)showViewContent
{
    _suitLab.text = _goodsModel.suitCar;
    _goodsLab.text = _goodsModel.goodsName;
    
    if (![NSString isBlankString:_goodsModel.originPrice]) {
        NSAttributedString *attrStr =
        [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@",_goodsModel.originPrice]
                                       attributes:
         @{NSFontAttributeName:[UIFont systemFontOfSize:14.f],
           NSForegroundColorAttributeName:UIColorFromRGB(0x999999),
           NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
           NSStrikethroughColorAttributeName:UIColorFromRGB(0x999999)}];
        self.originPriceLab.attributedText = attrStr;
    }
    
    if ([NSString isBlankString:_goodsModel.goodsPrice]) {
        _goodsPriceLab.text = @"";
    }
    else
    {
        _goodsPriceLab.text = [NSString stringWithFormat:@"￥%@",_goodsModel.goodsPrice];
    }
    
    _goodsStockLab.text = _goodsModel.repertory;
    _scoreLab.text = [NSString stringWithFormat:@"%@分，共0条",_goodsModel.commentScore];
//    if (repairModel) {
//        [_orderBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
//    }
//    else
//    {
//        [_orderBtn setTitle:@"选择维修店" forState:UIControlStateNormal];
//    }
    
    //大图
    if (_goodsModel) {
        _totalNum = _goodsModel.goodsIconArr.count;
        [_pageControl setNumberOfPages:_totalNum];
        [_pageControl setCurrentPage:_currentPage];
        [_imgScrollView setContentSize:CGSizeMake(kMainScreenWidth*_totalNum, 156)];
        for (UIView *view in _imgScrollView.subviews) {
            [view removeFromSuperview];
        }
        
        if (_totalNum > 0) {
            for (NSUInteger i = 0; i < _totalNum; i ++) {
                UIImageView *tmpImg = [[UIImageView alloc] initWithFrame:CGRectMake(kMainScreenWidth*i, 0, kMainScreenWidth, 342)];
                NSString *imgUrlStr = _goodsModel.goodsIconArr[i];
                [tmpImg sd_setImageWithURL:[NSURL URLWithString:[imgUrlStr URLEncodedString]] placeholderImage:IMAGE(@"goods_icon_default")];
                tmpImg.tag = i;
                [_imgScrollView addSubview:tmpImg];
            }
        }
    }
}


#pragma mark - button
//减数目
- (IBAction)minusBtnClip:(id)sender
{
    if (_goodsModel.goodsNum > 1) {
        _goodsModel.goodsNum --;
        _goodsNumLab.text = [NSString stringWithFormat:@"%ld",_goodsModel.goodsNum];
    }
    else
    {
        [MBProgressHUD showHUDAWhile:@"商品数目已经是最少了" toView:self.navigationController.view duration:1];
    }
}

//加数目
- (IBAction)addBtnClip:(id)sender
{
    //允许添加的最大数目
    if (_goodsModel.maxValue > 0) {
        if (_goodsModel.goodsNum >= _goodsModel.maxValue) {
            [MBProgressHUD showHUDAWhile:@"商品数量已达上限" toView:self.navigationController.view duration:1];
            return;
        }
    }
    
    if (_goodsModel.goodsNum >= [_goodsModel.repertory integerValue]) {
        [MBProgressHUD showHUDAWhile:@"库存不足，不能添加" toView:self.navigationController.view duration:1];
        return;
    }
    
    _goodsModel.goodsNum ++;
    _goodsNumLab.text = [NSString stringWithFormat:@"%ld",_goodsModel.goodsNum];
}

- (IBAction)orderBtnClip:(id)sender
{
    if (!TIsLogin) {
        UIStoryboard *AuthStoryBoard    = [UIStoryboard storyboardWithName:@"AuthStoryboard" bundle:nil];
        LoginViewController *loginVC = [AuthStoryBoard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    
    BOOL isAddSuccess = [CartOperations insertGoodsToCart:self.goodsModel];
    
    if (isAddSuccess) {
        [MBProgressHUD showHUDAWhile:@"加入购车成功" toView:self.navigationController.view duration:1];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [MBProgressHUD showHUDAWhile:@"加入购车失败" toView:self.navigationController.view duration:1];
    }
    
//    if (repairModel) {
//        //预约订单
//        UIStoryboard *firstStoryBoard = [UIStoryboard storyboardWithName:@"FirstPage" bundle:nil];
//        BookOrderViewController *bookVc = [firstStoryBoard instantiateViewControllerWithIdentifier:@"BookOrderViewController"];
//        bookVc.goodsModel = self.goodsModel;
//        bookVc.repairShop = repairModel;
//        [self.navigationController pushViewController:bookVc animated:YES];
//    }
//    else
//    {
//        //选择服务店
//        UIStoryboard *firstStoryBoard = [UIStoryboard storyboardWithName:@"FirstPage" bundle:nil];
//        SelectRepairViewController *selectRepairVc = [firstStoryBoard instantiateViewControllerWithIdentifier:@"SelectRepairViewController"];
//        selectRepairVc.selectModel = repairModel;
//        selectRepairVc.delegate = self;
//        [self.navigationController pushViewController:selectRepairVc animated:YES];
//    }
}

- (IBAction)goodsIntroduceBtn:(id)sender
{
    //商品介绍
    UIStoryboard *firstStoryBoard = [UIStoryboard storyboardWithName:@"FirstPage" bundle:nil];
    GoodsIntroductionViewController *introductionVc = [firstStoryBoard instantiateViewControllerWithIdentifier:@"GoodsIntroductionViewController"];
    introductionVc.goodsModel = self.goodsModel;
//    introductionVc.repairShop = repairModel;
    [self.navigationController pushViewController:introductionVc animated:YES];
}

- (IBAction)pageChanged:(id)sender
{
    _currentPage = _pageControl.currentPage; //获取当前pagecontrol的值
    [_imgScrollView setContentOffset:CGPointMake(kMainScreenWidth*_currentPage, 0) animated:YES];
}

#pragma mark - uiScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    if (scrollView == _imgScrollView) {
        CGFloat pageWidth = scrollView.frame.size.width;
        if (scrollView.contentOffset.x > (_totalNum - 1)*pageWidth + pageWidth/4) {
            _currentPage = 0;
            [_pageControl setCurrentPage:_currentPage];
            [_imgScrollView setContentOffset:CGPointMake(kMainScreenWidth*_currentPage, 0) animated:YES];
        }
        else
        {
            _currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
            [_pageControl setCurrentPage:_currentPage];
        }
    }
}

#pragma mark UITableView&DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _commentArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 86.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsCommentCell"];
    
    GoodsCommentModel *model = _commentArr[indexPath.row];
    
    [cell.nameLab setText:model.commentName];
    cell.starView.padding = 5;
    cell.starView.alignment = RateViewAlignmentLeft;
    cell.starView.editable = NO;
    [cell.starView setRate:[model.commentScore floatValue]];
    [cell.commentContent setText:model.commentContent];
    
    return cell;
}

//cell点击事件处理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - SelectRepairShopDelegate
- (void)didSelectRepairShop:(RepairShopModel *)model
{
//    if (model) {
//        repairModel = model;
//        [_orderBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
//    }
}

#pragma mark - request
- (void)getGoodsDetailRequest
{
    //获取商品请求
    NSString *skuId = _goodsModel.goodsId;
    if ([NSString isBlankString:_goodsModel.goodsId]) {
        skuId = @"";
    }
    
    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    [TigroneRequests getGoodsWithBlock:^(GoodsModel *model, NSString *errorStr) {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        if (!errorStr) {
            if (model) {
                _goodsModel = model;
                [self showViewContent];
            }
        }
        else
        {
            [MBProgressHUD showHUDAWhile:errorStr toView:self.navigationController.view duration:1];
        }
    } paramDic:@{@"skuId":skuId}];
}

- (void)getGoodsCommentRequest
{
//    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    [TigroneRequests getGoodsCommentListWithBlock:^(NSArray *resultArr, NSString *errorStr) {
//        [MBProgressHUD hideHUDForView:self.navigationController.view];
        if (errorStr) {
            [MBProgressHUD showHUDAWhile:errorStr toView:self.navigationController.view duration:1];
        }
        else
        {
            NSString *commentStr = [NSString stringWithFormat:@"用户评论(%@)",@(resultArr.count)];
            [_segmentControl setSectionTitles:@[commentStr, @"服务承诺"]];
            [_segmentControl setNeedsDisplay];
            _scoreLab.text = [NSString stringWithFormat:@"%@分，共%@条",_goodsModel.commentScore,@(resultArr.count)];
            [_commentArr removeAllObjects];
            [_commentArr addObjectsFromArray:resultArr];
            [_commentView reloadData];
        }
    } paramDic:@{@"skuId":_goodsModel.goodsId}];
}

//- (void)getPersonalInfoRequest
//{
//    [TigroneRequests getUserInformation:^(UserInfoModel *userModel, NSString *errorStr) {
//        if (!errorStr) {
//            //获取成功
//            if (userModel && ![NSString isBlankString:userModel.shopId]) {
//                if (!repairModel) {
//                    repairModel = [[RepairShopModel alloc] init];
//                }
//                repairModel.shopId = userModel.shopId;
//                repairModel.shopName = userModel.shopName;
//                repairModel.shopAddr = userModel.shopAddr;
//                [_orderBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
//            }
//        }
//    } paramDic:@{@"phone":PhoneNum,
//                 @"token":Token}];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

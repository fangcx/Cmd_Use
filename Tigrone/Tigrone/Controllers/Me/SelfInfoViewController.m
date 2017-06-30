//
//  SelfInfoViewController.m
//  Tigrone
//
//  Created by 张刚 on 15/12/21.
//  Copyright © 2015年 iOS Team. All rights reserved.
//

#import "SelfInfoViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "TigroneRequests.h"
#import "NickNameViewController.h"
#import "EmailModifyViewController.h"
#import "PhoneNumberViewController.h"
#import "SelectRepairViewController.h"
#import "UIImageView+WebCache.h"

@interface SelfInfoViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
{
    BOOL isGetheader;
    UIImage *selectHeaderImg;
    UserInfoModel *_userModel;
}

@property (strong, nonatomic) NSString *lastChosenMediaType;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSURL *movieURL;
@property (weak, nonatomic) IBOutlet UITableViewCell *headPortraitCell;
@property (weak, nonatomic) IBOutlet UIImageView *headPortraitImage;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLab;
@property (weak, nonatomic) IBOutlet UILabel *emailLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;

@end

@implementation SelfInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isGetheader = NO;
    [self.tableView setContentInset:UIEdgeInsetsMake(-2, 0, 0, 0)];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    [self.headPortraitCell setBackgroundColor:Tigrone_SchemeColor];
    
    self.view.backgroundColor = ColorWithRGB(239, 250, 254);
    _phoneLab.text = PhoneNum;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!isGetheader) {
        [self getPersonalInfoRequest];
    }
}

- (void)viewDidLayoutSubviews
{
    [self.headPortraitImage.layer setMasksToBounds:YES];
    [self.headPortraitImage.layer setCornerRadius:50];
}

#pragma mark - reuquest
-(void)getPersonalInfoRequest
{
    //获取个人信息
    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    [TigroneRequests getUserInformation:^(UserInfoModel *userModel, NSString *errorStr) {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        if (!errorStr) {
            //获取成功
            _userModel = userModel;
            
            if (![NSString isBlankString:_userModel.userName]) {
                _nickNameLab.text = _userModel.userName;
            }
            else
            {
                _nickNameLab.text = @"未设置";
            }
            
            if (![NSString isBlankString:_userModel.userEmail]) {
                _emailLab.text = _userModel.userEmail;
            }
            else
            {
                _emailLab.text = @"未设置";
            }
            
            _phoneLab.text = _userModel.userPhone;
            
            if (![NSString isBlankString:_userModel.userIcon]) {
//                UIImageView *tmpImgView = [[UIImageView alloc] init];
//                [tmpImgView sd_setImageWithURL:[NSURL URLWithString:[_userModel.userIcon URLEncodedString]] placeholderImage:IMAGE(@"me_self_info")];
//                UIImage *shrunkenImage = [self shrinkImage:tmpImgView.image toSize:self.headPortraitImage.bounds.size];
//                self.headPortraitImage.image = shrunkenImage;
                [self.headPortraitImage sd_setImageWithURL:[NSURL URLWithString:[_userModel.userIcon URLEncodedString]] placeholderImage:IMAGE(@"me_self_info")];
            }
        }
        else
        {
            [MBProgressHUD showHUDAWhile:errorStr toView:self.navigationController.view duration:1];
        }
    } paramDic:@{@"phone":PhoneNum,
                 @"token":Token}];
}

- (void)setUserHeaderRequest:(NSData *)imgData
{
    [MBProgressHUD showHUDWithMsg:nil toView:self.navigationController.view];
    [TigroneRequests setUserHeaderWithBlock:^(NSString *errorStr,BOOL isSuccess) {
        [MBProgressHUD hideHUDForView:self.navigationController.view];
        [MBProgressHUD showHUDAWhile:errorStr toView:self.navigationController.view duration:1];
        isGetheader = NO;
        if (isSuccess) {
            //设置头像成功
            UIImage *shrunkenImage = [self shrinkImage:selectHeaderImg toSize:self.headPortraitImage.bounds.size];
            self.headPortraitImage.image = shrunkenImage;
        }
    } paramDic:@{@"phone":PhoneNum,
                 @"token":Token}
     fileData:imgData];
}

#pragma mark - TableView delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选择", nil];
        [actionSheet showInView:self.view];
    }
    else
    {
        switch (indexPath.row) {
            case 0:
            {
                //昵称
                UIStoryboard *meStoryboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
                NickNameViewController *nickNameVc = [meStoryboard instantiateViewControllerWithIdentifier:@"NickNameViewController"];
                if (_userModel) {
                    nickNameVc.nickName = _userModel.userName;
                }
                [self.navigationController pushViewController:nickNameVc animated:YES];
            }
                break;
                
            case 1:
            {
                //邮箱
                UIStoryboard *meStoryboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
                EmailModifyViewController *emailVc = [meStoryboard instantiateViewControllerWithIdentifier:@"EmailModifyViewController"];
                if (_userModel) {
                    emailVc.emailStr = _userModel.userEmail;
                }
                [self.navigationController pushViewController:emailVc animated:YES];
            }
                break;
                
            case 2:
            {
                //手机号
                UIStoryboard *meStoryboard = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
                PhoneNumberViewController *phoneVc = [meStoryboard instantiateViewControllerWithIdentifier:@"PhoneNumberViewController"];
                [self.navigationController pushViewController:phoneVc animated:YES];
            }
                break;
                
            case 4:
            {
                //默认维修店
                UIStoryboard *firstStoryBoard = [UIStoryboard storyboardWithName:@"FirstPage" bundle:nil];
                SelectRepairViewController *selectRepairVc = [firstStoryBoard instantiateViewControllerWithIdentifier:@"SelectRepairViewController"];
                if (![NSString isBlankString:_userModel.shopId]) {
                    RepairShopModel *model = [[RepairShopModel alloc] init];
                    model.shopId = _userModel.shopId;
                    model.shopName = _userModel.shopName;
                    selectRepairVc.selectModel = model;
                }
                [self.navigationController pushViewController:selectRepairVc animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

#pragma mark - public methods

- (void)pickMediaFromSource:(UIImagePickerControllerSourceType)sourceType
{
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if([UIImagePickerController isSourceTypeAvailable:sourceType] && [mediaTypes count] > 0){
        NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.mediaTypes = mediaTypes;
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

- (UIImage *)shrinkImage:(UIImage *)original toSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    [original drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *final = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return final;
}

#pragma mark - UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self pickMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
    }else if (buttonIndex == 0){
        [self pickMediaFromSource:UIImagePickerControllerSourceTypeCamera];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.lastChosenMediaType = info[UIImagePickerControllerMediaType];
    if([self.lastChosenMediaType isEqual:(NSString *)kUTTypeImage]){
        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        selectHeaderImg = chosenImage;
        NSData *imgData = UIImageJPEGRepresentation(chosenImage, 1);
        if (imgData) {
            isGetheader = YES;
            [self setUserHeaderRequest:imgData];
        }
    }else{
        
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end

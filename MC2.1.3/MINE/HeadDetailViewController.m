//
//  HeadDetailViewController.m
//  MiningCircle
//
//  Created by ql on 16/3/1.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "HeadDetailViewController.h"
#import "HeadDetailTableViewCell.h"
#import "ImageTableViewCell.h"
#import "UIImageView+WebCache.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "VPImageCropperViewController.h"
#import "DataManager.h"
#import "PwdEdite.h"
#import "Tool.h"
#import "NickNameViewController.h"
#import "UIImage+Extension.h"
#import "HudView.h"
#import "SuccessHud.h"
//#define ORIGINAL_MAX_WIDTH 640.0f
@interface HeadDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,VPImageCropperDelegate,NickNameDelegate>
{
    NSArray *titleArr;
    HudView *hud;
    SuccessHud *succcessHud;
}
@end

@implementation HeadDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
 //   self.navigationController.navigationBar.translucent = NO;
 //   [self.navigationController.navigationBar setBarTintColor:RGB(19, 19, 19)];
    
    
   // UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:nil action:nil];
   // self.navigationItem.backBarButtonItem = item;

    self.title = ZGS(@"alertPhoto");
    titleArr = @[ZGS(@"photo"),ZGS(@"nickName")];
    
    NSLog(@"zzzzz%@",ZGS(@"photo"));
          
    UINib *nib1 = [UINib nibWithNibName:@"ImageTableViewCell" bundle:nil];
    [_tbView registerNib:nib1 forCellReuseIdentifier:@"imgCell"];

    UINib *nib = [UINib nibWithNibName:@"HeadDetailTableViewCell" bundle:nil];
    [_tbView registerNib:nib forCellReuseIdentifier:@"headDetail"];
    
    
    _tbView.scrollEnabled = NO;
    self.isPost = YES;
}
#pragma -mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titleArr.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ImageTableViewCell" owner:self options:nil];
        ImageTableViewCell *cell = nib[0];
       // cell.backgroundColor = [UIColor redColor];
        cell.title.text = titleArr[indexPath.row];
        if(_img)
        {
            cell.headImage.image = _img;
        }
        else
        {
        NSURL *url = [NSURL URLWithString:_imgUrl];
        [cell.headImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"test"]];
        }
        return cell;
        
    }
    else
    {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"HeadDetailTableViewCell" owner:self options:nil];
        HeadDetailTableViewCell *cell = nib[0];
        cell.title.text = titleArr[indexPath.row];
        cell.detail.text = _name;
        return cell;

    }
}
#pragma -mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return 88;
    }
    else
    {
        return 44;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0 )
    {
        [self selectedImage];
    }
    else
    {
        [self modifyNickName];
    }
}
#pragma -mark 修改昵称
-(void)modifyNickName
{
    NickNameViewController *nickNameController = [[NickNameViewController alloc]initWithNibName:@"NickNameViewController" bundle:nil];
    nickNameController.nameStr = _name;
    nickNameController.nickDelegate = self;
    [self.navigationController pushViewController:nickNameController animated:YES];
}
-(void)modifyName:(NickNameViewController *)nickViewController didFinished:(NSString *)nickName
{
    _name = nickName;
    if(nickName)
    {
        [self sendPic:nil and:nickName];
    }
    [_tbView reloadData];
    [nickViewController.navigationController popViewControllerAnimated:YES];
}


#pragma -mark actionsheet
-(void)selectedImage
{
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:ZGS(@"cancle")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:ZGS(@"takePhote"), ZGS(@"FromPhotos"), nil];
    [choiceSheet showInView:self.view];

}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            //相册
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }
}
#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    //要上传的图片要压缩一下
//   editedImage =  [editedImage fixOrientation:editedImage];
    editedImage = [self imageByScalingToMaxSize:editedImage maxWidth:100];
    self.img = editedImage;
    if(editedImage)
    {
        [self postToServer:editedImage];
    }
    [_tbView reloadData];
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        UIImage *newImg = [UIImage fixOrientation:portraitImg];
        //这里不压缩的话图太大的时候会崩，压缩太小的话大图会模糊
        newImg = [self imageByScalingToMaxSize:newImg maxWidth:640];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:newImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    
    return result;
}
#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage maxWidth:(CGFloat)originalMaxWidth{
    if (sourceImage.size.width < originalMaxWidth) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = originalMaxWidth;
        //等比例压缩
        btWidth = sourceImage.size.width * (originalMaxWidth / sourceImage.size.height);
    } else {
        btWidth = originalMaxWidth;
        btHeight = sourceImage.size.height * (originalMaxWidth / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)loadHudView
{
    hud = [[HudView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    hud.tipLabel.text = @"正在上传";
    // hud.time = 3.0f;
    hud.center = CGPointMake(width1/2, height1*1/3);
    [hud startShow];
    [self.view addSubview:hud];
}
-(void)showSuccessView
{
    //sue
   // SuccessHud *succcessHud = [[SuccessHud alloc]init];
   succcessHud  = [[SuccessHud alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
  //  succcessHud.tipLabel.text = @"上传成功";
    
    succcessHud.center = CGPointMake(width1/2, height1/3);
    [self.view addSubview:succcessHud];
    
}
#pragma -mark loadToServer
-(void)postToServer:(UIImage *)postImg
{
    if(_isPost)
    {
        [self loadHudView];
    }
    AFHTTPSessionManager *manager = [DataManager shareHTTPRequestOperationManager];
#if KMIN
    NSString *str = [NSString stringWithFormat:@"%@upload/c",MAINURL];
#elif KGOLD
    NSString *str = [NSString stringWithFormat:@"%@upfile",MAINURL];
#endif
    NSData *data = UIImagePNGRepresentation(postImg);
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *dataStr = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",dataStr];
    
    [manager POST:str parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:@"uploadFile" fileName:fileName mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"suc");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if(dict.count > 0)
        {
#if KMIN
            NSString *line = dict[@"path"];
#elif KGOLD
            NSString *line = dict[fileName];
#endif
            if(self.isPost)
            {
                [self sendPic:line and:nil];
            }
            else
            {

                self.picLine = line;
                self.modifyLine = line;
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       NSLog(@"fail");
    }];
}
#pragma -mark sendPic
-(void)sendPic:(NSString *)line and:(NSString *)name
{
    NSUserDefaults *userDefault = [NSUserDefaults new];
    if(name == nil)
        name = [userDefault objectForKey:@"username"];
    if (line == nil) {
        line = _imgUrl;
    }
    if(name.length > 0&&line.length > 0)
    {
        NSDictionary *dict = @{@"cmd":@"setuserinfo",@"col":@{@"user_img":line,@"user_nick":name}};
      //  dict = [PwdEdite ecoding:dict];
        
        [[DataManager shareInstance]ConnectServer:STRURL parameters:dict isPost:YES result:^(NSDictionary *resultBlock) {
            [hud stopShow];
          //  [self showSuccessView];
        }];
    }
}
@end

//
//  ImageTableViewCell.m
//  MiningCircle
//
//  Created by ql on 16/3/1.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "ImageTableViewCell.h"
#import "VPImageCropperViewController.h"

@interface ImageTableViewCell ()<VPImageCropperDelegate>

@end
@implementation ImageTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//#pragma mark VPImageCropperDelegate
//- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
//    self.headImage.image = editedImage;
//    [cropperViewController dismissViewControllerAnimated:YES completion:^{
//        // TO DO
//    }];
//}
//
//- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
//    [cropperViewController dismissViewControllerAnimated:YES completion:^{
//    }];
//}

//- (UIImageView *)headImage {
//    if (!_headImage) {
//     //   CGFloat w = 100.0f; CGFloat h = w;
//      //  CGFloat x = (self.view.frame.size.width - w) / 2;
//      //  CGFloat y = (self.view.frame.size.height - h) / 2;
//      //  _headImage = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
//        [_headImage.layer setCornerRadius:(_headImage.frame.size.height/2)];
//        [_headImage.layer setMasksToBounds:YES];
//        [_headImage setContentMode:UIViewContentModeScaleAspectFill];
//        [_headImage setClipsToBounds:YES];
//        _headImage.layer.shadowColor = [UIColor blackColor].CGColor;
//        _headImage.layer.shadowOffset = CGSizeMake(4, 4);
//        _headImage.layer.shadowOpacity = 0.5;
//        _headImage.layer.shadowRadius = 2.0;
//        _headImage.layer.borderColor = [[UIColor blackColor] CGColor];
//        _headImage.layer.borderWidth = 2.0f;
//        _headImage.userInteractionEnabled = YES;
//    
//    }
//    return _headImage;
//}

@end

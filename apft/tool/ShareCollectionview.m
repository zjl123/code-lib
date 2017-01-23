//
//  ShareCollectionview.m
//  MiningCircle
//
//  Created by ql on 16/9/6.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "ShareCollectionview.h"
#import <ShareSDKUI//ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <Social/Social.h>
@implementation ShareCollectionview

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
 //   flowLayout.minimumInteritemSpacing = 3;
    flowLayout.minimumLineSpacing = 3;
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if(self)
    {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.scrollEnabled = NO;
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor clearColor];
     //   self.userInteractionEnabled = YES;
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"shareCell"];
    }
    return self;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _stateArr.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    return CGSizeMake((w-5*3)/_stateArr.count, h);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"shareCell" forIndexPath:indexPath];
    cell.userInteractionEnabled = YES;
   // cell.backgroundColor = RGB(arc4random()%255, arc4random()%255, arc4random()%255);
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, (cell.frame.size.height-40)/2, cell.frame.size.width, 40)];
    NSDictionary *dict = _stateArr[indexPath.row];
    imgView.image = [UIImage imageNamed:dict[@"icon"]];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.userInteractionEnabled = YES;
    [cell addSubview:imgView];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [UIView animateWithDuration:0.2f animations:^{
        self.superview.frame = CGRectMake(0, height1, width1, 100);
    } completion:^(BOOL finished) {
        self.hidden = YES;
        NSLog(@"%@",self.superview);
        self.superview.superview.hidden = YES;
    }];
    if (indexPath.row < _stateArr.count) {
        NSDictionary *dict = _stateArr[indexPath.row];
        NSString *icon = dict[@"icon"];
        if ([icon isEqualToString:@"more"]) {
            NSArray *activity = @[_title,_img,_url];
            UIActivityViewController *activityController = [[UIActivityViewController alloc]initWithActivityItems:activity applicationActivities:nil];
            [_controlller presentViewController:activityController animated:YES completion:^{
                
            }];
        }
        else
        {
        NSInteger type =  [dict[@"api"] integerValue];
        
        if(type)
        {
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            if(type != SSDKPlatformTypeSinaWeibo)
            {
                
                //参数
                [shareParams SSDKEnableUseClientShare];
                [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@",_content]
                                                 images:_img
                                                    url:_url
                                                  title:_title
                                                   type:SSDKContentTypeAuto];
            }
            else
            {
                [shareParams SSDKEnableUseClientShare];
                [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@ %@",_content,_url]
                                                 images:_img
                                                    url:_url
                                                  title:_title
                                                   type:SSDKContentTypeAuto];
            }
            [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                switch (state) {
                        
                    case SSDKResponseStateSuccess:
                    {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:ZGS(@"shareSuc")
                                                                            message:nil
                                                                           delegate:nil
                                                                  cancelButtonTitle:ZGS(@"ok")
                                                                  otherButtonTitles:nil];
                        [alertView show];
                        break;
                    }
                    case SSDKResponseStateFail:
                    {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:ZGS(@"shareFail")
                                                                            message:ZGS(@"shareError")
                                                                           delegate:nil
                                                                  cancelButtonTitle:ZGS(@"ok")
                                                                  otherButtonTitles:nil];
                        [alertView show];
                        break;
                    }
                    default:
                        break;
                }
                
                
                
            }];
        }
                }
    }
   
}
@end

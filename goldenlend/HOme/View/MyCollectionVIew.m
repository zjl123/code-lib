//
//  MyCollectionVIew.m
//  MiningCircle
//
//  Created by ql on 16/5/14.
//  Copyright © 2016年 zjl. All rights reserved.
//  EditChannel的collectionview

#import "MyCollectionVIew.h"
#import "ChannelCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "BannerDetailViewController.h"
@implementation MyCollectionVIew
{
    NSMutableArray *mutArr;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.minimumLineSpacing = 1;
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if(self)
    {
        self.backgroundColor = RGB(237, 237, 237);
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        //设置代理
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[ChannelCollectionViewCell class] forCellWithReuseIdentifier:@"channel"];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:longPress];
        //修改成懒加载
    }
    return self;
}
-(void)setArr:(NSArray *)arr
{
    _arr = arr;
   mutArr = [NSMutableArray arrayWithArray:arr];
}
-(void)longPress:(UILongPressGestureRecognizer *)press
{
    
    //判断手势状态
    switch (press.state) {
        case UIGestureRecognizerStateBegan:{
            CGPoint point = [press locationInView:self];
            if(point.x > (width1-3)/4||point.y > 80)
            {
                NSIndexPath *sourceIndexPath =   [self indexPathForItemAtPoint:[press locationInView:self]];
                ChannelCollectionViewCell *cell = (ChannelCollectionViewCell *)[self cellForItemAtIndexPath:sourceIndexPath];
                //放大
                cell.transform = CGAffineTransformMakeScale(1.1, 1.1);
                //添加四个边阴影
                cell.layer.shadowColor = [UIColor grayColor].CGColor;//阴影颜色
                cell.layer.shadowOffset = CGSizeMake(2, 2);//偏移距离
                cell.layer.shadowOpacity = 0.5;//不透明度
                cell.layer.shadowRadius = 1.0;//半径
                cell.layer.masksToBounds = NO;
                if(sourceIndexPath == nil)
                {
                    break;
                }
                //从路径上开始移动路径上的cell
                [self beginInteractiveMovementForItemAtIndexPath:sourceIndexPath];
            }
            
        }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            //移动过程中随时更新cell位置
            CGPoint point = [press locationInView:self];
            if(point.x > (width1-3)/4 || point.y > 80)
            {
                [self updateInteractiveMovementTargetPosition:[press locationInView:self]];
            }
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            //移动结束关闭cell移动
            [self endInteractiveMovement];
            NSIndexPath *indexPath =   [self indexPathForItemAtPoint:[press locationInView:self]];
            ChannelCollectionViewCell *cell = (ChannelCollectionViewCell *)[self cellForItemAtIndexPath:indexPath];
            
            //放大
            cell.transform = CGAffineTransformMakeScale(1, 1);
            //添加四个边阴影
            cell.layer.shadowColor = [UIColor clearColor].CGColor;//阴影颜色
            cell.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
            cell.layer.shadowOpacity = 0.5;//不透明度
            cell.layer.shadowRadius = 0;//半径
            cell.layer.masksToBounds = NO;
            
            
        }
            break;
            
        default:
        {
            [self cancelInteractiveMovement];
            
            NSIndexPath *indexPath =   [self indexPathForItemAtPoint:[press locationInView:self]];
            ChannelCollectionViewCell *cell = (ChannelCollectionViewCell *)[self cellForItemAtIndexPath:indexPath];
            //放大
            cell.transform = CGAffineTransformMakeScale(1, 1);
            //添加四个边阴影
            cell.layer.shadowColor = [UIColor clearColor].CGColor;//阴影颜色
            cell.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
            cell.layer.shadowOpacity = 0.5;//不透明度
            cell.layer.shadowRadius = 0;//半径
            cell.layer.masksToBounds = NO;
            
        }
            break;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChannelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"channel" forIndexPath:indexPath];
    if(indexPath.row == 0)
    {
        cell.backgroundColor = RGB(240, 240, 240);
        cell.title.textColor = RGB(150, 150, 150);
        cell.userInteractionEnabled = NO;
        cell.multipleTouchEnabled = NO;
    }
    else
    {
        cell.backgroundColor = [UIColor whiteColor];
        cell.title.textColor = RGB(50, 50, 50);
  }

    NSDictionary *dict = _arr[indexPath.row];
    cell.title.text = dict[@"title"];
    NSURL *url = [NSURL URLWithString:dict[@"ico"]];
    [cell.imgView sd_setImageWithURL:url];
    return cell;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _arr.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
   // NSLog(@"ccccccc%f",(width1-3)/4);
    return CGSizeMake((width1-3)/4, (width1-3)/4);
}
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0)
    {
        return NO;
    }
    return YES;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  //  NSLog(@"hhh");
    
    NSDictionary *dict = _arr[indexPath.row];
    NSString *strUrl = dict[@"act"];
    [self.jumpDelegate jumpToBanner:strUrl];
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    ChannelCollectionViewCell *cell = (ChannelCollectionViewCell *)[self cellForItemAtIndexPath:destinationIndexPath];
    
    //放大
    cell.transform = CGAffineTransformMakeScale(1, 1);
    //添加四个边阴影
    cell.layer.shadowColor = [UIColor clearColor].CGColor;//阴影颜色
    cell.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
    cell.layer.shadowOpacity = 0.5;//不透明度
    cell.layer.shadowRadius = 0;//半径
    cell.layer.masksToBounds = NO;
    // objc;
    
   NSDictionary *objc  = [mutArr objectAtIndex:sourceIndexPath.row];
    [mutArr removeObject:objc];
    [mutArr insertObject:objc atIndex:destinationIndexPath.row];
    NSUserDefaults *userDefault = [NSUserDefaults new];
    [userDefault setObject:mutArr forKey:@"function"];
    _arr = mutArr;
    
}

@end

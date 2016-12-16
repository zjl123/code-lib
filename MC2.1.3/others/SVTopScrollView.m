//
//  SVTopScrollView.m
//  SlideView
//
//  Created by Chen Yaoqiang on 13-12-27.
//  Copyright (c) 2013年 Chen Yaoqiang. All rights reserved.
//

#import "SVTopScrollView.h"
#import "SVGloble.h"
//#import "SVRootScrollView.h"
#import "WebCollectionView.h"
#import "NSString+Exten.h"
#import "TextCollectionViewCell.h"
//按钮上下总空隙
#define BUTTONGAP 20
//滑条宽度
//#define CONTENTSIZEX
//按钮id
#define BUTTONID (sender.tag-100)
//滑动id
//#define BUTTONSELECTEDID (scrollViewSelectedChannelID - 100)
//加括号啊
#define scWidth (width1-47)

@interface SVTopScrollView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@end
@implementation SVTopScrollView

//@synthesize nameArray;
//@synthesize scrollViewSelectedChannelID;

+ (SVTopScrollView *)shareInstance {
    static SVTopScrollView *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance=[[self alloc] initWithFrame:CGRectMake(0, 0, scWidth, 38)];//14号字体高度为16.71,15号字体高度18
    });
    return _instance;

}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        //[self initWithNameButtons];
        
    }
    return self;
}
-(void)initWithNameButtons
{
    if(!self.titleCollectionView)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        CGFloat itemsH = ([[UIScreen mainScreen] bounds].size.width)/4.5;
        flowLayout.itemSize = CGSizeMake(itemsH, self.bounds.size.height);
        self.titleCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) collectionViewLayout:flowLayout];
        self.titleCollectionView.delegate = self;
        self.titleCollectionView.dataSource = self;
        self.titleCollectionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleCollectionView];
        [self.titleCollectionView registerClass:[TextCollectionViewCell class] forCellWithReuseIdentifier:@"SegmentCell"];
        self.titleCollectionView.bounces = NO;
        self.titleCollectionView.showsHorizontalScrollIndicator = NO;
      //  self.titleCollectionView.backgroundColor = [UIColor whiteColor];
    }
    if(_nameArray.count > 0)
    {
        CGSize itemSize = [self.nameArray[0] getStringSize:[UIFont systemFontOfSize:14] width:self.bounds.size.width];
        // NSLog(@"hhhh%f",itemSize.height);
        if(!shadowImageView)
        {
            shadowImageView = [[UIView alloc]init];
            shadowImageView.backgroundColor = RGB(224, 224, 224);
            //zPosition=-1设置层级最低.
            shadowImageView.layer.zPosition = -1;
            [self.titleCollectionView insertSubview:shadowImageView atIndex:0];
            shadowImageView.layer.cornerRadius = 13;

        }
        shadowImageView.frame = CGRectMake(BUTTONGAP/2-5, 6, itemSize.width+BUTTONGAP+10, self.titleCollectionView.frame.size.height-12);

    }

    [self.titleCollectionView reloadData];
    [self setSelectedSegmentIndex:0 animated:NO];
}

-(NSArray *)nameArray
{
    if(!_nameArray)
    {
        self.nameArray = [NSArray array];
    }
    return _nameArray;
}
-(NSMutableArray *)wArray
{
    if(!_wArray)
    {
        self.wArray = [NSMutableArray array];
    }
    return _wArray;
}
-(void)setSelectedSegmentIndex:(NSUInteger)index animated:(BOOL)animated
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    if(_nameArray.count > 0)
    {
        //滚动到collectionview水平方向的中间
        [self.titleCollectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    }
    [self tipImageScrolling:indexPath];
  //  [[WebCollectionView shareInstance]loadData];
}
#pragma -mark UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _nameArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TextCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SegmentCell" forIndexPath:indexPath];
  //  cell.backgroundColor = [UIColor redColor];
    cell.title.text = self.nameArray[indexPath.row];
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize = [self.nameArray[indexPath.row] getStringSize:[UIFont systemFontOfSize:15] width:self.bounds.size.width];
    return CGSizeMake(itemSize.width+BUTTONGAP*2, self.titleCollectionView.frame.size.height);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.IndexChangeBlock) {
        self.IndexChangeBlock(indexPath.row);
    }
    
    [self tipImageScrolling:indexPath];
    [self.titleCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
}
-(void)tipImageScrolling:(NSIndexPath *)indexPath
{
    TextCollectionViewCell *cell = (TextCollectionViewCell *)[_titleCollectionView cellForItemAtIndexPath:indexPath];
    if(cell)
    {
        [UIView animateWithDuration:0.25 animations:^{
            
            if(_nameArray.count > 0)
            {
                [shadowImageView setFrame:CGRectMake(cell.frame.origin.x+BUTTONGAP/2-5, BUTTONGAP/4, cell.bounds.size.width-BUTTONGAP+10, cell.bounds.size.height-BUTTONGAP/2)];
            }
            
        } completion:^(BOOL finished) {
        }];
    }
}
@end

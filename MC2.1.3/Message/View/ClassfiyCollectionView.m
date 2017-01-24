//
//  ClassfiyCollectionView.m
//  MiningCircle
//
//  Created by ql on 2016/12/8.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "ClassfiyCollectionView.h"
#import "ClassfiyCollectionViewCell.h"
@interface ClassfiyCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end
@implementation ClassfiyCollectionView
{
    int mMenuShowStatus;
    int showIndex;
}
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
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 1.0f;
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if(self)
    {
        //self.backgroundColor = [UIColor clearColor];
        self.backgroundColor = RGB(248, 248, 248);
        self.delegate = self;
        self.dataSource = self;
        self.showsVerticalScrollIndicator = NO;
        self.bounces = NO;
        [self registerClass:[ClassfiyCollectionViewCell class] forCellWithReuseIdentifier:@"classfiy"];
        [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        mMenuShowStatus = 0;
        showIndex =0;
        }
    return self;
}
-(void)setInfo:(NSArray *)info
{
    _info = info;
    [self reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIButton *btn = [self viewWithTag:700];
        if(btn)
        {
            [self btnCLick:btn];
        }
    });
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = _info[indexPath.section];
    NSArray *arr = dict[@"level2"];
    NSDictionary *dict1 = arr[indexPath.row];
    [self.classfiyDelegate ClassfiyClick:indexPath.section andRow:indexPath.row andTag:@"" andCatId:dict1[@"catId"]];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.info.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if((mMenuShowStatus & (1<<section)) != 0)
    {
        NSDictionary *dict = _info[section];
        
        NSArray *arr = dict[@"level2"];
        return arr.count;
    }
    return 0;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ClassfiyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"classfiy" forIndexPath:indexPath];
    NSDictionary *dict = _info[indexPath.section];
    NSArray *arr = dict[@"level2"];
    NSDictionary *dict1 = arr[indexPath.row];
    cell.titleLabel.text = dict1[@"title2"];
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.frame.size.width, 44);
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    CGFloat w = reusableView.frame.size.width;
    CGFloat h = reusableView.frame.size.height;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = 700+indexPath.section;
    btn.frame = CGRectMake(0, 0, w, h);
    NSDictionary *dict = _info[indexPath.section];
    NSString *str = dict[@"title"];
    [btn setTitle:str forState:UIControlStateNormal];
    if(showIndex == indexPath.section)
    {
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor:[[UIColor redColor] colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
        
    }
    else
    {
        btn.backgroundColor = RGB(248, 248, 248);
        [btn setTitleColor:RGB(150, 150, 150) forState:UIControlStateNormal];
    }
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(btnCLick:) forControlEvents:UIControlEventTouchUpInside];
    [reusableView addSubview:btn];
    
    //line
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, h-1, w, 1.0f)];
    line.backgroundColor = RGB(238, 238, 238);
    [reusableView addSubview:line];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(w-1, 0, 1, h)];
    line1.backgroundColor = RGB(238, 238, 238);
    [reusableView addSubview:line1];
    return reusableView;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.frame.size.width, 50);
}

-(void)btnCLick:(UIButton *)sender
{
    static int num = 700;
    int status = 1<<(sender.tag-700);
    if((mMenuShowStatus&status) == 0)
    {
        mMenuShowStatus = status;
    }
    else
    {
        //按字节去反
        mMenuShowStatus &= ~status;
    }
    showIndex = (int)(sender.tag-700);
    //刷新两个section
   // [self reloadSections:[NSIndexSet indexSetWithIndex:num-700]];
  //  [self reloadSections:[NSIndexSet indexSetWithIndex:sender.tag-700]];

    [self reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:sender.tag-700];
        [self selectItemAtIndexPath:index animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        NSDictionary *dict = _info[sender.tag-700];
        NSArray *arr = dict[@"level2"];
        NSDictionary *dict1 = arr[0];

       // NSInteger num = [dict1[@"catId"] integerValue];
       // NSString *str = [NSString stringWithFormat:@"%ld",num];
        [self.classfiyDelegate ClassfiyClick:index.section andRow:index.row andTag:sender.titleLabel.text andCatId:dict1[@"catId"]];
    });
    
    num = (int)sender.tag;
}
@end

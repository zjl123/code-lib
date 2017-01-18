//
//  TicketCollectionView.m
//  MiningCircle
//
//  Created by ql on 2016/12/6.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "TicketCollectionView.h"
#import "TicketDetailCollectionViewCell.h"
#import "HeaderCollectionReusableView.h"
#import "PromotionDetailCollectionViewCell.h"
#import "NSString+Exten.h"
#import "TextCollectionViewCell.h"
#import "PurchaseQuantityCollectionViewCell.h"
@implementation TicketCollectionView
{
    UICollectionViewFlowLayout *flowLayout;
    NSArray *allkeys;
    UITextField *tmpTextField;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
  //
    //flowLayout.minimumLineSpacing = 15;
    self = [super initWithFrame:frame collectionViewLayout:flowLayout];
    if(self)
    {
        self.delegate = self;
        self.dataSource = self;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        [self registerClass:[TicketDetailCollectionViewCell class] forCellWithReuseIdentifier:@"ticketDetail"];
        [self registerClass:[PromotionDetailCollectionViewCell class] forCellWithReuseIdentifier:@"promotionDetail"];
        [self registerClass:[TextCollectionViewCell class] forCellWithReuseIdentifier:@"text"];
        [self registerClass:[PurchaseQuantityCollectionViewCell class] forCellWithReuseIdentifier:@"purchase"];
        UINib *nib = [UINib nibWithNibName:@"HeaderCollectionReusableView" bundle:nil];
        [self registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHiden:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
     [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}
-(void)setFlag:(NSString *)flag
{
    _flag = flag;
    if([flag isEqualToString:@"促销"])
    {
        self.backgroundColor = [UIColor whiteColor];

      //  self.backgroundColor = RGB(240, 240, 240);
        flowLayout.minimumLineSpacing = 1;
    }
    else
    {
        self.backgroundColor = RGB(240, 240, 240);
        flowLayout.minimumLineSpacing = 15;
    }
}
-(void)setDataDict:(NSDictionary *)dataDict
{
    self.backgroundColor = [UIColor whiteColor];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _dataDict = dataDict;
    allkeys = dataDict.allKeys;
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(_dataDict.count > 0)
    {
        if(section < allkeys.count)
        {
            NSArray *arr = _dataDict[allkeys[section]];
            return arr.count;
        }
        else
        {
            return 1;
        }
    }
    return _dataArr.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if(_dataDict.count > 0)
    {
        return allkeys.count+1;
    }
    else
    {
        return 1;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(![_flag isEqualToString:@"促销"])
    {
        //领券
        NSLog(@"领券");
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([_flag isEqualToString:@"促销"])
    {
        PromotionDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"promotionDetail" forIndexPath:indexPath];
        NSDictionary *dict = _dataArr[indexPath.row];
        cell.model = [[PromotionModel alloc]initWithDictionary:dict];
        return cell;
    }
    else if([_flag isEqualToString:@"领优惠券"])
    {
        TicketDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ticketDetail" forIndexPath:indexPath];
        NSDictionary *dict = _dataArr[indexPath.row];
        cell.model = [[TicketModel alloc]initWithDictionary:dict];
        return cell;
    }
    else
    {
        if(indexPath.section < allkeys.count)
        {
            TextCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"text" forIndexPath:indexPath];
            cell.greyPoint.hidden = YES;
            NSArray *arr = _dataDict[allkeys[indexPath.section]];
            cell.title.font = [UIFont systemFontOfSize:13];
            cell.title.text = arr[indexPath.row];
            cell.title.textAlignment = NSTextAlignmentCenter;
            cell.title.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
         //   cell.title.backgroundColor = [UIColor redColor];
            cell.backgroundColor = RGB(245, 245, 245);
            cell.contentView.layer.cornerRadius = 10;
            cell.layer.cornerRadius = 10;
            return cell;
        }
        else
        {
            PurchaseQuantityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"purchase" forIndexPath:indexPath];
            cell.inputBox.text = @"1";
            tmpTextField = cell.inputBox;
            cell.detialLabel.hidden = YES;
            return cell;
        }
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat myW = self.frame.size.width;
    if([_flag isEqualToString:@"促销"])
    {
        NSDictionary *dict = _dataArr[indexPath.row];
        PromotionModel *model = [[PromotionModel alloc]initWithDictionary:dict];
        NSString *str = model.detail;
        
        NSString *titleStr = model.title;
        CGSize titleSize = [titleStr getStringSize:[UIFont systemFontOfSize:14] width:100];
        CGFloat w = titleSize.width+8+10;
        CGSize size = [str getStringSize:[UIFont systemFontOfSize:13] width:myW-w];
        return CGSizeMake(myW, size.height+12+12);
    }
    else if ([_flag isEqualToString:@"领优惠券"])
    {
        return CGSizeMake(myW-20, 86);
    }
    else
    {
        if(indexPath.section < allkeys.count)
        {
            NSArray *arr = _dataDict[allkeys[indexPath.section]];
            NSString *str  = arr[indexPath.row];
            CGSize size = [str getStringSize:[UIFont systemFontOfSize:13] width:myW-20];
            return  CGSizeMake(size.width+25, size.height+15);
        }
        else
        {
            return CGSizeMake(myW-20, 50);
        }
        
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(width1, 30);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGFloat w = self.frame.size.width;
    if([_flag isEqualToString:@"促销"])
    {
        return CGSizeMake(w, 0.1);
        
    }
    else if([_flag isEqualToString:@"领优惠券"])
    {
        return CGSizeMake(w, 30);
    }
    else
    {
        NSInteger count = _dataDict.allKeys.count;
        if(section < count)
        {
            return CGSizeMake(w, 30);
        }
        else
        {
            return CGSizeMake(w, 0.1);
        }
    }
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    HeaderCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    if([_flag isEqualToString:@"促销"])
    {
        view.editBtn.hidden = YES;
        //  NSDictionary *dict = [sectionArr objectAtIndex:indexPath.section];
        view.title.text = @"hhhh";
    }
    else if([_flag isEqualToString:@"领优惠券"])
    {
        view.editBtn.hidden = YES;
      //  NSDictionary *dict = [sectionArr objectAtIndex:indexPath.section];
        view.title.text = @"可领优惠券";
        
    }
    else
    {
      //  NSArray *allkeys = _dataDict.allKeys;
        view.editBtn.hidden = YES;
        if(indexPath.section < allkeys.count)
            view.title.text = allkeys[indexPath.section];
    }
    return view;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}
-(void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *dict = [aNotification userInfo];
    NSValue *aValue = [dict objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int h = keyboardRect.size.height;
   // CGFloat y = self.contentOffset.y-h;
    //取得键盘的动画时间，视觉上更连贯
    double duration = [[dict objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if(h > 0)
    {
        [UIView animateWithDuration:duration animations:^{
            CGRect rect = self.frame;
            rect.origin.y = rect.origin.y-h;
            self.frame = rect;
        }];
    }
}
-(void)keyboardWillHiden:(NSNotification *)aNotification
{
    NSDictionary *dict = [aNotification userInfo];
    NSValue *aValue = [dict objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int h = keyboardRect.size.height;
    double duration = [[dict objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        CGRect rect = self.frame;
        rect.origin.y = rect.origin.y+h;
        self.frame = rect;
    }];

}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if(tmpTextField)
    {
        [tmpTextField resignFirstResponder];
    }
    //滚回来
    
}
@end

//
//  PromotionDetailCollectionViewCell.m
//  MiningCircle
//
//  Created by ql on 2016/12/8.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "PromotionDetailCollectionViewCell.h"
#import "NSString+Exten.h"
@implementation PromotionDetailCollectionViewCell
{
    UILabel *title;
    UILabel *detail;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor whiteColor];
        title = [[UILabel alloc]init];
        title.textColor = RGB(242, 41, 41);
        title.font = [UIFont systemFontOfSize:12];
        [self addSubview:title];
        detail = [[UILabel alloc]init];
        detail.numberOfLines = 0;
        detail.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        detail.font = [UIFont systemFontOfSize:13];
        [self addSubview:detail];
    }
    return self;
}
-(void)setModel:(PromotionModel *)model
{
    CGFloat w = self.frame.size.width;
    NSString *titleStr = model.title;
    CGSize titleSize = [titleStr getStringSize:[UIFont systemFontOfSize:14] width:100];
    title.frame = CGRectMake(8, 12, titleSize.width, titleSize.height);
    CGFloat detailX = CGRectGetMaxX(title.frame)+10;
    title.text = titleStr;
    title.textAlignment = NSTextAlignmentCenter;
    title.layer.borderWidth = 0.5f;
    title.layer.borderColor = RGB(242, 41, 41).CGColor;
    title.layer.cornerRadius = 2.0f;
    NSString *detailStr = model.detail;
    CGSize detailSize = [detailStr getStringSize:[UIFont systemFontOfSize:13] width:w-detailX-10];
    detail.frame = CGRectMake(detailX, 12,detailSize.width , detailSize.height);
    detail.text = detailStr;
    
    UIView *greyLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-1, w, 1)];
    greyLine.backgroundColor = RGB(240, 240, 240);
    [self addSubview:greyLine];
}
@end

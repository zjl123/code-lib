//
//  PromotionCollectionViewCell.m
//  MiningCircle
//
//  Created by ql on 2016/12/6.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "PromotionCollectionViewCell.h"
#import "NSString+Exten.h"
@interface PromotionCollectionViewCell ()
@property(nonatomic, retain)UILabel *titleLabel;

@end
@implementation PromotionCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor whiteColor];
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = RGB(176, 178, 184);
    }
    return self;
}
-(void)setInfo:(NSArray *)info
{
    _info = info;
    NSString *str = ZGS(@"Gpromotion");
    CGSize titleSize = [str getStringSize:[UIFont systemFontOfSize:13] width:100];
  //  CGFloat height = self.frame.size.height;
    _titleLabel.frame = CGRectMake(8, 8, titleSize.width, titleSize.height);
    _titleLabel.text = str;
    CGFloat titleMidY = CGRectGetMidY(_titleLabel.frame);
    [self addSubview:_titleLabel];
    CGFloat tagX = CGRectGetMaxX(_titleLabel.frame)+10;
    CGFloat tagY;
    NSString *s = @"我";
    CGSize tagSize = [s getStringSize:[UIFont systemFontOfSize:13] width:20];
    tagY =titleMidY - tagSize.height/2;
    for (NSDictionary *dict in info) {
        NSString *tag = dict[@"tag"];
        CGSize size = [tag getStringSize:[UIFont systemFontOfSize:13] width:100];
        UILabel *tagLabel = [[UILabel alloc]initWithFrame:CGRectMake(tagX, tagY, size.width, tagSize.height)];
        tagLabel.textAlignment = NSTextAlignmentCenter;
        tagLabel.text = tag;
        tagLabel.font = [UIFont systemFontOfSize:12];
        tagLabel.textColor = RGB(242, 41, 41);
        tagLabel.layer.borderWidth = 0.5f;
        tagLabel.layer.borderColor = [RGB(242, 41, 41) CGColor];
        
        [self addSubview:tagLabel];
        
        
        NSString *tagDetail = dict[@"tagDetail"];
        
        CGFloat detailX = CGRectGetMaxX(tagLabel.frame)+10;
        CGSize detailSize = [tagDetail getStringSize:[UIFont systemFontOfSize:13] width:width1-detailX-20];
        // CGFloat detailY =(height - detailSize.height)/2;
        //显示单行
        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(detailX, tagY, detailSize.width, tagSize.height)];
        detailLabel.text = tagDetail;
        detailLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:detailLabel];
        tagY = CGRectGetMaxY(tagLabel.frame)+7;
    }
    
    
    
    
    
}
@end

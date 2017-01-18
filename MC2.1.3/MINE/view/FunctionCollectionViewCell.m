//
//  FunctionCollectionViewCell.m
//  MiningCircle
//
//  Created by ql on 15/11/12.
//  Copyright © 2015年 zjl. All rights reserved.
//

#import "FunctionCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "Tool.h"
@implementation FunctionCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"FunctionCollectionViewCell" owner:self options:nil];
        return [nib objectAtIndex:0];
    }
    return self;
    
}
//-(void)layoutSubviews
//{
//    
//
//}
-(void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    _titleName.text = _dict[@"title"];
    _subTitle.text = _dict[@"sub_title"];
    NSString *str = _dict[@"ico"];
    if(str.length > 0)
    {
        _icon.hidden = NO;
        NSURL *url = [NSURL URLWithString:str];
        [_icon sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"gray-mc"]];
    }
    else
    {
        _icon.hidden = YES;
    }
    _redPoint.layer.cornerRadius = 4;
    NSString *key = [NSString stringWithFormat:@"%@",_dict[@"id"]];
    if([[_redDict allKeys] containsObject:key])
    {
        _redPoint.hidden = NO;
    }
    else
    {
        _redPoint.hidden = YES;
    }

}
-(void)drawRect:(CGRect)rect
{
    NSString *label3 = _dict[@"label3"];
    if(label3.length > 0 && label3 != nil)
    {
        [self drawLine];
    }
//    else
//    {
//        [self clearLine];
//    }
//    
}
-(void)clearLine
{
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGFloat w = self.frame.size.width;
    CGRect rect = CGRectMake(w-40, 0, 40, 40);
    CGContextClearRect(ref, rect);
}
-(void)drawLine
{
    CGContextRef ref = UIGraphicsGetCurrentContext();
    
    NSString *bgColor = _dict[@"label3-bk"];
    UIColor *color = [Tool colorFromHexRGB:bgColor :1];
    //画笔颜色
    CGContextSetStrokeColorWithColor(ref, [color CGColor]);
    //填充颜色
    CGContextSetFillColorWithColor(ref, [color CGColor]);
    //线宽
    CGContextSetLineWidth(ref, 1);
    //相交类型
    CGContextSetLineJoin(ref, kCGLineJoinRound);
    //类型
    CGContextSetLineCap(ref, kCGLineCapRound);
   // CGFloat lengths[2] = {5,2};
   // CGContextSetLineDash(ref, 0, lengths, 2);
    //移动到一点
    CGFloat w = self.frame.size.width;
    CGContextMoveToPoint(ref, w-40, 0);
    //画线
    CGContextAddLineToPoint(ref, w, 40);
    CGContextAddLineToPoint(ref, w, 20);
    CGContextAddLineToPoint(ref, w-20, 0);
    CGContextClosePath(ref);
    CGContextDrawPath(ref, kCGPathFillStroke);

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(w-40, 20, 40, 20)];
    label.center = CGPointMake(w-15, 14);
    label.text = _dict[@"label3"];
    NSString *labelColor = _dict[@"label3-color"];
    label.textColor = [Tool colorFromHexRGB:labelColor :1];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    label.transform = CGAffineTransformRotate(label.transform, M_PI_4);
    [self addSubview:label];

}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.redPoint.hidden = YES;
}
@end

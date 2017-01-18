//
//  TicketCollectionViewCell.m
//  MiningCircle
//
//  Created by ql on 2016/12/6.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "TicketCollectionViewCell.h"
#import "NSString+Exten.h"

@interface TicketCollectionViewCell ()
@property(nonatomic, retain)UILabel *titleLabel;
@end
@implementation TicketCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor whiteColor];
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = RGB(176, 178, 184);
//        NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"xib1" owner:self options:nil];
//        return arr[0];
        
    }
    return self;
}
-(void)setInfo:(NSArray *)info
{
    _info = info;
//    self.backgroundColor = [UIColor whiteColor];
//    _titleLabel = [[UILabel alloc]init];
//    _titleLabel.font = [UIFont systemFontOfSize:13];
//    _titleLabel.textColor = RGB(176, 178, 184);
//
    NSString *str = ZGS(@"Gticket");
    CGSize titleSize = [str getStringSize:[UIFont systemFontOfSize:13] width:100];
    CGFloat height = self.frame.size.height;
    _titleLabel.frame = CGRectMake(8, 0, titleSize.width, height);
    _titleLabel.text = str;
    [self addSubview:_titleLabel];
    CGFloat titleMaxX = CGRectGetMaxX(_titleLabel.frame);
    CGFloat labelMinX = titleMaxX+10;
    NSString *flag = @"我";
    CGSize flagSize = [flag getStringSize:[UIFont systemFontOfSize:13] width:100];
    CGFloat gap = 5.0f;
    CGFloat labelY = (height-flagSize.height-gap)/2;
    for (NSDictionary *dict in info) {
        NSString *str = [NSString stringWithFormat:@"满%@减%@",dict[@"total"],dict[@"offSet"]];
        CGSize size = [str getStringSize:[UIFont systemFontOfSize:13] width:width1-titleMaxX];
        if(labelMinX+size.width+15+20 > width1)
        {
            break;
        }
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(labelMinX, labelY, size.width+15, size.height+gap)];
        labelMinX = CGRectGetMaxX(label.frame)+10;
        label.text = str;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = RGB(242, 41, 41);
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:13];
        [self addSubview:label];
    }
    
}

@end

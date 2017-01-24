//
//  TicketDetailCollectionViewCell.m
//  MiningCircle
//
//  Created by ql on 2016/12/6.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "TicketDetailCollectionViewCell.h"

@implementation TicketDetailCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"TicketDetailCollectionViewCell" owner:self options:nil];
       // self.layer.cornerRadius = 10;
        return  arr[0];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(TicketModel *)model
{
    
    _clickLabel.text = @"点击领取";
    _clickLabel.layer.borderWidth = 1.0f;
    _clickLabel.layer.borderColor = [RGB(0, 165, 247) CGColor];
    _clickLabel.layer.cornerRadius = 10.f;
    
    _titleLabel.text = model.title;
    
    _timeLabel.text = model.time;
    
    NSString *str = [NSString stringWithFormat:@"￥%@",model.total];
    NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange range = NSMakeRange(0, 1);
    [mutStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:range];
    _offSetLabel.attributedText = mutStr;
    _totalLabel.text = [NSString stringWithFormat:@"满%@元可用",model.offset];
}
@end

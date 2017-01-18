
//
//  CustomField.m
//  MiningCircle
//
//  Created by ql on 16/8/22.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "CustomField.h"

@implementation CustomField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    //   CGFloat h = self.frame.size.height;
    
}
 */
-(void)setPlaceholder:(NSString *)placeholder
{
//    NSLog(@"ttttt%@",placeholder);
    NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc]initWithString:placeholder];
    [mutStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} range:NSMakeRange(0, mutStr.length)];
    self.attributedPlaceholder = mutStr;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = RGB(234, 234, 234).CGColor;
        self.layer.cornerRadius = self.frame.size.height/2;
    }
    return self;
}
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect rect = bounds;
    rect.origin.x = 10;
    return rect;
}
-(CGRect)textRectForBounds:(CGRect)bounds
{
    bounds.origin.x += 10;
   // NSLog(@",,,,,,%f",bounds.origin.x);
   // NSLog(@".....%f",bounds.size.width);
    bounds.size.width = bounds.size.width - 10;
    return bounds;
    
}
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    return [self textRectForBounds:bounds];
}
@end

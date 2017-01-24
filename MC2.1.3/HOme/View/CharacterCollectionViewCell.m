//
//  CharacterCollectionViewCell.m
//  MiningCircle
//
//  Created by ql on 2016/12/14.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "CharacterCollectionViewCell.h"
#import "NSString+Exten.h"
@implementation CharacterCollectionViewCell
{
    UILabel *label;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor whiteColor];
        label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        [self addSubview:label];
    }
    return self;
}
-(void)setCharacters:(NSDictionary *)characters
{
    _characters = characters;
    label.frame = CGRectMake(10, 0, self.frame.size.width-10, self.frame.size.height);
    NSArray *allkeys = characters.allKeys;
   // NSString *str = @"请选择";
   // NSString *lastStr;
  NSString *aaa =   [allkeys componentsJoinedByString:@","];
    label.text = [NSString stringWithFormat:@"请选择%@",aaa];
    
    

}
-(void)setNum:(NSInteger)num
{
    _num = num;
}
@end

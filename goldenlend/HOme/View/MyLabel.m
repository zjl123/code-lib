//
//  MyLabel.m
//  MiningCircle
//
//  Created by ql on 16/5/26.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "MyLabel.h"
#import "Tool.h"
@implementation MyLabel
-(instancetype)init
{
    self = [super init];
    if(self)
    {
        [self setNumberOfLines:1];
    }
    return self;
}
-(void)setInfo:(NSDictionary *)info
{
    _info = info;
    NSString *str = _info[@"name"];
    CGFloat fontSize = [_info[@"fontSize"] floatValue]+1;
    self.font = [UIFont systemFontOfSize:fontSize];
    self.text = str;
    NSString *tintColor = _info[@"tintColor"];
    if(tintColor.length > 0)
    {
        self.textColor = [Tool colorFromHexRGB:tintColor :1];
    }
    else
    {
        self.textColor = [UIColor whiteColor];
    }
    NSString *bgColor = _info[@"bgColor"];
    if(bgColor.length > 0)
    {
        self.backgroundColor = [Tool colorFromHexRGB:bgColor :[_info[@"alpha"] floatValue]];
    }
    else
    {
        self.backgroundColor = [[UIColor  blackColor] colorWithAlphaComponent:0.5];
    }

}
@end

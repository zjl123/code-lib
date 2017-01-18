//
//  ListCollectionViewCell.m
//  MiningCircle
//
//  Created by ql on 16/4/18.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "ListCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@implementation ListCollectionViewCell

- (void)awakeFromNib {
    
    
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"ListCollectionViewCell" owner:self options:nil];
        return arr[0];
    }
    return self;
}
-(void)setInfo:(NSDictionary *)info
{
    _info = info;
    _title.text = _info[@"name"];
    //_imgView.backgroundColor = [UIColor whiteColor];
    NSString *imgStr = _info[@"img"];
    NSURL *url = [NSURL URLWithString:imgStr];
    [_imgView sd_setImageWithURL:url];

}
@end

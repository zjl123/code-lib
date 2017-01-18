//
//  ActSubTbVIew.m
//  MiningCircle
//
//  Created by ql on 2016/10/19.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "ActSubTbVIew.h"
#import "AddTableViewCell.h"
@implementation ActSubTbVIew

//+(ActSubTbVIew *)shareInstance
//{
//    static ActSubTbVIew *_instance;
//    static dispatch_once_t onceToken;
//    
//    dispatch_once(&onceToken, ^{
//       
//        
//    });
//}
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if(self)
    {
        self.delegate = self;
        self.dataSource = self;
        self.scrollEnabled = NO;
        self.separatorColor = [UIColor blackColor];
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        UINib *nib = [UINib nibWithNibName:@"AddTableViewCell" bundle:nil];
        [self registerNib:nib forCellReuseIdentifier:@"add"];
    }
    return self;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tbArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"add"];
    NSDictionary *dict = [self.tbArr objectAtIndex:indexPath.row];
    cell.info = dict;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.superview.hidden = YES;
    AddTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if([cell.titleVIew.text isEqualToString: ZGS(@"IMAddBlack")])
    {
        [self.jumpDelegate jumpTo:1001];
    }
    else if ([cell.titleVIew.text isEqualToString:ZGS(@"IMRemoveBlack")])
    {
        [self.jumpDelegate jumpTo:1002];
    }
    else
    {
        [self.jumpDelegate jumpTo:indexPath.row];
    }
}

@end

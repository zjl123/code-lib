//
//  SearchView.m
//  MiningCircle
//
//  Created by ql on 16/2/23.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "SearchView.h"
#import "NSString+Exten.h"
#import "PullTableViewCell.h"
@interface SearchView ()<UITextFieldDelegate,UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>

@end
@implementation SearchView
{
    UITableView *tbView;
    UIView *bgView;
    UITapGestureRecognizer *tap;
    NSArray *dataArr;
    CGSize size;
    NSDictionary *searchDict;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.9];
        self.layer.cornerRadius = 15;
        //搜索标志图
        _searchImgView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7, 16, frame.size.height-14)];
        _searchImgView.image = [UIImage imageNamed:@"qiyi_phone_search_edit_left_icon"];
        _searchImgView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_searchImgView];
        
        _categoryBtn = [BgImgButton buttonWithType:UIButtonTypeCustom];
        //分类
        NSString *title = @"交易厅";
         size = [title getStringSize:[UIFont systemFontOfSize:14] width:200];
    //    NSLog(@"%f=====%f",size.width,frame.size.height);
        _categoryBtn.frame = CGRectMake(7, 5, size.width+10, frame.size.height-10);
        // _categoryBtn.backgroundColor = [UIColor greenColor];
        [_categoryBtn setBackgroundImage:[UIImage imageNamed:@"triangle"] forState:UIControlStateNormal];
        [_categoryBtn addTarget:self action:@selector(categoryClick:) forControlEvents:UIControlEventTouchUpInside];
        _categoryBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_categoryBtn setTitleColor:RGB(100, 100, 100) forState:UIControlStateNormal];
        
//        //_categoryBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
//         _categoryBtn.titleLabel.minimumScaleFactor = 0.5;
     //   [_categoryBtn setTitle:title forState:UIControlStateNormal];
        [self refreshData];
        [self addSubview:_categoryBtn];
        _categoryBtn.hidden = YES;

        
        
        CGFloat cateMaxX = CGRectGetMaxX(_searchImgView.frame);
        _searchField = [[UITextField alloc]initWithFrame:CGRectMake(cateMaxX+5, 5, frame.size.width-55, frame.size.height-7)];
        _searchField.tintColor = RGB(36, 157, 238);
        _searchField.returnKeyType = UIReturnKeyDefault;
        _searchField.delegate = self;
        _searchField.textColor = [UIColor blackColor];//RGB(200, 200, 200);
        _searchField.font = [UIFont systemFontOfSize:14];
        NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc]initWithString:ZGS(@"searchTip")];
        
        NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
       // paragraphStyle.alignment = NSTextAlignmentCenter;

        [mutStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGB(133, 133, 133),NSForegroundColorAttributeName,[UIFont systemFontOfSize:14],NSFontAttributeName, paragraphStyle,NSParagraphStyleAttributeName,nil] range:NSMakeRange(0, mutStr.length)];
        _searchField.attributedPlaceholder = mutStr;
        
        //clearButton
        UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        clearBtn.frame = CGRectMake(frame.size.width-27, 2.5, 25, 25);
        [clearBtn addTarget:self action:@selector(clearClick:) forControlEvents:UIControlEventTouchUpInside];
        [clearBtn setBackgroundImage:[UIImage imageNamed:@"qiyi_phone_title_search_delete_btn"] forState:UIControlStateNormal];
        [clearBtn setBackgroundImage:[UIImage imageNamed:@"qiyi_phone_title_search_delete_btn_press"] forState:UIControlStateHighlighted];
        [clearBtn setBackgroundImage:[UIImage imageNamed:@"qiyi_phone_title_search_delete_btn_press"] forState:UIControlStateSelected];
        
        [self addSubview:clearBtn];
        [self addSubview:_searchField];
    }
    return self;
}
-(void)refreshData
{
    NSUserDefaults *userDefault = [NSUserDefaults new];
    dataArr = [userDefault objectForKey:@"searchKey"];
    if(dataArr.count >=1)
    {
        NSDictionary *dict = dataArr[0];
        //   NSLog(@"%@",dict[@"title"]);
        _categoryBtn.searchKey = dict[@"title"];
        self.rescat = dict[@"rescat"];
        
    }

}
-(void)changeFrame
{
    _categoryBtn.hidden = NO;
    _searchImgView.hidden = YES;
    CGFloat MaxX = CGRectGetMaxX(_categoryBtn.frame);
    _searchField.frame = CGRectMake(MaxX+5, 5, self.frame.size.width-55, self.frame.size.height-7);
    
}
-(void)rollBack
{
    _categoryBtn.hidden = YES;
    _searchImgView.hidden = NO;
    CGFloat MaxX = CGRectGetMaxX(_searchImgView.frame);
    _searchField.frame = CGRectMake(MaxX+5, 5, self.frame.size.width-55, self.frame.size.height-7);
}
-(void)categoryClick:(UIButton *)sender
{
   // NSLog(@"切花");
    [self setUpTbVIew];
}

-(void)setUpTbVIew
{
    if(!tbView)
    { 
        
        bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width1, height1)];
        tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBg:)];
        tap.delegate = self;
        [bgView addGestureRecognizer:tap];
        [_controller.view addSubview:bgView];
        CGFloat tbX = CGRectGetMinX(self.frame)+CGRectGetMinX(_categoryBtn.frame);
        CGFloat tbY = CGRectGetMaxY(self.frame)+20;
        tbView = [[UITableView alloc]initWithFrame:CGRectMake(tbX,tbY, size.width+40, dataArr.count*30) style:UITableViewStylePlain];
        [bgView addSubview:tbView];
        tbView.scrollEnabled =  NO;
        tbView.delegate = self;
        tbView.dataSource = self;
        tbView.separatorColor = [UIColor blackColor];
        tbView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        UINib *nib = [UINib nibWithNibName:@"PullTableViewCell" bundle:nil];
        [tbView registerNib:nib forCellReuseIdentifier:@"pull"];
        tbView.hidden = YES;
        
    }
//    CATransition *animation = [CATransition animation];
//    animation.duration = 0.2f;
//    animation.timingFunction = UIViewAnimationCurveEaseInOut;
//    animation.fillMode=  kCATransitionFromRight;
//    [tbView.layer addAnimation:animation forKey:@"animation"];
//    [animation startProgress];
    bgView.hidden = NO;
    tbView.hidden = NO;
    [tbView reloadData];
    

}
-(void)tapBg:(UITapGestureRecognizer *)tapGesture
{
    tapGesture.view.hidden = YES;
    CATransition *animation = [CATransition animation];
    animation.duration = 0.2f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode=  kCATransitionFromRight;
    animation.subtype = kCATransitionReveal;
    [tbView.layer addAnimation:animation forKey:@"animation"];
    tbView.hidden = YES;
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
  //  NSLog(@"cdd");
    //截获手势（解决手势冲突问题）
    if([touch.view.superview isKindOfClass:[UITableViewCell class]])
    {
        return NO;
    }
    else
    {
        return YES;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PullTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pull"];
    UIColor *color = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = color;
    //  NSLog(@"%@",self.navigationItem.tbData);
    NSDictionary *dict = [dataArr objectAtIndex:indexPath.row];
    cell.titleLabel.text = dict[@"title"];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = dataArr[indexPath.row];
    NSString *title = dict[@"title"];
    CGSize fontSzie = [title getStringSize:[UIFont systemFontOfSize:14] width:200];
    CGFloat newW = fontSzie.width+10;
    CGFloat w = CGRectGetWidth(_categoryBtn.frame);
    if(newW != w)
    {
        CGRect rect = _categoryBtn.frame;
        rect.size.width = newW;
        _categoryBtn.frame = rect;
        CGFloat maxX = CGRectGetMaxX(_categoryBtn.frame);
        CGRect rect1 = _searchField.frame;
        rect1.origin.x = maxX+5;
        _searchField.frame = rect1;
        
    }
    _categoryBtn.searchKey = title;
    self.rescat = dict[@"rescat"];
    [self tapBg:tap];
    
}
-(void)clearClick:(UIButton *)btn
{
    _searchField.text = @"";
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *str = textField.text;
    
    if(str.length > 0)
    {
        [self.delegate jumpSearchList:str];
      //  self.delegate = nil;
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.returnKeyType = UIReturnKeySearch;
    [self.delegate jumpSearch];
 //   self.delegate = nil;
}
@end

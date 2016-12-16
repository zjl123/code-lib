//
//  FriendDetailViewController.m
//  MiningCircle
//
//  Created by ql on 16/10/12.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "FriendDetailViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "UIImageView+WebCache.h"
#import "RemarkNameViewController.h"
#import "NSString+Exten.h"
#import "ActSubTbVIew.h"
#import "DataManager.h"
#import "Tool.h"
#import "IMRCChatViewController.h"
#import "PwdEdite.h"
@interface FriendDetailViewController ()<TransformValueDelegate,JumpDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *remarksLabel;
@property (weak, nonatomic) IBOutlet UIView *remarksBg;
- (IBAction)Conversation:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *conversationClick;
@property (weak, nonatomic) IBOutlet UIImageView *headPotrail;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameCenterY;
@property (weak, nonatomic) IBOutlet UIView *whiteBg1;
@property (weak, nonatomic) IBOutlet UILabel *remark1;
@property (weak, nonatomic) IBOutlet UILabel *remark2;
@property (retain, nonatomic) NSArray *tbArr;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@end

@implementation FriendDetailViewController
{
    BOOL _isRefresh;
    UIView *bgView;
    ActSubTbVIew *tbView;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.remarksLabel.text = ZGS(@"IMRemarkTip");
    [self.conversationClick setTitle:ZGS(@"IMMessage") forState:UIControlStateNormal];
    self.conversationClick.layer.cornerRadius = 3;
    _isRefresh = NO;
    NSURL *url = [NSURL URLWithString:_model.portraitUri];
    [self.headPotrail sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"contact"]];
    [self isremark];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.remarksBg addGestureRecognizer:tap];
    //更多
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 30);
    [btn setImage:[UIImage imageNamed:@"detail"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    [self blackOrnot];
}
-(void)blackOrnot
{
    NSString *str;
    
    if(([_model.status integerValue]&4)  == 4)
    {
        str = ZGS(@"IMRemoveBlack");
        _tipLabel.hidden = NO;
        _tipLabel.text = ZGS(@"IMBlockTip");
    }
    else
    {
       str = ZGS(@"IMAddBlack");
        _tipLabel.hidden = YES;
    }
    self.tbArr = @[@{@"title":str,@"ico":@""},@{@"title":ZGS(@"delete"),@"ico":@""}];
    tbView.tbArr = _tbArr;
    [tbView reloadData];
}
-(void)rightClick:(UIButton *)sender
{
    //资料设置
    if(!tbView)
    {
        bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width1, height1)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBg:)];
        tap.delegate = self;
        [bgView addGestureRecognizer:tap];
        /////////////////////////////////////////////
        [self.tabBarController.view insertSubview:bgView belowSubview:sender];
        tbView = [[ActSubTbVIew alloc]initWithFrame:CGRectMake(width1*2/3-30,20+self.navigationController.navigationBar.frame.size.height, width1/3+30, self.tbArr.count*44) style:UITableViewStylePlain];
        tbView.jumpDelegate = self;
        tbView.tbArr = _tbArr;
        tbView.hidden = YES;
        [bgView addSubview:tbView];
        
    }
    sender.selected = YES;
    CATransition *animation = [CATransition animation];
    animation.duration = 0.2f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode=  kCATransitionFromRight;
    [tbView.layer addAnimation:animation forKey:@"animation"];
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
#pragma -mark JumpDelegate
-(void)jumpTo:(NSInteger)tag
{
    if(tag == 1001)
    {
       //加入黑名单
        NSString *msg = ZGS(@"IMBlockTip");
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:ZGS(@"IMAddBlack") message:msg delegate:self cancelButtonTitle:ZGS(@"cancle") otherButtonTitles:ZGS(@"ok"), nil];
        alertView.tag = 511;
        [alertView show];
    }
    else if (tag == 1)
    {
       //删除
        NSString *msg = [NSString stringWithFormat:ZGS(@"IMDeleTip"),_model.name];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:ZGS(@"delete") message:msg delegate:self cancelButtonTitle:ZGS(@"cancle") otherButtonTitles:ZGS(@"delete"), nil];
        alertView.tag = 510;
        [alertView show];
    }
    else if (tag == 1002)
    {
        [self removeBlackList];
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // NSLog(@"%@",[touch.view.superview class]);
    // NSLog(@"%@",[gestureRecognizer.view class]);
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

-(void)isremark
{
    if (_model.remarksName.length > 0) {
        
        _name.hidden = YES;
        _remark1.hidden = NO;
        _remark2.hidden = NO;
        _remark1.text = _model.remarksName;
        _remark2.text = [NSString stringWithFormat:ZGS(@"IMRemark"),_model.name];
        
    }
    else
    {
        _remark1.hidden = YES;
        _remark2.hidden = YES;
        _name.hidden = NO;
        self.name.text = _model.name;
    }

}
-(void)tap:(UIGestureRecognizer *)gesture
{
    RemarkNameViewController *remarkVC = [[RemarkNameViewController alloc]initWithNibName:@"RemarkNameViewController" bundle:nil];
    remarkVC.userid = _model.userId;
    if(_model.remarksName.length > 0)
    {
        remarkVC.remarkFieldTip = _model.remarksName;
    }
    else
    {
        remarkVC.remarkFieldTip = _model.name;
    }
    _isRefresh = YES;
    remarkVC.transDelegate = self;
    [self.navigationController pushViewController:remarkVC animated:YES];
}
-(void)transformValues:(NSString *)value
{
    _model.remarksName = value;
    [self isremark];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 510&&buttonIndex == 1)
    {
        //删除
        [self deleteFriend];
    }
    else if (alertView.tag == 511&&buttonIndex == 1)
    {
        //黑名单
        [self addBlackList];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)Conversation:(id)sender {
    IMRCChatViewController *conversation = [[IMRCChatViewController alloc]init];
    conversation.conversationType = ConversationType_PRIVATE;
    conversation.targetId = _model.userId;
    [self.navigationController pushViewController:conversation animated:YES];
}
#pragma -mark 删除好友
-(void)deleteFriend
{
   // AFHTTPSessionManager *manager = [DataManager shareHTTPRequestOperationManager];
    NSString *selfId = [DEFAULT objectForKey:@"userid"];
   
    NSString *getUrl = [NSString stringWithFormat:@"%@rongyun.do?deleteFriend&sourceUserId=%@&targetUserId=%@",MAINURL,selfId,_model.userId];
    [[DataManager shareInstance]ConnectServer:getUrl parameters:nil isPost:NO result:^(NSDictionary *resultBlock) {
        NSInteger code = [resultBlock[@"code"] integerValue];
        if(code == 200)
        {
            NSMutableArray *arr = [NSMutableArray arrayWithArray:[Tool readFileFromPath:@"friend"]];
            for (NSDictionary *dict in arr) {
                if([_model.userId isEqualToString:dict[@"userId"]])
                {
                    [arr removeObject:dict];
                    break;
                }
            }
            [self.freshDelegate refresh:YES andNewData:arr];
            NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(thread) object:nil];
            [thread start];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:ZGS(@"IMDeleFailed") delegate:self cancelButtonTitle:ZGS(@"ok") otherButtonTitles:nil, nil];
            [alertView show];
        }
        
        

    }];
}
#pragma -mark 添加黑名单
-(void)addBlackList
{
    NSString *selfId = [DEFAULT objectForKey:@"userid"];
    NSString *getUrl = [NSString stringWithFormat:@"%@rongyun.do?addBlackUser&sourceUserId=%@&targetUserId=%@",MAINURL,selfId,_model.userId];
    [[DataManager shareInstance]ConnectServer:getUrl parameters:nil isPost:NO result:^(NSDictionary *resultBlock) {
        NSInteger code = [resultBlock[@"code"] integerValue];
        if(code == 200)
        {
            [self.freshDelegate refresh:YES andNewData:nil];
            NSThread *thread1 = [[NSThread alloc]initWithTarget:self selector:@selector(thread1) object:nil];
            [thread1 start];
            _tipLabel.hidden = NO;
            _tipLabel.text = ZGS(@"IMBlockTip");
            _model.status = @"4";
            [self blackOrnot];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:ZGS(@"IMBlockFailed") delegate:self cancelButtonTitle:ZGS(@"ok") otherButtonTitles:nil, nil];
            [alertView show];
        }
        

    }];

}
#pragma -mark 移出黑名单
-(void)removeBlackList
{
    //AFHTTPSessionManager *manager = [DataManager shareHTTPRequestOperationManager];
    NSString *selfId = [DEFAULT objectForKey:@"userid"];
    NSString *getUrl = [NSString stringWithFormat:@"%@rongyun.do?userRemoveBlack&sourceUserId=%@&targetUserId=%@",MAINURL,selfId,_model.userId];
    [[DataManager shareInstance]ConnectServer:getUrl parameters:nil isPost:NO result:^(NSDictionary *resultBlock) {
        NSInteger code = [resultBlock[@"code"] integerValue];
        if(code == 200)
        {
            [self.freshDelegate refresh:YES andNewData:nil];
            NSThread *thread2 = [[NSThread alloc]initWithTarget:self selector:@selector(thread2) object:nil];
            [thread2 start];
            _tipLabel.hidden = YES;
            _model.status = @"1";
            [self blackOrnot];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:ZGS(@"IMRemoveBlockFailed") delegate:self cancelButtonTitle:ZGS(@"ok") otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];
    
    
//    [manager GET:getUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        // NSLog(@"%@",dict);
//        dict = [PwdEdite decoding:dict];
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];

}
-(void)thread2
{
    //移出黑名单
    NSMutableArray *mutArr = [NSMutableArray arrayWithArray:[Tool readFileFromPath:@"friend"]];
    for (int i = 0; i < mutArr.count; i++) {
        NSDictionary *dict = mutArr[i];
        if([dict[@"userId"] isEqualToString:_model.userId])
        {
            NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:dict];
            [mutDict setObject:@"1" forKey:@"status"];
            [mutArr replaceObjectAtIndex:i withObject:mutDict];
            
            break;
        }

    }
    [Tool writeToFile:mutArr withPath:@"friend"];
}

-(void)thread1
{
    //添加黑名单
    NSMutableArray *mutArr = [NSMutableArray arrayWithArray:[Tool readFileFromPath:@"friend"]];
//    for (NSDictionary *dict in mutArr) {
//        static int i = 0;
//        if([dict[@"userId"] isEqualToString:_model.userId])
//        {
//            NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:dict];
//            [mutDict setObject:@"4" forKey:@"status"];
//            [mutArr replaceObjectAtIndex:i withObject:mutDict];
//            
//            break;
//        }
//        i++;
//    }
    for (int i = 0; i < mutArr.count; i++) {
        NSDictionary *dict = mutArr[i];
        if([dict[@"userId"] isEqualToString:_model.userId])
        {
            NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:dict];
            [mutDict setObject:@"4" forKey:@"status"];
            [mutArr replaceObjectAtIndex:i withObject:mutDict];
            
            break;
        }
    }
    
    
    [Tool writeToFile:mutArr withPath:@"friend"];
}
-(void)thread
{
    //读好友列表
    NSMutableArray *mutArr = [NSMutableArray arrayWithArray:[Tool readFileFromPath:@"friend"]];
    for (NSDictionary *dict in mutArr) {
        if([dict[@"userId"] isEqualToString:_model.userId])
        {
            [mutArr removeObject:dict];
            break;
        }
    }
    [Tool writeToFile:mutArr withPath:@"friend"];
}
@end

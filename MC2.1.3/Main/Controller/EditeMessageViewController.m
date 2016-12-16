//
//  EditeMessageViewController.m
//  MiningCircle
//
//  Created by ql on 16/1/11.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "EditeMessageViewController.h"
#import "DataManager.h"
@interface EditeMessageViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *phoneNums;
@property (weak, nonatomic) IBOutlet UITextView *content;

@end

@implementation EditeMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = ZGS(@"SMessage");
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 32)];
    [btn setTitle:ZGS(@"send") forState:UIControlStateNormal];
    [btn setTitle:ZGS(@"send") forState:UIControlStateSelected];
    [btn setTitleColor:RGB(164, 164, 164) forState:UIControlStateNormal];
    [btn setTitleColor:RGB(164, 164, 164) forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rigntItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rigntItem;
    _content.delegate = self;
    _phoneNums.layer.borderWidth = 1.0f;
    _phoneNums.layer.borderColor = [[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.8] CGColor];
    _phoneNums.layer.cornerRadius = 2;
    
    _content.layer.borderWidth = 1.0f;
    _content.layer.borderColor = [[UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:0.8] CGColor];
    _content.layer.cornerRadius = 2;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSMutableString *mutStr = [NSMutableString string];
    for (NSString *name in _nameArr) {
        [mutStr appendFormat:@"%@;",name];
    }
    self.phoneNums.text = mutStr;
    self.content.text = _msg;
}
-(void)btnClick:(UIButton *)btn
{
    [self postToService];
}
-(void)postToService
{
   // AFHTTPSessionManager *manager = [DataManager shareHTTPRequestOperationManager];
    NSUserDefaults *userDefault = [NSUserDefaults new];
    NSString *tk = [userDefault objectForKey:@"tk"];
    NSString *str = [NSString stringWithFormat:@"%@&tk=%@&content=%@&lstmobiles=",_urlStr,tk,_msg];
    NSMutableString *mutString = [[NSMutableString alloc]initWithString:str];
    for (int i = 0; i < _phoneArr.count; i++) {
        [mutString appendFormat:@"%@,%@,",_phoneArr[i],_nameArr[i]];
    }
  //  NSLog(@"%@",mutString);
    mutString =(NSMutableString *) [mutString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[DataManager shareInstance]ConnectServer:STRURL parameters:nil isPost:YES result:^(NSDictionary *resultBlock) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"sendSuc") delegate:self cancelButtonTitle:nil otherButtonTitles:ZGS(@"ok"), nil];
        [alert show];
    }];
    
    
    
    
    
//    [manager POST:STRURL parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"sendSuc") delegate:self cancelButtonTitle:nil otherButtonTitles:ZGS(@"ok"), nil];
//        [alert show];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
    
    
//    [manager POST:mutString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"sendSuc") delegate:self cancelButtonTitle:nil otherButtonTitles:ZGS(@"ok"), nil];
//        [alert show];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([@"n" isEqualToString:text])
    {
        return NO;
    }
    return YES;
}
#pragma -mark 点击空白处收回键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.phoneNums resignFirstResponder];
    [self.content resignFirstResponder];
    
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

@end

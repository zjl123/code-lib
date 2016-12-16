//
//  FeedBackViewController.m
//  MiningCircle
//
//  Created by zjl on 15/8/21.
//  Copyright (c) 2015年 zjl. All rights reserved.
//

#import "FeedBackViewController.h"
#import "DataManager.h"
#import "PwdEdite.h"
@interface FeedBackViewController () <UIAlertViewDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
- (IBAction)commit:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;

@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = ZGS(@"feedback");
    self.placeHolderLabel.text = ZGS(@"suggesttip");
    [_commitBtn setTitle:ZGS(@"submit") forState:UIControlStateNormal];
    [_commitBtn setTitle:ZGS(@"submit") forState:UIControlStateSelected];
    _textView.delegate = self;
    

}
-(void)postSuggest
{
   
 
    NSDictionary *paramers = [[NSDictionary alloc]initWithObjectsAndKeys:@"feedback",@"cmd",self.textView.text,@"msg",@"0",@"type", nil];
    //NSDictionary *params = [PwdEdite ecoding:dict];
   // AFHTTPSessionManager *manager = [DataManager shareHTTPRequestOperationManager];
    [[DataManager shareInstance]ConnectServer:STRURL parameters:paramers isPost:YES result:^(NSDictionary *resultBlock) {
        int ret = -1;
        if ([resultBlock count] > 0) {
            ret = [[resultBlock objectForKey:@"ret"] intValue];
        }
        if(ret == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"thanks") delegate:self cancelButtonTitle:nil otherButtonTitles:ZGS(@"ok"), nil];
            [alert show];
            alert.delegate = self;
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:ZGS(@"alert") message:ZGS(@"exception") delegate:self cancelButtonTitle:nil otherButtonTitles:ZGS(@"ok"), nil];
            [alert show];
            
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (![_textView.text isEqualToString:@""])
    {
        _placeHolderLabel.hidden = YES;
    }
    if ([_textView.text isEqualToString:@""])
    {
        _placeHolderLabel.hidden = NO;
    }
    
    if (![_textView.text isEqualToString:@""])
    {
        _placeHolderLabel.hidden = YES;
    }
    if ([_textView.text isEqualToString:@""])
    {
        _placeHolderLabel.hidden = NO;
    }
    
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textView resignFirstResponder];
}
- (IBAction)commit:(id)sender {
    
    
    [self postSuggest];
}
@end

//
//  NickNameViewController.m
//  MiningCircle
//
//  Created by ql on 16/7/1.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "NickNameViewController.h"
#import "ImgButton.h"
@interface NickNameViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nickName;

@end

@implementation NickNameViewController
{
    UIView *hudView;
    ImgButton *saveBtn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = ZGS(@"alertName");
    self.nickName.text = self.nameStr;
    [self.nickName becomeFirstResponder];
    [self.nickName addTarget:self action:@selector(textFieldEditChange:) forControlEvents:UIControlEventEditingChanged];
    
    //保存按钮
    saveBtn = [ImgButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(0, 0, 50, 32);
    saveBtn.title = ZGS(@"save");
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    saveBtn.layer.cornerRadius = 2;
    saveBtn.backgroundColor = MAINCOLOR;
    saveBtn.userInteractionEnabled = NO;
    [saveBtn addTarget:self action:@selector(saveName:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //遮罩
    hudView = [[UIView alloc]initWithFrame:saveBtn.frame];
    hudView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    [saveBtn addSubview:hudView];
}
-(void)textFieldEditChange:(UITextField *)theTextField
{
    NSLog( @"text changed: %@", theTextField.text);
    if(hudView)
    {
        [hudView removeFromSuperview];
        hudView = nil;
    }
    saveBtn.userInteractionEnabled = YES;
}
-(void)saveName:(ImgButton *)sender
{
   // NSLog(@"fwavawvawv");
    if(self.nickDelegate && [self.nickDelegate conformsToProtocol:@protocol(NickNameDelegate)])
    [self.nickDelegate modifyName:self didFinished:self.nickName.text];
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

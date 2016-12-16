//
//  ShowTextViewController.m
//  MiningCircle
//
//  Created by ql on 16/9/27.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "ShowTextViewController.h"

@interface ShowTextViewController ()

@end

@implementation ShowTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _textLabel.text = _msg;
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

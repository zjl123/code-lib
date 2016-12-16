//
//  WebViewController.m
//  MiningCircle
//
//  Created by zhanglily on 15/9/25.
//  Copyright (c) 2015年 zjl. All rights reserved.
//
#import "WebViewController.h"
#import "GreyView.h"
#import "ActivityView.h"
#import "UIWebView+Addition.h"
#import "ShareView.h"
#import "ImgButton.h"
#import "NSString+Exten.h"
@interface WebViewController () <UIWebViewDelegate>
{
    
   // GreyView *view;
  //  ActivityView *activity;
    UIButton *backBtn;
    UIButton *closeBtn;
    UIButton *shareBtn;
   // UILabel *label;
}

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setHidesBackButton:YES];
    self.navigationController.navigationBar.topItem.title = @"";
    

    web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, width1, height1-self.navigationController.navigationBar.frame.size.height-StatuesHeight)];
    web.delegate = self;
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(7, 4, 30, 36);
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
   // backBtn.imageView.backgroundColor = [UIColor yellowColor];
    backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
 //   backBtn.backgroundColor = [UIColor greenColor];
    [backBtn addTarget:self action:@selector(leftBtnclick:) forControlEvents:UIControlEventTouchUpInside];
    [web.scrollView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:web];
    closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setTitle:ZGS(@"close") forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    CGSize closeSize = [ZGS(@"close") getStringSize:[UIFont systemFontOfSize:18] width:100];
  //  closeBtn.backgroundColor = [UIColor redColor];
    closeBtn.frame = CGRectMake(39, 7, closeSize.width, 30);
   // closeBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [closeBtn addTarget:self action:@selector(leftCloseBtnclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:closeBtn];
    [self.navigationController.navigationBar addSubview:backBtn];
    CGFloat labelx = CGRectGetMaxX(closeBtn.frame);
    
   //SearchView

    SearchView *searchView = [self.navigationController.navigationBar viewWithTag:711];
    if(searchView.hidden == YES || !searchView)
    {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(labelx+10, 2, (width1/2-labelx)*2, 40)];
        _label.textColor = [UIColor whiteColor];
        _label.minimumScaleFactor = 0.5;
        [self.navigationController.navigationBar addSubview:_label];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    closeBtn.hidden = YES;
    backBtn.hidden = YES;
    _label.hidden = YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    closeBtn.hidden = YES;
    backBtn.hidden = NO;
    _label.hidden = NO;
}
-(void)leftBtnclick:(UIButton *)item
{
     SearchView *searchView = [self.navigationController.navigationBar viewWithTag:711];
    if(searchView && searchView.hidden == NO)
    {
        if(web.canGoBack)
        {
            [web goBack];
            closeBtn.hidden = YES;
        }
        else
        {
            UIButton *btn = (UIButton *)[self.navigationController.navigationBar viewWithTag:888];
            if(self.navigationController.viewControllers.count <=2)
            {
                btn.hidden = NO;
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
        }

    }
    else
    {
        if(web.canGoBack)
        {
            [web goBack];
            closeBtn.hidden = NO;
        }
        else
        {
            UIButton *btn = (UIButton *)[self.navigationController.navigationBar viewWithTag:888];
            if(self.navigationController.viewControllers.count <=2)
            {
                btn.hidden = NO;
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void)leftCloseBtnclick:(UIBarButtonItem *)item
{
    UIButton *btn = (UIButton *)[self.navigationController.navigationBar viewWithTag:888];
    if(self.navigationController.viewControllers.count <=2)
    {
        btn.hidden = NO;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self activituStartShow];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
  //  if(view !=nil)
  ///  {
        [_activity removeFromSuperview];
        [_greyView removeFromSuperview];
        _greyView = nil;
 //   }
    _label.text = [web pageTitle];
    
    _label.lineBreakMode = NSLineBreakByTruncatingTail;
    _label.textAlignment = NSTextAlignmentCenter;

    
}
-(void)activityStopShow
{
  //  if(view !=nil)
  //  {
        [_activity stopAnimating];
        [_greyView removeFromSuperview];
        _greyView = nil;
  //  }
}
-(void)activituStartShow
{
    if(!_greyView)
    {
        _greyView = [[GreyView alloc]init];
        _greyView.frame = CGRectMake(0, 0, 80, 80);
        _greyView.center = CGPointMake(width1/2, height1/2-80);
        [self.view addSubview:_greyView];
        _activity = [[ActivityView alloc]init];
        _activity.frame = CGRectMake(0, 0, 50, 50);
        _activity.center = _greyView.center;
        [self.view addSubview:_activity];
        [_activity startAnimating];
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(activityStopShow) userInfo:nil repeats:NO];
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

@end

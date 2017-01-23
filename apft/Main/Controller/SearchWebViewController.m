//
//  SearchWebViewController.m
//  MiningCircle
//
//  Created by ql on 16/7/29.
//  Copyright © 2016年 zjl. All rights reserved.
//

#import "SearchWebViewController.h"

@interface SearchWebViewController ()<UIGestureRecognizerDelegate>

@end

@implementation SearchWebViewController
{
    BOOL isHidden;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  //  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleBordered target:self action:@selector(backToRoot:)];
    //加一个手势，右滑回到根视图
    SearchView *searchView = [self.navigationController.navigationBar viewWithTag:711];
    if(searchView.hidden == NO)
    {
        isHidden = NO;
        searchView.delegate = self;
        searchView.searchField.text = self.searchStr;
        //  searchView.searchField.delegate = searchView;
    }
    else
    {
        isHidden = YES;
    }

    
    
}
-(void)backToRoot:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;
    NSString *strUrl = url.absoluteString;
    if([strUrl rangeOfString:@".do?o="].location != NSNotFound)
    {
        [self jump:strUrl];
        return NO;
    }
    return YES;
}
-(void)jump:(NSString *)href
{
    BannerDetailViewController *banner = [[BannerDetailViewController alloc]init];
    banner.herfStr = href;
    banner.searchStr = self.searchStr;
    [self.navigationController pushViewController:banner animated:YES];
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

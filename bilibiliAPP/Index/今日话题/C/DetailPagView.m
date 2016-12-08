//
//  DetailPagView.m
//  导航滑动
//
//  Created by imac on 15/10/23.
//  Copyright (c) 2015年 Big Nerd Ranch. All rights reserved.
//

#import "DetailPagView.h"
#import "MBProgressHUD.h"

@interface DetailPagView () <UIWebViewDelegate>{
    MBProgressHUD *hub;
    UIWebView *webView;
}


@end

@implementation DetailPagView


- (void)viewDidLoad {
    [super viewDidLoad];
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    webView.backgroundColor = [UIColor lightGrayColor];
    webView.scrollView.bounces = NO;
    NSURL *url = [NSURL URLWithString:self.link];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    webView.delegate = self ;
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    hub = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hub];
    
    webView.userInteractionEnabled = YES;
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    [webView addGestureRecognizer:swipe];
    
}

//平扫的动作
- (void)swipeAction:(UISwipeGestureRecognizer *)sender {
    
    // 清扫手势 四个方向
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"向右清扫");
    [UIView animateWithDuration:.35 animations:^{
            CGAffineTransform newTransform = CGAffineTransformMakeScale(.8, .8);
            [webView setTransform:newTransform];    }
                         completion:^(BOOL finished){
                             [UIView animateWithDuration:.25 animations:^{
                                 [webView setAlpha:0];
                             } completion:^(BOOL finished){
                                 [webView removeFromSuperview]; }];
                         }];
        [self performSelector:@selector(dismissView) withObject:nil afterDelay:.65];
    }
}

-(void)dismissView{
    [self.navigationController popViewControllerAnimated:YES];

}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    [hub showAnimated:YES];
    
}

-(void) webViewDidFinishLoad:(UIWebView *)webView {
    [hub removeFromSuperview];
}

-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [hub removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

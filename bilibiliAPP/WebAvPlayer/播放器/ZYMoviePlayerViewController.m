//
//  ZYMoviePlayerViewController.m
//  导航滑动
//
//  Created by imac on 15/11/2.
//  Copyright (c) 2015年 Big Nerd Ranch. All rights reserved.
//

#import "ZYMoviePlayerViewController.h"

@interface ZYMoviePlayerViewController ()

@end

@implementation ZYMoviePlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
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

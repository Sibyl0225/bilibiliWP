//
//  MyHomePage.m
//  BiliBili
//
//  Created by imac on 15/10/16.
//  Copyright © 2015年 徐志远. All rights reserved.
//

#import "MyHomePage.h"

@interface MyHomePage ()

@end

@implementation MyHomePage

- (void)viewDidLoad {
    [super viewDidLoad];
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    [self.view addGestureRecognizer:swipe];
}
//平扫的动作
- (void)swipeAction:(UISwipeGestureRecognizer *)sender {
    
    // 清扫手势 四个方向
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"向右清扫");
        [UIView animateWithDuration:.25 animations:^{
            CGAffineTransform newTransform = CGAffineTransformMakeScale(1.2, 1.2);
            [self.view setTransform:newTransform];    }
                         completion:^(BOOL finished){
                             [UIView animateWithDuration:.35 animations:^{
                                 CGAffineTransform newTransform = CGAffineTransformMakeScale(0.3, 0.3);
                                 [self.view setTransform:newTransform];
                             } completion:^(BOOL finished){
                                 //                                 [self.view removeFromSuperview];
                             }];
                         }];
        [self performSelector:@selector(dismissView) withObject:nil afterDelay:.65];
    }
}

-(void)dismissView{
    
    [self.navigationController popViewControllerAnimated:YES];
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

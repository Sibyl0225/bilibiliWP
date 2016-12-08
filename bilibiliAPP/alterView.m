//
//  alterView.m
//  bilibiliAPP
//
//  Created by MAC on 9/9/16.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "alterView.h"
#import "MyLayout.h"


#define key_window [[UIApplication sharedApplication].delegate window]

@implementation alterView


- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    UIView *newView = [UIView new];
    CGFloat rateWidth = 7;
    CGFloat rateheight = 5;
    newView.backgroundColor = RandomColor;
    newView.clipsToBounds = YES;
    newView.size = CGSizeMake(kSWidth*(rateWidth - 2)/rateWidth, kSHeight*(rateheight - 2)/rateheight);
    newView.left = kSWidth/rateWidth;
    newView.top = kSHeight/rateheight;
    newView.layer.cornerRadius = 5.0f;
    
    MyLinearLayout *leftGroundView = [[MyLinearLayout alloc]initWithOrientation:MyLayoutViewOrientation_Vert];
    leftGroundView.size = CGSizeMake(newView.width/2, newView.height - 45 - 25);
    leftGroundView.left = 0;
    leftGroundView.top = 25;
    [newView addSubview:leftGroundView];
    
    MyLinearLayout *rightGroundView = [[MyLinearLayout alloc]initWithOrientation:MyLayoutViewOrientation_Vert];
    rightGroundView.size = CGSizeMake(newView.width/2, newView.height - 45 - 25);
    rightGroundView.left = newView.width/2;
    rightGroundView.top = 25;
    [newView addSubview:rightGroundView];
    
    for (int i = 0; i<10; i++) {
        UIView *newView = [UIView new];
        newView.backgroundColor = RandomColor;
        newView.size = CGSizeMake(100, 30);
        newView.myTopMargin = 10;
        
        if (i%2==0) {
            newView.myLeftMargin = 20;
            [leftGroundView addSubview:newView];
        }else{
            newView.myLeftMargin = 20;
            [rightGroundView addSubview:newView];
        }

    }
    
    UIButton *button = [[UIButton alloc]init];
    button.backgroundColor = RandomColor;
    button.size = CGSizeMake(CGRectGetWidth(newView.bounds), 45);
    button.top = CGRectGetHeight(newView.bounds) - 45;
    button.left = 0;
    [button setTitle:@"选择" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [newView addSubview:button];
    
    [key_window addSubview:newView];
}


@end

//
//  MasonryPriorityTest.m
//  bilibiliAPP
//
//  Created by MAC on 7/11/16.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "MasonryPriorityTest.h"

@implementation MasonryPriorityTest


- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"MasonryPriorityTest";
    self.view.backgroundColor = [UIColor blackColor];
    
    
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:@"这个需要扩展全" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:button];
    
    [self.view addSubview:button];
    
    UILabel *lable = [[UILabel alloc]init];
    lable.text = @"知乎是一个真实的网络问答社区,社区氛围友好与理性,连接各行各业的精英。用户分享着彼此的专业知识、经验和见解,为中文互联网源源不断地提供高质量的信息。";
    lable.textColor = [UIColor greenColor];
    lable.font = [UIFont systemFontOfSize:14];
    lable.numberOfLines = 1;
    [self.view addSubview:lable];
    
    
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.view).offset(150);
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lable).offset(0);
        make.right.equalTo(self.view).offset(-15);
        make.left.equalTo(lable.mas_right).offset(10);
    }];
}


@end

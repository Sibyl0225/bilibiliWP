//
//  testViewController.m
//  bilibiliAPP
//
//  Created by MAC on 1/9/16.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "testViewController.h"

#define ScrWidth kScreenWidth

#define ScrHeight kScreenHeight

@interface testViewController ()<UITableViewDelegate ,UITableViewDataSource>

@property (nonatomic ,strong) UIButton *lastButton;

@property (nonatomic ,strong) UIView *tagView;

@property (nonatomic ,strong) UIView *currentTableView;

@end

@implementation testViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"测试页面";
    self.view.backgroundColor = [UIColor whiteColor];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    UIView *BGView = [UIScrollView new];
    BGView.backgroundColor = [self randomColor];
    BGView.size = CGSizeMake(ScrWidth, 64);
    BGView.left = 0;
    BGView.top = 0;
    [self.view addSubview:BGView];

    
    UIButton *musicButton = [[UIButton alloc]init];
    musicButton.size = CGSizeMake(ScrWidth/2, 60);
    musicButton.left = 0;
    musicButton.top = 0;
    musicButton.tag = 100;
    [musicButton setTitle:@"音乐" forState:UIControlStateNormal];
    [musicButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [musicButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    musicButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [musicButton addTarget:self action:@selector(changeButtonSelectStatus:) forControlEvents:UIControlEventTouchUpInside];
    musicButton.selected = YES;
    [BGView addSubview:musicButton];
    self.lastButton = musicButton;
    
    UIButton *videoButton = [[UIButton alloc]init];
    videoButton.size = CGSizeMake(ScrWidth/2, 60);
    videoButton.left = ScrWidth/2;
    videoButton.top = 0;
    [videoButton setTitle:@"视频" forState:UIControlStateNormal];
    [videoButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [videoButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    videoButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [videoButton addTarget:self action:@selector(changeButtonSelectStatus:) forControlEvents:UIControlEventTouchUpInside];
    videoButton.selected = NO;
    [BGView addSubview:videoButton];
    
    UIView *tagView = [UIView new];
    tagView.backgroundColor = [self randomColor];
    tagView.size = CGSizeMake(ScrWidth/2, 4);
    tagView.left = 0;
    tagView.top = 60;
    [BGView addSubview:tagView];
    self.tagView = tagView;
    
    
    UITableView *tableView = [UITableView new];
    tableView.size = CGSizeMake(ScrWidth, ScrHeight - 64 - 64);
    tableView.left = 0;
    tableView.top = 64;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [UIView new];
    self.currentTableView = tableView;
    
    [self.view addSubview:tableView];
    
    UIView *clearView = [UIView new];
    clearView.backgroundColor = [UIColor clearColor];
    clearView.size = CGSizeMake(ScrWidth, ScrHeight - 64 - 64);
    clearView.left = 0;
    clearView.top = 64;
    [self.view addSubview:clearView];
    
    
    UISwipeGestureRecognizer *rightswipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    [rightswipe setDirection:UISwipeGestureRecognizerDirectionRight];
    
    UISwipeGestureRecognizer *leftswipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    [leftswipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    [clearView addGestureRecognizer:rightswipe];
    
    [clearView addGestureRecognizer:leftswipe];

    

}

//平扫的动作
- (void)swipeAction:(UISwipeGestureRecognizer *)recognizer {
    
    // 清扫手势 四个方向
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"向右清扫");
        [UIView animateWithDuration:.25 animations:^{
            self.currentTableView.right = ScrWidth*2;
            self.currentTableView.alpha = 0.1;
        }completion:^(BOOL finished){
            self.currentTableView.right = 0;
            self.currentTableView.alpha = 0.9;
            [UIView animateWithDuration:.35 animations:^{
                self.currentTableView.right = ScrWidth;
                self.currentTableView.alpha = 1;
            }];
        }];
    }
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft){
        NSLog(@"向左清扫");
        [UIView animateWithDuration:.25 animations:^{
            self.currentTableView.left = - ScrWidth;
            self.currentTableView.alpha = 0.1;
        }completion:^(BOOL finished){
            self.currentTableView.left = ScrWidth;
            self.currentTableView.alpha = 0.9;
            [UIView animateWithDuration:0.35 animations:^{
                self.currentTableView.left = 0;
                self.currentTableView.alpha = 1;
            }];
        }];
    }
    
//    if(recognizer.direction==UISwipeGestureRecognizerDirectionDown) {
//        
//        NSLog(@"swipe down");
//        //执行程序
//    }
//    if(recognizer.direction==UISwipeGestureRecognizerDirectionUp) {
//        
//        NSLog(@"swipe up");
//        //执行程序
//    }
//    
//    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
//        
//        NSLog(@"swipe left");
//        //执行程序
//    }
//    
//    if(recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
//        
//        NSLog(@"swipe right");
//        //执行程序
//    }
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.backgroundColor = [self randomColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)changeButtonSelectStatus:(UIButton *)button{
    if ([button isEqual:self.lastButton]) {
        
    }else{
        
        button.selected = !button.selected;
        self.lastButton.selected = !self.lastButton.selected;
        
        self.lastButton = button;
    }
    
    CGFloat contentOffSetX;
    if (button.tag == 100) {
        contentOffSetX = 0;
    }else{
        contentOffSetX = ScrWidth/2;
    }
    
    [UIView animateWithDuration:0.35 animations:^{
        self.tagView.left = contentOffSetX;
    }];

}

- (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

@end

//
//  ViewController.m
//  bilibiliAPP
//
//  Created by MAC on 16/4/12.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "ViewController.h"

#import "NewAnimatList.h"
#import "MyHomePageView.h"
#import "BiliBiliIndex.h"
#import "RecomView.h"
#import "TodayTopicView.h"



@interface ViewController ()<UIScrollViewDelegate>{
    int currentOffSetX;
    int currentPag;
    int tag;
    int NexPag;
    int PerPag;
}
@property (strong,nonatomic) UIScrollView *TopScroView;
@property (strong,nonatomic) UIScrollView *ContentScroView;
@property (strong,nonatomic) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBarHidden = YES;
    NSArray *titleArray = @[@"新番列表",@"我的主页",@"精彩推荐",@"新番推荐",@"今日话题"];
    self.dataArray = [NSArray arrayWithArray:titleArray];
    self.title  = @"主页";
    tag = 0;
    self.pag = 2;
    [self creatScroView];
    [self creatButton:titleArray];
    [self creatContentView:titleArray];
    
}

-(void)creatScroView{
    self.TopScroView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 24, kSWidth, 40)];
    self.TopScroView.backgroundColor = [UIColor lightGrayColor];
   // self.TopScroView.bounces = NO;
    self.TopScroView.showsVerticalScrollIndicator = NO;
    self.TopScroView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.TopScroView];
    
    self.ContentScroView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.TopScroView.bottom, kSWidth, kSHeight - 64)];
    self.ContentScroView.pagingEnabled = YES;
    self.ContentScroView.showsVerticalScrollIndicator = NO;
    self.ContentScroView.showsHorizontalScrollIndicator = NO;
    self.ContentScroView.delegate = self;
    self.ContentScroView.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:self.ContentScroView];
}

-(void)creatButton:(NSArray *)array{
    int sum  =  0;
    
    for (int i = 0 ; i < array.count + 3; i ++) {
        
        NSString *str;
        if (i < array.count) {
            str = [NSString stringWithFormat:@"%@",array[i]];
        }else{
            str = [NSString stringWithFormat:@"%@",array[i - array.count]];
        }
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(sum, 0, str.length * 25, 40)];
        NSLog(@"%d",sum);
        
        sum += (str.length * 25);
        [button setTitle:str forState:UIControlStateNormal];
        button.tag = 100 + i;
        [button setTitleColor:[UIColor colorWithRed:0.24 green:0.74 blue:0.87 alpha:1.00] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(topBarAction:) forControlEvents:UIControlEventTouchDown];
        [self.TopScroView addSubview:button];
    }
    UIButton *lastButtom = (UIButton *)[self.TopScroView viewWithTag:100 + array.count + 2 ];
    self.TopScroView.contentSize = CGSizeMake(lastButtom.right + 10, 20);
    UIButton *fristBut = [self.TopScroView  viewWithTag:100+self.pag];
    [self.TopScroView setContentOffset:CGPointMake(fristBut.left, 0)];
    
}

-(void)creatContentView:(NSArray *)array{
    
    int viewtag;
    viewtag = (int)self.pag + 200;
    UIView *view ;
    switch (viewtag) {
        case 200: {
            NewAnimatList *listView = [[NewAnimatList alloc]initWithFrame:CGRectMake(kSWidth * 0, 0, kSWidth, kSHeight -64)];
            view = listView;
        }
            break ;
        case 201: {
            MyHomePageView *myHomeView = [[MyHomePageView alloc]initWithFrame:CGRectMake(kSWidth * 1, 0, kSWidth, kSHeight -64)];
            view = myHomeView;
        }
            break ;
        case 202: {
            BiliBiliIndex *indexView = [[BiliBiliIndex alloc]initWithFrame:CGRectMake(kSWidth * 2, 0, kSWidth, kSHeight -64)];
            view = indexView;
        }
            break ;
        case 203: {
            RecomView *reComView = [[RecomView alloc]initWithFrame:CGRectMake(kSWidth * 3, 0, kSWidth, kSHeight -64)];
            view = reComView;
        }
            break ;
        case 204: {
            TodayTopicView *todayTopic = [[TodayTopicView alloc]initWithFrame:CGRectMake(kSWidth * 4, 0, kSWidth, kSHeight -64)];
            view = todayTopic;
        }
            break ;
            
        default:
            break;
    }
    view.tag = viewtag;
    [self.ContentScroView addSubview:view];
    [self.ContentScroView setContentOffset:CGPointMake(view.left, 0) animated:NO];
    self.ContentScroView.contentSize = CGSizeMake(kSWidth * array.count , kSHeight - 40 - 64 );
}


//开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;{
//    currentOffSetX = self.ContentScroView.contentOffset.x;
//    currentPag = (currentOffSetX /kSWidth);
//    NexPag = currentPag + 1;
//    PerPag = currentPag - 1;
    
//    if (PerPag < 0) {
//        PerPag = (int)self.dataArray.count - 1;
//    }
//    if (NexPag > self.dataArray.count) {
//        NexPag = 0;
//    }
    //  NSLog(@"scrollViewWillBeginDragging——开始拖拽");
}

//在滚动
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    
    //     NSLog(@"scrollViewDidScroll——在滚动");
}

//结束拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    currentOffSetX = self.ContentScroView.contentOffset.x;
//    UIButton *lastButtom = (UIButton *)[self.TopScroView viewWithTag:100 + self.dataArray.count - 1 ];
//    //是否越界
//    if (currentOffSetX < -(kSWidth/5)){
//        NSLog(@"%f",kSWidth * (self.dataArray.count - 1));
//        [self.ContentScroView setContentOffset:CGPointMake(kSWidth * (self.dataArray.count - 1) , 0) animated:NO];
//        [self.TopScroView setContentOffset:CGPointMake(lastButtom.left - 10, 0) animated:NO];
//    }
//    if(currentOffSetX > ((self.dataArray.count - 1) * kSWidth  + (kSWidth/5))){
//        NSLog(@"%f",(self.dataArray.count) * kSWidth);
//        [self.ContentScroView setContentOffset:CGPointMake(0 , 0) animated:NO];
//        [self.TopScroView setContentOffset:CGPointMake(0 , 0) animated:NO];
//    }
//    //是否翻页
//    if (currentOffSetX < (currentPag * kSWidth) - (kSWidth/5)){
//        currentPag = PerPag;
//        NSLog(@"上一页");
//        if (currentPag != self.dataArray.count -1) {
//            [self.ContentScroView setContentOffset:CGPointMake(currentPag * kSWidth , 0) animated:NO];
//        }else{
//            [self.ContentScroView setContentOffset:CGPointMake(currentPag * kSWidth, 0) animated:NO];
//        }
//        return;
//    }
//    if(currentOffSetX > (currentPag * kSWidth) + (kSWidth/5) ){
//        currentPag = NexPag;
//        NSLog(@"下一页");
//        if (currentPag!=0) {
//            [self.ContentScroView setContentOffset:CGPointMake(currentPag * kSWidth , 0) animated:NO];
//        }else{
//            [self.ContentScroView setContentOffset:CGPointMake(0, 0) animated:NO];
//        }
//    }
    //  NSLog(@"scrollViewDidEndDragging——结束拖拽");
    
}


//开始降速
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;
{
    
//    currentOffSetX = self.ContentScroView.contentOffset.x;
//    UIButton *lastButtom = (UIButton *)[self.TopScroView viewWithTag:100 + self.dataArray.count - 1 ];
//    //是否越界
//    if (currentOffSetX < -(kSWidth/4)){
//        NSLog(@"%f",kSWidth * (self.dataArray.count - 1));
//        [self.ContentScroView setContentOffset:CGPointMake(kSWidth * (self.dataArray.count - 1) , 0) animated:NO];
//        [self.TopScroView setContentOffset:CGPointMake(lastButtom.left - 10, 0) animated:NO];
//    }
//    if(currentOffSetX > ((self.dataArray.count - 1) * kSWidth  + (kSWidth/4))){
//        NSLog(@"%f",(self.dataArray.count) * kSWidth);
//        [self.ContentScroView setContentOffset:CGPointMake(0 , 0) animated:NO];
//        [self.TopScroView setContentOffset:CGPointMake(0 , 0) animated:NO];
//    }
//    //是否翻页
//    if (currentOffSetX < (currentPag * kSWidth) - (kSWidth/4)){
//        currentPag = PerPag;
//        NSLog(@"上一页");
//        if (currentPag != self.dataArray.count -1) {
//            [self.ContentScroView setContentOffset:CGPointMake(currentPag * kSWidth , 0) animated:NO];
//        }else{
//            [self.ContentScroView setContentOffset:CGPointMake(currentPag * kSWidth, 0) animated:NO];
//        }
//        return;
//    }
//    if(currentOffSetX > (currentPag * kSWidth) + (kSWidth/4) ){
//        currentPag = NexPag;
//        NSLog(@"下一页");
//        if (currentPag!=0) {
//            [self.ContentScroView setContentOffset:CGPointMake(currentPag * kSWidth , 0) animated:NO];
//        }else{
//            [self.ContentScroView setContentOffset:CGPointMake(0, 0) animated:NO];
//        }
//    }
    //   NSLog(@"scrollViewWillBeginDecelerating——开始降速");
    
}

//减速停止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    currentOffSetX = self.ContentScroView.contentOffset.x;
    currentPag = (currentOffSetX /kSWidth);
    UIButton *Button = (UIButton *)[self.TopScroView viewWithTag:currentPag + 100];
    [self.TopScroView setContentOffset:CGPointMake(Button.left - 10 , 0) animated:YES];
    [self creatViewWith:Button];
    NSLog(@"scrollViewDidEndDecelerating——减速停止");
}

-(void)topBarAction:(UIButton *)button{
    long i = button.tag - 100;
    //   NSLog(@"tag:%ld",i);
    if(i != 0 || i < self.dataArray.count ){
        [self.ContentScroView setContentOffset:CGPointMake(kSWidth * i, 0)animated:YES];
        [self.TopScroView setContentOffset:CGPointMake(button.left - 10, 0) animated:YES];
        [self creatViewWith:button];
    }
    
    if(i >= self.dataArray.count){
        [self.ContentScroView setContentOffset:CGPointMake(kSWidth * (i - self.dataArray.count), 0)animated:NO];
        button = (UIButton *)[self.TopScroView viewWithTag:(i - self.dataArray.count)];
        [self.TopScroView setContentOffset:CGPointMake(button.left, 0) animated:NO];
    }
}

-(void)creatViewWith:(UIButton*)sender
{
    long viewtag = 200 + (sender.tag - 100);
    if (viewtag >= 205) {
        viewtag = viewtag - 5 ;
    }
    UIView *contentView = [self.ContentScroView viewWithTag:viewtag];
    if (contentView == nil) {
        UIView *view ;
        switch (viewtag) {
            case 200: {
                 NewAnimatList *listView = [[NewAnimatList alloc]initWithFrame:CGRectMake(kSWidth * 0, 0, kSWidth, kSHeight -64)];
                view = listView;
                }
                break ;
            case 201: {
                MyHomePageView *myHomeView = [[MyHomePageView alloc]initWithFrame:CGRectMake(kSWidth * 1, 0, kSWidth, kSHeight -64)];
                view = myHomeView;
                }
                break ;
            case 202: {
                BiliBiliIndex *indexView = [[BiliBiliIndex alloc]initWithFrame:CGRectMake(kSWidth * 2, 0, kSWidth, kSHeight -64)];
                view = indexView;
                }
                break ;
            case 203: {
                RecomView *reComView = [[RecomView alloc]initWithFrame:CGRectMake(kSWidth * 3, 0, kSWidth, kSHeight -64)];
                view = reComView;
                }
                break ;
            case 204: {
                TodayTopicView *todayTopic = [[TodayTopicView alloc]initWithFrame:CGRectMake(kSWidth * 4, 0, kSWidth, kSHeight -64)];
                view = todayTopic;
                }
                break ;

            default:
                break;
        }
        view.tag = viewtag ;
        NSLog(@"tag : %ld",viewtag);
        [self.ContentScroView addSubview:view];
        [self.ContentScroView setContentOffset:CGPointMake(view.left, 0) animated:NO];
    }
}


@end

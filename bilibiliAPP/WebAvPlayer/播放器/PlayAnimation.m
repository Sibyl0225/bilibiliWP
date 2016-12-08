//
//  PlayAnimation.m
//  导航滑动
//
//  Created by imac on 15/10/31.
//  Copyright (c) 2015年 Big Nerd Ranch. All rights reserved.
//

#import "PlayAnimation.h"
#import "LHWebAVPlayer.h"
#import "LHSortAV.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MoviePlayerViewController.h"

@interface PlayAnimation ()<NSXMLParserDelegate>{
    UIImageView *imageBgV;
}

//解析出得数据，内部是字典类型
@property (strong,nonatomic) NSMutableArray * notes ;

// 当前标签的名字 ,currentTagName 用于存储正在解析的元素名
@property (strong ,nonatomic) NSString * currentTagName ;
@property (strong ,nonatomic) UITextField *avID;
@property (strong ,nonatomic) LHSortAV *sort;
@end

@implementation PlayAnimation

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    imageBgV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [imageBgV setImage:[UIImage imageNamed:@"lunchPage"]];
    [self.view addSubview:imageBgV];
    imageBgV.userInteractionEnabled = YES;
    
    self.avID = [[UITextField alloc] initWithFrame:CGRectMake(20, 150, 200, 40)];
    self.avID.layer.borderWidth = 2;
    [imageBgV addSubview:self.avID];
    self.avID.text = self.avidStr;
    // 头像
    self.DogHeadImageView = [[UIImageView alloc] init];
    self.DogHeadImageView.backgroundColor = [UIColor clearColor];
    self.DogHeadImageView.size = CGSizeMake(50, 50);
    self.DogHeadImageView.left = self.avID.right + 10;
    self.DogHeadImageView.centerY = self.avID.centerY;
    self.DogHeadImageView.layer.cornerRadius = 25.0;
    self.DogHeadImageView.layer.borderWidth = 1.0;
    self.DogHeadImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.DogHeadImageView.layer.masksToBounds = YES;
    self.DogHeadImageView.image = [UIImage imageNamed:@"playBtn"];
    [imageBgV addSubview:self.DogHeadImageView];
    self.DogHeadImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] init];
    singleTapRecognizer.numberOfTapsRequired = 1;
    [singleTapRecognizer addTarget:self action:@selector(PhotoAnimation)];
    [self.DogHeadImageView addGestureRecognizer:singleTapRecognizer];
    
    imageBgV.userInteractionEnabled = YES;
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    [imageBgV addGestureRecognizer:swipe];

}
//平扫的动作
- (void)swipeAction:(UISwipeGestureRecognizer *)sender {
    
    // 清扫手势 四个方向
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"向右清扫");
        [UIView animateWithDuration:.35 animations:^{
            CGAffineTransform newTransform = CGAffineTransformMakeScale(.8, .8);
            [imageBgV setTransform:newTransform];    }
                         completion:^(BOOL finished){
                             [UIView animateWithDuration:.25 animations:^{
                                 [imageBgV setAlpha:0];
                             } completion:^(BOOL finished){
                                 [imageBgV removeFromSuperview]; }];
                         }];
        [self performSelector:@selector(dismissView) withObject:nil afterDelay:.65];
    }
}

-(void)dismissView{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)PhotoAnimation
{
    NSString *avString = [NSString stringWithFormat:@"http://api.bilibili.com/view?type=json&appkey=422fd9d7289a1dd9&id=%@&page=1&rnd=1300",self.avID.text];
    NSURL *url = [NSURL URLWithString:avString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    // 设置超时时间
    request.timeoutInterval = 10;
    
    // 获取session
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        id resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        self.sort = [LHSortAV new];
        NSString *cidString = resultDic[@"cid"];
        NSLog(@"CID : %@    AVID : %@" ,cidString ,self.avidStr);
        self.sort.CID = [NSNumber numberWithInt:[cidString intValue]];
        self.sort.AV = [NSNumber numberWithInt:[self.avidStr intValue]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self xmlWithString:cidString];
//            [self playVideo];
        });
    }];
    
    [task resume];
    
    
}

-(void)xmlWithString:(NSString *) cidString{
    //        @"http://interface.bilibili.com/playurl?cid=4860468&platform=wp8&appkey=422fd9d7289a1dd9"
    NSString *urlString =[NSString stringWithFormat:@"http://interface.bilibili.com/playurl?type=json&cid=%@&platform=wp&appkey=422fd9d7289a1dd9",cidString];
    NSURL *url = [NSURL URLWithString:urlString];
    
    // 2.构造GET请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    // 设置超时时间
    request.timeoutInterval = 10;
    
    // 获取session
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"NSURLResponse : %@",response);
        // 网络请求成功之后 回调block 将数据传递过去
        // 1>解析JSON
//                id resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        // 2>在主线程上回传数据（数据用于刷新UI的）
        dispatch_async(dispatch_get_main_queue(), ^{
            NSXMLParser * parser = [[NSXMLParser alloc] initWithData:data];
            parser.delegate = self ;
            [parser parse];
            NSLog(@"解析搞定...");
            if (self.notes != nil && self.notes.count > 0) {
                [self playVideo];
                NSLog(@"一切正常正在为你加载....");
            } else{
                NSLog(@"很抱歉播放失败！");
            }
        });
        
    }];
    [task resume];
}

- (void)playVideo{
    
    NSString *urlStr= self.notes[0];
//    urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    MoviePlayerViewController *playerViewController =[[MoviePlayerViewController alloc]init];
    playerViewController.url = urlStr;
    [self presentMoviePlayerViewControllerAnimated:playerViewController];
    
//    MoviePlayerViewController* movie = [[MoviePlayerViewController alloc] init];
//    
//    __weak typeof(movie) weakMovie = movie;
//    __weak typeof(self) weakSelf = self;
//    
//    [LHWebAVPlayer getPlayerURL:self.sort backBlock:^(NSArray* arr) {
//        
//        //            NSURL* URL = [NSURL URLWithString:urlString];
//        
//        weakMovie.url = [arr firstObject];
//        
//        weakMovie.danmaku = [NSString stringWithFormat:@"%@",[arr lastObject]];
//        
//        if ([[arr firstObject] length] > 0) {
//            
//            if (weakSelf.presentedViewController == nil) {
//                
//                [weakSelf presentViewController:movie animated:NO completion:nil];
//            }
//        }
//        else {
//            
//            self.view.userInteractionEnabled = YES;
//        }
//        
//    }];
}

-(NSUInteger)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait;
}

//- (void)videoFinished{
//    if (videoRequest) {
//        isPlay = !isPlay;
//        [videoRequest clearDelegatesAndCancel];
//        videoRequest = nil;
//    }
//}



//文档开始时触发 ,开始解析时 只触发一次
-(void)parserDidStartDocument:(NSXMLParser *)parser{
    self.notes = [NSMutableArray new];
}

// 文档出错时触发
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSLog(@"%@",parseError);
}

// 遇到字符串时 触发
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if ([_currentTagName isEqualToString:@"url"]) {
        
        if (string.length > 3) {
            
            NSString *str = @"mp4";
            if ([string rangeOfString:str].location != NSNotFound) {
                NSLog(@"有MP4地址");
                [self.notes addObject:string];
                NSLog(@"%@",string);
            } else{
                NSLog(@"很抱歉没有MP4地址");
            }
        }
        
    }
}

//遇到结束标签触发
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    self.currentTagName = nil ;
    //该方法主要是用来 清理刚刚解析完成的元素产生的影响，以便于不影响接下来解析
}

//遇到一个开始标签触发
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    _currentTagName = elementName ;
    //    NSLog(@"%@",elementName);
}
//文档结束
-(void)parserDidEndDocument:(NSXMLParser *)parser{
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadViewNotification" object:self.notes userInfo:nil];
    //    //进入该方法就意味着解析完成，需要清理一些成员变量，同时要将数据返回给表示层（表示图控制器） 通过广播机制将数据通过广播通知投送到 表示层
    //    self.notes = nil;
}

//-(void)playTheAnimation{
//    //播放
//    [self.moviePlayer play];
//    
//    //添加通知
//    [self addNotification];
//    
//}
//
//-(void)dealloc{
//    //移除所有通知监控
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
//
//-(NSURL *)getNetworkUrl{
//    NSString *urlStr= self.notes[1];
//    urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *url=[NSURL URLWithString:urlStr];
//    return url;
//}
//
////-(NSURL *)getFileUrl{
////    NSString *urlStr=[[NSBundle mainBundle] pathForResource:@"OP.mp4" ofType:nil];
////    NSURL *url=[NSURL fileURLWithPath:urlStr];
////    return url;
////}
//
//-(MPMoviePlayerController *)moviePlayer{
//    if (!_moviePlayer) {
//        NSURL *url=[self getNetworkUrl];
//        _moviePlayer=[[MPMoviePlayerController alloc]initWithContentURL:url];
//        _moviePlayer.view.frame=self.view.bounds;
//        _moviePlayer.view.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//        [self.view addSubview:_moviePlayer.view];
//    }
//    return _moviePlayer;
//}
//
//-(void)addNotification{
//    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
//    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.moviePlayer];
//    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
//    
//}
//
//-(void)mediaPlayerPlaybackStateChange:(NSNotification *)notification{
//    switch (self.moviePlayer.playbackState) {
//        case MPMoviePlaybackStatePlaying:
//            NSLog(@"正在播放...");
//            break;
//        case MPMoviePlaybackStatePaused:
//            NSLog(@"暂停播放.");
//            break;
//        case MPMoviePlaybackStateStopped:
//            NSLog(@"停止播放.");
//            break;
//        default:
//            NSLog(@"播放状态:%li",self.moviePlayer.playbackState);
//            break;
//    }
//}
//
//-(void)mediaPlayerPlaybackFinished:(NSNotification *)notification{
//    NSLog(@"播放完成.%li",self.moviePlayer.playbackState);
//}



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

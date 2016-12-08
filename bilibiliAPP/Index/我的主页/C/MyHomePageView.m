//
//  MyHomePageView.m
//  bilibiliAPP
//
//  Created by MAC on 16/4/12.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "MyHomePageView.h"
#import "MyHomePage.h"
#import "searchViewController.h"

@interface MyHomePageView (){
    BOOL isOpen;
}

@property (nonatomic,strong) UIView *tabBarView;


@end

@implementation MyHomePageView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createdView];
        [self createdTabBarView];
    }
    return self;
}


- (void) createdView{
    
    NSArray *functionArray = [[NSArray alloc] initWithObjects:@"",@"",@"",@"",@"",@"关注动态",@"本地视频",@"",@"收藏夹",@"",@"下载队列",@"",@"播放历史",nil];
    int index = 0 ;
    
    for (int i = 0; i < 2; i ++) {
        for (int j = 0; j < 3; j ++) {
            
            UIButton *homeView = [[UIButton alloc] initWithFrame:CGRectMake(i * (100 + 20) + 40, j * (100 + 20) + 80 , 100, 100)];
            homeView.backgroundColor = [UIColor colorWithRed:217/255.0 green:99/255.0 blue:130/255.0 alpha:1];
           int tag = (i+1)*(j+4);
            //NSLog(@"%d",tag);
            homeView.tag = tag;
            index = tag;
            
            [self addSubview:homeView];
            
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 74 , 80, 20)];
            textLabel.backgroundColor = [ UIColor clearColor];
            textLabel.font = [UIFont boldSystemFontOfSize:20];
            textLabel.textColor = [UIColor whiteColor];
            [homeView addSubview:textLabel];
            
            textLabel.text = functionArray[index];
            if (index == 4) {
                UIImageView *userimage =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
                userimage.image = [UIImage imageNamed:@"userImage"];
                //                userimage.contentMode = UIViewContentModeScaleToFill;
                [textLabel removeFromSuperview];
                [homeView addSubview:userimage];
            }
            [homeView addTarget:self action:@selector(homePagItemChooseAction:) forControlEvents:UIControlEventTouchDown];
        }
    }
    
}

- (void)homePagItemChooseAction:(UIButton *)button{
    if (button.tag == 4) {
        MyHomePage *myDetailPage = [MyHomePage new];
        [self.viewController.navigationController pushViewController:myDetailPage animated:YES];
    }

}

- (void) createdTabBarView{
    _tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0,kSHeight - 64 - 40, kSWidth, 260)];
    _tabBarView.backgroundColor = [UIColor colorWithRed:95/255.0 green:95/255.0 blue:95/255.0 alpha:1];
    
    [self addSubview:_tabBarView];
    //更多详情
    UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(kSWidth - 40 , 0, 40, 40)];
    moreButton.contentEdgeInsets = UIEdgeInsetsMake(5, 0, 0, 0);
    moreButton.backgroundColor = [UIColor clearColor];
    [_tabBarView addSubview: moreButton];
    [moreButton setTitle:@"..." forState:UIControlStateNormal ];
    [moreButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [moreButton addTarget:self action:@selector(showMoreChoose) forControlEvents:UIControlEventTouchUpInside];
    //搜索按钮
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(kSWidth /2 - 20 , 5, 30, 30)];
//    searchButton.backgroundColor = [UIColor whiteColor];
    [_tabBarView addSubview: searchButton];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"SearchReuslt"] forState:UIControlStateNormal];
    searchButton.contentMode = UIViewContentModeScaleAspectFill;
    [searchButton addTarget:self action:@selector(searchAnimateByKeyWords) forControlEvents:UIControlEventTouchUpInside];
    
}



- (void) showMoreChoose {
    
    isOpen = !isOpen;
    CGAffineTransform N;
    if ( isOpen  == YES ) {
        N =CGAffineTransformMakeTranslation( 0, -20);
    } else {
        N = CGAffineTransformIdentity;
    }
    [UIView animateWithDuration:0.1 animations:^{
        _tabBarView.transform = N;
    }];
    
}

- (void) searchAnimateByKeyWords{
    
    searchViewController *seaVC =  [[searchViewController alloc] init];
    
    [self.viewController.navigationController  pushViewController:seaVC animated:YES];
    
}


@end


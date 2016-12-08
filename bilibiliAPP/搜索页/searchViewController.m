//
//  searchViewController.m
//  BiliBili
//
//  Created by imac on 15/9/7.
//  Copyright (c) 2015年 徐志远. All rights reserved.
//

#import "searchViewController.h"
#import "SeachCell.h"
#import "SeachModel.h"
#import "NSDictionary+Tools.h"
#import "NSString+Tools.h"
#import "UIKit+AFNetworking.h"
#import "PlayAnimation.h"

@interface searchViewController ()<UITableViewDelegate ,UITableViewDataSource,UITextFieldDelegate>{
    BOOL isOpen;
    NSMutableArray *HeiDic ;
    SeachCell *TempCell;
    SeachCell *cell;
}
@property (weak, nonatomic) IBOutlet UIView *Navigation;
@property (weak, nonatomic) IBOutlet UITextField *searchInput;
@property (weak, nonatomic) IBOutlet UIButton *seachBegin;
@property (weak, nonatomic) IBOutlet UIView *tabBarView;
@property (weak, nonatomic) IBOutlet UIButton *moreChoose;
@property (strong ,nonatomic) NSMutableArray *dataArray;
@property (assign ,nonatomic) NSInteger *page;

@end
static NSString *cellIndentifer = @"cellIndentifer";

@implementation searchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 0;
    
    [_seachBegin addTarget:self action:@selector(searchWithString:) forControlEvents:UIControlEventTouchUpInside];
    [_moreChoose addTarget:self action:@selector(showMoreChoose) forControlEvents:UIControlEventTouchUpInside];
    HeiDic = [NSMutableArray array];
    self.seachResult.delegate = self;
    self.seachResult.dataSource = self;
    self.searchInput.delegate = self;
    self.seachResult.showsVerticalScrollIndicator = NO;
    [self.seachResult registerClass:[SeachCell class] forCellReuseIdentifier:cellIndentifer];
    TempCell = [[NSBundle mainBundle] loadNibNamed:@"RearchCell" owner:self options:nil].lastObject ;
    self.seachResult.tableFooterView = [[UIView alloc] init];
    _Navigation.userInteractionEnabled = YES;
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    [_Navigation addGestureRecognizer:swipe];

}

- (void) search{

//    NSString *path = [[NSBundle mainBundle] pathForResource:@"searchResulte" ofType:@"json"];
//    self.dataArray = [NSMutableArray array];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//    NSArray *resultArray = resultDic[@"result"];
//    for (NSDictionary *dic in resultArray) {
//        SeachModel *model = [[SeachModel alloc] initWithDictionary:dic];
//        [self.dataArray addObject:model];
//    }
//    [self.seachResult reloadData];
}


- (void) searchWithString:(NSString *)keyWord{
    self.page++;
    keyWord = self.searchInput.text;
    NSLog(@"keyWord : %@",keyWord);
    NSString* rest = [@"" URLEncodedString:keyWord];
    //    NSLog(@"%@",rest);
    NSDictionary* dict = @{ @"keyword" : rest };
    
    NSMutableDictionary* mdic = [dict mutableCopy];
    
    mdic[@"_device"] = @"android";
    mdic[@"_hwid"] = @"831fc7511fa9aff5";
    mdic[@"appkey"] = @"85eb6835b0a1034e";
    mdic[@"bangumi_num"] = @"1";
    mdic[@"build"] = @"408005";
    mdic[@"main_ver"] = @"v3";
    mdic[@"page"] = [NSString stringWithFormat:@"%zd", self.page];
    mdic[@"pagesize"] = @"20";
    mdic[@"platform"] = @"android";
    mdic[@"search_type"] = @"all";
    mdic[@"source_type"] = @"0";
    mdic[@"special_num"] = @"1";
    mdic[@"topic_num"] = @"1";
    mdic[@"upuser_num"] = @"1";
    NSString* basePath = [mdic appendGetSortParameterWithSignWithBasePath:@"http://api.bilibili.cn/search?"];
    
    //        NSLog(@"%@", [NSThread currentThread]);
    NSURL* URL = [NSURL URLWithString:basePath];
    
    
    
    NSURLRequest* request = [NSURLRequest requestWithURL:URL];
    
    UIWebView* webView = [[UIWebView alloc] init];
    
    
    //NSProgress *progress = [NSProgress progressWithTotalUnitCount:0];
    //NSProgress *progress = nil;
    
    [webView loadRequest:request progress:nil  success:^NSString * _Nonnull(NSHTTPURLResponse * _Nonnull response, NSString * _Nonnull HTML) {
        
        if (HTML != nil) {
            
            NSMutableString* str = [NSMutableString stringWithString:HTML];
            
            NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:nil];
            
            NSArray* resultArray = [NSArray arrayWithArray:[[dict valueForKey:@"result"] valueForKey:@"video"]];
//                            NSLog(@"%@", resultArray);
            self.dataArray = [NSMutableArray arrayWithCapacity:resultArray.count];
            for (NSDictionary* dict in resultArray) {
                SeachModel *model = [[SeachModel alloc] initWithDictionary:dict];
                [self.dataArray addObject:model];
            }
            [self.seachResult reloadData];
            
        }
        return HTML;
        
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
    


}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifer];
    if (cell == nil) {
        cell = [[SeachCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifer];
    }
   
    SeachModel *model = self.dataArray[indexPath.row];
    [cell configureCellWithModel:model];
    return cell;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //封面
    UIImageView *imageView = [[UIImageView alloc] init];
    //标题
    UILabel *titleLabel = [[UILabel alloc] init];
    //UP主
    UILabel *UpNameLabel = [[UILabel alloc] init];
    //时间
    UILabel *timeLabel = [[UILabel alloc] init];
    //观看(播放次数)
    UILabel *playLabel = [[UILabel alloc] init];
    //收藏
    UILabel *favoritesLabel = [[UILabel alloc] init];
    //评论
    UILabel *commentLabel = [[UILabel alloc] init];
    //弹幕
    UILabel *midLabel = [[UILabel alloc] init];
    //描述
    UILabel *listDescriptionLabel = [[UILabel alloc] init];

    SeachModel *model = self.dataArray[indexPath.row];
    //赋值
    imageView.image = nil;
    
    titleLabel.text = model.title;
    titleLabel.textColor = [UIColor blueColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    
//    UpNameLabel.text = @"血月此方";
//    UpNameLabel.textColor = [UIColor redColor];
//    UpNameLabel.font = [UIFont boldSystemFontOfSize:16];
//    
//    
//    timeLabel.text = @"2015-10-7 05:39";
//    timeLabel.textColor = [UIColor lightTextColor];
//    timeLabel.font = [UIFont boldSystemFontOfSize:12];
//    
//    playLabel.text = [NSString stringWithFormat:@"播放：3052" ];
//    playLabel.textColor = [UIColor lightGrayColor];
//    playLabel.font = [UIFont boldSystemFontOfSize:12];
//    
//    favoritesLabel.text = [NSString stringWithFormat:@"收藏：2" ];
//    favoritesLabel.textColor = [UIColor lightGrayColor];
//    favoritesLabel.font = [UIFont boldSystemFontOfSize:12];
//    
//    commentLabel.text = [NSString stringWithFormat:@"评论：23" ];
//    commentLabel.textColor = [UIColor lightGrayColor];
//    commentLabel.font = [UIFont boldSystemFontOfSize:12];
//    
//    midLabel.text =[NSString stringWithFormat:@"弹幕：100" ];
//    midLabel.textColor = [UIColor lightGrayColor];
//    midLabel.font = [UIFont boldSystemFontOfSize:12];
    
    listDescriptionLabel.text = model.resultDescription;
    listDescriptionLabel.textColor = [UIColor whiteColor];
    listDescriptionLabel.numberOfLines = 3;
    listDescriptionLabel.font = [UIFont boldSystemFontOfSize:14];
    
    // 位置
    imageView.frame = CGRectMake(10, 5, 100, 70);
    CGFloat labelWidth = (kScreenWidth - imageView.right - 10 - 10) / 2;
    CGSize titleLabelSize = [titleLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth - imageView.right - 10 - 10, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} context:nil].size;
    
    titleLabel.frame = CGRectMake(imageView.right + 10, 0, kScreenWidth - imageView.right - 10 - 10, titleLabelSize.height);
    
    UpNameLabel.frame = CGRectMake(titleLabel.left, titleLabel.bottom, labelWidth, 20);
    
    timeLabel.frame = CGRectMake(UpNameLabel.right, titleLabel.bottom , labelWidth , 20);
    
    playLabel.frame = CGRectMake(titleLabel.left, UpNameLabel.bottom, labelWidth, 20);
    
    favoritesLabel.frame = CGRectMake(playLabel.right ,UpNameLabel.bottom , labelWidth, 20);
    
    commentLabel.frame = CGRectMake(titleLabel.left, playLabel.bottom, labelWidth, 20);
    
    midLabel.frame = CGRectMake(commentLabel.right, playLabel.bottom, labelWidth, 20);
    
    CGSize listDescriptionSize = [listDescriptionLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth - 20, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:listDescriptionLabel.font} context:nil].size;
    listDescriptionLabel.frame = CGRectMake(10, commentLabel.bottom, kScreenWidth - 20, listDescriptionSize.height);
    
   return  listDescriptionLabel.bottom + 5;

}

#pragma mark - TextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self performSelector:@selector(search) withObject:nil];
   return [self.searchInput resignFirstResponder];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PlayAnimation *PAVC =[[PlayAnimation alloc]init];
    SeachModel *model = self.dataArray[indexPath.row];
    PAVC.avidStr =  model.aid;
    PAVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController presentViewController:PAVC animated:YES completion:^{
        NSLog(@"正在为你跳转！");
    }];
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

- (void) showMoreChoose {  //时间差产生的错觉
    isOpen = !isOpen;
    CGAffineTransform N;
    if ( isOpen  == YES ) {
        N =CGAffineTransformMakeTranslation( 0, -200);
    } else {
        N = CGAffineTransformIdentity;
    }
    [UIView animateWithDuration:0.35 animations:^{
        _tabBarView.transform = N;
    }];
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

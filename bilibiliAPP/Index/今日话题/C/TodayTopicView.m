//
//  TodayTopiceView.m
//  bilibiliAPP
//
//  Created by MAC on 16/4/12.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "TodayTopicView.h"
#import "TopicCell.h"
#import "TodayTopicModel.h"
#import "TodayTopicModel.h"
#import "DetailPagView.h"

@interface TodayTopicView ()<UITableViewDelegate , UITableViewDataSource>

@property (strong ,nonatomic) NSMutableArray *dataArray;
@property (strong ,nonatomic) UITableView  *tableView;

@end

@implementation TodayTopicView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatTabelView];
        [self isNetworkReachable];
    }
    return self;
}
#pragma mark - 网络判断
- (void)isNetworkReachable{
    /*
        AFNetworkReachabilityStatusUnknown          = -1,
        AFNetworkReachabilityStatusNotReachable     = 0,
        AFNetworkReachabilityStatusReachableViaWWAN = 1,
        AFNetworkReachabilityStatusReachableViaWiFi = 2,
     */
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        if (status == AFNetworkReachabilityStatusNotReachable) {
            [MBProgressHUD showMessage:@"加载本地数据……"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 几秒后本地加载
                [self getTadayTopicDataFromLocal];
            });
        } else if( status == AFNetworkReachabilityStatusReachableViaWiFi || status == AFNetworkReachabilityStatusReachableViaWWAN){
            [MBProgressHUD showMessage:@"加载网络数据……"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 几秒后网络请求
                [self getTadayTopicDataFromService];
                //隐藏提示框
                [MBProgressHUD hideHUD];
                // 提醒加载数据成功
                [MBProgressHUD showSuccess:@"加载完成！"];
            });
            
        } else if( status == AFNetworkReachabilityStatusUnknown){
        };
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];

}
#pragma mark - 获取本地数据
-(void)getTadayTopicDataFromLocal{
    BOOL isSucceed;
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *JsonPath=[path stringByAppendingPathComponent:@"TadayTopic.json"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:JsonPath] == NO) {
        isSucceed = NO;
    } else{
        NSData *data = [NSData dataWithContentsOfFile:JsonPath];
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        self.dataArray = [NSMutableArray array];
        NSArray *listArray = resultDic[@"list"];
        for (NSDictionary *dic in listArray) {
            TodayTopicModel *model = [[TodayTopicModel alloc] initWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        if (self.dataArray.count > 0) {
            [self.tableView reloadData];
            self.tableView.tableFooterView = [self clickToLoadMore];
            isSucceed = YES;
        } else{
            isSucceed = NO;
        }
    }
    NSString *massage;
    if (isSucceed){
        massage = @"加载完成！";
    } else{
        massage = @"加载失败！";
    }
    //隐藏提示框
    [MBProgressHUD hideHUD];
    // 提醒加载数据成功
    [MBProgressHUD showSuccess:massage];
    
}

#pragma mark - 获取本地数据
-(void)getTadayTopicDataFromService{

     NSString *urlString = @"http://www.bilibili.com/index/slideshow.json";
    [BiliBiliDataService GETRequestWithURLString:urlString completionHandle:^(id resultContent) {
        NSDictionary *resultDic = resultContent;
        NSData *JsonData = [resultDic modelToJSONData];
        self.dataArray = [NSMutableArray array];
        NSArray *listArray = resultDic[@"list"];
        for (NSDictionary *dic in listArray) {
        TodayTopicModel *model = [[TodayTopicModel alloc] initWithDictionary:dic];
                    [self.dataArray addObject:model];
                }
        NSString *massage;
        if (self.dataArray.count > 0) {
            massage = @"加载完成！";
            NSLog(@"%@",[self saveJSONToDisk:JsonData] ? @"Succeed":@"Failed");
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.tableView reloadData];
                    self.tableView.tableFooterView = [self clickToLoadMore];
                });
        } else{
            massage = @"加载失败！";
        }
        //隐藏提示框
        [MBProgressHUD hideHUD];
        // 提醒加载数据成功
        [MBProgressHUD showSuccess:massage];
        
    }];
    
}

#pragma mark - 点击加载更多……
-(UIView *)clickToLoadMore{
    UIView *footerView = [UIView new];
    footerView.frame = CGRectMake(0, 0, kSWidth, 30);
    
    UILabel *loadMoreLabel = [UILabel new];
    [footerView addSubview:loadMoreLabel];
    loadMoreLabel = [UIView_Tools configLabel:loadMoreLabel withtext:@"点击加载更多" withTextColor:MAINCOLOR withTextFont:[UIFont systemFontOfSize:16] withTextAlignment:NSTextAlignmentLeft];
    loadMoreLabel.frame = CGRectMake(15, 5, kSWidth - 30, 20);
    loadMoreLabel.centerY = footerView.centerY;
    
    return footerView;
}

#pragma mark - 存储JSON数据到本地
- (BOOL)saveJSONToDisk:(NSData *)JsonData{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[paths objectAtIndex:0];
    NSLog(@"JsonPath : %@",path);
    NSString *JsonPath=[path stringByAppendingPathComponent:@"TadayTopic.json"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isSucceed;
    if ([fileManager fileExistsAtPath:JsonPath] == NO) {
    //Save To Disk
    isSucceed = [JsonData writeToFile:JsonPath atomically:YES];
    
    } else{
        NSError *error;
        [fileManager removeItemAtPath:JsonPath error:nil];
        if (!error){
        //Save To Disk
          isSucceed = [JsonData writeToFile:JsonPath atomically:YES];
        } else {
        NSLog(@"写入错误原因：%@",error);
        }
    };
    return isSucceed;
}
#pragma mark - 创建表视图
-(void)creatTabelView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSWidth, kSHeight - 66)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
    self.tableView.bounces = NO;
    self.tableView.rowHeight = 140;
    self.tableView.showsVerticalScrollIndicator = NO;
}

#pragma mark - Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TopicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopicCell"];
    if (cell == nil) {
        // 从IB文件加载视图
        [tableView registerNib:[UINib nibWithNibName:@"TopicCell" bundle:nil] forCellReuseIdentifier:@"TopicCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"TopicCell"];
        
    }
    [cell configureCellWithModel:self.dataArray[indexPath.row]];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [cell.BGImage sd_setImageWithURL:[NSURL URLWithString:cell.imageUrl] placeholderImage:[UIImage imageNamed:@"topic"]];
    cell.DetailLabel.text = cell.title;
    cell.DetailLabel.font = [UIFont boldSystemFontOfSize:16];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (kSWidth - 20) / 2;
}
#pragma mark - cell点击效果
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TodayTopicModel *todayTopic = self.dataArray[indexPath.row];
    DetailPagView *detailView = [[DetailPagView alloc]init];
    detailView.link = todayTopic.link;
    if (self.viewController.navigationController) {
        [self.viewController.navigationController pushViewController:detailView animated:YES];
    }else{
        NSLog(@"没有哦 navigationController");
    }

}
@end


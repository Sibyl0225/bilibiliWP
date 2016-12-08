//
//  NewAnimatList.m
//  bilibiliAPP
//
//  Created by MAC on 16/4/12.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "NewAnimatList.h"
#import "ListModel.h"

@interface NewAnimatList ()<UITableViewDataSource ,UITableViewDelegate>{
    NSString  *whichWeek;
    NSString  *whichYestadatWeek;
    NSString  *weekdayStr;
    NSString  *weekdayYestadatStr;
    NSInteger  dataMinute;
    NSInteger  dataHour;
    NSString  *timeStr;
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSArray *sectionArray;
@property (nonatomic, strong) UITableView  *tableView;

@property (nonatomic ,strong) NSMutableArray *Array1; //周一
@property (nonatomic ,strong) NSMutableArray *Array2; //周二
@property (nonatomic ,strong) NSMutableArray *Array3; //周三
@property (nonatomic ,strong) NSMutableArray *Array4; //周四
@property (nonatomic ,strong) NSMutableArray *Array5; //周五
@property (nonatomic ,strong) NSMutableArray *Array6; //周六
@property (nonatomic ,strong) NSMutableArray *Array0; //周日


@end

@implementation NewAnimatList

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatTableView];
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
                [self getNewAnimatListDataFromLocal];
            });
        } else if( status == AFNetworkReachabilityStatusReachableViaWiFi || status == AFNetworkReachabilityStatusReachableViaWWAN){
            [MBProgressHUD showMessage:@"加载网络数据……"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 几秒后网络请求
                [self getNewAnimatListDataFromService];
                //隐藏提示框
                [MBProgressHUD hideHUD];
                // 提醒加载数据成功
//                [MBProgressHUD showSuccess:@"加载完成！"];
            });
            
        } else if( status == AFNetworkReachabilityStatusUnknown){
        };
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
}
#pragma mark - 获取本地数据
-(void)getNewAnimatListDataFromLocal{
    BOOL isSucceed;
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *JsonPath=[path stringByAppendingPathComponent:@"IndexList.json"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:JsonPath] == NO) {
        isSucceed = NO;
    } else{
        NSData *data = [NSData dataWithContentsOfFile:JsonPath];
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        self.dataArray = [NSMutableArray array];
        NSArray *listArray = resultDic[@"list"];

        self.dataArray = [self dataArrayAddObjectWithDict:listArray];
        
        if (self.dataArray.count > 0) {
            [self.tableView reloadData];
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

- (NSMutableArray *)dataArrayAddObjectWithDict:(NSArray *)resultArray{
    
    ListModel *model;
    self.dataArray = [NSMutableArray array];
    NSMutableArray *Array1 = [NSMutableArray array];
    NSMutableArray *Array2 = [NSMutableArray array];
    NSMutableArray *Array3 = [NSMutableArray array];
    NSMutableArray *Array4 = [NSMutableArray array];
    NSMutableArray *Array5 = [NSMutableArray array];
    NSMutableArray *Array6 = [NSMutableArray array];
    NSMutableArray *Array0 = [NSMutableArray array];
    
    for (NSDictionary *dict in resultArray) {
        if ([dict[@"weekday"] intValue] == 1) {
            model = [ListModel modelWithDictionary:dict];
            [Array1 addObject:model];
        }
        if ([dict[@"weekday"] intValue] == 2) {
            model = [ListModel modelWithDictionary:dict];
            [Array2 addObject:model];
        }
        if ([dict[@"weekday"] intValue] == 3) {
            model = [ListModel modelWithDictionary:dict];
            [Array3 addObject:model];
        }
        if ([dict[@"weekday"] intValue] == 4) {
            model = [ListModel modelWithDictionary:dict];
            [Array4 addObject:model];
        }
        if ([dict[@"weekday"] intValue] == 5) {
            model = [ListModel modelWithDictionary:dict];
            [Array5 addObject:model];
        }
        if ([dict[@"weekday"] intValue] == 6) {
            model = [ListModel modelWithDictionary:dict];
            [Array6 addObject:model];
        }
        if ([dict[@"weekday"] intValue] == 0) {
            model = [ListModel modelWithDictionary:dict];
            [Array0 addObject:model];
        }
    }
    [self.dataArray addObjectsFromArray:@[Array1,Array2,Array3,Array4,Array5,Array6,Array0]];
    
    return self.dataArray;
}

#pragma mark - 获取本地数据
-(void)getNewAnimatListDataFromService{
    
    NSString *urlString = @"http://api.bilibili.com/bangumi?type=json&appkey=422fd9d7289a1dd9&btype=2&weekday=0";
    [BiliBiliDataService GETRequestWithURLString:urlString completionHandle:^(id resultContent) {
        NSDictionary *resultDic = resultContent;
        NSData *JsonData = [resultDic modelToJSONData];
        self.dataArray = [NSMutableArray array];
        NSArray *listArray = resultDic[@"list"];
        
        self.dataArray = [self dataArrayAddObjectWithDict:listArray];
        
        NSString *massage;
        if (self.dataArray.count > 0) {
            massage = @"加载完成！";
            NSLog(@"%@",[self saveJSONToDisk:JsonData] ? @"Succeed":@"Failed");
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
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


#pragma mark - 存储JSON数据到本地
- (BOOL)saveJSONToDisk:(NSData *)JsonData{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[paths objectAtIndex:0];
    NSLog(@"JsonPath : %@",path);
    NSString *JsonPath=[path stringByAppendingPathComponent:@"IndexList.json"];
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


- (void)creatTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSWidth, kSHeight - 64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 30.f;
    self.tableView.sectionHeaderHeight = 30.f;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *countArray = self.dataArray[section];
    return countArray.count;
}
//section 的定制
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 30)];
    [sectionView setBackgroundColor:[UIColor whiteColor]];
    //week数组
    NSArray *index = [[NSArray alloc] initWithObjects:@"一", @"二", @"三", @"四", @"五", @"六",@"日", nil];
    //增加UILabel
    UILabel *week = [[UILabel alloc] initWithFrame:CGRectMake(50, - 5, self.width - 150, 40)];
    
    [week setBackgroundColor:[UIColor clearColor]];
    
    week.font = [UIFont boldSystemFontOfSize:16.0f];
    [sectionView addSubview:week];
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width - 75, - 5, 75, 40)];
    [rightLabel setBackgroundColor:[UIColor clearColor]];
    rightLabel.font = [UIFont systemFontOfSize:16.0f];
    rightLabel.textColor = [UIColor redColor];
    rightLabel.textAlignment = NSTextAlignmentLeft;
    [sectionView addSubview:rightLabel];
    
    UILabel *dianLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 6, 18, 18)];
    dianLabel.backgroundColor = [UIColor grayColor];
    [sectionView addSubview:dianLabel];
    
    weekdayStr = [NSString stringWithFormat:@"星期%@",index[section]];
    week.text =  weekdayStr;
    
    if ( [weekdayStr  isEqualToString:whichWeek ]) {
        [week setTextColor:[UIColor redColor]];
        dianLabel.backgroundColor = [UIColor redColor];
        rightLabel.text = @"今天";
    } else {
        [week setTextColor:[UIColor blackColor]];
    }
    
    return sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *AnimatListIdentifier = @"AnimatListIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AnimatListIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    
    if (cell == nil) {
        // 从IB文件加载视图
        NSArray *xibs = [[NSBundle mainBundle] loadNibNamed:@"AnimatList" owner:self options:nil];
        cell = [xibs lastObject];
    }
    
    //查找视图树，获取子视图
    self.sectionArray = self.dataArray[indexPath.section];
    ListModel *animatList = self.sectionArray[indexPath.row];
    
    UIButton *playButton = (UIButton *)[cell.contentView viewWithTag:100];
    UILabel *animatNameLabel = (UILabel *)[cell.contentView viewWithTag:110];
    UILabel *playTimeLabel = (UILabel *)[cell.contentView viewWithTag:120];
    animatNameLabel.text = animatList.title; //标题
    
    NSArray *timeArray =  [animatList.lastupdate_at componentsSeparatedByString:@" "];
    NSString *timeRangeStr = [NSString stringWithFormat:@"%@",timeArray[1]];
    playTimeLabel.text = timeRangeStr;   //最后更新时间
    
    playButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    animatNameLabel.font = [UIFont systemFontOfSize:16.0f];
    playTimeLabel.font = [UIFont systemFontOfSize:14.0f];
    
    if (animatList.new){
            [playButton setTitle:@"新" forState:UIControlStateNormal];
            [playButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [animatNameLabel setTextColor:[UIColor redColor]];
            [playTimeLabel setTextColor:[UIColor redColor]];
        }else {
            [playButton setTitle:@"" forState:UIControlStateNormal];
            [playButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [animatNameLabel setTextColor:[UIColor blackColor]];
            [playTimeLabel setTextColor:[UIColor blackColor]];
        }
    
    return cell;
}

//当前时间
-(void) _requestData{
    
    //获取当前（0时区）时间
    NSDate *now = [NSDate date];
    NSLog(@"now date is: %@", now);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
   // NSInteger year = [dateComponent year];
   // NSInteger month = [dateComponent month];
   // NSInteger day = [dateComponent day];
    dataHour = [dateComponent hour];
    dataMinute = [dateComponent minute];
  //  NSInteger second = [dateComponent second];
    NSInteger weekday = [dateComponent weekday];
    whichWeek = [self whichWeek:weekday];
    whichYestadatWeek =[self whichYestady:weekday];
    //    NSLog(@"今天是：%@ 昨天是：%@", whichWeek,whichYestadatWeek);
    //    NSLog(@"日期: %ld年%ld月%ld日 ", year,month,day);
    //    NSLog(@"时间:   %ld:%ld:%ld", dataHour,dataMinute,second);
    
}
//今天
- (NSString * )whichWeek:(NSInteger)weekDay
{
    switch (weekDay) {
        case 1:
            return @"星期日";
            break;
        case 2:
            return @"星期一";
            break;
        case 3:
            return @"星期二";
            break;
        case 4:
            return @"星期三";
            break;
        case 5:
            return @"星期四";
            break;
        case 6:
            return @"星期五";
            break;
        case 7:
            return @"星期六";
            break;
        default:
            return @"";
            break;
    }
}
//昨天
- (NSString * )whichYestady:(NSInteger) weekDay
{
    switch (weekDay) {
        case 1:
            return @"星期六";
            break;
        case 2:
            return @"星期日";
            break;
        case 3:
            return @"星期一";
            break;
        case 4:
            return @"星期二";
            break;
        case 5:
            return @"星期三";
            break;
        case 6:
            return @"星期四";
            break;
        case 7:
            return @"星期五";
            break;
        default:
            return @"";
            break;
    }
}



@end

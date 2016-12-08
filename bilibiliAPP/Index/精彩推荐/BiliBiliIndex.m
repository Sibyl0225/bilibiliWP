//
//  BiliBiliIndex.m
//  bilibiliAPP
//
//  Created by MAC on 16/4/12.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BiliBiliIndex.h"
#import "NewsCell.h"
#import "indexModel.h"
#import "PlayAnimation.h"
#import "UIImage+Extension.h"

@interface BiliBiliIndex ()<UICollectionViewDelegate ,UICollectionViewDataSource>{
    BOOL  isOpen[30];
}

@property (nonatomic ,strong) UICollectionView *collectionView;

@property (nonatomic ,strong) NewsCell * cell;
@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic ,strong) NSMutableArray *tempArray;

@property (nonatomic ,strong) NSMutableArray *type1;
@property (nonatomic ,strong) NSMutableArray *type3;
@property (nonatomic ,strong) NSMutableArray *type4;
@property (nonatomic ,strong) NSMutableArray *type5;
@property (nonatomic ,strong) NSMutableArray *type11;
@property (nonatomic ,strong) NSMutableArray *type13;
@property (nonatomic ,strong) NSMutableArray *type23;
@property (nonatomic ,strong) NSMutableArray *type36;
@property (nonatomic ,strong) NSMutableArray *type129;
@property (nonatomic ,strong) NSMutableArray *type119;

@property (nonatomic ,strong) NSMutableArray *updateNum;

@property (nonatomic, strong) NSOperationQueue *queue;

@end

static NSString *indentify = @"collectionIndentify";

@implementation BiliBiliIndex

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.dataArray = [NSMutableArray array];
        self.tempArray =[NSMutableArray array];
        [self creatCollectionView];
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
                [self getIndexDataFromLocal];
            });
        } else if( status == AFNetworkReachabilityStatusReachableViaWiFi || status == AFNetworkReachabilityStatusReachableViaWWAN){
            [MBProgressHUD showMessage:@"加载网络数据……"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 几秒后网络请求
                [self getIndexDataFromService];
                //隐藏提示框
                [MBProgressHUD hideHUD];
//                // 提醒加载数据成功
//                [MBProgressHUD showSuccess:@"加载完成！"];
            });
            
        } else if( status == AFNetworkReachabilityStatusUnknown){
        };
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
}

-(void)getIndexDataFromService{
    self.type1   = [NSMutableArray array];
    self.type3   = [NSMutableArray array];
    self.type4   = [NSMutableArray array];
    self.type5   = [NSMutableArray array];
    self.type11  = [NSMutableArray array];
    self.type13  = [NSMutableArray array];
    self.type23  = [NSMutableArray array];
    self.type36  = [NSMutableArray array];
    self.type129 = [NSMutableArray array];
    self.type119 = [NSMutableArray array];
    self.updateNum = [NSMutableArray array];
    
    NSArray *indexArray = @[@"type1",@"type3",@"type4",@"type5",@"type11",@"type13",@"type23",@"type36",@"type129",@"type119"];
    
    NSString *urlString = @"http://api.bilibili.com/index";
    [BiliBiliDataService GETRequestWithURLString:urlString completionHandle:^(id resultContent) {
        NSDictionary *resultDic = resultContent;
        NSData *JsonData = [resultDic modelToJSONData];
        NSMutableArray *dataArray = [NSMutableArray array];
        int index = 0;
        for (NSString *indexStr in indexArray) {
            NSDictionary *type = resultDic[indexStr];
            
            for (NSString *key in [type allKeys]) {
                if ([key isEqualToString:@"num"]) {
                    //  加入到头标数组中
                    [self.updateNum addObject:type[@"num"]];
                }else{
                    NSDictionary *num = type[key];
                    [dataArray addObject:num];
                }
            }
            
            indexModel *modal;
            for (int i = 0; i < dataArray.count; i ++) {
                NSDictionary *subjectDic = dataArray[i];
                modal = [indexModel modelWithDictionary:subjectDic];
                [self.tempArray addObject:modal ];
            }
            [dataArray removeAllObjects];
            
            if (index == 0) {
                _type1 = [self.tempArray mutableCopy];
            }else if (index == 1){
                _type3 = [self.tempArray mutableCopy];
            }
            else if (index == 2){
                _type4 = [self.tempArray mutableCopy];
            }
            else if (index == 3){
                _type5 = [self.tempArray mutableCopy];
            }
            else if (index == 4){
                _type11 = [self.tempArray mutableCopy];
            }
            else if (index == 5){
                _type13 = [self.tempArray mutableCopy];
            }
            else if (index == 6){
                _type23 = [self.tempArray mutableCopy];
            }
            else if (index == 7){
                _type36 = [self.tempArray mutableCopy];
            }
            else if (index == 8){
                _type129 = [self.tempArray mutableCopy];
            }
            else if (index == 9){
                _type119 = [self.tempArray mutableCopy];
            }
            
            [self.tempArray removeAllObjects];
            index ++;
        }
        self.dataArray = [NSMutableArray arrayWithObjects:self.type1,self.type3,self.type4,self.type5,self.type11,self.type13,self.type23,self.type36,self.type129,self.type119, nil];
        
        NSString *massage;
        if (self.dataArray.count > 0) {
            massage = @"加载完成！";
            NSLog(@"%@",[self saveJSONToDisk:JsonData] ? @"Succeed":@"Failed");
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.collectionView reloadData];
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
    NSString *JsonPath=[path stringByAppendingPathComponent:@"BiliBiliIndex.json"];
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

-(void)getIndexDataFromLocal{
    
}

- (UICollectionViewFlowLayout *)createFlowlayout{
    
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
    // flowLayout.minimumInteritemSpacing =10;
    //  flowLayout.minimumLineSpacing = 10;
    float size = (kScreenWidth - 20 - 20 - 10 * 2) / 3;
    flowLayout.itemSize=CGSizeMake(size, 80);
    
    return flowLayout;
}

- (void)creatCollectionView{
    
    self.collectionView  =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 80) collectionViewLayout:[self createFlowlayout]];
    
    self.collectionView.backgroundColor =[UIColor clearColor];
    self.collectionView.bounces = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self addSubview:self.collectionView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"NewsCell" bundle:nil]forCellWithReuseIdentifier:indentify];

}

// 十行
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 10;
}
//每行3个Item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
    
}

//边距调整
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake( 10, 20, 0, 20 );//分别为上、左、下、右
}

//创建单元（Item）
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *ss=@[@"动画",@"音乐舞蹈",@"游戏",@"娱乐",@"电视剧",@"番剧",@"电影",@"科技",@"直播",@"鬼畜"];
    
   NewsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:indentify forIndexPath:indexPath];
    // 第一行赋字
    if (indexPath.row == 0) {
        cell.kindsName.text = ss[indexPath.section];
        cell.kindsName.font = [UIFont systemFontOfSize:18];
        cell.bgImage.image = nil;
    }else if(indexPath.row > 0) {
        if (self.dataArray.count > 0) {
        NSArray *rowArray = self.dataArray[indexPath.section];
        indexModel *modal = rowArray[indexPath.row];
        cell.titleText = modal.title;
        cell.kindsName.text = nil;
        cell.avid = modal.aid;
        [cell.bgImage sd_setImageWithURL:[NSURL URLWithString:modal.pic] placeholderImage:[UIImage imageNamed:@"userImage"]];
        cell.tempImage = cell.bgImage.image;
        }
    }
    
    return cell;

}

//点击后的效果
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NewsCell *cell;
    NSArray *rowArray = self.dataArray[indexPath.section];
    indexModel *model = rowArray[indexPath.row];
    if (indexPath.row != 0 && isOpen[indexPath.row] == NO ) {
        NSLog(@"%ld",indexPath.section);
        cell = (NewsCell *)[collectionView cellForItemAtIndexPath:indexPath];
        float size = (kScreenWidth - 20 - 20 - 10 * 2) / 3;
        UIImage *image = [UIImage imageWithColor:Color(207, 99, 130) withSize:CGSizeMake(size, 80)];
        UIImage *imageLogo = [image watermarkImage:[NSString stringWithFormat:@"%@",model.title]];
        if (cell.bgImage.image != imageLogo) {
            cell.bgImage.image = imageLogo;
            isOpen[indexPath.row] = YES;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 2秒后异步执行这里的代码...
                [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                isOpen[indexPath.row] = NO;
            });
        }
    } else if (isOpen[indexPath.row]){
        
        PlayAnimation *PAVC =[[PlayAnimation alloc]init];
        PAVC.avidStr = model.aid;
        PAVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self.viewController.navigationController presentViewController:PAVC animated:YES completion:^{
            NSLog(@"正在为你跳转！");
        }];
    }else  {
//        cell = (NewsCell *)[collectionView cellForItemAtIndexPath:indexPath];
//        MenuView *menuVC = [[MenuView alloc]init];
//        [self.navigationController   pushViewController:menuVC animated:YES];
    }
}


@end

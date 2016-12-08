//
//  RecomView.m
//  bilibiliAPP
//
//  Created by MAC on 16/4/12.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "RecomView.h"
#import "RecomModel.h"
#import "ReComCollectionCell.h"
#import "BWaterflowLayout.h"

@interface RecomView ()<BWaterflowLayoutDelegate,UICollectionViewDataSource>

@property (strong ,nonatomic) NSMutableArray *dataArray;
@property (strong ,nonatomic) UITableView  *tableView;
@property (strong ,nonatomic) UICollectionView *collectionView;
@property (strong ,nonatomic) ReComCollectionCell *cell;
@end

static NSString *reComCellIndentifier = @"reComCellIndentifier";

@implementation RecomView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = RandomColor;
         [self setupLayout];
         [self getDataFromService];
    }
    return self;
}

- (void)getDataFromService{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"list" ofType:@"json"];
    self.dataArray = [NSMutableArray array];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    self.dataArray = [NSMutableArray array];
    NSArray *listArray = resultDic[@"list"];
    for (NSDictionary *dict in listArray) {
       RecomModel * modal = [[RecomModel alloc] initWithDictionary:dict];
        [self.dataArray addObject:modal];
    }
    [self.collectionView reloadData];
}

- (void)setupLayout {
    //创建布局
    BWaterflowLayout *layout = [[BWaterflowLayout alloc]init];
    
    layout.delegate = self;
    
    //创建CollectionView
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kSWidth, kSHeight - 66) collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:[ReComCollectionCell class] forCellWithReuseIdentifier:reComCellIndentifier];
    
    [self addSubview:self.collectionView];
    
}
#pragma mark - <UICollectionViewDataSource>

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ReComCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reComCellIndentifier forIndexPath:indexPath];
    RecomModel *model = self.dataArray[indexPath.item];
    [cell configModel:model];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

#pragma mark - <BWaterflowLayoutDelegate>

-(CGFloat)waterflowLayout:(BWaterflowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth {
    RecomModel *model = self.dataArray[index];
    return itemWidth * (model.height / model.width);
}
//瀑布流列数
- (CGFloat)columnCountInWaterflowLayout:(BWaterflowLayout *)waterflowLayout {
    return 3;
}
- (CGFloat)columnMarginInWaterflowLayout:(BWaterflowLayout *)waterflowLayout {
    return 10;
    
}
- (CGFloat)rowMarginInWaterflowLayout:(BWaterflowLayout *)waterflowLayout {
    return 10;
    
}
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(BWaterflowLayout *)waterflowLayout {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


@end

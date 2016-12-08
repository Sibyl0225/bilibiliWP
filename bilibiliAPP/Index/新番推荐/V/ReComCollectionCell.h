//
//  ReComCollectionCell.h
//  bilibiliAPP
//
//  Created by MAC on 16/4/24.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RecomModel;
@interface ReComCollectionCell : UICollectionViewCell

@property (strong ,nonatomic)   UIImageView *imageView;
@property (strong ,nonatomic)   UILabel     *titleLabel;
@property (strong ,nonatomic)   RecomModel     *remodel;


-(void)configModel:(RecomModel *)model;


@end

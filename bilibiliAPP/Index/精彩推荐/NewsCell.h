//
//  NewsCell.h
//  BiliBili
//
//  Created by imac on 15/9/9.
//  Copyright (c) 2015年 徐志远. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *kindsName;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (strong, nonatomic) UIImage *tempImage;
@property (nonatomic, strong) NSString *pic; //图片
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) NSString *avid;

@end

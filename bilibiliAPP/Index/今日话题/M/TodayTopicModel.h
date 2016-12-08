//
//  TodayTopicModel.h
//  bilibiliAPP
//
//  Created by MAC on 16/4/12.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayTopicModel : UIView
/**
 *  标题
 */
@property (nonatomic ,copy) NSString *title;
/**
 *  链接
 */
@property (nonatomic ,copy) NSString *link;
/**
 *  图片
 */
@property (nonatomic ,copy) NSString *img;
/**
 *  小图（未使用）
 */
@property (nonatomic ,copy) NSString *simg;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;

- (instancetype)initWithDictionary:(NSDictionary *)dict;


@end

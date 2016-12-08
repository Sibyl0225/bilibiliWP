//
//  RecomModel.h
//  bilibiliAPP
//
//  Created by MAC on 16/4/12.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecomModel : UIView

@property (nonatomic, copy) NSString *imageurl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) float width;
@property (nonatomic, assign) float height;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;

- (instancetype)initWithDictionary:(NSDictionary *) dict;

@end

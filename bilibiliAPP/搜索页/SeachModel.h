//
//  SeachModel.h
//  导航滑动
//
//  Created by imac on 15/10/27.
//  Copyright (c) 2015年 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeachModel : NSObject

@property (nonatomic, strong) NSString *aid;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *author;

@property (nonatomic, strong) NSString *pic;

@property (nonatomic, strong) NSString *typename;
@property (nonatomic, assign) double favorites;
@property (nonatomic, assign) double mid;
@property (nonatomic, assign) double play;

@property (nonatomic, strong) NSString *resultDescription;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

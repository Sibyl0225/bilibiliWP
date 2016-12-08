//
//  TodayTopicModel.m
//  bilibiliAPP
//
//  Created by MAC on 16/4/12.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "TodayTopicModel.h"

@implementation TodayTopicModel

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    if(self) {
        self.title = dict[@"title"];
        self.img = dict[@"img"];
        self.link = dict[@"link"];
        self.simg = dict[@"simg"];
    }
    return self;
}

@end

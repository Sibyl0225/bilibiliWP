//
//  SeachModel.m
//  导航滑动
//
//  Created by imac on 15/10/27.
//  Copyright (c) 2015年 Big Nerd Ranch. All rights reserved.
//

#import "SeachModel.h"

@implementation SeachModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    if(self) {
        self.aid = dict[@"aid"];
        self.title = dict[@"title"];
        self.author = dict[@"author"];
        
        self.pic = dict[@"pic"];
        self.mid = [dict[@"mid"] doubleValue];
        self.favorites = [dict[@"favorites"] doubleValue];
        self.typename = dict[@"typename"];
        self.play = [dict[@"play"] doubleValue];
        
        self.resultDescription = dict[@"description"];
        
    }
    
    return self;
    
}

@end

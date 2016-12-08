//
//  RecomModel.m
//  bilibiliAPP
//
//  Created by MAC on 16/4/12.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "RecomModel.h"

@implementation RecomModel

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if(self) {
        
        self.imageurl = dict[@"imageurl"];
        self.title = dict[@"title"];
        NSString *width = [NSString stringWithFormat:@"%@",dict[@"width"]];
        NSString *height = [NSString stringWithFormat:@"%@",dict[@"height"]];
        if (width.length>0 && height.length > 0) {
            self.width = [width intValue];
            self.height = [height intValue];
        }else{
            self.width = 0;
            self.height = 0;
        }
    }
    
    return self;
    
}

@end

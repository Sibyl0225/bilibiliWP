//
//  BiliBiliDataService.h
//  bilibiliAPP
//
//  Created by MAC on 16/5/9.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BiliBiliDataService : NSObject

+ (void)GETRequestWithURLString:(NSString *)urlString completionHandle:(void (^)(id resultContent))block;

@end

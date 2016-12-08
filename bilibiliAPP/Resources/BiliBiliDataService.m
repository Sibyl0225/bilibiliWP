//
//  BiliBiliDataService.m
//  bilibiliAPP
//
//  Created by MAC on 16/5/9.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "BiliBiliDataService.h"

@implementation BiliBiliDataService

+ (void)GETRequestWithURLString:(NSString *)urlString completionHandle:(void (^)(id responseObject))block{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
         block(responseObject);
        });
    }];
    
    [dataTask resume];

}

@end

//
//  ListModel.h
//  bilibiliAPP
//
//  Created by MAC on 16/4/12.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListModel : UIView

@property (nonatomic ,copy  ) NSString *bgmcount;
@property (nonatomic ,copy  ) NSString *lastupdate_at;
@property (nonatomic ,copy  ) NSString *mcover;
@property (nonatomic ,copy  ) NSString *area;
@property (nonatomic ,copy  ) NSString *title;
@property (nonatomic ,copy  ) NSString *arealimit;
@property (nonatomic ,copy  ) NSString *cover;
@property (nonatomic ,copy  ) NSString *scover;
@property (nonatomic ,assign) BOOL     new;
@property (nonatomic ,assign) long     typeid;
@property (nonatomic ,assign) long     lastupdate;
@property (nonatomic ,assign) long     click;
@property (nonatomic ,assign) long     spid;
@property (nonatomic ,assign) long     priority;
@property (nonatomic ,assign) long     season_id;
@property (nonatomic ,assign) long     areaid;
@property (nonatomic ,assign) long     video_view;
@property (nonatomic ,assign) long     attention;
@property (nonatomic ,assign) long     weekday;

@end

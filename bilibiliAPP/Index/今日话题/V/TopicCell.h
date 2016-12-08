//
//  TopicCell.h
//  BiliBili
//
//  Created by imac on 15/10/16.
//  Copyright © 2015年 徐志远. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TopicList;

@interface TopicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *DetailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *BGImage;

@property (assign, nonatomic) float height;
@property (assign, nonatomic) float width;
@property (assign, nonatomic) NSString *imageUrl;
@property (assign, nonatomic) NSString *title;
@property (assign, nonatomic) NSString *link;

- (void)configureCellWithModel:(TopicList *)modal;

@end

//
//  TopicCell.m
//  BiliBili
//
//  Created by imac on 15/10/16.
//  Copyright © 2015年 徐志远. All rights reserved.
//

#import "TopicCell.h"
#import "TodayTopicModel.h"

@implementation TopicCell

- (void)configureCellWithModel:(TodayTopicModel *)modal {
    
    self.title = modal.title;
    self.imageUrl = modal.img;
    self.link = modal.link;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

//-(void)layoutSubviews{
//    [super layoutSubviews];
//    
//}

@end

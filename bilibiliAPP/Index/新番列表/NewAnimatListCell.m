//
//  NewAnimatListCell.m
//  bilibiliAPP
//
//  Created by MAC on 16/5/9.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "NewAnimatListCell.h"



@implementation NewAnimatListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        [self initSubViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

//- (void)initSubViews{
//
//}

@end

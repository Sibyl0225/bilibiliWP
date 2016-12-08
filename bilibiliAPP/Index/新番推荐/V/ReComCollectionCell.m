//
//  ReComCollectionCell.m
//  bilibiliAPP
//
//  Created by MAC on 16/4/24.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "ReComCollectionCell.h"
#import "RecomModel.h"
#import "BWaterflowLayout.h"
#import "UIImageView+WebCache.h"

@interface ReComCollectionCell()


@end

@implementation ReComCollectionCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}
-(void)initSubView{
    self.imageView = [[UIImageView alloc]init];
    [self addSubview:self.imageView];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    [self addSubview:self.titleLabel];
}

-(void)configModel:(RecomModel *)model{
    _remodel= model;
    self.titleLabel.text = _remodel.title;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_remodel.imageurl] placeholderImage:[UIImage imageNamed:@"default.jpg"]];
    [self layoutIfNeeded];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
    self.titleLabel.frame = CGRectMake(0, self.bounds.size.height  - 15, self.bounds.size.width, 15);
    
}



@end

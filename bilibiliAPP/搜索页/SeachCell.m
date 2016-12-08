//
//  SeachCell.m
//  导航滑动
//
//  Created by imac on 15/10/27.
//  Copyright (c) 2015年 Big Nerd Ranch. All rights reserved.
//

#import "SeachCell.h"
#import "SeachModel.h"

@interface SeachCell(){
    UIImageView *imageView;
    UILabel *titleLabel;
    UILabel *UpNameLabel;
    UILabel *playLabel;
    UILabel *favoritesLabel;
    UILabel *typeNameLabel;
    UILabel *midLabel;
    UILabel *listDescriptionLabel;

}
@end

@implementation SeachCell
- (void)configureCellWithModel:(SeachModel *)modal{
    
    titleLabel.text = modal.title;
    CGSize titleLabelSize = [titleLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth - imageView.right - 10 - 10, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} context:nil].size;
    titleLabel.frame = CGRectMake(imageView.right + 10, 0, kScreenWidth - imageView.right - 10 - 10, titleLabelSize.height);
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:modal.pic] placeholderImage:[UIImage imageNamed:@"userImage"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;

    UpNameLabel.text = [NSString stringWithFormat:@"UP主:%@",modal.author];
    
//        favoritesLabel.text = [NSString stringWithFormat:@"%.f",self.favorites];
    
    typeNameLabel.text = [NSString stringWithFormat:@"类型:%@",modal.typename];;
    favoritesLabel.text =  [NSString stringWithFormat:@"收藏:%.f",modal.favorites];
    midLabel.text =  [NSString stringWithFormat:@"评论:%.f",modal.mid];
    playLabel.text =  [NSString stringWithFormat:@"播放:%.f",modal.play];

    listDescriptionLabel.text = modal.resultDescription;
    
    CGSize listDescriptionSize = [listDescriptionLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth - 20, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:listDescriptionLabel.font} context:nil].size;
    listDescriptionLabel.frame = CGRectMake(10, typeNameLabel.bottom, kScreenWidth - 20, listDescriptionSize.height);
    
    [self layoutIfNeeded];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initSubview];
    }
    return self;
}



-(void)_initSubview{
    //封面
    imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor clearColor];
    [self addSubview:imageView];
    
    //标题
    titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:titleLabel];
    
    //UP主
    UpNameLabel = [[UILabel alloc] init];
    UpNameLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:UpNameLabel];

    
    //观看(播放次数)
    playLabel = [[UILabel alloc] init];
    playLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:playLabel];
    
    //收藏
    favoritesLabel = [[UILabel alloc] init];
    favoritesLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:favoritesLabel];
    
    //评论
    typeNameLabel = [[UILabel alloc] init];
    typeNameLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:typeNameLabel];
    
    //弹幕
    midLabel = [[UILabel alloc] init];
    midLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:midLabel];
    
    //描述
    listDescriptionLabel = [[UILabel alloc] init];
    listDescriptionLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:listDescriptionLabel];
    
    //赋值
//   [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.pic]];
    
    
//    titleLabel.text = self.title;
    titleLabel.textColor = [UIColor blueColor];
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    
//    UpNameLabel.text = self.author;
    UpNameLabel.textColor = [UIColor redColor];
    UpNameLabel.font = [UIFont boldSystemFontOfSize:16];
    
    
    
//    playLabel.text = [NSString stringWithFormat:@"%.f",self.play ];
    playLabel.textColor = [UIColor lightGrayColor];
    playLabel.font = [UIFont boldSystemFontOfSize:12];
    
//    favoritesLabel.text = [NSString stringWithFormat:@"%.f",self.favorites];
    favoritesLabel.textColor = [UIColor lightGrayColor];
    favoritesLabel.font = [UIFont boldSystemFontOfSize:12];
    
//    typeNameLabel.text = self.typename ;
    typeNameLabel.textColor = [UIColor lightGrayColor];
    typeNameLabel.font = [UIFont boldSystemFontOfSize:12];
    
//    midLabel.text =[NSString stringWithFormat:@"%.f",self.mid ];
    midLabel.textColor = [UIColor lightGrayColor];
    midLabel.font = [UIFont boldSystemFontOfSize:12];
    
//    listDescriptionLabel.text = self.resultDescription;
    listDescriptionLabel.textColor = [UIColor blackColor];
    listDescriptionLabel.numberOfLines = 0;
    listDescriptionLabel.font = [UIFont boldSystemFontOfSize:14];
    

}

-(void)layoutSubviews{
    [super layoutSubviews];
    // 位置
    imageView.frame = CGRectMake(10, 5, 120, 70);
    CGFloat labelWidth = (kScreenWidth - imageView.right - 10 - 10) / 2;
    CGSize titleLabelSize = [titleLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth - imageView.right - 10 - 10, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} context:nil].size;
    titleLabel.frame = CGRectMake(imageView.right + 10, 0, kScreenWidth - imageView.right - 10 - 10, titleLabelSize.height);
    
    UpNameLabel.frame = CGRectMake(titleLabel.left, titleLabel.bottom, kSWidth - titleLabel.left - 20, 20);
    
    playLabel.frame = CGRectMake(titleLabel.left, UpNameLabel.bottom, labelWidth, 20);
    
    favoritesLabel.frame = CGRectMake(playLabel.right ,UpNameLabel.bottom , labelWidth, 20);
    
    typeNameLabel.frame = CGRectMake(titleLabel.left, playLabel.bottom, labelWidth, 20);
    
    midLabel.frame = CGRectMake(typeNameLabel.right, playLabel.bottom, labelWidth, 20);
    
    CGSize listDescriptionSize = [listDescriptionLabel.text boundingRectWithSize:CGSizeMake(kScreenWidth - 20, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:listDescriptionLabel.font} context:nil].size;
    listDescriptionLabel.frame = CGRectMake(10, typeNameLabel.bottom, kScreenWidth - 20, listDescriptionSize.height);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

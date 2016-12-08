//
//  UIImage+Extension.m
//  网易新闻
//
//  Created by apple on 14-7-25.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

+ (UIImage *)imageWithColor:(UIColor *)color withSize:(CGSize)itemSize
{
    CGFloat imageW = itemSize.width;
    CGFloat imageH = itemSize.height;
    // 1.开启基于位图的图形上下文     (CGSize size, BOOL opaque(透明), CGFloat scale(缩放))
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
    
    // 2.画一个color颜色的矩形框
    [color set];
    UIRectFill(CGRectMake(0, 0, imageW, imageH));
    
    // 3.拿到图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4.关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}
- (UIImage *)watermarkImage:(NSString *)text{
    
    //1.获取上下文
    
    UIGraphicsBeginImageContext(self.size);
    
    //2.绘制图片
    
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    //3.绘制水印文字
    
    CGRect rect = CGRectMake(5, self.size.height / 10, self.size.width - 10, (4 * self.size.height)/ 5);
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    
    style.alignment = NSTextAlignmentLeft;
    
    //文字的属性
    
    NSDictionary *dic = @{
                          NSFontAttributeName:[UIFont systemFontOfSize:14],
                          NSParagraphStyleAttributeName:style,
                          NSForegroundColorAttributeName:[UIColor whiteColor]
                                                                    };
        
    //将文字绘制上去
        
    [text drawInRect:rect withAttributes:dic];
 
    //4.获取绘制到得图片
 
    UIImage *watermarkImage = UIGraphicsGetImageFromCurrentImageContext();
 
    //5.结束图片的绘制
 
    UIGraphicsEndImageContext();
 
    return watermarkImage;
}

@end

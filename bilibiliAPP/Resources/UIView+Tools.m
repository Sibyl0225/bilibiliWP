//
//  UIView+Tools.m
//  导航滑动
//
//  Created by MAC on 16/5/5.
//  Copyright © 2016年 Big Nerd Ranch. All rights reserved.
//

#import "UIView+Tools.h"

@implementation UIView_Tools

+ (UIView *)configView:(UIView *)view withBackGroundColor:(UIColor *)backGroundColor{
    view.backgroundColor = backGroundColor;
    return view;
}
/**
 *  配置Button
 *
 *  @param button           要配置的Button
 *  @param title            标题
 *  @param titleColor       标题颜色
 *  @param titleFontSize    标题字体
 *  @param borderWidth      边框宽度
 *  @param layerBorderColor 边框颜色
 *  @param radius           边框弧度
 *
 *  @return 配置完成的Button
 */
+ (UIButton *)configButton:(UIButton *)button withTitle:(NSString *)title withTitleColor:(UIColor *)titleColor withTitleFont:(UIFont *)titleFontSize withBorderWidth:(int)borderWidth withBorderColor:(UIColor *)layerBorderColor withCornerRadius:(CGFloat)radius
{
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
     button.titleLabel.font = titleFontSize;
     button.layer.borderWidth = borderWidth;
     button.layer.borderColor = layerBorderColor.CGColor;
     button.layer.cornerRadius = radius;
    
    return button;
}
/**
 *  配置TextField
 *
 *  @param textfield        要配置的TextField
 *  @param placeholder      替位文字
 *  @param textColor        文字颜色
 *  @param titleFontSize    文字字体
 *  @param borderWidth      边框宽度
 *  @param layerBorderColor 边框颜色
 *  @param radius           边框弧度
 *
 *  @return 配置完成的TextField
 */
+ (UITextField *)configTextfield:(UITextField *)textfield withPlaceHolder:(NSString *)placeholder withTextColor:(UIColor *)textColor withTitleFont:(UIFont *)titleFontSize withBorderWidth:(int)borderWidth withBorderColor:(UIColor *)layerBorderColor withCornerRadius:(CGFloat)radius
{
    textfield.placeholder = placeholder;
    textfield.textColor = textColor;
    textfield.font = titleFontSize;
    textfield.layer.borderWidth = borderWidth;
    textfield.layer.borderColor = layerBorderColor.CGColor;
    textfield.layer.cornerRadius = radius;
    
    return textfield;
}
/**
 *  配置Label
 *
 *  @param label         要配置的Label
 *  @param text          要显示的文字
 *  @param textColor     字体颜色
 *  @param textFontSize  字体大小
 *  @param textAlignment 文字位置
 *
 *  @return 配置完成的Label
 */
+ (UILabel *)configLabel:(UILabel *)label withtext:(NSString *)text withTextColor:(UIColor *)textColor withTextFont:(UIFont *)textFontSize withTextAlignment:(NSTextAlignment)textAlignment
{
    label.text = text;
    label.textColor = textColor;
    label.font = textFontSize;
    label.textAlignment = textAlignment;
    
    return label;
}

@end

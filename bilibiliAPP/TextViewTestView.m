//
//  TextViewTestViewController.m
//  bilibiliAPP
//
//  Created by MAC on 10/10/16.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "TextViewTestView.h"
//#import "YYKit.h"
#import "MyView.h"

@interface TextViewTestView ()<UITextViewDelegate>

@property (nonatomic, strong) MyView *textView;

@end

@implementation TextViewTestView


- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    CGRect cellFrame = CGRectMake(5, 0, kSWidth - 10, 100);
    
    self.textView = [[MyView alloc] initWithFrame:cellFrame];
    self.textView.text = @"我的天！";
    self.textView.delegate = self;
    
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.textView.backgroundColor = [UIColor redColor];
    self.textView.font = [UIFont systemFontOfSize:18.0f];
    
    self.textView.placeholder = @"你想输入什么？";
    self.textView.placeholderTextColor = [UIColor blueColor];
    
    self.textView.scrollEnabled = NO;
    self.textView.showsVerticalScrollIndicator = NO;
    self.textView.showsHorizontalScrollIndicator = NO;

    [self.view addSubview:self.textView];
    
    UIButton *button = [[UIButton alloc]init];
    button.size = CGSizeMake(50, 50);
    button.top = self.textView.bottom + 100;
    button.left = 50;
    [button setTitle:@"SSSSSSSS" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor ] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button addTarget:self action:@selector(textRegistFrist) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

}

- (void)textRegistFrist{
    [self.textView resignFirstResponder];
}

- (void)textViewSizeToFits
{
    CGSize oldSize = self.textView.size;
    CGSize newSize = [self.textView sizeThatFits:CGSizeMake(kSWidth - 10, FLT_MAX)];
    if (fabs(newSize.height - oldSize.height) > 0.01)
    {
        [UIView animateWithDuration:.35 animations:^{
            self.textView.size = CGSizeMake(kSWidth - 10, newSize.height);
        }];
    }
}


- (void)textViewDidChange:(UITableView *)textView{
    if ([textView isEqual:self.textView]) {
        [self textViewSizeToFits];
    }
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{

    NSString *finllyString = [self inputString:textView.text stringByReplacingRegex:@"[\n]+" options:NSRegularExpressionCaseInsensitive withString:@"\n"];
    NSLog(@"resultString:%@",finllyString);
    
}

- (NSString *)inputString:(NSString *)inputSting stringByReplacingRegex:(NSString *)regex
                             options:(NSRegularExpressionOptions)options
                          withString:(NSString *)replacement; {
    NSRegularExpression *pattern = [NSRegularExpression regularExpressionWithPattern:regex options:options error:nil];
    if (!pattern) return inputSting;
    return [pattern stringByReplacingMatchesInString:inputSting options:0 range:NSMakeRange(0, [inputSting length]) withTemplate:replacement];
}

//    NSString *searchText = @"// Do any additional setup after \n\n\n\n loading the view,\n\n\n typically from a nib.";
//    NSError *error = NULL;
//
//
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\n]+" options:NSRegularExpressionCaseInsensitive error:&error];
////    NSTextCheckingResult *result = [regex firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
//
//    NSArray *resultArray = [regex matchesInString:searchText options:NSMatchingReportCompletion range:NSMakeRange(0, [searchText length])];
//    if (resultArray.count>0) {
//        [resultArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            NSTextCheckingResult *result = resultArray[idx];
//            NSLog(@"%@",NSStringFromRange(result.range));
//        }];
//    }
//    NSMutableArray *resultRange = [NSMutableArray arrayWithCapacity:resultArray.count];
//    [resultArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSTextCheckingResult *result = resultArray[idx];
//        NSLog(@"%@",NSStringFromRange(result.range));
//        [resultRange addObject:result.range];
//    }];
//
//    [resultRange enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSRange resultRange = resultRange[idx];
//        NSLog(@"%@",NSStringFromRange(result.range));
//        [resultRange addObject:result.range];
//    }];


//    NSString *finllyString = [textView.text stringByReplacingRegex:@"[\n]+" options:NSRegularExpressionCaseInsensitive withString:@"\n"];

//    if (result) {
//        NSLog(@"%@\n", [searchText substringWithRange:result.range]);
//    }

@end

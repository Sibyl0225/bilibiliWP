//
//  erweimaVC.m
//  bilibiliAPP
//
//  Created by MAC on 4/11/16.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "erweimaVC.h"
#import <AVFoundation/AVFoundation.h>

@interface erweimaVC ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong ,nonnull) UIImageView *imageView;

@property (nonatomic, strong) AVCaptureSession *session;

@property(nonatomic,strong) CALayer *layer;

@end

@implementation erweimaVC

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.size = CGSizeMake(200, 200);
        _imageView.center = self.view.center;
        _imageView.backgroundColor = [UIColor purpleColor];
    }
    return _imageView;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    // 1.创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.恢复默认
    [filter setDefaults];
    
    // 3.给过滤器添加数据(正则表达式/账号和密码)
    NSString *dataString = @"http://www.520it.com";
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    
    //因为生成的二维码模糊，所以通过createNonInterpolatedUIImageFormCIImage:outputImage来获得高清的二维码图片
    
    // 5.显示二维码
    self.imageView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];
    
    [self.view  addSubview:self.imageView];
    
}

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

- (void)catchImage{
    
    // 1.创建捕捉会话
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    self.session = session;
    
    // 2.添加输入设备(数据从摄像头输入)
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    [session addInput:input];
    
    // 3.添加输出数据(示例对象-->类对象-->元类对象-->根元类对象)
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [session addOutput:output];
    
    // 3.1.设置输入元数据的类型(类型是二维码数据)
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    // 4.添加扫描图层
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.frame = self.view.bounds;
    [self.view.layer addSublayer:layer];
    self.layer = layer;
    
    // 5.开始扫描
    [session startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count > 0) {
        //获得扫描数据，最后一个时最新扫描的数据
        AVMetadataMachineReadableCodeObject *object = [metadataObjects lastObject];
        NSLog(@"%@", object.stringValue);
        
        // 停止扫描
        [self.session stopRunning];
        
        // 将预览图层移除
        [self.layer removeFromSuperlayer];
    } else {
        NSLog(@"没有扫描到数据");
    }
}

//使用iOS7原生API进行二维码条形码的扫描
//
//IOS7之前，开发者进行扫码编程时，一般会借助第三方库。常用的是ZBarSDK，IOS7之后，系统的AVMetadataObject类中，为我们提供了解析二维码的接口。经过测试，使用原生API扫描和处理的效率非常高，远远高于第三方库。
//
//一、使用方法示例
//
//官方提供的接口非常简单，代码如下：
//
//@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate>//用于处理采集信息的代理
//{
//    AVCaptureSession * session;//输入输出的中间桥梁
//}
//@end
//@implementation ViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view, typically from a nib.
//    //获取摄像设备
//    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    //创建输入流
//    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
//    //创建输出流
//    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
//    //设置代理 在主线程里刷新
//    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
//    
//    //初始化链接对象
//    session = [[AVCaptureSession alloc]init];
//    //高质量采集率
//    [session setSessionPreset:AVCaptureSessionPresetHigh];
//    
//    [session addInput:input];
//    [session addOutput:output];
//    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
//    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
//    
//    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
//    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
//    layer.frame=self.view.layer.bounds;
//    [self.view.layer insertSublayer:layer atIndex:0];
//    //开始捕获
//    [session startRunning];
//}
//之后我们的UI上已经可以看到摄像头捕获的内容，只要实现代理中的方法，就可以完成二维码条形码的扫描：
//
//-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
//    if (metadataObjects.count>0) {
//        //[session stopRunning];
//        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
//        //输出扫描字符串
//        NSLog(@"%@",metadataObject.stringValue);
//    }
//}
//二、一些优化
//
//通过上面的代码测试，我们可以发现系统的解析处理效率是相当的高，IOS官方提供的API也确实非常强大，然而，我们可以做进一步的优化，将效率更加提高：
//
//首先，AVCaptureMetadataOutput类中有一个这样的属性(在IOS7.0之后可用)：
//
//@property(nonatomic) CGRect rectOfInterest;
//
//这个属性大致意思就是告诉系统它需要注意的区域，大部分APP的扫码UI中都会有一个框，提醒你将条形码放入那个区域，这个属性的作用就在这里，它可以设置一个范围，只处理在这个范围内捕获到的图像的信息。如此一来，可想而知，我们代码的效率又会得到很大的提高，在使用这个属性的时候。需要几点注意：
//
//1、这个CGRect参数和普通的Rect范围不太一样，它的四个值的范围都是0-1，表示比例。
//
//2、经过测试发现，这个参数里面的x对应的恰恰是距离左上角的垂直距离，y对应的是距离左上角的水平距离。
//
//3、宽度和高度设置的情况也是类似。
//
//3、举个例子如果我们想让扫描的处理区域是屏幕的下半部分，我们这样设置
//
//output.rectOfInterest=CGRectMake(0.5,0,0.5, 1);
//具体apple为什么要设计成这样，或者是这个参数我的用法那里不对，还需要了解的朋友给个指导。

@end

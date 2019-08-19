//
//  ViewController.m
//  NSURLSessionTest
//
//  Created by Macmini on 2019/8/19.
//  Copyright © 2019 Macmini. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NSURLSessionDataTaskTest];
    [self NSURLSessionDownloadTaskTest];
    [self NSURLSessionUploadTaskTest];
    // Do any additional setup after loading the view.
}

#pragma mark ========== NSURLSession请求网络数据 ==========
- (void)NSURLSessionDataTaskTest {
    //创建请求url
    NSString *urlString = @"http://www.cnblogs.com/mddblog/p/5215453.html";
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    //创建request
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
    //创建session
    NSURLSession *shareSession = [NSURLSession sharedSession];
    //创建task
    NSURLSessionDataTask *dataTask = [shareSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 网络请求完成之后就会执行，NSURLSession自动实现多线程
        NSLog(@"%@",[NSThread currentThread]);
        if (data && (error == nil)) {
            // 网络访问成功
            NSLog(@"data=%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } else {
            // 网络访问失败
            NSLog(@"error=%@",error);
        }
        
    }];
    //开启请求dataTask
    [dataTask resume];
}
#pragma mark ========== 下载请求 ==========
- (void)NSURLSessionDownloadTaskTest {
    //创建url
    NSString *urlString = @"http://localhost/周杰伦 - 枫.mp3";
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    //创建request
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
    //创建session
    NSURLSession *shareSession = [NSURLSession sharedSession];
    
    NSURLSessionDownloadTask *downloadTask = [shareSession downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"location:%@",location.path); // 采用模拟器测试，为了方便将其下载到Mac桌面
        // NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        if (!error) {
            NSString *filePath = @"/Users/userName/Desktop/周杰伦 - 枫.mp3";
            NSError *fileError;
            [[NSFileManager defaultManager] copyItemAtPath:location.path toPath:filePath error:&fileError];
            if (fileError == nil) {
                NSLog(@"file save success");
            } else {
                NSLog(@"file save error: %@",fileError);
            }
        } else {
            NSLog(@"download error:%@",error);
        }
    }];
    //开启请求downloadTask
    [downloadTask resume];
}
#pragma mark ========== 上传请求 ==========
- (void)NSURLSessionUploadTaskTest {
    //创建url
    NSString *urlString = @"http://localhost/upload.php";
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    //创建request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    //创建session
    NSURLSession *shareSession = [NSURLSession sharedSession];
    
    [[shareSession uploadTaskWithRequest:request fromData:[NSData dataWithContentsOfFile:@"/Users/userName/Desktop/IMG_0359.jpg"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"upload success：%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        } else {
            NSLog(@"upload error:%@",error);
        }
    }] resume];
}

@end

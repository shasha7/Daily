//
//  DBWebViewController.m
//  DouBan
//
//  Created by wangweihu on 2018/4/6.
//  Copyright © 2018年 wwh. All rights reserved.
//

#import "DBWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "DBJS.h"

@interface DBWebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation DBWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.delegate = self;
    [self.view addSubview:webView];
    self.webView = webView;
    
    NSURL *pathUrl = [[NSBundle mainBundle] URLForResource:@"佳缘测试.html" withExtension:nil];
    [self.webView loadRequest:[NSURLRequest requestWithURL:pathUrl]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad");
    // 注入JS对象
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"DBJS"] = [[DBJS alloc] init];
    
    // 网页如何知道客户端已经加载好网页了
    NSString *readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    NSLog(@"readyState = %@", readyState);
    BOOL complete = [readyState isEqualToString:@"complete"];
    if (complete) {
        // 通知网页
        [context[@"webViewLoadComplete"] callWithArguments:nil];
        NSLog(@"readyState ======== %@", readyState);
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"shouldStartLoadWithRequest");
    return YES;
}

@end

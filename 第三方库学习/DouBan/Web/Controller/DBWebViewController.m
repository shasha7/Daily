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

- (void)dealloc {
    // JD面试题笔试题
    // https://blog.csdn.net/majiakun1/article/details/54944942
    // 控制台打印 Cannot form weak reference to instance (0x105a011a0) of class DBWebViewController. It is possible that this object was over-released, or is in the process of deallocation
    // 需要查看objc-709源码 崩溃在weak_register_no_lock方法中，当某个类正在deallocating时候，尝试用__weak修饰的变量去引用正在释放的对象，会造成循环释放，也就是过度调用release方法
    // __weak __typeof(self) weak_self = self;
    // NSLog(@"%@", weak_self);
}

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

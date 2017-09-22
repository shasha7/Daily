//
//  ViewController.m
//  Cookie
//
//  Created by 王伟虎 on 2017/9/22.
//  Copyright © 2017年 wwh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIWebViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /*
     iOS中的Cookie
     当我们访问一个网站时，NSURLRequest都会主动帮我们记录下来访问的站点所设置的Cookie，
     如果Cookie存在的话，会把这些信息放在由NSHTTPCookieStorage单例管理的容器中共享，当你下次再访问这个站点时，NSURLRequest会拿着上次保存下来了的Cookie继续去请求。
     Cookie是由服务器端生成，发送给User-Agent（一般是浏览器或者客户端），浏览器会将Cookie的key/value保存到某个目录下的文本文件内，下次请求同一网站地址时就发送该Cookie给服务器。
     Cookie必然会通过HTTP的Respone传过来，并且Cookie在Respone中的HTTP header中。
     */
    
    NSString *str = @"http://www.jianshu.com/subscriptions#/subscriptions/74013/collection";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:str]];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.delegate = self;
    [self.view addSubview:webView];
    [webView loadRequest:request];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:webView.request.URL];
    for (NSHTTPCookie *cookie in cookies) {
        NSLog(@"cookie = %@", cookie);
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

}

#pragma mark - 对给定的URL手动设置Cookies

- (void)manualSetCookie:(NSURL *)url {
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    // cookie name
    [cookieProperties setObject:@"username" forKey:NSHTTPCookieName];
    
    // cookie value
    [cookieProperties setObject:@"my ios cookie" forKey:NSHTTPCookieValue];
    
    // 域名
    [cookieProperties setObject:@"dev.skyfox.org" forKey:NSHTTPCookieDomain];
    
    // origin URL
    [cookieProperties setObject:@"dev.skyfox.org" forKey:NSHTTPCookieOriginURL];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
    
    // 设置失效时间
    [cookieProperties setObject:[NSDate dateWithTimeIntervalSinceNow:5] forKey:NSHTTPCookieExpires];
    
    //设置sessionOnly
    [cookieProperties setObject:@"0" forKey:NSHTTPCookieDiscard];
    
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    // The main document URL to be used as a base for the "same domain as main document" policy
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:@[cookie] forURL:url mainDocumentURL:nil];
}

#pragma mark - 删除给定URL的缓存

- (void)removeCached:(NSURL *)url {
    if (url) {
        [[NSURLCache sharedURLCache] removeCachedResponseForRequest:[NSURLRequest requestWithURL:url]];
    }
}

#pragma mark - 删除给定URL的cookies

- (void)deleteCookies:(NSURL *)url {
    if (url) {
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
        for (NSHTTPCookie *cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
}

@end

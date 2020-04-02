//
//  JYIntroductionVC.m
//  JYEducation
//
//  Created by 精英教育 on 2020/3/26.
//  Copyright © 2020 smart. All rights reserved.
//

#import "JYIntroductionVC.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface JYIntroductionVC ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic,strong) WKWebViewConfiguration *wkConfig;
@property (nonatomic,copy) NSString * contntUrl;

@end

@implementation JYIntroductionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    
    [self.view addSubview:self.wkWebView];
    NSString * url = @"http://ah.sina.com.cn/edu/news/2016-11-09/154661241.html";
     NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.wkWebView loadRequest:request];
}

- (WKWebView *)wkWebView{
    CGFloat lastViewHigh = CGRectGetWidth(self.view.frame)*9/16 + NavitionbarHeight +45;
    if (!_wkWebView) {
        //以下代码适配大小
//        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=1.0, user-scalable=no'); document.getElementsByTagName('head')[0].appendChild(meta); var style = document.createElement('style'); style.innerHTML = 'img {width: 50%}'; document.body.appendChild(style);";
        NSString*jSString = [NSString stringWithFormat:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content','width=device-width','user-scalable=no'); document.getElementsByTagName('head')[0].appendChild(meta);"];
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        wkWebConfig.userContentController = wkUController;
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - lastViewHigh - BottomSafebarHeight) configuration:wkWebConfig];
        _wkWebView.scrollView.scrollEnabled = YES;
        _wkWebView.navigationDelegate = self;
        _wkWebView.scrollView.contentSize = CGSizeMake(ScreenWidth, MAXFLOAT);
//        [_wkWebView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _wkWebView;
}

//web开始加载时回调
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
   
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
   
      
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"cccc"]) {
//        NSString * alipayStr = KISDictionaryHaveKey(message.body, @"str");
       
    }

}

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler{
    NSLog(@"12345====%@",javaScriptString);
}


- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    NSURLCredential *cred = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
    completionHandler(NSURLSessionAuthChallengeUseCredential,cred);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
   
    //如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    NSURL *url = navigationAction.request.URL;
    NSString *urlString = (url) ? url.absoluteString : @"";
    
    
    //     iTunes: App Store link isMatch:RX(@"\\/\\/itunes\\.apple\\.com\\/")
    if ([urlString containsString:@"itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:url];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    //     Protocol/URL-Scheme without http(s)
    else if ([urlString containsString:@"alipays://platformapi/startapp"]) {
        [[UIApplication sharedApplication] openURL:url];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

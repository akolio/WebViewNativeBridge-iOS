//
//  ViewController.h
//  WebViewTest-iOS
//
//  Created by Antti Köliö on 30/08/15.
//  Copyright (c) 2015 Antti Köliö. All rights reserved.
//

#import <UIKit/UIKit.h>
@import WebKit;
#import "WebViewAppMessageHandler.h"
#import "WebViewLogMessageHandler.h"

@interface ViewController : UIViewController

//@property (nonatomic, readonly, copy) WKWebViewConfiguration webViewConfig;
@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) WebViewLogMessageHandler *webViewLogMessageHandler;
@property (strong, nonatomic) WebViewAppMessageHandler *webViewAppMessageHandler;


@end


//
//  WebViewHelper.h
//  WKWebViewTest
//
//  Created by Antti Köliö on 03/05/15.
//  Copyright (c) 2015 Antti Köliö. All rights reserved.
//

#import <Foundation/Foundation.h>
@import WebKit;

@interface WebViewHelper : NSObject

+(void)executeJavaScriptInWebView:(WKWebView *)webView withContent:(NSString *) content;
+(void)executeWebViewCallbackInWebView:(WKWebView *)webView WithCallbackId:(NSString *)callbackId andContent:(NSDictionary *) content;

@end

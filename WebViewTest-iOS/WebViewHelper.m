//
//  WebViewHelper.m
//  WKWebViewTest
//
//  Created by Antti Köliö on 03/05/15.
//  Copyright (c) 2015 Antti Köliö. All rights reserved.
//

#import "WebViewHelper.h"

@implementation WebViewHelper


+(void)executeJavaScriptInWebView:(WKWebView *)webView withContent:(NSString *) content {
    [webView evaluateJavaScript:content completionHandler:^(id result, NSError *error) {
        if(error != nil) {
            NSLog(@"%@ reason: %ld", error.localizedDescription, error.code);
        }
    }];
}

+(void)executeWebViewCallbackInWebView:(WKWebView *)webView WithCallbackId:(NSString *)callbackId andContent:(NSDictionary *) content {
    NSError *error = nil;
    NSData *returnData = [NSJSONSerialization dataWithJSONObject:@{ @"callbackId" : callbackId, @"content" : content } options:kNilOptions error:&error];
    NSString *returnString = [[NSString alloc] initWithBytes:[returnData bytes] length:returnData.length encoding:NSUTF8StringEncoding];
//    NSLog(@"returning data to js: %@", returnString);
    [webView evaluateJavaScript:[NSString stringWithFormat:@"NativeBridge.handleCallback('%@');", returnString] completionHandler:^(id result, NSError *error) {
        if(error != nil) {
            NSLog(@"%@ reason: %ld", error.localizedDescription, error.code);
        }
    }];
}

@end

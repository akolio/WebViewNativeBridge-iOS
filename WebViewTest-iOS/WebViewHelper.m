//
//  WebViewHelper.m
//  WKWebViewTest
//
//  Created by Antti Köliö on 03/05/15.
//  Copyright (c) 2015 Antti Köliö. All rights reserved.
//

#import "WebViewHelper.h"

@implementation WebViewHelper


+(void)executeJavaScriptInWebView:(UIWebView *)webView withContent:(NSString *) content {
    NSString *result = [webView stringByEvaluatingJavaScriptFromString:content];
    NSLog(@"result of script: %@", result);
}

+(void)executeWebViewCallbackInWebView:(UIWebView *)webView WithCallbackId:(NSString *)callbackId andContent:(NSString *) content {
    NSError *error = nil;
    NSData *returnData = [NSJSONSerialization dataWithJSONObject:@{ @"callbackId" : callbackId, @"content" : content } options:kNilOptions error:&error];
    NSString *returnString = [[NSString alloc] initWithBytes:[returnData bytes] length:returnData.length encoding:NSUTF8StringEncoding];
    
    NSString *result = [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"NativeBridge.handleCallback('%@');", returnString]];
    NSLog(@"result of script: %@", result);
}

@end

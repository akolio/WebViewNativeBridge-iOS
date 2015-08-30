//
//  WebViewLogMessageHandler.m
//  WKWebViewTest
//
//  Created by Antti Köliö on 03/05/15.
//  Copyright (c) 2015 Antti Köliö. All rights reserved.
//

#import "WebViewLogMessageHandler.h"

@implementation WebViewLogMessageHandler

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    
    //NSLog(@"%@", message.body);
    
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[message.body dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    
    NSString *logMessage = [json valueForKey:@"logMessage"];
    NSLog(@"JSLog: %@", logMessage);
    
}

@end

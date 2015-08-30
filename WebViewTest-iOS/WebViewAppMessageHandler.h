//
//  WebViewNativeBridge.h
//  WKWebViewTest
//
//  Created by Antti Köliö on 03/05/15.
//  Copyright (c) 2015 Antti Köliö. All rights reserved.
//

#import <Foundation/Foundation.h>
@import WebKit;

@interface WebViewAppMessageHandler : NSObject<WKScriptMessageHandler>

// (cmdname), (callbackId, arguments)
-(void)addCommandForName:(NSString *)commandName command:(void (^)(NSString *, id))command;

@end

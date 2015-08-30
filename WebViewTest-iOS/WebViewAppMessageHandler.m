//
//  WebViewNativeBridge.m
//  WKWebViewTest
//
//  Created by Antti Köliö on 03/05/15.
//  Copyright (c) 2015 Antti Köliö. All rights reserved.
//

#import "WebViewAppMessageHandler.h"

@interface WebViewAppMessageHandler ()

@property (nonatomic, strong) NSMutableDictionary *commands;

@end

@implementation WebViewAppMessageHandler



- (instancetype)init
{
    self = [super init];
    if (self) {        
        self.commands = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)addCommandForName:(NSString *)commandName command:(void (^)(NSString *, id))command {
    [self.commands setValue:command forKey:commandName];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    
    //    NSLog(@"%@", message.body);
    
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[message.body dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    
    
    NSString *callbackId = [json valueForKey:@"callbackId"];
    NSString *commandName = [json valueForKey:@"command"];
    NSString *arguments = [json valueForKey:@"arguments"];
    
    //    NSLog(@"callbackId: %@", callbackId);
    //    NSLog(@"command: %@", command);
    //    NSLog(@"arguments: %@", arguments);
    
    void (^command)(NSString *, id) = [self.commands valueForKey:commandName];
    if(command != nil) {
        command(callbackId, arguments);
    }
    
    
    
    
}

@end

//
//  WebViewCommandHandler.m
//  WebViewTest-iOS
//
//  Created by Antti Köliö on 04/09/15.
//  Copyright (c) 2015 Antti Köliö. All rights reserved.
//

#import "WebViewCommandHandler.h"

@interface WebViewCommandHandler ()

@property (nonatomic, strong) NSMutableDictionary *commands;

@end


@implementation WebViewCommandHandler

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

-(void)handleCommand:(NSDictionary *)cmdInfo {
    NSString *callbackId = [cmdInfo objectForKey:@"callbackId"];
    NSString *commandName = [cmdInfo objectForKey:@"command"];
    id arguments = [cmdInfo objectForKey:@"arguments"];
    
    void (^command)(NSString *, id) = [self.commands valueForKey:commandName];
    if(command != nil) {
        command(callbackId, arguments);
    }    
}


@end

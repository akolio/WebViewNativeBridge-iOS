//
//  WebViewCommandHandler.h
//  WebViewTest-iOS
//
//  Created by Antti Köliö on 04/09/15.
//  Copyright (c) 2015 Antti Köliö. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebViewCommandHandler : NSObject

// (cmdname), (callbackId, arguments)
-(void)addCommandForName:(NSString *)commandName command:(void (^)(NSString *, id))command;
-(void)handleCommand:(NSDictionary *)cmdInfo;

@end

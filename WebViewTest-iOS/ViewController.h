//
//  ViewController.h
//  WebViewTest-iOS
//
//  Created by Antti Köliö on 30/08/15.
//  Copyright (c) 2015 Antti Köliö. All rights reserved.
//

#import <UIKit/UIKit.h>
@import WebKit;
@import MobileCoreServices;
#import "WebViewCommandHandler.h"

@interface ViewController : UIViewController <UIWebViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) WebViewCommandHandler *webViewCommandHandler;


@end


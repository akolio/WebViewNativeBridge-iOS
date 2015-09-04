//
//  ViewController.m
//  WebViewTest-iOS
//
//  Created by Antti Köliö on 30/08/15.
//  Copyright (c) 2015 Antti Köliö. All rights reserved.
//

#import "ViewController.h"
#import "WebViewHelper.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.webView];
    
    self.webView.delegate = self;
    
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"web"];
    path = [path stringByAppendingPathComponent:@"index.html"];
    NSLog(@"path: %@", path);
    
    //    NSError *error = nil;
    //    NSLog(@"contents:\n%@", [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error]);
    
    NSURL *url = [NSURL fileURLWithPath:path isDirectory:NO];
    //    NSURL *url = [NSURL URLWithString:@"http://www.google.fi"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    [self.webView loadRequest:request];
    
    
    UIButton *jsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:jsButton];
    jsButton.frame = CGRectMake(0, self.view.frame.size.height - 30, 100, 30);
    [jsButton setTitle:@"Native to JS" forState:UIControlStateNormal];
    [jsButton addTarget:self action:@selector(alertJs) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.webViewCommandHandler = [[WebViewCommandHandler alloc] init];
    __weak ViewController *weakSelf = self;
    
    [self.webViewCommandHandler addCommandForName:@"yesno" command:^(NSString *callbackId, id arguments) {
        [weakSelf yesNoWithCallbackId:callbackId arguments:arguments];
    }];
    
}

- (void)alertJs {
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeStyle = NSDateFormatterMediumStyle;
    df.dateStyle = NSDateFormatterNoStyle;
    NSString *message = [NSString stringWithFormat:@"%@", [df stringFromDate:[NSDate date]]];
    
    [WebViewHelper executeJavaScriptInWebView:self.webView withContent:[NSString stringWithFormat:@"insertText('%@');", message]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)yesNoWithCallbackId:(NSString *)callbackId arguments:(NSString *)arguments {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"?" message:arguments preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction* yesAction = [UIAlertAction
                                actionWithTitle:@"Yes"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    NSLog(@"selected yes");
                                    [WebViewHelper executeWebViewCallbackInWebView:self.webView WithCallbackId:callbackId andContent:@"Yes"];
                                }];
    [alertController addAction:yesAction];
    
    UIAlertAction* noAction = [UIAlertAction
                               actionWithTitle:@"No"
                               style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action)
                               {
                                   NSLog(@"selected no");
                                   [WebViewHelper executeWebViewCallbackInWebView:self.webView WithCallbackId:callbackId andContent:@"No"];
                               }];
    [alertController addAction:noAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}



#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = request.URL;
    NSLog(@"shouldStartLoadWithRequest: %@", url.description);
    
    if([@"mytestappscheme" isEqualToString:url.scheme]) {
        NSString *host = url.host;
        NSLog(@"mytestappscheme host: %@", host); // nativelog
        
        if([@"nativelog" isEqualToString:url.host]) {
//            NSString *path = url.path;
//            NSLog(@"mytestappscheme path: %@", path); // /{"logMessage":"log message from html/js"}
            
            NSArray *pathComponents = url.pathComponents;
            NSString *jsonString = [pathComponents objectAtIndex:1];
            NSLog(@"mytestappscheme jsonString: %@", jsonString); // {"logMessage":"log message from html/js"}

        } else if([@"nativeapp" isEqualToString:url.host]) {
            //            NSLog(@"mytestappscheme path: %@", url.path); // {"callbackId":1,"command":"yesno","arguments":"Hello from JS!"}

            NSArray *pathComponents = url.pathComponents;
            NSString *jsonString = [pathComponents objectAtIndex:1];
            
            NSError *err = nil;
            NSDictionary *cmdInfo = [NSJSONSerialization JSONObjectWithData: [jsonString dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error: &err];
            [self.webViewCommandHandler handleCommand:cmdInfo];
            
        }
        
    }
    
    
    return YES;
}

@end

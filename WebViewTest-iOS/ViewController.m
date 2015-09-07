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

-(WKUserContentController *)createWKUserContentController{
    self.webViewLogMessageHandler = [[WebViewLogMessageHandler alloc] init];
    self.webViewAppMessageHandler = [[WebViewAppMessageHandler alloc] init];
    
    __weak ViewController *weakSelf = self;
    
    [self.webViewAppMessageHandler addCommandForName:@"yesno" command:^(NSString *callbackId, id arguments) {
        
        [weakSelf yesNoWithCallbackId:callbackId arguments:arguments];
        
    }];
    
    [self.webViewAppMessageHandler addCommandForName:@"images" command:^(NSString *callbackId, id arguments) {
        [weakSelf showImagePickerWithCallbackId:callbackId arguments:arguments];
    }];
    
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    [userContentController addScriptMessageHandler:self.webViewLogMessageHandler name:@"nativelog"];
    [userContentController addScriptMessageHandler:self.webViewAppMessageHandler name:@"nativeapp"];
    return userContentController;
}

- (BOOL)okToCopyFileWithName:(NSString *)fileName {
    NSArray *okTypes = @[@".html", @".js", @".css"];
    
    for (int i = 0; i < [okTypes count]; i++) {
        if ([[fileName lowercaseString] hasSuffix:[okTypes objectAtIndex:i]]) {
            return YES;
        }
    }
    return NO;
}

- (void)copyFilesFromPath:(NSString *) origPath to:(NSString *)destPath {
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager createDirectoryAtPath:destPath withIntermediateDirectories:YES attributes:nil error:&error]) {
        NSLog(@"Error creating directory: %@", [error localizedDescription]);
    }
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:origPath error:&error];
    for (int i = 0; i < [contents count]; i++) {
        NSString *fileName = [contents objectAtIndex:i];
        if([self okToCopyFileWithName:fileName]) {
            NSString *origFilePath = [origPath stringByAppendingPathComponent:fileName];
            NSString *destFilePath = [destPath stringByAppendingPathComponent:fileName];
            NSLog(@"Copying file from: %@ to: %@", origFilePath, destFilePath);
            
            if ([fileManager fileExistsAtPath:destFilePath]) {
                if (![fileManager removeItemAtPath:destFilePath error:&error]) {
                    NSLog(@"Error deleting file: %@", [error localizedDescription]);
                }
            }
            if (![fileManager copyItemAtPath:origFilePath toPath:destFilePath error:&error]) {
                NSLog(@"Error copying file: %@", [error localizedDescription]);
            }
        }
        
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *origWebPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"web"];
    NSString *tempWebPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"web"];
    [self copyFilesFromPath:origWebPath to:tempWebPath];
    NSString *origJsPath = [origWebPath stringByAppendingPathComponent:@"js"];
    NSString *tempJsPath = [tempWebPath stringByAppendingPathComponent:@"js"];
    [self copyFilesFromPath:origJsPath to:tempJsPath];
    
    WKWebViewConfiguration *webViewConfig = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userContentController = [self createWKUserContentController];
    webViewConfig.userContentController = userContentController;
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:webViewConfig];
    [self.view addSubview:self.webView];
    
//    NSString *indexHtmlPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"web"];
//    indexHtmlPath = [indexHtmlPath stringByAppendingPathComponent:@"index.html"];
    NSString *indexHtmlPath = [tempWebPath stringByAppendingPathComponent:@"index.html"];
    NSLog(@"loading html from: %@", indexHtmlPath);
    
    //    NSError *error = nil;
    //    NSLog(@"contents:\n%@", [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error]);
    
    NSURL *url = [NSURL fileURLWithPath:indexHtmlPath isDirectory:NO];
    //    NSURL *url = [NSURL URLWithString:@"http://www.google.fi"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    [self.webView loadRequest:request];
    
    
    UIButton *jsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:jsButton];
    jsButton.frame = CGRectMake(0, self.view.frame.size.height - 30, 100, 30);
    [jsButton setTitle:@"Native to JS" forState:UIControlStateNormal];
    [jsButton addTarget:self action:@selector(alertJs) forControlEvents:UIControlEventTouchUpInside];
    
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
                                    [WebViewHelper executeWebViewCallbackInWebView:self.webView WithCallbackId:callbackId andContent:@{@"answer":@"Yes"}];
                                }];
    [alertController addAction:yesAction];
    
    UIAlertAction* noAction = [UIAlertAction
                               actionWithTitle:@"No"
                               style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * action)
                               {
                                   NSLog(@"selected no");
                                   [WebViewHelper executeWebViewCallbackInWebView:self.webView WithCallbackId:callbackId andContent:@{@"answer":@"No"}];
                               }];
    [alertController addAction:noAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}


NSString *imagePickerCallbackId;
-(void)showImagePickerWithCallbackId:(NSString *)callbackId arguments:(NSString *)arguments {
    imagePickerCallbackId = callbackId;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

# pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    NSError *error;
    
    if ([(NSString *)kUTTypeImage isEqualToString:[info objectForKey:UIImagePickerControllerMediaType]]) {
        NSLog(@"Image picked");
    
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSData *pngData = UIImagePNGRepresentation(image);
        NSString *pngDataBase64 = [pngData base64EncodedStringWithOptions:kNilOptions];
        // ^ don't split lines with NSDataBase64Encoding64CharacterLineLength

        [WebViewHelper executeWebViewCallbackInWebView:self.webView WithCallbackId:imagePickerCallbackId andContent:@{@"pngDataBase64":pngDataBase64}];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    
}


@end

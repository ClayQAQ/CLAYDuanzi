//
//  CLAYWebViewController.m
//  项目四
//
//  Created by CLAY on 16/8/27.
//  Copyright © 2016年 CLAY. All rights reserved.
//

#import "CLAYWebViewController.h"
#import "CLAYSquare.h"
#import <NJKWebViewProgress.h>

@interface CLAYWebViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBackItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goForwardItem;


@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
/** NJK进度 */
@property (nonatomic, strong) NJKWebViewProgress *progress;
@end

@implementation CLAYWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    self.progress = [[NJKWebViewProgress alloc] init];
    self.webView.delegate = self.progress;
    __weak typeof(self) weakSelf = self;
    self.progress.progressBlock = ^(float progress){
        weakSelf.progressView.progress = progress;
        weakSelf.progressView.hidden = (progress == 1.0);
    };
    self.progress.webViewProxyDelegate = self;
    
}


- (IBAction)goBackItem:(id)sender {
        [self.webView goBack];
}

- (IBAction)goForwardItem:(id)sender {
        [self.webView goForward];
}

- (IBAction)refreshItem:(id)sender {
    [self.webView reload];
}

#pragma mark - <UIWebViewDelegate>
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    self.goBackItem.enabled = [self.webView canGoBack];
    self.goForwardItem.enabled = [self.webView canGoForward];
}
@end

//
//  RSSWebViewController.m
//  RSSClient
//
//  Created by Александр on 25.09.17.
//  Copyright © 2017 Александр. All rights reserved.
//

#import "RSSWebViewController.h"
#import "RSSHTMLController.h"

@interface RSSWebViewController () <RSSHTMLControllerDelegate>
{
    WKWebView *_webView;
    NSString *_url;
    RSSHTMLController *_htmlController;
    UIActivityIndicatorView *_loadingIndicator;
}
@end

@implementation RSSWebViewController

- (instancetype)initWithUrl:(NSString *)urlString
{
    if(self = [super init])
    {
        _url = urlString;
    }
    
    return self;
}

- (void)dealloc
{
    [_htmlController release];
    [_loadingIndicator release];

    [super dealloc];
}

- (void)loadView
{
    _webView = [WKWebView new];
    self.view = _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _htmlController = [RSSHTMLController new];
    _htmlController.delegate = self;
    _webView.navigationDelegate = _htmlController;
    
    _loadingIndicator = [UIActivityIndicatorView new];
    [_loadingIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_loadingIndicator setColor:[UIColor grayColor]];
    [_loadingIndicator setHidesWhenStopped:YES];

    [_webView addSubview:_loadingIndicator];
    
    [_loadingIndicator startAnimating];
    
    [self loadUrl];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [_loadingIndicator setFrame:CGRectMake(_webView.frame.size.width/2, _webView.frame.size.height/2, 0, 0)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadUrl
{
    NSURL *url = [NSURL URLWithString:_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

#pragma mark - RSSHTMLControllerDelegate

- (void)didFinishLoadingWebView
{
    [self stopLoadingIndicator];
}

- (void)failLoadWithError:(NSInteger)errorCode
{
    NSString *message = [NSString stringWithFormat:@"Error loading page: %ld", (long)errorCode];
    UIAlertView* dialogue = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [dialogue show];

    [self stopLoadingIndicator];
}

- (void)stopLoadingIndicator
{
    if(_loadingIndicator.isAnimating)
    {
        [_loadingIndicator stopAnimating];
    }
}

@end

//
//  RSSHTMLController.m
//  RSSClient
//
//  Created by Alexander Baranov on 25.09.17.
//  Copyright © 2017 Александр. All rights reserved.
//

#import "RSSHTMLController.h"

@implementation RSSHTMLController

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    decisionHandler([self shouldStartDecidePolicyRequest: [navigationAction request] navigationType:[navigationAction navigationType]]);
}

- (BOOL) shouldStartDecidePolicyRequest: (NSURLRequest *) request
                         navigationType:(WKNavigationType) navigationType
{
    return YES;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse
decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    decisionHandler([self shouldStartDecidePolicyResponse: [navigationResponse response]]);
}

- (BOOL) shouldStartDecidePolicyResponse: (NSURLResponse *) response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if(httpResponse.statusCode == 404)
    {
        [self.delegate failLoadWithError:httpResponse.statusCode];
    }
    return YES;
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertView* dialogue = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [dialogue show];
    
    completionHandler();
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation
      withError:(NSError *)error
{
    [self processingError:error];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
      withError:(NSError *)error
{
    [self.delegate didFinishLoadingWebView];
    
    [self processingError:error];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self.delegate didFinishLoadingWebView];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
}

- (void)processingError:(NSError *)error
{
    NSInteger errorCode = NSURLErrorUnknown;
    switch (error.code) {
        case NSURLErrorCancelled:
            return;
            
        case NSURLErrorNotConnectedToInternet:
            errorCode = NSURLErrorNotConnectedToInternet;
            break;
            
        default:
            break;
    }

    [self.delegate failLoadWithError:errorCode];

    NSLog(@"%@", [error localizedDescription]);
    NSLog(@"%@", [error.userInfo objectForKey:@"NSErrorFailingURLStringKey"]);
}

@end

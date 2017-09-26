//
//  RSSHTMLController.h
//  RSSClient
//
//  Created by Alexander Baranov on 25.09.17.
//  Copyright © 2017 Александр. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RSSHTMLControllerDelegate
- (void)didFinishLoadingWebView;
- (void)failLoadWithError:(NSInteger)errorCode;
@end

@interface RSSHTMLController : NSObject <WKNavigationDelegate>

@property (weak, nonatomic) id<RSSHTMLControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

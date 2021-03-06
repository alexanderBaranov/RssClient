//
//  RSSHotnewsLoader.h
//  RSSClient
//
//  Created by Александр on 24.09.17.
//  Copyright © 2017 Александр. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RSSHotnewsLoaderDelegate
- (void)willStartLoadHotnews;
- (void)didCompleteLoadNews:(NSMutableArray *)hotnews;
@end

@interface RSSHotnewsLoader : NSObject

- (instancetype)initWithDelegate:(id<RSSHotnewsLoaderDelegate>)delegate;
- (void)startLoadHotnews;

@end

NS_ASSUME_NONNULL_END

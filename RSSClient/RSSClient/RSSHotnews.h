//
//  RSSHotnews.h
//  RSSClient
//
//  Created by Александр on 24.09.17.
//  Copyright © 2017 Александр. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSHotnews : NSObject

@property(strong, nonatomic) NSString *title;
@property(strong, nonatomic) NSString *rssDescription;
@property(strong, nonatomic) NSString *link;

@end

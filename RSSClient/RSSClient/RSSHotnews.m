//
//  RSSHotnews.m
//  RSSClient
//
//  Created by Александр on 24.09.17.
//  Copyright © 2017 Александр. All rights reserved.
//

#import "RSSHotnews.h"

@implementation RSSHotnews

- (instancetype)init
{
    if(self = [super init])
    {
        _title = [NSString string];
        _rssDescription = [NSString string];
        _link = [NSString string];
    }
    
    return self;
}

- (void)dealloc
{
    [_title release];
    [_rssDescription release];
    [_link release];

    [super dealloc];
}

@end

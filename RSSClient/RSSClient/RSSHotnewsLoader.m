//
//  RSSHotnewsLoader.m
//  RSSClient
//
//  Created by Александр on 24.09.17.
//  Copyright © 2017 Александр. All rights reserved.
//

#import "RSSHotnewsLoader.h"
#import "RSSHotnews.h"

static NSString * const kHotnewsUrl = @"http://images.apple.com/main/rss/hotnews/hotnews.rss";

static NSString * const kTitle = @"title";
static NSString * const kDescription = @"description";
static NSString * const kLink = @"link";
static NSString * const kItem = @"item";


@interface RSSHotnewsLoader() <NSXMLParserDelegate>
{
    RSSHotnews *_hotnewsElement;
    NSString *_currentParseNode;
    BOOL _isItemNode;
}
@end

@implementation RSSHotnewsLoader
{
    id<RSSHotnewsLoaderDelegate> _delegate;
    NSMutableArray<RSSHotnews *> *_hotNews;
}

- (instancetype)initWithDelegate:(id<RSSHotnewsLoaderDelegate>)delegate
{
    if(self = [super init])
    {
        _delegate = delegate;
    }
    
    return self;
}

- (void)dealloc
{
    if(_hotnewsElement)
    {
        [_hotnewsElement release];
    }
    
    [super dealloc];
}

- (void)startLoadHotnews
{
    [_delegate willStartLoadHotnews];
    
    _hotNews = [NSMutableArray array];
    
    NSURL *url = [NSURL URLWithString:kHotnewsUrl];
    NSXMLParser* parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser parse];

    [parser release];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [_delegate didCompleteLoadNews:_hotNews];
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    
}

-(void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError
{
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:kItem])
    {
        _isItemNode = YES;
    }
    else if(_isItemNode)
    {
        if(!_hotnewsElement)
        {
            _hotnewsElement = [RSSHotnews new];
        }

        _currentParseNode = [elementName copy];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:kItem])
    {
        _isItemNode = NO;

        [_hotNews addObject:_hotnewsElement];
        _hotnewsElement = nil;
    }
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if(!_isItemNode)
    {
        return;
    }
    
    if([string isEqualToString:@"\n"])
    {
        return;
    }
    
    if([_currentParseNode isEqualToString:kTitle])
    {
        _hotnewsElement.title = [_hotnewsElement.title stringByAppendingString:string];
    }
    else if([_currentParseNode isEqualToString:kDescription])
    {
        _hotnewsElement.rssDescription = [_hotnewsElement.rssDescription stringByAppendingString:string];
    }
    else if([_currentParseNode isEqualToString:kLink])
    {
        _hotnewsElement.link = [_hotnewsElement.link stringByAppendingString:string];
    }
}

@end

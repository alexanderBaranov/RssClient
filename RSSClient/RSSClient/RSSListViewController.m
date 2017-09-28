//
//  RSSListViewController.m
//  RSSClient
//
//  Created by Александр on 24.09.17.
//  Copyright © 2017 Александр. All rights reserved.
//

#import "RSSListViewController.h"
#import "RSSHotnewsLoader.h"
#import "RSSHotnews.h"
#import "RSSWebViewController.h"

@interface RSSListViewController () <RSSHotnewsLoaderDelegate>
{
    NSArray *_hotnews;
}

@end

@implementation RSSListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RSSHotnewsLoader *hotnewsLoader = [[RSSHotnewsLoader alloc] initWithDelegate:self];
    [hotnewsLoader startLoadHotnews];
    [hotnewsLoader release];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    
//    if([self.tableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)])
//    {
//        self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
//    }

    self.title = @"RSS list";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_hotnews release];
    
    [super dealloc];
}

#pragma mark - RSSHotnewsLoaderDelegate

- (void)willStartLoadHotnews
{
    
}

- (void)didCompleteLoadNews:(NSMutableArray *)hotnews
{
    _hotnews = [hotnews copy];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
self.tableView.layoutMargins = UIEdgeInsetsZero;
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    CGFloat detailTextheight = [self heightForText:cell.detailTextLabel.text
                                             width:self.tableView.frame.size.width
                                           andFont:cell.detailTextLabel.font];
    
    CGFloat textLabelheight = [self heightForText:cell.textLabel.text
                                            width:self.tableView.frame.size.width
                                          andFont:cell.textLabel.font];
    
    CGFloat heightOffset = 50;
    if(UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
    {
        heightOffset = 70;
    }
    
    return detailTextheight + textLabelheight + heightOffset;
}

- (CGFloat)heightForText:(NSString *)text width:(CGFloat)width andFont:(UIFont *)font {
    if(!text)
    {
        return 0;
    }

    CGRect frame = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:font}
                                      context:nil];
    return frame.size.height + 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _hotnews.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    RSSHotnews *hotnews = [_hotnews objectAtIndex:indexPath.row];

    cell.textLabel.text = hotnews.title;
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.text = hotnews.rssDescription;
    cell.detailTextLabel.numberOfLines = 0;

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RSSHotnews *hotnews = [_hotnews objectAtIndex:indexPath.row];
    
    RSSWebViewController *webViewController = [[[RSSWebViewController alloc] initWithUrl:hotnews.link] autorelease];
    [self.navigationController pushViewController:webViewController animated:YES];
}

@end

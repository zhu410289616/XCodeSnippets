//
//  CSSnippetsView.m
//  XCodeSnippets
//
//  Created by zhuruhong on 2018/1/18.
//  Copyright © 2018年 zhuruhong. All rights reserved.
//

#import "CSSnippetsView.h"

@implementation CSSnippetsView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup:NSZeroRect];
    }
    return self;
}

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup:frame];
    }
    return self;
}

- (void)setup:(NSRect)frame
{
    CGFloat width = NSWidth(frame);
    CGFloat height = NSHeight(frame);
    
    NSRect rect = NSZeroRect;
    
    rect = NSMakeRect(0, 0, width, height);
    _scrollView = [[NSScrollView alloc] initWithFrame:rect];
    
    _tableAdapter = [[CSSnippetsTableAdapter alloc] initWithTestData];
    
    _tableView = [[CSSnippetsTableView alloc] initWithFrame:rect];
    _tableView.delegate = _tableAdapter;
    _tableView.dataSource = _tableAdapter;
    
    NSTableColumn *column = nil;
    column = [[NSTableColumn alloc] initWithIdentifier:@"firstColumn"];
    column.width = width;
    [_tableView addTableColumn:column];
    
    _scrollView.documentView = _tableView;
    _scrollView.drawsBackground = NO;
    _scrollView.hasVerticalScroller = YES;
    _scrollView.hasHorizontalScroller = YES;
    _scrollView.autohidesScrollers = YES;
    [self addSubview:_scrollView];
}

- (void)resizeSubviewsWithOldSize:(NSSize)oldSize
{
    [super resizeSubviewsWithOldSize:oldSize];
    _scrollView.frame = self.bounds;
    _tableView.frame = self.bounds;
    [_tableView reloadData];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)updateViewWithData:(NSArray *)snippets
{
    [_tableAdapter.dataArray removeAllObjects];
    if (snippets.count > 0) {
        [_tableAdapter.dataArray addObjectsFromArray:snippets];
    }
    [_tableView reloadData];
}

@end

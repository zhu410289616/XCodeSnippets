//
//  CSSnippetsTableAdapter.m
//  XCodeSnippets
//
//  Created by zhuruhong on 2018/1/18.
//  Copyright © 2018年 zhuruhong. All rights reserved.
//

#import "CSSnippetsTableAdapter.h"

@implementation CSSnippetsTableAdapter

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataArray = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithTestData
{
    self = [super init];
    if (self) {
        _dataArray = [NSMutableArray array];
        
        CSSnippetModel *model = nil;
        for (NSInteger i=0; i<20; i++) {
            model = [[CSSnippetModel alloc] init];
            model.shortcut = [NSString stringWithFormat:@"csx%ld", i];
            model.title = [NSString stringWithFormat:@"title%ld", i];
            model.summary = [NSString stringWithFormat:@"summary%ld", i];
            model.contents = [NSString stringWithFormat:@"contents%ld", i];
            [_dataArray addObject:model];
        }
        
    }
    return self;
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return _dataArray.count;
}

- (nullable id)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
{
    return nil;
}

#pragma mark - NSTableViewDelegate

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 70;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *identifier = [tableColumn identifier];
    CSSnippetsTableCell *cell = [tableView makeViewWithIdentifier:identifier owner:self];
    if (!cell) {
        NSRect rect = NSMakeRect(0, 0, tableColumn.width, 60);
        cell = [[CSSnippetsTableCell alloc] initWithFrame:rect];
        cell.rightMenuItem.action = @selector(doRightMenuClicked:);
        cell.rightMenuItem.target = self;
    }
    
    CSSnippetModel *model = _dataArray[row];
    if (CSSnippetSourceSystem == model.source) {
        cell.rightMenuItem.title = @"Xcode原生代码片段";
    } else {
        cell.rightMenuItem.title = model.isInstalled ? @"Uninstall" : @"Install";
    }
    
    cell.model = model;
    cell.rightMenuItem.tag = row;
    
    return cell;
}

- (void)doRightMenuClicked:(id)sender
{
    NSMenuItem *theMenuItem = sender;
    CSSnippetModel *model = _dataArray[theMenuItem.tag];
#ifdef DEBUG
    NSLog(@"source: %ld, uninstall model: %@", model.source, model.title);
#endif
    
    if (CSSnippetSourceSystem == model.source) {
        return;
    } else {
        if (model.isInstalled) {
            [self doUninstallSnippet:model];
        } else {
            [self doInstallSnippet:model];
        }
    }
}

- (void)doUninstallSnippet:(CSSnippetModel *)model
{
    if ([_delegate respondsToSelector:@selector(didUninstallMenuClicked:)]) {
        [_delegate didUninstallMenuClicked:model];
    }
}

- (void)doInstallSnippet:(CSSnippetModel *)model
{
    if ([_delegate respondsToSelector:@selector(didInstallMenuClicked:)]) {
        [_delegate didInstallMenuClicked:model];
    }
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    if ([_delegate respondsToSelector:@selector(didCellSelected:)]) {
        [_delegate didCellSelected:_dataArray[row]];
    }
    return NO;
}

@end

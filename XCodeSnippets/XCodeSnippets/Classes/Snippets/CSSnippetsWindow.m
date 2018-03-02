//
//  CSSnippetsWindow.m
//  XCodeSnippets
//
//  Created by zhuruhong on 2018/1/19.
//  Copyright © 2018年 zhuruhong. All rights reserved.
//

#import "CSSnippetsWindow.h"
#import "CSSnippetsView.h"
#import "CSCodeSnippetsManager.h"
#import "NSUserDefaults+PL.h"

@interface CSSnippetsWindow () <NSSearchFieldDelegate, CSSnippetsTableAdapterDelegate>

@property (nonatomic, strong) IBOutlet NSSearchField *searchField;
@property (nonatomic, strong) CSSnippetsView *snippetsView;
@property (nonatomic, strong) NSMutableArray *snippetArray;

@property (nonatomic, strong) CSSnippetDetailWindow *detailWindow;

@end

@implementation CSSnippetsWindow

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    _snippetArray = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidResize:) name:NSWindowDidResizeNotification object:nil];
    
    CGFloat width = NSWidth(self.window.contentView.frame);
    CGFloat height = NSHeight(self.window.contentView.frame);
    
    _searchField.frame = NSMakeRect(0, 0, width, 22);
    NSRect rect = NSMakeRect(0, 22, width, height-22);
    _snippetsView = [[CSSnippetsView alloc] initWithFrame:rect];
    _snippetsView.tableAdapter.delegate = self;
    [self.window.contentView addSubview:_snippetsView];
    
    //初始化数据
    [self setupCodeSnippets];
}

- (void)setupCodeSnippets
{
    [self installAppCodeSnippets];
    [self readAllCodeSnippets];
}

- (void)installAppCodeSnippets
{
    BOOL isInstalled = [NSUserDefaults pl_boolForKey:@"APP_IS_INSTALLED"];
    if (isInstalled) {
        return;
    }
    
    BOOL result = [[CSCodeSnippetsManager sharedInstance] installAppCodeSnippets];
    if (result) {
        [NSUserDefaults pl_setObject:@(YES) forKey:@"APP_IS_INSTALLED"];
    }
}

- (void)readAllCodeSnippets
{
    NSArray *snippets = [[CSCodeSnippetsManager sharedInstance] allCodeSnippets];
    [_snippetArray removeAllObjects];
    [_snippetArray addObjectsFromArray:snippets];
    
    [_snippetsView updateViewWithData:_snippetArray];
    
    _searchField.stringValue = @"";
}

- (void)searchSnippetsWithKeyword:(NSString *)keyword
{
    NSString *key = keyword;
    if (key.length == 0) {
        [_snippetsView updateViewWithData:_snippetArray];
        return;
    }
    
    NSMutableArray *searched = [NSMutableArray array];
    for (CSSnippetModel *item in _snippetArray) {
        NSRange range = [item.shortcut rangeOfString:key];
        if (range.length > 0) {
            [searched addObject:item];
            continue;
        }
        
        range = [item.title rangeOfString:key];
        if (range.length > 0) {
            [searched addObject:item];
            continue;
        }
    }
    [_snippetsView updateViewWithData:searched];
}

#pragma mark - Notification

- (void)windowDidResize:(NSNotification *)notif
{
    NSWindow *theWindow = notif.object;
    
    CGFloat width = NSWidth(theWindow.contentView.frame);
    CGFloat height = NSHeight(theWindow.contentView.frame);
    _searchField.frame = NSMakeRect(0, 0, width, 22);
    _snippetsView.frame = NSMakeRect(0, 22, width, height-22);
}

- (void)controlTextDidChange:(NSNotification *)notification
{
    NSTextField *textField = [notification object];
    
    if (textField == _searchField) {
        [self searchSnippetsWithKeyword:textField.stringValue];
    }
}

#pragma mark - CSSnippetsTableAdapterDelegate

- (void)didCellSelected:(CSSnippetModel *)model
{
    NSLog(@"cell selected model: %@", model.title);
    
    if (!_detailWindow) {
        _detailWindow = [[CSSnippetDetailWindow alloc] initWithWindowNibName:@"CSSnippetDetailWindow"];
    }
    _detailWindow.detailMode = (CSSnippetSourceSystem == model.source) ? CSSnippetDetailModeLock : CSSnippetDetailModeEdit;
    _detailWindow.snippetModel = model;
    _detailWindow.delegate = self;
    [_detailWindow.window orderFront:self];
}

- (void)didUninstallMenuClicked:(CSSnippetModel *)model
{
    [[CSCodeSnippetsManager sharedInstance] removeSnippet:model error:nil];
    
    [self readAllCodeSnippets];
}

- (void)didInstallMenuClicked:(CSSnippetModel *)model
{
    [[CSCodeSnippetsManager sharedInstance] addSnippet:model error:nil];
    
    [self readAllCodeSnippets];
}

#pragma mark - CSSnippetDetailWindowDelegate

- (void)didDeleteSnippet:(CSSnippetModel *)model
{
    [self didUninstallMenuClicked:model];
}

- (void)didAddSnippet:(CSSnippetModel *)model
{
    [self didInstallMenuClicked:model];
}

@end

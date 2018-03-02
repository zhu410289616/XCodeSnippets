//
//  CSSnippetDetailWindow.m
//  XCodeSnippets
//
//  Created by zhuruhong on 2018/1/19.
//  Copyright © 2018年 zhuruhong. All rights reserved.
//

#import "CSSnippetDetailWindow.h"
#import "NSString+PL.h"
#import "CSCodeSnippetsManager.h"
#import "NSFileManager+PL.h"
#import "CSFileManager.h"

@interface CSSnippetDetailWindow ()

@property (nonatomic, weak) IBOutlet NSTextField *titleField;
@property (nonatomic, weak) IBOutlet NSTextField *summaryField;
@property (nonatomic, weak) IBOutlet NSTextField *shortcutField;
@property (nonatomic, strong) IBOutlet NSTextView *contentsTextView;
@property (nonatomic, weak) IBOutlet NSButton *deleteButton;
@property (nonatomic, weak) IBOutlet NSButton *cancelButton;
@property (nonatomic, weak) IBOutlet NSButton *doneButton;

@end

@implementation CSSnippetDetailWindow

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    [self updateViewWithData:_snippetModel];
}

- (void)setSnippetModel:(CSSnippetModel *)snippetModel
{
    _snippetModel = snippetModel;
    [self updateViewWithData:_snippetModel];
}

- (void)updateViewWithData:(CSSnippetModel *)snippetModel
{
    _titleField.stringValue = snippetModel.title ?: @"";
    _summaryField.stringValue = snippetModel.summary ?: @"";
    _shortcutField.stringValue = snippetModel.shortcut ?: @"";
    _contentsTextView.string = snippetModel.contents ?: @"";
    
    _cancelButton.hidden = NO;
    switch (_detailMode) {
        case CSSnippetDetailModeLock:
        {
            [_titleField setEditable:NO];
            [_summaryField setEditable:NO];
            [_shortcutField setEditable:NO];
            [_contentsTextView setEditable:NO];
            _deleteButton.hidden = YES;
            _doneButton.hidden = YES;
        }
            break;
        case CSSnippetDetailModeAdd:
        {
            [_titleField setEditable:YES];
            [_summaryField setEditable:YES];
            [_shortcutField setEditable:YES];
            [_contentsTextView setEditable:YES];
            _deleteButton.hidden = YES;
            _doneButton.hidden = NO;
        }
            break;
        case CSSnippetDetailModeEdit:
        {
            [_titleField setEditable:YES];
            [_summaryField setEditable:YES];
            [_shortcutField setEditable:YES];
            [_contentsTextView setEditable:YES];
            _deleteButton.hidden = NO;
            _doneButton.hidden = NO;
        }
            break;
    }
}

- (IBAction)onDeleteButtonClicked:(id)sender
{
    //删除snippet
    if ([_delegate respondsToSelector:@selector(didDeleteSnippet:)]) {
        [_delegate didDeleteSnippet:_snippetModel];
    }
    
    [self.window close];
}

- (IBAction)onCancelButtonClicked:(id)sender
{
    [self.window close];
}

- (IBAction)onDoneButtonClicked:(id)sender
{
    //更新snippet
    NSString *title = _titleField.stringValue ?: @"";
    NSString *summary = _summaryField.stringValue ?: @"";
    NSString *shortcut = _shortcutField.stringValue ?: @"";
    NSString *contents = _contentsTextView.string ?: @"";
    NSString *identifier = shortcut;
    
    if (title.length == 0 || summary.length == 0 || shortcut.length == 0 || contents.length == 0) {
        return;
    }
    
    if (CSSnippetDetailModeAdd == _detailMode) {
        NSString *tempData = [NSString stringWithFormat:@"%@-%@-%@-%@", title, summary, shortcut, contents];
        identifier = [tempData pl_stringFromMD5];
        _snippetModel = [[CSSnippetModel alloc] init];
        _snippetModel.identifier = identifier;
        _snippetModel.source = CSSnippetSourceCustomer;
    } else if (CSSnippetDetailModeEdit == _detailMode) {
        _snippetModel.identifier = _snippetModel.identifier;
    }
    NSLog(@"identifier: %@", _snippetModel.identifier);
    _snippetModel.title = title;
    _snippetModel.summary = summary;
    _snippetModel.shortcut = shortcut;
    _snippetModel.contents = contents;
    
    //保存 code snippet
    if ([_delegate respondsToSelector:@selector(didAddSnippet:)]) {
        [_delegate didAddSnippet:_snippetModel];
    }
    
    [self.window close];
}

@end

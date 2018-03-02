//
//  CSSnippetsTableCell.m
//  XCodeSnippets
//
//  Created by zhuruhong on 2018/1/18.
//  Copyright © 2018年 zhuruhong. All rights reserved.
//

#import "CSSnippetsTableCell.h"

@implementation CSSnippetsTableCell

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat width = NSWidth(frame);
        NSRect rect = NSZeroRect;
        
        rect = NSMakeRect(11, 11, 48, 48);
        _iconImageView = [[NSImageView alloc] initWithFrame:rect];
        _iconImageView.image = [NSImage imageNamed:@"ic_system"];
        [self addSubview:_iconImageView];
        
        rect = NSMakeRect(70, 15, width-70-20, 18);
        _summaryField = [[NSTextField alloc] initWithFrame:rect];
        _summaryField.font = [NSFont systemFontOfSize:16.0f];
        _summaryField.textColor = [NSColor grayColor];
        _summaryField.drawsBackground = NO;
        _summaryField.bordered = NO;
        _summaryField.focusRingType = NSFocusRingTypeNone;
        _summaryField.editable = NO;
        [self addSubview:_summaryField];
        
        rect = NSMakeRect(70, NSMaxY(_summaryField.frame)+8, width-70-20, 20);
        _titleField = [[NSTextField alloc] initWithFrame:rect];
        _titleField.font = [NSFont systemFontOfSize:18.0f];
        _titleField.textColor = [NSColor blackColor];
        _titleField.drawsBackground = NO;
        _titleField.bordered = NO;
        _titleField.focusRingType = NSFocusRingTypeNone;
        _titleField.editable = NO;
        [self addSubview:_titleField];
        
        rect = NSMakeRect(width-11-8, (70-8)/2, 8, 8);
        _statusView = [[NSView alloc] initWithFrame:rect];
        _statusView.wantsLayer = YES;
        _statusView.layer.backgroundColor = [NSColor systemBlueColor].CGColor;
        _statusView.layer.cornerRadius = 4;
        [self addSubview:_statusView];
        
        rect = NSMakeRect(0, 0, width, 0.5);
        _lineView = [[NSView alloc] initWithFrame:rect];
        _lineView.wantsLayer = YES;
        _lineView.layer.backgroundColor = [NSColor whiteColor].CGColor;
        [self addSubview:_lineView];
        
        NSMenuItem *theItem = [[NSMenuItem alloc] init];
        theItem.enabled = YES;
        _rightMenuItem = theItem;
        
        NSMenu *rightMenu = [[NSMenu alloc] initWithTitle:@"right menu"];
        [rightMenu addItem:theItem];
        
        self.menu = rightMenu;
    }
    return self;
}

- (void)setModel:(CSSnippetModel *)model
{
    _model = model;
    
    NSString *iconName = (CSSnippetSourceSystem == _model.source) ? @"ic_system" : @"ic_user";
    _iconImageView.image = [NSImage imageNamed:iconName];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"[%@] %@", _model.shortcut, _model.title]];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[NSColor systemOrangeColor] range:NSMakeRange(0, _model.shortcut.length+2)];
    _titleField.attributedStringValue = attrStr;
    _summaryField.stringValue = [NSString stringWithFormat:@"%@", _model.summary];
    _statusView.hidden = !_model.isInstalled;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end

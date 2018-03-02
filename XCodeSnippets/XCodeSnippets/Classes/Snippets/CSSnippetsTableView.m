//
//  CSSnippetsTableView.m
//  XCodeSnippets
//
//  Created by zhuruhong on 2018/1/18.
//  Copyright © 2018年 zhuruhong. All rights reserved.
//

#import "CSSnippetsTableView.h"

@implementation CSSnippetsTableView

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [NSColor clearColor];
        self.focusRingType = NSFocusRingTypeNone;
        self.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;
        self.headerView.frame = NSZeroRect;
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end

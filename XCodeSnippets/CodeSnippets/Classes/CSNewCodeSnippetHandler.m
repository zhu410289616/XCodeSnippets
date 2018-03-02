//
//  CSNewCodeSnippetHandler.m
//  CodeSnippets
//
//  Created by zhuruhong on 2018/1/22.
//  Copyright © 2018年 zhuruhong. All rights reserved.
//

#import "CSNewCodeSnippetHandler.h"
#import <AppKit/NSWorkspace.h>
#import "NSString+PL.h"

@implementation CSNewCodeSnippetHandler

- (void)handleInvocation:(XCSourceEditorCommandInvocation *)invocation
{
    NSMutableString *theSelectedLines = [NSMutableString string];
    
    NSMutableArray <NSString *> *lines = invocation.buffer.lines;
    
    NSMutableArray <XCSourceTextRange *> *selections = invocation.buffer.selections;
    for (XCSourceTextRange *tr in selections) {
        XCSourceTextPosition start = tr.start;
        XCSourceTextPosition end = tr.end;
        NSLog(@"{%ld:%ld, %ld:%ld}", start.line, start.column, end.line, end.column);
        if (start.line == end.line && start.column == end.column) {
            continue;
        }
        
        if (start.line == end.line) {
            NSString *theLine = lines[start.line];
            theLine = [theLine substringWithRange:NSMakeRange(start.column, end.column - start.column)];
            [theSelectedLines appendFormat:@"%@", theLine];
        } else {
            for (NSInteger i=start.line; i<=end.line; i++) {
                NSString *theLine = lines[i];
                if (i == start.line) {
                    theLine = [theLine substringFromIndex:start.column];
                    [theSelectedLines appendFormat:@"%@", theLine];
                } else if (i == end.line) {
                    theLine = [theLine substringToIndex:end.column];
                    [theSelectedLines appendFormat:@"%@", theLine];
                } else {
                    [theSelectedLines appendFormat:@"%@", theLine];
                }
            }//for
        }
    }
    NSLog(@"theSelectedLines: %@", theSelectedLines);
    
    NSString *param = [theSelectedLines pl_urlEncode];
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"xcodesnippets:n%@", param]];
    [[NSWorkspace sharedWorkspace] openURL:URL];
}

@end

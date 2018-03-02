//
//  CSInsertCodeSnippetHandler.m
//  CodeSnippets
//
//  Created by zhuruhong on 2018/1/22.
//  Copyright © 2018年 zhuruhong. All rights reserved.
//

#import "CSInsertCodeSnippetHandler.h"
#import "CSCodeSnippetsManager.h"

@implementation CSInsertCodeSnippetHandler

- (void)handleInvocation:(XCSourceEditorCommandInvocation *)invocation
{
    XCSourceTextRange *selection = invocation.buffer.selections.firstObject;
    NSMutableArray *lines = invocation.buffer.lines;
    NSInteger index = selection.start.line;
    NSInteger column = selection.end.column;
    
    NSInteger matchedCount = 0;
    if (index > lines.count - 1) {
        return;
    }
    
    NSString *originalLine = lines[index];
    
    //max match length for shortcut
    for (NSInteger matchLength=8; matchLength>=1; matchLength--) {
        if (column - matchLength < 0) {
            continue;
        }
        
        NSRange targetRange = NSMakeRange(column - matchLength, matchLength);
        NSString *lastInsertStr = [originalLine substringWithRange:targetRange];
        
        NSString *matchedContents = [self matchedContentsWithShortcut:lastInsertStr];
        if (matchedContents.length == 0) {
            continue;
        }
        
        NSRange matchedRange = [originalLine rangeOfString:lastInsertStr];
        NSInteger numberOfSpaceIndent = matchedRange.location;
        NSMutableString *indentStr = [NSMutableString string];
        for (NSInteger i=numberOfSpaceIndent; i>0; i--) {
            [indentStr appendString:@" "];
        }
        
        NSArray *lines2Insert = [self convert2LinesWithCode:matchedContents];
        
        //insert 1st line
        lines[index] = [originalLine stringByReplacingOccurrencesOfString:lastInsertStr withString:lines2Insert[0] options:NSBackwardsSearch range:targetRange];
        
        //insert the rest
        for (NSInteger i=1; i<lines2Insert.count; i++) {
            NSString *item2Insert = lines2Insert[i];
            //indent
            item2Insert = [NSString stringWithFormat:@"%@%@", indentStr, item2Insert];
            [lines insertObject:item2Insert atIndex:index+i];
        }
        
        matchedCount = matchLength;
    }
    
    //adjust selection
    if (matchedCount > 0) {
        selection.start = XCSourceTextPositionMake(selection.start.line, selection.start.column - matchedCount);
        selection.end = selection.start;
    }
}

- (NSArray *)convert2LinesWithCode:(NSString *)code
{
    NSMutableArray *lines = [NSMutableArray array];
    
    NSArray *itemList = [code componentsSeparatedByString:@"\n"];
    for (NSString *item in itemList) {
        [lines addObject:item];
    }
    
    return lines;
}

- (NSString *)matchedContentsWithShortcut:(NSString *)shortcut
{
    NSDictionary *shortcutDic = [[CSCodeSnippetsManager sharedInstance] allCodeSnippetsShortcutMap];
    return shortcutDic[shortcut];
}

@end

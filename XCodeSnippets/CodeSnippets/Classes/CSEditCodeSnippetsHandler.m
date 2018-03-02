//
//  CSEditCodeSnippetsHandler.m
//  CodeSnippets
//
//  Created by zhuruhong on 2018/1/22.
//  Copyright © 2018年 zhuruhong. All rights reserved.
//

#import "CSEditCodeSnippetsHandler.h"
#import <AppKit/NSWorkspace.h>

@implementation CSEditCodeSnippetsHandler

- (void)handleInvocation:(XCSourceEditorCommandInvocation *)invocation
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"xcodesnippets:v"]];
    [[NSWorkspace sharedWorkspace] openURL:URL];
}

@end

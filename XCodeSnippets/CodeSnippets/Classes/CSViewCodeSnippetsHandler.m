//
//  CSViewCodeSnippetsHandler.m
//  CodeSnippets
//
//  Created by zhuruhong on 2018/2/1.
//  Copyright © 2018年 zhuruhong. All rights reserved.
//

#import "CSViewCodeSnippetsHandler.h"
#import <AppKit/NSWorkspace.h>

@implementation CSViewCodeSnippetsHandler

- (void)handleInvocation:(XCSourceEditorCommandInvocation *)invocation
{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"xcodesnippets:v"]];
    [[NSWorkspace sharedWorkspace] openURL:URL];
}

@end

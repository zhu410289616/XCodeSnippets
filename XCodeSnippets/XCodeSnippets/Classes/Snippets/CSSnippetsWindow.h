//
//  CSSnippetsWindow.h
//  XCodeSnippets
//
//  Created by zhuruhong on 2018/1/19.
//  Copyright © 2018年 zhuruhong. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CSSnippetDetailWindow.h"

@interface CSSnippetsWindow : NSWindowController <CSSnippetDetailWindowDelegate>

- (void)readAllCodeSnippets;

@end

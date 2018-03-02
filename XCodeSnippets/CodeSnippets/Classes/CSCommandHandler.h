//
//  CSCommandHandler.h
//  CodeSnippets
//
//  Created by zhuruhong on 2018/1/22.
//  Copyright © 2018年 zhuruhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XcodeKit/XcodeKit.h>

@protocol CSCommandHandler <NSObject>

- (void)handleInvocation:(XCSourceEditorCommandInvocation *)invocation;

@end

//
//  CSCodeSnippetsWriter.h
//  LogicService
//
//  Created by zhuruhong on 2018/1/25.
//

#import <Foundation/Foundation.h>
#import "CSSnippetModel.h"

@protocol CSCodeSnippetsWriter <NSObject>

@required

- (BOOL)writeSnippet:(CSSnippetModel *)snippet toDir:(NSString *)dir;
- (BOOL)writeSnippets:(NSArray<CSSnippetModel *> *)snippets toDir:(NSString *)dir;

@end

@interface CSCodeSnippetsWriter : NSObject <CSCodeSnippetsWriter>

@end

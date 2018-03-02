//
//  CSSystemCodeSnippetsReader.h
//  LogicService
//
//  Created by zhuruhong on 2018/1/25.
//

#import <Foundation/Foundation.h>
#import "CSCodeSnippetsReader.h"

FOUNDATION_EXPORT NSString *CSSystemCodeSnippetsDir(void);

@interface CSSystemCodeSnippetsReader : NSObject <CSCodeSnippetsReader>

@property (nonatomic, assign) CSSnippetSource source;

- (NSArray<CSSnippetModel *> *)readCodeSnippets;

@end

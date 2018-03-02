//
//  CSCodeSnippetsReader.h
//  LogicService
//
//  Created by zhuruhong on 2018/1/25.
//

#import <Foundation/Foundation.h>
#import "CSSnippetModel.h"

@protocol CSCodeSnippetsReader <NSObject>

@required

@property (nonatomic, assign) CSSnippetSource source;

- (NSArray<CSSnippetModel *> *)readCodeSnippetsWithPath:(NSString *)path;

@end

@interface CSCodeSnippetsReader : NSObject <CSCodeSnippetsReader>

@property (nonatomic, assign) CSSnippetSource source;

@end

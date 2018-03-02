//
//  SourceEditorCommand.m
//  CodeSnippets
//
//  Created by zhuruhong on 2018/1/18.
//  Copyright © 2018年 zhuruhong. All rights reserved.
//

#import "SourceEditorCommand.h"
#import "CSNewCodeSnippetHandler.h"
#import "CSEditCodeSnippetsHandler.h"
#import "CSViewCodeSnippetsHandler.h"
#import "CSInsertCodeSnippetHandler.h"

@interface SourceEditorCommand ()

@property (nonatomic, strong) NSDictionary *handlerMap;

@end

@implementation SourceEditorCommand

- (instancetype)init
{
    self = [super init];
    if (self) {
        CSNewCodeSnippetHandler *nHandler = [[CSNewCodeSnippetHandler alloc] init];
        CSEditCodeSnippetsHandler *eHandler = [[CSEditCodeSnippetsHandler alloc] init];
        CSViewCodeSnippetsHandler *vHandler = [[CSViewCodeSnippetsHandler alloc] init];
        CSInsertCodeSnippetHandler *iHanlder = [[CSInsertCodeSnippetHandler alloc] init];
        _handlerMap = @{
                        @"XCodeSnippets.NewCodeSnippet":nHandler,
                        @"XCodeSnippets.EditCodeSnippets":eHandler,
                        @"XCodeSnippets.ViewCodeSnippets":vHandler,
                        @"XCodeSnippets.InsertCodeSnippet":iHanlder
                        };
    }
    return self;
}

- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation completionHandler:(void (^)(NSError * _Nullable nilOrError))completionHandler
{
    // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
    
    NSString *command = invocation.commandIdentifier;
    NSLog(@"command: %@", command);
    
    id<CSCommandHandler> handler = _handlerMap[command];
    [handler handleInvocation:invocation];
    
    completionHandler(nil);
}

@end

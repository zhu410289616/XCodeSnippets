//
//  CSCodeSnippetsWriter.m
//  LogicService
//
//  Created by zhuruhong on 2018/1/25.
//

#import "CSCodeSnippetsWriter.h"
#import "NSString+PL.h"
#import "NSFileManager+PL.h"
#import "CSCodeSnippetsDefines.h"

@interface CSCodeSnippetsWriter ()

@property (nonatomic, strong, readonly) NSString *template;

@end

@implementation CSCodeSnippetsWriter

- (instancetype)init
{
    self = [super init];
    if (self) {
        //code snippet template
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"CodeSnippet" ofType:@"template"];
        NSData *templateData = [NSData dataWithContentsOfFile:bundlePath];
        _template = [[NSString alloc] initWithData:templateData encoding:NSUTF8StringEncoding];
    }
    return self;
}

- (BOOL)writeSnippet:(CSSnippetModel *)snippet toDir:(NSString *)dir
{
    if (![snippet isValid] || dir.length == 0) {
        CSCodeSnippetsLog(@"数据有误，Code Snippet 写入失败");
        return NO;
    }
    
    NSString *identifier = snippet.identifier;
    NSString *shortcut = [snippet.shortcut pl_replaceCharacterForXml];
    NSString *title = [snippet.title pl_replaceCharacterForXml];
    NSString *summary = [snippet.summary pl_replaceCharacterForXml];
    NSString *contents = [snippet.contents pl_replaceCharacterForXml];
    
    //生成.codesnippet文件内容
    NSString *snippetTemplate = [_template copy];
    snippetTemplate = [snippetTemplate stringByReplacingOccurrencesOfString:@"{Identifier}" withString:identifier];
    snippetTemplate = [snippetTemplate stringByReplacingOccurrencesOfString:@"{Shortcut}" withString:shortcut];
    snippetTemplate = [snippetTemplate stringByReplacingOccurrencesOfString:@"{Title}" withString:title];
    snippetTemplate = [snippetTemplate stringByReplacingOccurrencesOfString:@"{Summary}" withString:summary];
    snippetTemplate = [snippetTemplate stringByReplacingOccurrencesOfString:@"{Contents}" withString:contents];
    snippetTemplate = [snippetTemplate stringByReplacingOccurrencesOfString:@"{Version}" withString:@"2"];
    
    NSString *path = [NSFileManager pl_pathWithFilePath:dir];
    NSString *filename = [NSString stringWithFormat:@"%@/%@.codesnippet", path, identifier];
    CSCodeSnippetsLog(@"filename: %@", filename);
    
    BOOL result = [[NSFileManager defaultManager] createFileAtPath:filename contents:[snippetTemplate dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    if (result) {
        CSCodeSnippetsLog(@"自定义 Code Snippet 写入成功");
    } else {
        CSCodeSnippetsLog(@"自定义 Code Snippet 写入成功");
    }
    
    return result;
}

- (BOOL)writeSnippets:(NSArray<CSSnippetModel *> *)snippets toDir:(NSString *)dir
{
    if (dir.length == 0) {
        return NO;
    }
    
    for (CSSnippetModel *item in snippets) {
        [self writeSnippet:item toDir:dir];
    }
    return YES;
}

@end

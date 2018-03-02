//
//  CSCodeSnippetsReader.m
//  LogicService
//
//  Created by zhuruhong on 2018/1/25.
//

#import "CSCodeSnippetsReader.h"

@implementation CSCodeSnippetsReader

- (NSArray<CSSnippetModel *> *)readCodeSnippetsWithPath:(NSString *)path
{
    if (path.length == 0) {
        return nil;
    }
    
    NSMutableArray *theSnippets = [NSMutableArray array];
    
    NSArray *snippetFileArray = [self getCodeSnippetFilesWithDir:path];
    
    for (NSString *item in snippetFileArray) {
        NSDictionary *plistData = [NSDictionary dictionaryWithContentsOfFile:item];
        CSSnippetModel *model = [[CSSnippetModel alloc] initWithIDEDic:plistData];
        if (![model isValid]) {
            continue;
        }
        model.source = _source;
        model.isInstalled = (CSSnippetSourceCustomer == _source);
        [theSnippets addObject:model];
    }
    
    return theSnippets;
}

#pragma mark - private function

- (NSArray<NSString *> *)getCodeSnippetFilesWithDir:(NSString *)aDir
{
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:aDir]) {
        return nil;
    }
    
    NSError *error;
    NSArray *contents = [fm contentsOfDirectoryAtPath:aDir error:&error];
    if (error) {
        return nil;
    }
    
    NSMutableArray *theFileArray = [[NSMutableArray alloc] init];
    for (NSString *name in contents) {
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", aDir, name];
        
        NSDictionary *fileAttributes = [fm attributesOfItemAtPath:filePath error:&error];
        NSString *fileType = [fileAttributes objectForKey:@"NSFileType"];
        if ([fileType isEqualToString:NSFileTypeRegular]) {
            NSString *ext = [[name lowercaseString] pathExtension];
            if ([ext hasSuffix:@"codesnippet"]) {
                [theFileArray addObject:filePath];
            }
        }
    }
    
    return theFileArray;
}

@end

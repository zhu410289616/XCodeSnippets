//
//  CSSnippetModel.m
//  XCodeSnippets
//
//  Created by zhuruhong on 2018/1/18.
//  Copyright © 2018年 zhuruhong. All rights reserved.
//

#import "CSSnippetModel.h"
#import "NSString+PL.h"

@implementation CSSnippetModel

- (BOOL)isValid
{
    if (_identifier.length == 0 || _title.length == 0 || _summary.length == 0 || _shortcut.length == 0 || _contents.length == 0) {
        return NO;
    }
    return YES;
}

@end

@implementation CSSnippetModel (Dictionary)

- (instancetype)initWithIDEDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        _identifier = dic[@"IDECodeSnippetIdentifier"];
        _shortcut = dic[@"IDECodeSnippetCompletionPrefix"];
        _title = dic[@"IDECodeSnippetTitle"];
        _summary = dic[@"IDECodeSnippetSummary"];
        _contents = dic[@"IDECodeSnippetContents"];
    }
    return self;
}

@end

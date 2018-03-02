//
//  CSSnippetDetailWindow.h
//  XCodeSnippets
//
//  Created by zhuruhong on 2018/1/19.
//  Copyright © 2018年 zhuruhong. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CSSnippetModel.h"

typedef NS_ENUM(NSInteger, CSSnippetDetailMode) {
    CSSnippetDetailModeLock = 0,
    CSSnippetDetailModeAdd,
    CSSnippetDetailModeEdit
};

@protocol CSSnippetDetailWindowDelegate <NSObject>

- (void)didDeleteSnippet:(CSSnippetModel *)model;
- (void)didAddSnippet:(CSSnippetModel *)model;

@end

@interface CSSnippetDetailWindow : NSWindowController

@property (nonatomic, weak) id<CSSnippetDetailWindowDelegate> delegate;
@property (nonatomic, assign) CSSnippetDetailMode detailMode;
@property (nonatomic, strong) CSSnippetModel *snippetModel;

@end

//
//  CSSnippetsView.h
//  XCodeSnippets
//
//  Created by zhuruhong on 2018/1/18.
//  Copyright © 2018年 zhuruhong. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CSSnippetsTableView.h"
#import "CSSnippetsTableAdapter.h"

@interface CSSnippetsView : NSView

@property (nonatomic, strong) NSScrollView *scrollView;
@property (nonatomic, strong) CSSnippetsTableAdapter *tableAdapter;
@property (nonatomic, strong) CSSnippetsTableView *tableView;

- (void)updateViewWithData:(NSArray *)snippets;

@end

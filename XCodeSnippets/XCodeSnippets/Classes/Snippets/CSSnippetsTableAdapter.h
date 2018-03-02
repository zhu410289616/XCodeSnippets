//
//  CSSnippetsTableAdapter.h
//  XCodeSnippets
//
//  Created by zhuruhong on 2018/1/18.
//  Copyright © 2018年 zhuruhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "CSSnippetModel.h"
#import "CSSnippetsTableCell.h"

@protocol CSSnippetsTableAdapterDelegate <NSObject>

- (void)didCellSelected:(CSSnippetModel *)model;
- (void)didUninstallMenuClicked:(CSSnippetModel *)model;
- (void)didInstallMenuClicked:(CSSnippetModel *)model;

@end

@interface CSSnippetsTableAdapter : NSObject <NSTableViewDataSource, NSTableViewDelegate>

@property (nonatomic, strong) NSMutableArray<CSSnippetModel *> *dataArray;
@property (nonatomic, weak) id<CSSnippetsTableAdapterDelegate> delegate;

- (instancetype)initWithTestData;

@end

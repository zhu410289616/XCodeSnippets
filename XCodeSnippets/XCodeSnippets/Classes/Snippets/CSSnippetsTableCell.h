//
//  CSSnippetsTableCell.h
//  XCodeSnippets
//
//  Created by zhuruhong on 2018/1/18.
//  Copyright © 2018年 zhuruhong. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CSSnippetModel.h"

@interface CSSnippetsTableCell : NSTableCellView

@property (nonatomic, strong) NSMenuItem *rightMenuItem;
@property (nonatomic, strong) NSImageView *iconImageView;
@property (nonatomic, strong) NSTextField *titleField;
@property (nonatomic, strong) NSTextField *summaryField;
@property (nonatomic, strong) NSView *statusView;
@property (nonatomic, strong) NSView *lineView;
@property (nonatomic, strong) CSSnippetModel *model;

@end

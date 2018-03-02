//
//  CSSnippetModel.h
//  XCodeSnippets
//
//  Created by zhuruhong on 2018/1/18.
//  Copyright © 2018年 zhuruhong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CSSnippetSource) {
    CSSnippetSourceSystem = 0,
    CSSnippetSourceApp = 1,
    CSSnippetSourceCustomer = 2
};

@interface CSSnippetModel : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *shortcut;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *contents;
@property (nonatomic, assign) CSSnippetSource source;
@property (nonatomic, assign) BOOL isInstalled;

- (BOOL)isValid;

@end

@interface CSSnippetModel (Dictionary)

- (instancetype)initWithIDEDic:(NSDictionary *)dic;

@end

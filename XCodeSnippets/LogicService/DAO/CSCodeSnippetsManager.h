//
//  CSCodeSnippetsManager.h
//  XCodeSnippets
//
//  Created by zhuruhong on 2018/1/21.
//  Copyright © 2018年 zhuruhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSSnippetModel.h"

FOUNDATION_EXPORT NSString *CSAppCodeSnippetsDir(void);
FOUNDATION_EXPORT NSString *CSCustomerCodeSnippetsDir(void);

@interface CSCodeSnippetsManager : NSObject

+ (instancetype)sharedInstance;

- (BOOL)installAppCodeSnippets;
- (BOOL)uninstallCustomerCodeSnippets;

- (NSArray<CSSnippetModel *> *)allCodeSnippets;
- (BOOL)addSnippet:(CSSnippetModel *)snippet error:(NSError **)error;
- (BOOL)removeSnippet:(CSSnippetModel *)snippet error:(NSError **)error;

/** 主app和插件不贡献实例，主app修改数据后，插件每次都需要通过共享空间读取最新数据 */
- (NSDictionary *)allCodeSnippetsShortcutMap;

@end

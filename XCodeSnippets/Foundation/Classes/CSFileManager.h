//
//  CSFileManager.h
//  XCodeSnippets
//
//  Created by zhuruhong on 2018/1/19.
//  Copyright © 2018年 zhuruhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSFileManager : NSObject

- (instancetype)initWithFilePath:(NSString *)filePath;
- (void)writeData:(NSData *)data;
- (void)writeData:(NSData *)data seekToEnd:(BOOL)seekToEnd;

@end

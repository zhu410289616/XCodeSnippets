//
//  CSFileManager.m
//  XCodeSnippets
//
//  Created by zhuruhong on 2018/1/19.
//  Copyright © 2018年 zhuruhong. All rights reserved.
//

#import "CSFileManager.h"

@interface CSFileManager ()

@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) NSFileHandle *fileHandle;

@end

@implementation CSFileManager

- (instancetype)initWithFilePath:(NSString *)filePath
{
    if (self = [super init]) {
        _filePath = filePath;
    }
    return self;
}

- (NSFileHandle *)fileHandle
{
    if (_fileHandle) {
        return _fileHandle;
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:_filePath]) {
        [[NSFileManager defaultManager] createFileAtPath:_filePath contents:nil attributes:nil];
    }
    
    _fileHandle = [NSFileHandle fileHandleForWritingAtPath:_filePath];
    return _fileHandle;
}

- (void)writeData:(NSData *)data
{
    [self writeData:data seekToEnd:YES];
}

- (void)writeData:(NSData *)data seekToEnd:(BOOL)seekToEnd
{
    if (data.length == 0) {
        return;
    }
    
    if (seekToEnd) {
        [self.fileHandle seekToEndOfFile];
    }
    
    [self.fileHandle writeData:data];
}

@end

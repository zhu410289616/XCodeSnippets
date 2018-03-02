//
//  NSFileManager+PL.h
//  PLFoundation
//
//  Created by zhuruhong on 2017/12/15.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (PL)

+ (NSString *)pl_pathWithFilePath:(NSString *)filepath;
+ (NSString *)pl_directoryInUserDomain:(NSSearchPathDirectory)directory;
+ (NSString *)pl_cacheDirectory;
+ (NSString *)pl_documentDirectory;
+ (unsigned long long)pl_fileSizeWithFilePath:(NSString *)filepath;
+ (unsigned long long)pl_fileSizeWithDirectory:(NSString *)directory;

+ (NSString *)pl_formatSpace:(double)tSpaceSize;

@end

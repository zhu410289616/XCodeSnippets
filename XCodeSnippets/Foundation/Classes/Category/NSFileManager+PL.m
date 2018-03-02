//
//  NSFileManager+PL.m
//  PLFoundation
//
//  Created by zhuruhong on 2017/12/15.
//

#import "NSFileManager+PL.h"

@implementation NSFileManager (PL)

+ (NSString *)pl_pathWithFilePath:(NSString *)filepath
{
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filepath isDirectory:NULL]) {
        return filepath;
    }
    [fm createDirectoryAtPath:filepath withIntermediateDirectories:YES attributes:nil error:nil];
    return filepath;
}

+ (NSString *)pl_directoryInUserDomain:(NSSearchPathDirectory)directory
{
    NSArray *directories = NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES);
    NSString *dir = [directories[0] stringByAppendingPathComponent:[NSProcessInfo processInfo].processName];
    return [self pl_pathWithFilePath:dir];
}

+ (NSString *)pl_cacheDirectory
{
    return [self pl_directoryInUserDomain:NSCachesDirectory];
}

+ (NSString *)pl_documentDirectory
{
    return [self pl_directoryInUserDomain:NSDocumentDirectory];
}

+ (unsigned long long)pl_fileSizeWithFilePath:(NSString *)filepath
{
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filepath isDirectory:NULL]) {
        NSDictionary *fileAttributes = [fm attributesOfItemAtPath:filepath error:nil];
        return [fileAttributes fileSize];
    }
    return 0;
}

+ (unsigned long long)pl_fileSizeWithDirectory:(NSString *)directory
{
    unsigned long long totalSize = 0;
    
    if (directory.length == 0) {
        return 0;
    }
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:directory]) {
        NSError *error;
        NSArray *contents = [fm contentsOfDirectoryAtPath:directory error:&error];
        if (error) {
            return 0;
        }
        
        for (id info in contents) {
            NSString *infoPath = [NSString stringWithFormat:@"%@/%@", directory, info];
            if ([fm fileExistsAtPath:infoPath isDirectory:NULL]) {
                NSDictionary *fileAttributes = [fm attributesOfItemAtPath:infoPath error:nil];
                totalSize += [fileAttributes fileSize];
            } else {
                totalSize += [NSFileManager pl_fileSizeWithDirectory:infoPath];
            }
        }
    }
    return totalSize;
}

+ (NSString *)pl_formatSpace:(double)tSpaceSize
{
    NSString *strUnit = @"B";
    int times = 0;
    double freespace = tSpaceSize;
    while (freespace > 1024) {
        times++;
        if (times == 1) {
            strUnit = @"KB";
        } else if (times == 2) {
            strUnit = @"MB";
        } else if (times == 3) {
            strUnit = @"GB";
        }
        freespace = freespace / 1024;
    }
    return [NSString stringWithFormat:@"%.2f %@", freespace, strUnit];
}

@end

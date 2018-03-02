//
//  NSUserDefaults+PL.m
//  PLFoundation
//
//  Created by zhuruhong on 2017/12/15.
//

#import "NSUserDefaults+PL.h"

@implementation NSUserDefaults (PL)

#pragma mark - read

+ (NSString *)pl_stringForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:defaultName];
}

+ (NSData *)pl_dataForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] dataForKey:defaultName];
}

+ (NSInteger)pl_integerForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:defaultName];
}

+ (float)pl_floatForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] floatForKey:defaultName];
}

+ (double)pl_doubleForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:defaultName];
}

+ (BOOL)pl_boolForKey:(NSString *)defaultName
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:defaultName];
}

#pragma mark - write

+ (void)pl_setObject:(id)value forKey:(NSString *)defaultName
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

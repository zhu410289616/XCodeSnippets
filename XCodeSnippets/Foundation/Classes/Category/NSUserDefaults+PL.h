//
//  NSUserDefaults+PL.h
//  PLFoundation
//
//  Created by zhuruhong on 2017/12/15.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (PL)

#pragma mark - read

+ (NSString *)pl_stringForKey:(NSString *)defaultName;
+ (NSData *)pl_dataForKey:(NSString *)defaultName;
+ (NSInteger)pl_integerForKey:(NSString *)defaultName;
+ (float)pl_floatForKey:(NSString *)defaultName;
+ (double)pl_doubleForKey:(NSString *)defaultName;
+ (BOOL)pl_boolForKey:(NSString *)defaultName;

#pragma mark - write

+ (void)pl_setObject:(id)value forKey:(NSString *)defaultName;

@end

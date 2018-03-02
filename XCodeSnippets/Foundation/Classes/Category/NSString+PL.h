//
//  NSString+PL.h
//  PLFoundation
//
//  Created by zhuruhong on 2017/12/15.
//

#import <Foundation/Foundation.h>

@interface NSString (PL)

+ (NSString *)pl_stringWithBundleShortVersion;
+ (NSString *)pl_stringWithBundleVersion;
+ (NSString *)pl_stringWithBundleName;
+ (NSString *)pl_stringWithAppVersion;

+ (NSString *)pl_stringWithDocumentDir;

+ (NSString *)pl_stringWithUUID;

- (NSString *)pl_stringFromMD5;

+ (NSString *)pl_safeString:(NSString *)srcStr defaultValue:(NSString *)defaultValue;

- (NSString *)pl_replaceCharacterForXml;

@end

@interface NSString (PL_Encoding_Decoding)

- (NSString *)pl_urlEncode;
- (NSString *)pl_urlDecode;

@end

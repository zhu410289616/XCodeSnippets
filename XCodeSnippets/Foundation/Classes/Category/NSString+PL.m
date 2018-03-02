//
//  NSString+PL.m
//  PLFoundation
//
//  Created by zhuruhong on 2017/12/15.
//

#import "NSString+PL.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (PL)

+ (NSString *)pl_stringWithBundleShortVersion
{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:bundlePath];
    NSString *bundleShortVersion = dict[@"CFBundleShortVersionString"];
    return bundleShortVersion;
}

+ (NSString *)pl_stringWithBundleVersion
{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:bundlePath];
    NSString *bundleVersion = dict[@"CFBundleVersion"];
    return bundleVersion;
}

+ (NSString *)pl_stringWithBundleName
{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:bundlePath];
    NSString *bundleName = dict[@"CFBundleName"];
    return bundleName;
}

+ (NSString *)pl_stringWithAppVersion
{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:bundlePath];
    NSString *bundleVersion = dict[@"CFBundleShortVersionString"];
    NSString *bundleName = dict[@"CFBundleName"];
    return [NSString stringWithFormat:@"%@ v%@", bundleName, bundleVersion];
}

+ (NSString *)pl_stringWithDocumentDir
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    return documentPath;
}

+ (NSString *)pl_stringWithUUID
{
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *uuidStr = CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    return uuidStr;
}

- (NSString *)pl_stringFromMD5
{
    
    if(self == nil || [self length] == 0) {
        return nil;
    }
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

+ (NSString *)pl_safeString:(NSString *)srcStr defaultValue:(NSString *)defaultValue
{
    return (srcStr.length == 0) ? defaultValue : srcStr;
}

- (NSString *)pl_replaceCharacterForXml
{
    NSString *dstStr = self;
    dstStr = [dstStr stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    dstStr = [dstStr stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    dstStr = [dstStr stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    dstStr = [dstStr stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];
    dstStr = [dstStr stringByReplacingOccurrencesOfString:@"'" withString:@"&apos;"];
    return dstStr;
}

@end

@implementation NSString (PL_Encoding_Decoding)

- (NSString *)pl_urlEncode
{
    return [self pl_urlEncodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)pl_urlEncodeUsingEncoding:(NSStringEncoding)encoding
{
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)self, NULL, (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", CFStringConvertNSStringEncodingToEncoding(encoding));
}

- (NSString *)pl_urlDecode
{
    return [self pl_urlDecodeUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)pl_urlDecodeUsingEncoding:(NSStringEncoding)encoding
{
    return (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)self, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(encoding));
}

@end

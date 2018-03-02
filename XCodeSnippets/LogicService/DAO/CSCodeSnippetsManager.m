//
//  CSCodeSnippetsManager.m
//  XCodeSnippets
//
//  Created by zhuruhong on 2018/1/21.
//  Copyright © 2018年 zhuruhong. All rights reserved.
//

#import "CSCodeSnippetsManager.h"
#import "CSSystemCodeSnippetsReader.h"
#import "CSCodeSnippetsReader.h"
#import "CSCodeSnippetsWriter.h"

NSString *CSAppCodeSnippetsDir(void)
{
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"com.zrh.XCodeSnippets.group"];
    return containerURL.path;
}

NSString *CSCustomerCodeSnippetsDir(void)
{
    return [NSString stringWithFormat:@"%@/Library/Developer/Xcode/UserData/CodeSnippets", NSHomeDirectory()];
}

static inline void CSTransformForIdentifier(NSArray *srcSnippets, NSMutableDictionary *dstSnippets)
{
    NSArray *theSnippets = srcSnippets;
    for (CSSnippetModel *item in theSnippets) {
        if (item.identifier.length == 0) {
            continue;
        }
        dstSnippets[item.identifier] = item;
    }
}

static inline void CSTransformForShortcut(NSArray *srcSnippets, NSMutableDictionary *dstShortcutDic)
{
    for (CSSnippetModel *item in srcSnippets) {
        if (![item isValid]) {
            continue;
        }
        dstShortcutDic[item.shortcut] = item.contents;
    }
}

@interface CSCodeSnippetsManager ()

@property (nonatomic, strong) NSMutableDictionary *systemSnippetsDic;
@property (nonatomic, strong) NSMutableDictionary *appSnippetsDic;
@property (nonatomic, strong) NSMutableDictionary *customerSnippetsDic;

@property (nonatomic, strong) CSSystemCodeSnippetsReader *systemCSReader;
@property (nonatomic, strong) CSCodeSnippetsReader *appCSReader;
@property (nonatomic, strong) CSCodeSnippetsReader *customerCSReader;

@property (nonatomic, strong) CSCodeSnippetsWriter *appCSWriter;
@property (nonatomic, strong) CSCodeSnippetsWriter *customerCSWriter;

@end

@implementation CSCodeSnippetsManager

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //cache
        _systemSnippetsDic = [NSMutableDictionary dictionary];
        _appSnippetsDic = [NSMutableDictionary dictionary];
        _customerSnippetsDic = [NSMutableDictionary dictionary];
        
        //reader
        _systemCSReader = [[CSSystemCodeSnippetsReader alloc] init];
        _systemCSReader.source = CSSnippetSourceSystem;
        
        _appCSReader = [[CSCodeSnippetsReader alloc] init];
        _appCSReader.source = CSSnippetSourceApp;
        
        _customerCSReader = [[CSCodeSnippetsReader alloc] init];
        _customerCSReader.source = CSSnippetSourceCustomer;
        
        __weak typeof(self) weakSelf = self;
        [self readAllCodeSnippetsFromFile:^(NSArray *systemSnippets, NSArray *appSnippets, NSArray *customerSnippets) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.systemSnippetsDic removeAllObjects];
            [strongSelf.appSnippetsDic removeAllObjects];
            [strongSelf.customerSnippetsDic removeAllObjects];
            CSTransformForIdentifier(systemSnippets, strongSelf.systemSnippetsDic);
            CSTransformForIdentifier(appSnippets, strongSelf.appSnippetsDic);
            CSTransformForIdentifier(customerSnippets, strongSelf.customerSnippetsDic);
        }];
        
        //writer
        _appCSWriter = [[CSCodeSnippetsWriter alloc] init];
        _customerCSWriter = [[CSCodeSnippetsWriter alloc] init];
    }
    return self;
}

- (BOOL)installAppCodeSnippets
{
    NSArray *appSnippets = _appSnippetsDic.allValues;
    
    for (CSSnippetModel *item in appSnippets) {
        [_appCSWriter writeSnippet:item toDir:CSCustomerCodeSnippetsDir()];
    }
    
    __weak typeof(self) weakSelf = self;
    [self readAllCodeSnippetsFromFile:^(NSArray *systemSnippets, NSArray *appSnippets, NSArray *customerSnippets) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.systemSnippetsDic removeAllObjects];
        [strongSelf.appSnippetsDic removeAllObjects];
        [strongSelf.customerSnippetsDic removeAllObjects];
        CSTransformForIdentifier(systemSnippets, strongSelf.systemSnippetsDic);
        CSTransformForIdentifier(appSnippets, strongSelf.appSnippetsDic);
        CSTransformForIdentifier(customerSnippets, strongSelf.customerSnippetsDic);
    }];
    
    return YES;
}

- (BOOL)uninstallCustomerCodeSnippets
{
    NSArray *customerSnippets = _customerSnippetsDic.allValues;
    
    for (CSSnippetModel *item in customerSnippets) {
        NSString *cFilename = [NSString stringWithFormat:@"%@/%@.codesnippet", CSCustomerCodeSnippetsDir(), item.identifier];
        [[NSFileManager defaultManager] removeItemAtPath:cFilename error:nil];
    }
    
    __weak typeof(self) weakSelf = self;
    [self readAllCodeSnippetsFromFile:^(NSArray *systemSnippets, NSArray *appSnippets, NSArray *customerSnippets) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.systemSnippetsDic removeAllObjects];
        [strongSelf.appSnippetsDic removeAllObjects];
        [strongSelf.customerSnippetsDic removeAllObjects];
        CSTransformForIdentifier(systemSnippets, strongSelf.systemSnippetsDic);
        CSTransformForIdentifier(appSnippets, strongSelf.appSnippetsDic);
        CSTransformForIdentifier(customerSnippets, strongSelf.customerSnippetsDic);
    }];
    
    return YES;
}

- (NSArray<CSSnippetModel *> *)allCodeSnippets
{
    NSMutableDictionary *theSnippetsDic = [NSMutableDictionary dictionary];
    [theSnippetsDic addEntriesFromDictionary:_systemSnippetsDic];
    [theSnippetsDic addEntriesFromDictionary:_appSnippetsDic];
    [theSnippetsDic addEntriesFromDictionary:_customerSnippetsDic];
    
    NSMutableArray *sortedSnippets = [NSMutableArray arrayWithCapacity:theSnippetsDic.allValues.count];
    [sortedSnippets addObjectsFromArray:theSnippetsDic.allValues];
    
    [sortedSnippets sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        CSSnippetModel *model1 = obj1;
        CSSnippetModel *model2 = obj2;
        
        if (model1.source > model2.source) {
            return NSOrderedAscending;
        } else if (model1.source < model2.source) {
            return NSOrderedDescending;
        } else {
            NSString *title1 = [model1.title lowercaseString] ?: @"";
            NSString *title2 = [model2.title lowercaseString] ?: @"";
            return [title1 compare:title2];
        }
        
    }];
    
    return sortedSnippets;
}

- (BOOL)addSnippet:(CSSnippetModel *)snippet error:(NSError **)error;
{
    if (![snippet isValid]) {
        return NO;
    }
    
    snippet.isInstalled = YES;
    _appSnippetsDic[snippet.identifier] = snippet;
    _customerSnippetsDic[snippet.identifier] = snippet;
    
    //数据写入cs共享目录(主app和插件共享空间)
    [_appCSWriter writeSnippet:snippet toDir:CSAppCodeSnippetsDir()];
    //数据写入Xcode自定义cs目录
    [_customerCSWriter writeSnippet:snippet toDir:CSCustomerCodeSnippetsDir()];
    
    return YES;
}

- (BOOL)removeSnippet:(CSSnippetModel *)snippet error:(NSError **)error
{
    if (snippet.identifier.length == 0) {
        return NO;
    }
    
    CSSnippetModel *model = _appSnippetsDic[snippet.identifier];
    model.isInstalled = NO;
    
    model = _customerSnippetsDic[snippet.identifier];
    model.isInstalled = NO;
    
    //app
    NSString *aFilename = [NSString stringWithFormat:@"%@/%@.codesnippet", CSAppCodeSnippetsDir(), snippet.identifier];
    [[NSFileManager defaultManager] removeItemAtPath:aFilename error:nil];
    
    //customer
    NSString *cFilename = [NSString stringWithFormat:@"%@/%@.codesnippet", CSCustomerCodeSnippetsDir(), snippet.identifier];
    BOOL result = [[NSFileManager defaultManager] removeItemAtPath:cFilename error:error];
    return result;
}

/** 主app和插件不贡献实例，主app修改数据后，插件每次都需要通过共享空间读取最新数据 */
- (NSDictionary *)allCodeSnippetsShortcutMap
{
    NSMutableDictionary *theShortcutDic = [NSMutableDictionary dictionary];
    
    //reader
    [self readAllCodeSnippetsFromFile:^(NSArray *systemSnippets, NSArray *appSnippets, NSArray *customerSnippets) {
        CSTransformForShortcut(systemSnippets, theShortcutDic);
        CSTransformForShortcut(appSnippets, theShortcutDic);
        CSTransformForShortcut(customerSnippets, theShortcutDic);
    }];
    
    return theShortcutDic;
}

#pragma mark - private function

- (void)readAllCodeSnippetsFromFile:(void(^)(NSArray *systemSnippets, NSArray *appSnippets, NSArray *customerSnippets))completeBlock
{
    NSArray *systemSnippets = [_systemCSReader readCodeSnippets];
    NSArray *appSnippets = [_appCSReader readCodeSnippetsWithPath:CSAppCodeSnippetsDir()];
    NSArray *customerSnippets = [_customerCSReader readCodeSnippetsWithPath:CSCustomerCodeSnippetsDir()];
    completeBlock(systemSnippets, appSnippets, customerSnippets);
}

@end

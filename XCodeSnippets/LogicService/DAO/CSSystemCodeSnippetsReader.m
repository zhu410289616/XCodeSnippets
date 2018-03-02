//
//  CSSystemCodeSnippetsReader.m
//  LogicService
//
//  Created by zhuruhong on 2018/1/25.
//

#import "CSSystemCodeSnippetsReader.h"
#import "CSCodeSnippetsDefines.h"

NSString *CSSystemCodeSnippetsDir(void)
{
    return @"/Applications/Xcode.app/Contents/Frameworks/IDEKit.framework/Versions/A/Resources/SystemCodeSnippets.codesnippets";
}

@interface CSSystemCodeSnippetsReader () <NSXMLParserDelegate>

@property (nonatomic, strong) NSMutableArray<CSSnippetModel *> *snippets;

@property (nonatomic, strong) NSMutableDictionary *processDic;
@property (nonatomic, strong) NSString *processKey;
@property (nonatomic, strong) NSString *processValue;

@property (nonatomic, strong) NSArray *storingElement;
@property (nonatomic, assign) BOOL shouldStoring;
@property (nonatomic, strong) NSMutableString *storingStr;

@end

@implementation CSSystemCodeSnippetsReader

- (instancetype)init
{
    self = [super init];
    if (self) {
        _snippets = [NSMutableArray array];
        _storingElement = @[ @"key", @"string", @"integer" ];
        _storingStr = [NSMutableString string];
    }
    return self;
}

- (NSArray<CSSnippetModel *> *)readCodeSnippets
{
    return [self readCodeSnippetsWithPath:CSSystemCodeSnippetsDir()];
}

- (NSArray<CSSnippetModel *> *)readCodeSnippetsWithPath:(NSString *)path
{
    NSData *snippetsData = [NSData dataWithContentsOfFile:path];
    if (snippetsData.length == 0) {
        return nil;
    }
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:snippetsData];
    parser.delegate = self;
    parser.shouldProcessNamespaces = NO;
    parser.shouldReportNamespacePrefixes = NO;
    parser.shouldResolveExternalEntities = NO;
    BOOL result = [parser parse];
#ifdef DEBUG
    if (result) {
        CSCodeSnippetsLog(@"sinippet count: %ld", _snippets.count);
    } else {
        CSCodeSnippetsLog(@"parserError: %@", parser.parserError);
    }
#endif
    return _snippets;
}

#pragma mark - NSXMLParserDelegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    CSCodeSnippetsLog(@"parserDidStartDocument...");
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict
{
    CSCodeSnippetsLog(@"didStartElement elementName: %@", elementName);
    
    if ([elementName isEqualToString:@"dict"]) {
        _processDic = [NSMutableDictionary dictionary];
    }
    
    _shouldStoring = [_storingElement containsObject:elementName];
    if (_shouldStoring) {
        _storingStr = [NSMutableString string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    CSCodeSnippetsLog(@"didEndElement elementName: %@", elementName);
    
    if (_shouldStoring) {
        NSString *storingValue = [NSString stringWithFormat:@"%@", _storingStr];
        
        if ([elementName isEqualToString:@"key"]) {
            _processKey = storingValue;
        } else if ([elementName isEqualToString:@"string"] || [elementName isEqualToString:@"integer"]) {
            _processValue = storingValue;
            
            _processDic[_processKey] = _processValue;
        }
    }
    
    if ([elementName isEqualToString:@"dict"] && _processDic.allKeys.count > 0) {
        CSSnippetModel *model = [[CSSnippetModel alloc] initWithIDEDic:_processDic];
        model.source = _source;
        [_snippets addObject:model];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    CSCodeSnippetsLog(@"storingCharacterData string: %@", string);
    
    if (_shouldStoring) {
        [_storingStr appendFormat:@"%@", string];
    }
}

@end

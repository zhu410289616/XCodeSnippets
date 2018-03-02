//
//  AppDelegate.m
//  XCodeSnippets
//
//  Created by zhuruhong on 2018/1/18.
//  Copyright © 2018年 zhuruhong. All rights reserved.
//

#import "AppDelegate.h"
#import "CSSnippetsWindow.h"
#import "CSSnippetDetailWindow.h"
#import "CSSnippetsAboutWindow.h"
#import "NSString+PL.h"
#import "CSCodeSnippetsManager.h"

@interface AppDelegate ()

@property (nonatomic, strong) CSSnippetsWindow *snippetsWindow;
@property (nonatomic, strong) CSSnippetDetailWindow *detailWindow;
@property (nonatomic, strong) CSSnippetsAboutWindow *aboutWindow;

@end

@implementation AppDelegate

#pragma mark - getter & setter

- (CSSnippetsWindow *)snippetsWindow
{
    if (!_snippetsWindow) {
        _snippetsWindow = [[CSSnippetsWindow alloc] initWithWindowNibName:@"CSSnippetsWindow"];
    }
    return _snippetsWindow;
}

- (CSSnippetDetailWindow *)detailWindow
{
    if (!_detailWindow) {
        _detailWindow = [[CSSnippetDetailWindow alloc] initWithWindowNibName:@"CSSnippetDetailWindow"];
    }
    return _detailWindow;
}

- (CSSnippetsAboutWindow *)aboutWindow
{
    if (!_aboutWindow) {
        _aboutWindow = [[CSSnippetsAboutWindow alloc] initWithWindowNibName:@"CSSnippetsAboutWindow"];
    }
    return _aboutWindow;
}

#pragma mark - action

- (void)handleURLEvent:(NSAppleEventDescriptor*)theEvent withReplyEvent:(NSAppleEventDescriptor*)replyEvent {
    // Process URL Request
    NSString *path = [[theEvent paramDescriptorForKeyword:keyDirectObject] stringValue];
    NSString *param = [path substringFromIndex:@"xcodesnippets:".length];
    param = [param pl_urlDecode];
    NSString *tag = [param substringWithRange:NSMakeRange(0, 1)];
    
    if ([tag isEqualToString:@"n"]) {
        CSSnippetModel *model = [[CSSnippetModel alloc] init];
        model.contents = [param substringFromIndex:1];
        
        self.detailWindow.delegate = self.snippetsWindow;
        self.detailWindow.detailMode = CSSnippetDetailModeAdd;
        self.detailWindow.snippetModel = model;
        [self.detailWindow.window orderFront:self];
    } else if ([tag isEqualToString:@"v"]) {
        NSLog(@"param: %@", param);
    } else {
        NSLog(@"param: %@", param);
    }
}

- (IBAction)newCodeSnippet:(id)sender
{
    NSLog(@"new code snippet");
    self.detailWindow.delegate = self.snippetsWindow;
    self.detailWindow.detailMode = CSSnippetDetailModeAdd;
    [self.detailWindow.window orderFront:self];
}

- (IBAction)installAllCodeSnippets:(id)sender
{
    [[CSCodeSnippetsManager sharedInstance] installAppCodeSnippets];
    [self.snippetsWindow readAllCodeSnippets];
}

- (IBAction)uninstallAllCodeSnippets:(id)sender
{
    [[CSCodeSnippetsManager sharedInstance] uninstallCustomerCodeSnippets];
    [self.snippetsWindow readAllCodeSnippets];
}

- (void)aboutXCodeSnippets
{
    NSLog(@"about code snippets");
    [self.aboutWindow.window orderFront:self];
}

#pragma mark - delegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self andSelector:@selector(handleURLEvent:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];
    
    [self.snippetsWindow.window makeKeyAndOrderFront:nil];
    [self addMenu];
}

- (void)addMenu
{
    NSMenu *mainMenu = [NSApp mainMenu];
    NSMenuItem *menuItem = nil;
    NSMenu *subMenu = nil;
    
    //about
    menuItem = [[NSMenuItem alloc] init];
    menuItem.title = @"About";
    [mainMenu addItem:menuItem];
    
    subMenu = [[NSMenu alloc] initWithTitle:@"About"];
    [subMenu addItemWithTitle:@"About" action:@selector(aboutXCodeSnippets) keyEquivalent:@"A"];
    menuItem.submenu = subMenu;
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag
{
    if (flag) {
        return NO;
    } else {
        [_snippetsWindow.window makeKeyAndOrderFront:self];
        return YES;
    }
}

@end

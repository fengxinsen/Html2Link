//
//  MainViewController.m
//  Html2Link
//
//  Created by video on 15/9/11.
//  Copyright (c) 2015年 Hinson.Von. All rights reserved.
//

#import "MainViewController.h"

#import <TFHpple.h>

#import "ResultData.h"
#import "ResultViewController.h"

@interface MainViewController ()
{
    NSString *resultTitle;
}
@end

static NSString * const url_6v = @"http://www.6vhao.com/";

@implementation MainViewController

- (void)dealloc {
    resultTitle = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:@"readNSPasteboard"];
    [[NSNotificationCenter defaultCenter] removeObserver:@"readOpenFile"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readNSPasteboard) name:@"readNSPasteboard" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readOpenFile:) name:@"readOpenFile" object:nil];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
}

- (IBAction)to6VAction:(NSButton *)sender {
    
    //打开默认浏览器
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:url_6v]];
}

- (IBAction)toOpneFileAction:(NSButton *)sender {

    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:YES];
    [openDlg setCanChooseDirectories:YES];
    
    [openDlg beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            NSString *path = [openDlg.URLs.firstObject path];
            NSLog(@"%@", path);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"readOpenFile" object:path];
        }
    }];
}

#pragma mark - NSPasteboard
- (void)readNSPasteboard {
    //    NSPasteboard
    [self readFromPasteboard:[NSPasteboard generalPasteboard]];
}

- (BOOL)readFromPasteboard:(NSPasteboard *)pb {
    NSArray *types = [pb types];
    if ([types containsObject:NSStringPboardType]) {
        NSString *value = [pb stringForType:NSStringPboardType];
        NSLog(@"%@", value);
        
        _linkAddress.stringValue = value;
        
        return YES;
    }
    
    return NO;
}

#pragma mark - 打开本地
- (void)readOpenFile:(NSNotification *)notification {
    
    _linkAddress.stringValue = notification.object;
}

#pragma mark - 跳转
- (IBAction)toResultAction:(NSButton *)sender {
    
    NSString *url = _linkAddress.stringValue;
    if (url.length == 0) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"确定"];
        [alert setMessageText:@"链接地址不能为空"];
        [alert setInformativeText:@"请输入链接地址"];
        [alert setAlertStyle:NSWarningAlertStyle];
        [alert runModal];
        return;
    }
    
    sender.enabled = NO;
    
    __weak typeof(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_queue_create("result", nil);
    dispatch_async(queue, ^{
        NSString *url = weakSelf.linkAddress.stringValue;
        NSArray *array = [weakSelf parse:url isNet:[url hasPrefix:@"http:"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            //beep 声音
            NSBeep();
            
            [weakSelf toShowResults:array];
            
            sender.enabled = YES;
        });
    });
}

- (void)toShowResults:(NSArray *)aArray {
    ResultViewController *rvc = [self.storyboard instantiateControllerWithIdentifier:@"result"];
    rvc.title = resultTitle;
    rvc.resultArray = aArray;
    [self presentViewControllerAsModalWindow:rvc];
}

#pragma mark - 解析
- (NSArray *)parse:(NSString *)urlString isNet:(BOOL)net {
    
    TFHpple *xpathParser = nil;
    //来自网络链接
    if (net) {
        NSURL *url = [NSURL URLWithString:urlString];
        
//        //转换成GBK编码
//        NSStringEncoding gbEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//
//        NSData *htmlData = [NSData dataWithContentsOfURL:url];
//        NSString *htmlStr = [[NSString alloc] initWithData:htmlData encoding:gbEncoding];
//        NSLog(@"htmlStr = %@", htmlStr);
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        data = [self toUTF8:data];
        xpathParser = [[TFHpple alloc] initWithHTMLData:data];
        //title
        TFHppleElement *e = [xpathParser peekAtSearchWithXPathQuery:@"//title"];
//        NSLog(@"%@", [e text]);
        resultTitle = e.text;
        
    } else {
        NSData *data =[NSData dataWithContentsOfFile:urlString];
        xpathParser = [[TFHpple alloc] initWithHTMLData:data];
        //title
        resultTitle = urlString;
    }
    
    NSArray *aArray = [xpathParser searchWithXPathQuery:@"//a"];
    NSMutableArray *m_array = [NSMutableArray array];
    for (TFHppleElement *element in aArray) {
        NSString *href = [[element attributes] objectForKey:@"href"];
        //过滤 留下ed2k ftp thunder
        if ([href hasPrefix:@"ed2k"] || [href hasPrefix:@"ftp"] || [href hasPrefix:@"thunder"]) {
            [m_array addObject:element];//a  加入
        }
    }
    
    NSMutableArray *result_array = [NSMutableArray array];
    ResultData *result_data = nil;
    for (TFHppleElement *m_element in m_array) {
//        NSLog(@"text = %@", [m_element text]);
//        NSLog(@"href = %@", [[m_element attributes] objectForKey:@"href"]);
        
        result_data = [ResultData new];
        result_data.title = [m_element text];
        result_data.href = [[m_element attributes] objectForKey:@"href"];
        [result_array addObject:result_data];
    }
    
    return [NSArray arrayWithArray:result_array];
}

- (NSData *)toUTF8:(NSData *)sourceData {
    
    CFStringRef gbkStr = CFStringCreateWithBytes(NULL, [sourceData bytes], [sourceData length], kCFStringEncodingGB_18030_2000, false);
    if (gbkStr == NULL) {
        return nil;
    } else {
        NSString *gbkString = (__bridge NSString *)gbkStr ;
        //根据网页源代码中编码方式进行修改，此处为从gbk转换为utf8
        NSString *utf8_String = [gbkString stringByReplacingOccurrencesOfString:@"meta http-equiv=\"Content-Type\" content=\"text/html; charset=gb2312\"" withString:@"meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\""];
        return [utf8_String dataUsingEncoding:NSUTF8StringEncoding];
    }
}

@end

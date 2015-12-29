//
//  ResultViewController.m
//  Html2Link
//
//  Created by video on 15/9/11.
//  Copyright (c) 2015年 Hinson.Von. All rights reserved.
//

#import "ResultViewController.h"

#import "ResultData.h"

@interface ResultViewController ()
{
    NSIndexSet *checkSet;
}
@end

@implementation ResultViewController

- (void)dealloc
{
    checkSet = nil;
    _resultArray = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _toTitleTF.stringValue = [NSString stringWithFormat:@"共%@条", @(_resultArray.count)];
}

- (IBAction)toCopyCheckAction:(NSButton *)sender {
    
    [self writeToPasteboard:[NSPasteboard generalPasteboard] withString:[self check2string]];
}

- (void)writeToPasteboard:(NSPasteboard *)pb withString:(NSString *)string {
    [pb declareTypes:[NSArray arrayWithObject:NSStringPboardType]
               owner:self];
    [pb setString:string forType:NSStringPboardType];
}

- (IBAction)toOutCheckAction:(NSButton *)sender {
    NSSavePanel *panel = [NSSavePanel savePanel];
    
    NSString *title = self.title;
    NSRange left = [title rangeOfString:@"《"];
    NSRange right = [title rangeOfString:@"》"];
    NSString *name = nil;
    if (left.length > 0 && right.length > 0) {
        name = [NSString stringWithFormat:@"%@.txt", [title substringWithRange:NSMakeRange(left.location, right.location - left.location + 1)]];
    } else {
        name = [NSString stringWithFormat:@"%@.txt", self.title];
    }

    [panel setNameFieldStringValue:name];
    [panel setMessage:@"请选择保存路径"];
    [panel setAllowsOtherFileTypes:YES];
    [panel setAllowedFileTypes:@[@"txt"]];
    [panel setExtensionHidden:YES];
    [panel setCanCreateDirectories:YES];
    if ([panel runModal] == NSFileHandlingPanelOKButton) {
        
        NSString *path = [[panel URL] path];
        [[self check2string] writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

#pragma mark - checkSet 输出string
- (NSString *)check2string {
    NSMutableString *str = [NSMutableString string];
    [checkSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        ResultData *data = _resultArray[idx];
        NSLog(@"输出 > %@", data.title);
        [str appendString:data.href];
        [str appendString:@"\n"];
    }];
    NSLog(@"输出 = %@", str);
    return str;
}

#pragma mark - NSTableView
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return _resultArray ? _resultArray.count : 0;
}
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    ResultData *data = _resultArray[row];
    return data;
}
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSTableCellView *result = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    
    ResultData *data = _resultArray[row];
    NSString *str;
    if ([tableColumn.identifier isEqualToString:@"title"]) {
        str = data.title;
        if ([str containsString:@"】"]) {
            str = [str componentsSeparatedByString:@"】"][1];
        }
    } else if ([tableColumn.identifier isEqualToString:@"href"]) {
        str = data.href;
    }
    result.textField.stringValue = str ? str : @"暂无";
//    result.textField.textColor = [NSColor blueColor];
//    result.textField.backgroundColor = [NSColor redColor];
//    result.textField.drawsBackground = YES;
    return result;
}
- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn
{
    NSLog(@"%@", tableColumn.identifier);
}
- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSTableView *tableView = notification.object;
    NSIndexSet *set = tableView.selectedRowIndexes;
    NSLog(@"选中 > %@", set);
    checkSet = set;
    _toCopyCheckBtn.enabled = checkSet.count > 0;
    _toOutCheckBtn.enabled = checkSet.count > 0;
    
//    [set enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
//        ResultData *data = _resultArray[idx];
//        NSLog(@"选中 > %@", data.title);
//    }];
}

@end

//
//  ResultViewController.h
//  Html2Link
//
//  Created by video on 15/9/11.
//  Copyright (c) 2015年 Hinson.Von. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface ResultViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet NSTextField *toTitleTF;

@property (weak) IBOutlet NSButton *toCopyCheckBtn;

@property (weak) IBOutlet NSButton *toOutCheckBtn;

- (IBAction)toCopyCheckAction:(NSButton *)sender;

- (IBAction)toOutCheckAction:(NSButton *)sender;

@property (weak) IBOutlet NSTableView *resultView;

@property (strong, nonatomic) NSArray *resultArray;

@end

NS_ASSUME_NONNULL_END
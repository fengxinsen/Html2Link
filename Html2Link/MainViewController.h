//
//  MainViewController.h
//  Html2Link
//
//  Created by video on 15/9/11.
//  Copyright (c) 2015年 Hinson.Von. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainViewController : NSViewController

- (IBAction)to6VAction:(NSButton *)sender;
- (IBAction)toOpneFileAction:(NSButton *)sender;

@property (weak) IBOutlet NSTextField *linkAddress;

- (IBAction)toResultAction:(NSButton *)sender;

@end

NS_ASSUME_NONNULL_END
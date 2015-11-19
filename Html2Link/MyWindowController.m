//
//  MyWindowController.m
//  Html2Link
//
//  Created by video on 15/11/17.
//  Copyright © 2015年 Hinson.Von. All rights reserved.
//

#import "MyWindowController.h"

@interface MyWindowController ()

@end

@implementation MyWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    NSButton *closeButton = [self.window standardWindowButton:NSWindowCloseButton];
    [closeButton setTarget:self];
    [closeButton setAction:@selector(closeApplication)];
}

- (void)closeApplication {
//    [[NSApplication sharedApplication] terminate:nil];
    exit(0);
}

@end

//
//  AppDelegate.m
//  Html2Link
//
//  Created by video on 15/9/11.
//  Copyright (c) 2015年 Hinson.Von. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
//    NSLog(@"%s" ,__FUNCTION__);
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
//    NSLog(@"%s" ,__FUNCTION__);
}

//- (void)applicationWillFinishLaunching:(NSNotification *)notification {NSLog(@"%s" ,__FUNCTION__);}

//- (void)applicationWillHide:(NSNotification *)notification {NSLog(@"%s" ,__FUNCTION__);}
//- (void)applicationDidHide:(NSNotification *)notification {NSLog(@"%s" ,__FUNCTION__);}
//- (void)applicationWillUnhide:(NSNotification *)notification {NSLog(@"%s" ,__FUNCTION__);}
//- (void)applicationDidUnhide:(NSNotification *)notification {NSLog(@"%s" ,__FUNCTION__);}

//- (void)applicationWillBecomeActive:(NSNotification *)notification {NSLog(@"%s" ,__FUNCTION__);}
- (void)applicationDidBecomeActive:(NSNotification *)notification {
//    NSLog(@"%s" ,__FUNCTION__);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"readNSPasteboard" object:nil];
}

//- (void)applicationWillResignActive:(NSNotification *)notification {NSLog(@"%s" ,__FUNCTION__);}
//- (void)applicationDidResignActive:(NSNotification *)notification {NSLog(@"%s" ,__FUNCTION__);}

//- (void)applicationWillUpdate:(NSNotification *)notification {NSLog(@"%s" ,__FUNCTION__);}
//- (void)applicationDidUpdate:(NSNotification *)notification {NSLog(@"%s" ,__FUNCTION__);}

//- (void)applicationDidChangeScreenParameters:(NSNotification *)notification {NSLog(@"%s" ,__FUNCTION__);}

//- (void)applicationDidChangeOcclusionState:(NSNotification *)notification {NSLog(@"%s" ,__FUNCTION__);}

@end

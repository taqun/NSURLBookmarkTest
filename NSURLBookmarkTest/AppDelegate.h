//
//  AppDelegate.h
//  NSURLBookmarkTest
//
//  Created by taqun on 2016/10/05.
//  Copyright © 2016年 taqun. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

- (NSString *)getSerializedBookmark:(NSString *)filePath;
- (NSString *)getFilePathFromBookmarkString:(NSString *)bookmarkString;

@end


//
//  AppDelegate.m
//  NSURLBookmarkTest
//
//  Created by taqun on 2016/10/05.
//  Copyright © 2016年 taqun. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    NSString *filePath = @"~/Desktop/test.txt";
    NSString *absoluteFilePath = [filePath stringByExpandingTildeInPath];
    //NSLog(@"%@", absoluteFilePath);
    
    NSString *bookmarkString = [self getSerializedBookmark:absoluteFilePath];
    NSLog(@"%@", bookmarkString);
    
    if(bookmarkString) {
        NSString *resolvedPath = [self getFilePathFromBookmarkString:bookmarkString];
        NSLog(@"%@", resolvedPath);
    }
}

- (NSString *)getSerializedBookmark:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSError *error = nil;
    NSData *bookmark = [url bookmarkDataWithOptions:NSURLBookmarkCreationWithSecurityScope includingResourceValuesForKeys:nil relativeToURL:nil error:&error];
    
    if(error) {
        NSLog(@"%@", error);
        return nil;
    } else {
        NSString *bookmarkString = [bookmark base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        return bookmarkString;
    }
}

- (NSString *)getFilePathFromBookmarkString:(NSString *)bookmarkString {
    NSData *bookmark = [[NSData alloc] initWithBase64EncodedString:bookmarkString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    NSError *error = nil;
    NSURL *url = [NSURL URLByResolvingBookmarkData:bookmark options:NSURLBookmarkResolutionWithSecurityScope relativeToURL:nil bookmarkDataIsStale:nil error:&error];
    
    if(error) {
        NSLog(@"%@", error);
        return nil;
    } else {
        return url.absoluteString;
    }
}


@end

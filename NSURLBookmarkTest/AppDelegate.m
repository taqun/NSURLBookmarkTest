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
    
    NSString *content = [self retriveFileFromSavedBookmark];
    NSLog(@"stored bookmark's content:");
    NSLog(@"%@", content);
    
    
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:YES];
    [panel beginWithCompletionHandler:^(NSInteger result) {
        NSURL *url = [[panel URLs] objectAtIndex:0];
        
        NSLog(@"%@", url);
        
        NSString *path = url.path;
        NSString *bookmarkString = [self getSerializedBookmark:path];
        NSLog(@"%@", bookmarkString);
        
        if(bookmarkString) {
            [[NSUserDefaults standardUserDefaults] setObject:bookmarkString forKey:@"bookmarkString"];
            
            NSString *resolvedPath = [self getFilePathFromBookmarkString:bookmarkString];
            NSLog(@"%@", resolvedPath);
            
            NSURL *url3 = [NSURL fileURLWithPath:resolvedPath];
            [url3 startAccessingSecurityScopedResource];
            NSError *error = nil;
            NSString *string2 = [NSString stringWithContentsOfURL:url3 encoding:NSUTF8StringEncoding error:&error];
            if(error) {
                NSLog(@"%@", error);
            }
            NSLog(@"%@", string2);
            [url3 stopAccessingSecurityScopedResource];
        }
    }];
}


- (NSString *)retriveFileFromSavedBookmark {
    NSString *bookmarkString = [[NSUserDefaults standardUserDefaults] objectForKey:@"bookmarkString"];
    
    if(bookmarkString) {
        NSData *savedBookmark = [[NSData alloc] initWithBase64EncodedString:bookmarkString options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSURL *url = [NSURL URLByResolvingBookmarkData:savedBookmark options:NSURLBookmarkResolutionWithSecurityScope relativeToURL:nil bookmarkDataIsStale:nil error:nil];
        
        NSError *error = nil;
        
        [url startAccessingSecurityScopedResource];
        
        NSString *resolvedPath = [self getFilePathFromBookmarkString:bookmarkString];
        NSURL *url2 = [NSURL fileURLWithPath:resolvedPath];
        NSString *string = [NSString stringWithContentsOfURL:url2 encoding:NSUTF8StringEncoding error:&error];
        
        [url stopAccessingSecurityScopedResource];
        
        if(error) {
            return error.localizedDescription;
        } else {
            return string;
        }
    } else {
        return @"no bookmark";
    }
}


- (NSString *)getSerializedBookmark:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    NSLog(@"%@", url.absoluteString);
    
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
        NSLog(@"%@", url);
        return url.path;
    }
}


@end

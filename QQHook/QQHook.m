//
//  QQHook.m
//  QQHook
//
//  Created by txx on 20/02/2017.
//  Copyright © 2017 txx. All rights reserved.
//

#import "QQHook.h"
#import "NSArray+funcational.h"
#import <RoutingHTTPServer.h>


@import AppKit;

static RoutingHTTPServer* _server = nil;



@implementation QQHook

+ (NSArray*) searchNickNameWithKey: (NSString*) key {
    
    NSWindow* window = [[NSApplication sharedApplication].windows filter:^BOOL(id item) {
        return [item isKindOfClass:NSClassFromString(@"MQAIOWindow2")];
    }].firstObject;
    
    if (window) {
        NSLog(@"当前 window: %@", window);
        
        id vc = [[window valueForKey:@"windowController"] valueForKey:@"searchViewController"];
        
        if (vc) {
            NSLog(@"目标 vc: %@", vc);
            id inter = [vc valueForKey:@"searchInter"];
            
            if (inter) {
                NSLog(@"目标 inter: %@", inter);
                NSMutableArray* result = [NSMutableArray array];
                
                SEL aSelector = NSSelectorFromString(@"Query:Contacts:WithKey:");
                
                if([inter respondsToSelector:aSelector]) {
                    NSLog(@"执行!");
                    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[inter methodSignatureForSelector:aSelector]];
                    [inv setSelector:aSelector];
                    [inv setTarget:inter];
                    
                    long long arg1 = 10;
                    NSMutableArray* arg2 = result;
                    NSString* arg3 = key;
                    
                    [inv setArgument:&(arg1) atIndex:2];
                    [inv setArgument:&(arg2) atIndex:3];
                    [inv setArgument:&(arg3) atIndex:4];
                    
                    [inv invoke];
                    
                    return [result filter:^BOOL(id item) {
                        return item != [NSNull null];
                    }];
                }
            }
        }
    }
    
    return @[];
}

+ (void) showAioWithContact: (id) item {
    NSWindow* window = [[NSApplication sharedApplication].windows filter:^BOOL(id item) {
        return [item isKindOfClass:NSClassFromString(@"MQAIOWindow2")];
    }].firstObject;
    
    if (window) {
        NSLog(@"当前 window: %@", window);
        
        id vc = [[window valueForKey:@"windowController"] valueForKey:@"searchViewController"];
        
        if (vc) {
            dispatch_async(dispatch_get_main_queue(), ^{
               [vc performSelector:NSSelectorFromString(@"showAioWithContact:") withObject:item]; 
            });
        }
    }
}

+ (NSString*) avatarPathWithItem: (id) item {
    
    if ([item isKindOfClass: NSClassFromString(@"Buddy")]) {
        
        
        Class cls = NSClassFromString(@"BHProfileManager");
        id instance = [(id)cls valueForKey:@"sharedInstance"];
        
        NSLog(@"BHProfileManager instance: %@", instance);
        
        NSString* uin = [[item valueForKey:@"friendModel"] valueForKey:@"uin"];
        
        NSLog(@"%@", uin);
        
        return [instance performSelector:NSSelectorFromString(@"getUserAvatarPathByUIN:") withObject: uin];
    }
    
    return @"";
}
@end

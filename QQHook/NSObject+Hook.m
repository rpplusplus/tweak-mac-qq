//
//  NSObject+Hook.m
//  QQHook
//
//  Created by txx on 20/02/2017.
//  Copyright © 2017 txx. All rights reserved.
//

#import "NSObject+Hook.h"
#import "GlobalData.h"
#import <objc/runtime.h>

@implementation NSObject (Hook)

+ (void) load {
    
    NSLog(@"挂载成功");
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [GlobalData sharedInstance];
        NSLog(@"Server 启动！");
        
//        [QQHook setupHTTPServer];
    });
}


@end

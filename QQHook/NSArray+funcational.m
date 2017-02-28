//
//  NSArray+funcational.m
//  QQHook
//
//  Created by txx on 20/02/2017.
//  Copyright © 2017 txx. All rights reserved.
//

#import "NSArray+funcational.h"

@implementation NSArray (funcational)

- (NSArray*) filter:(BOOL (^)(id item))block {
    NSMutableArray* arr = [NSMutableArray array];
    
    for (id item in self) {
        if (block(item)) {
            [arr addObject:item];
        }
    }
    
    return arr;
}

- (NSArray*) map: (id (^)(id item)) block {
    NSMutableArray* arr = [NSMutableArray array];
    
    for (id item in self) {
        id newItem = block(item);
        if (newItem) {
            [arr addObject:newItem];
        } else {
            [arr addObject:[NSNull null]];
        }
    }
    
    return arr;
}

@end

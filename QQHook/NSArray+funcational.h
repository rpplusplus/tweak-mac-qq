//
//  NSArray+funcational.h
//  QQHook
//
//  Created by txx on 20/02/2017.
//  Copyright © 2017 txx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (funcational)

- (NSArray*) filter:(BOOL (^)(id item))block;
- (NSArray*) map: (id (^)(id item)) block;

@end

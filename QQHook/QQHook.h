//
//  QQHook.h
//  QQHook
//
//  Created by txx on 20/02/2017.
//  Copyright © 2017 txx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QQHook : NSObject

+ (NSArray*) searchNickNameWithKey: (NSString*) key;
+ (void) showAioWithContact: (id) item;
+ (NSString*) avatarPathWithItem: (id) item;

@end

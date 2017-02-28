//
//  GlobalData.m
//  QQHook
//
//  Created by txx on 22/02/2017.
//  Copyright © 2017 txx. All rights reserved.
//

#import "GlobalData.h"

#import <RoutingHTTPServer.h>
#import "QQHook.h"
#import "NSArray+funcational.h"

@interface GlobalData ()

@property (nonatomic, strong) RoutingHTTPServer* server;
@property (nonatomic, strong) NSArray* lastSearchResult;
@end

@implementation GlobalData

+ (instancetype) sharedInstance {
    static GlobalData* instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [GlobalData new];
    });
    
    return instance;
}

- (void) setupServer {
    _server = [[RoutingHTTPServer alloc] init];
    [_server setPort:2222];
    
    [_server handleMethod: @"GET" withPath: @"/search" block: ^(RouteRequest *request, RouteResponse* response) {
        [response setHeader:@"Content-Type" value:@"application/json"];
        NSString* key = request.params[@"key"];
        
        self.lastSearchResult = [QQHook searchNickNameWithKey:key];
        
        __block NSInteger index = 0;
        
        NSArray* tmp = [self.lastSearchResult map:^id(id item) {
            if ([item isKindOfClass:NSClassFromString(@"Buddy")]) {
                NSString* path = [QQHook avatarPathWithItem:item];
                
                return @{@"title": [item valueForKey:@"DisplayName"],
                         @"arg": @(index++),
                         @"icon": @{@"path": path?:@""}};
            }
            
            if ([item isKindOfClass:NSClassFromString(@"Discuss")])
                return @{@"title": [item valueForKey:@"name"],
                         @"arg": @(index++)};
            
            
            if ([item isKindOfClass:NSClassFromString(@"Group")])
                return @{@"title": [item valueForKey:@"DisplayName"],
                         @"arg": @(index++)};
            
            return @"";
        }];
        
        [response respondWithData: [NSJSONSerialization dataWithJSONObject:@{@"items": tmp}
                                                                   options:0
                                                                     error:nil]];
    }];
    
    
    [_server handleMethod: @"GET" withPath:@"/select_with_last_search_index" block:^(RouteRequest *request, RouteResponse *response) {
        [response setHeader:@"Content-Type" value:@"application/json"];
        NSInteger index = [request.params[@"index"] intValue];
        
        if (self.lastSearchResult && self.lastSearchResult.count > index) {
            [QQHook showAioWithContact: self.lastSearchResult[index]];
            [response respondWithData: [NSJSONSerialization dataWithJSONObject:@{@"message": @"OK"}
                                                                        options:0
                                                                          error:nil]];
        } else {
            [response setStatusCode:400];
            [response respondWithData:[NSJSONSerialization dataWithJSONObject:@{@"message": @"Bad Access"}
                                                                      options:0
                                                                        error:nil]];
        }
        
    }];
    
    [_server start:nil];
}

- (instancetype) init {
    if (self = [super init]) {
        [self setupServer];
    }
    
    return self;
}

@end

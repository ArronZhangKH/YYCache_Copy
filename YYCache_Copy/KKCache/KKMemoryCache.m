//
//  KKMemoryCache.m
//  YYCache_Copy
//
//  Created by 张楷鸿 on 2020/6/24.
//  Copyright © 2020 张楷鸿. All rights reserved.
//

#import "KKMemoryCache.h"
#import "KKLinkedMap.h"
#import <pthread.h>
#import <UIKit/UIKit.h>

@implementation KKMemoryCache
{
    pthread_mutex_t _lock;
    KKLinkedMap *_lru;
    dispatch_queue_t _queue;
}

#pragma mark - Private
- (void)_trimRecursively {
    
}

- (void)_appDidReceiveMemoryWarningNotification{
    if (self.didReceiveMemoryWarningBlock) {
        self.didReceiveMemoryWarningBlock(self);
    }
    if (self.shouldRemoveAllObjectsOnMemoryWarning) {
        [self removeAllObjects];
    }
}

- (void)_appDidEnterBackgroundNotification{
    if (self.didEnterBackgroundBlock) {
        self.didEnterBackgroundBlock(self);
    }
    if (self.shouldRemoveAllObjectsWhenEnteringBackground) {
        [self removeAllObjects];
    }
}

#pragma mark - Public

- (instancetype)init{
    if (self = [super init]) {
        pthread_mutex_init(&_lock, NULL);
        _lru = [[KKLinkedMap alloc] init];
        _queue = dispatch_queue_create("com.aaron.cache.memory", DISPATCH_QUEUE_SERIAL);
        
        _countLimit = NSUIntegerMax;
        _costLimit = NSUIntegerMax;
        _ageLimit = DBL_MAX;
        _autoTrimInterval = 5.0;
        _shouldRemoveAllObjectsOnMemoryWarning = YES;
        _shouldRemoveAllObjectsWhenEnteringBackground = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_appDidReceiveMemoryWarningNotification) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_appDidEnterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [self _trimRecursively];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_lru removeAll];
    pthread_mutex_destroy(&_lock);
}

@end

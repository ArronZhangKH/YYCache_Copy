//
//  KKLinkedMap.m
//  YYCache_Copy
//
//  Created by 张楷鸿 on 2020/6/24.
//  Copyright © 2020 张楷鸿. All rights reserved.
//

#import "KKLinkedMap.h"
#import <pthread.h>

static inline dispatch_queue_t KKMemoryCacheGetReleaseQueue() {
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
}

///=============================================================================
/// @name KKLinkedMapNode
///=============================================================================
@interface KKLinkedMapNode : NSObject
{
    @package
    __unsafe_unretained KKLinkedMapNode *_prev;
    __unsafe_unretained KKLinkedMapNode *_next;
    id _key;
    id _value;
    NSUInteger _cost;
    NSTimeInterval _time;
}

@end

@implementation KKLinkedMapNode
@end

///=============================================================================
/// @name KKLinkedMap
///=============================================================================
@interface KKLinkedMap ()
{
    @package
    CFMutableDictionaryRef _dic;
    NSUInteger _totalCost;
    NSUInteger _totalCount;
    KKLinkedMapNode *_head;
    KKLinkedMapNode *_tail;
    BOOL _releaseOnMainThread;
    BOOL _releaseAsynchronously;
}

@end


@implementation KKLinkedMap

- (instancetype)init{
    if (self = [super init]) {
        _dic = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        _releaseOnMainThread = NO;
        _releaseAsynchronously = NO;
    }
    return self;
}

- (void)dealloc{
    CFRelease(_dic);
}

- (void)insertNodeAtHead:(KKLinkedMapNode *)node{
    CFDictionarySetValue(_dic, (__bridge const void *)(node->_key), (__bridge const void *)(node));
    _totalCost += node->_cost;
    _totalCount++;
    if (_head) {
        node->_next = _head;
        _head->_prev = node;
        _head = node;
    } else {
        _head = _tail = node;
    }
}

- (void)bringNodeToHead:(KKLinkedMapNode *)node{
    if (_head == node)  return;
    if (_tail == node) {
        _tail = node->_prev;
        _tail->_next = nil;
    } else {
        node->_next->_prev = node->_prev;
        node->_prev->_next = node->_next;
    }
    node->_next = _head;
    node->_prev = nil;
    _head->_prev = node;
    _head = node;
}

- (void)removeNode:(KKLinkedMapNode *)node{
    CFDictionaryRemoveValue(_dic, (__bridge const void *)(node->_key));
    _totalCost -= node->_cost;
    _totalCount--;
    if (node->_next) {
        node->_next->_prev = node->_prev;
    }
    if (node->_prev) {
        node->_prev->_next = node->_next;
    }
    if (node == _head) {
        _head = node->_next;
    }
    if (node == _tail) {
        _tail = node->_prev;
    }
}

- (nullable KKLinkedMapNode *)removeTailNode{
    if (_tail == nil)   return nil;
    KKLinkedMapNode *tail = _tail;
    CFDictionaryRemoveValue(_dic, (__bridge const void *)(_tail->_key));
    _totalCost -= _tail->_cost;
    _totalCount--;
    if (_tail == _head) {
        _head = _tail = nil;
    } else {
        _tail = _tail->_prev;
        _tail->_next = nil;
    }
    return tail;
}

- (void)removeAll{
    _totalCost = 0;
    _totalCount = 0;
    _head = nil;
    _tail = nil;
    if (CFDictionaryGetCount(_dic) > 0) {
        CFMutableDictionaryRef holder = _dic;
        _dic = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        if (_releaseAsynchronously) {
            if (_releaseOnMainThread) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    CFRelease(holder);
                });
            } else {
                dispatch_async(KKMemoryCacheGetReleaseQueue(), ^{
                    CFRelease(holder);
                });
            }
        } else {
            if (_releaseOnMainThread && pthread_main_np() == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    CFRelease(holder);
                });
            } else {
                CFRelease(holder);
            }
        }
    }
}


@end

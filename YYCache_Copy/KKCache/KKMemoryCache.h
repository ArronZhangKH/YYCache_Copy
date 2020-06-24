//
//  KKMemoryCache.h
//  YYCache_Copy
//
//  Created by 张楷鸿 on 2020/6/24.
//  Copyright © 2020 张楷鸿. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKMemoryCache : NSObject
#pragma mark - Attribute
///=============================================================================
/// @name Attribute
///=============================================================================
@property (nullable, copy) NSString *name;  ///缓存的名字, 默认是nil
@property (readonly) NSUInteger totalCount; ///缓存中的对象数量
@property (readonly) NSUInteger totalCost;  ///缓存中对象的占用空间


#pragma mark - Limit
///=============================================================================
/// @name Limit
///=============================================================================
@property (nonatomic, assign) NSUInteger countLimit;  ///  缓存的对象数量的限制, 默认值是NSUIntegerMax
@property (nonatomic, assign) NSUInteger costLimit; /// 缓存的对象占用空间的限制, 默认值是NSUIntegerMax
@property (nonatomic, assign) NSTimeInterval ageLimit;
@property (nonatomic, assign) NSTimeInterval autoTrimInterval;

@property (nonatomic, assign) BOOL shouldRemoveAllObjectsOnMemoryWarning;
@property (nonatomic, assign) BOOL shouldRemoveAllObjectsWhenEnteringBackground;
@property (nonatomic, assign) BOOL releaseOnMainThread;
@property (nonatomic, assign) BOOL releaseAsynchronously;

@property (nonatomic, copy) void (^didReceiveMemoryWarningBlock)(KKMemoryCache *cache);
@property (nonatomic, copy) void (^didEnterBackgroundBlock)(KKMemoryCache *cache);


#pragma mark - Access Methods
///=============================================================================
/// @name Access Methods
///=============================================================================
- (BOOL)containsObjectForKey:(id)key;

- (nullable id)objectForKey:(id)key;

- (void)setObject:(nullable id)object forKey:(id)key;

- (void)setObject:(nullable id)object forKey:(id)key withCost:(NSUInteger)cost;

- (void)removeObjectForKey:(id)key;

- (void)removeAllObjects;


#pragma mark - Trim
///=============================================================================
/// @name Trim
///=============================================================================
- (void)trimToCount:(NSUInteger)count;

- (void)trimToCost:(NSUInteger)cost;

- (void)trimToAge:(NSTimeInterval)age;

@end

NS_ASSUME_NONNULL_END

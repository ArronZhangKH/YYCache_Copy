//
//  KKLinkedMap.h
//  YYCache_Copy
//
//  Created by 张楷鸿 on 2020/6/24.
//  Copyright © 2020 张楷鸿. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KKLinkedMapNode;

NS_ASSUME_NONNULL_BEGIN

@interface KKLinkedMap : NSObject

- (void)insertNodeAtHead:(KKLinkedMapNode *)node;
- (void)bringNodeToHead:(KKLinkedMapNode *)node;
- (void)removeNode:(KKLinkedMapNode *)node;
- (nullable KKLinkedMapNode *)removeTailNode;
- (void)removeAll;

@end

NS_ASSUME_NONNULL_END

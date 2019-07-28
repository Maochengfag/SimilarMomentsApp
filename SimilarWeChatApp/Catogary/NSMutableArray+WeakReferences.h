//
//  NSMutableArray+WeakReferences.h
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/3.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (WeakReferences)
+ (id)mutableArrayUsingWeakReferences;

+ (id)mutableArrayUsingWeakReferencesWithCapacity:(NSUInteger)capacity;
@end

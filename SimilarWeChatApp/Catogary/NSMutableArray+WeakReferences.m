//
//  NSMutableArray+WeakReferences.m
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/3.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import "NSMutableArray+WeakReferences.h"

@implementation NSMutableArray (WeakReferences)
+ (id)mutableArrayUsingWeakReferences{
    return [self mutableArrayUsingWeakReferencesWithCapacity:0];
}

+ (id)mutableArrayUsingWeakReferencesWithCapacity:(NSUInteger)capacity{
    CFArrayCallBacks callbacks = {0,NULL,NULL,CFCopyDescription,CFEqual};
    return (id)CFBridgingRelease(CFArrayCreateMutable(0, capacity, &callbacks));
}

@end

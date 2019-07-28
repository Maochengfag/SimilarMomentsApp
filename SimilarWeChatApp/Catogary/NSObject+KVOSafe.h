//
//  NSObject+KVOSafe.h
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/9.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 
 A addobeserver B A 先 dealloc B未移除keypath的crash捕获不到 B先dealloc，B未移除keypath的crash可以捕获搭配
 1、重复添加相同的keypath的观察者 会重复调用 observeValueForKeyPath。。方法
 
 2、crash 情况：
    1、移除未注册观察者 会crash
    2、重复移除观察者 会crash
 3、添加观察者但是没有实现-observeValueFOrKeyPath：ofObject:change:context方法
 4、添加移除keypath=nil
 5、添加移除observer=nil;
 */

@interface KVOObserverInfo:NSObject

@end

@interface NSObject (KVOSafe)

+ (void)openKVOSafeProtector;

@end

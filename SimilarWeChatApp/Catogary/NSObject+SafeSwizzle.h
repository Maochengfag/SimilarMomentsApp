//
//  NSObject+SafeSwizzle.h
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/9.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (SafeSwizzle)

+ (void)safe_exchangeInstanceMethod:(Class)dClass originalSel:(SEL)originalSelector newSel:(SEL)newSelector;

@end

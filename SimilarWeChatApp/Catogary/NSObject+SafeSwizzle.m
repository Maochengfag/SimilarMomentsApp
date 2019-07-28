//
//  NSObject+SafeSwizzle.m
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/9.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import "NSObject+SafeSwizzle.h"

@implementation NSObject (SafeSwizzle)

+ (void)safe_exchangeInstanceMethod:(Class)dClass originalSel:(SEL)originalSelector newSel:(SEL)newSelector{
    
    Method originalMethod = class_getInstanceMethod(dClass, originalSelector);
    Method newMethod = class_getInstanceMethod(dClass, newSelector);
    //MEthod 中包含IMP函数指针 通过替换IMP实现SEL调用不同函数实现
    //isAdd 返回表示添加成功
    BOOL isAdd = class_addMethod(dClass, originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    //class_addMethod 如果发现方法已经存在，会失败返回，也可以用来做检查用，我们这里是为了避免源方法没有实现的情况，如果方法没有存在我们则先尝试添加被替换的方法的实现
    if (isAdd){
        class_replaceMethod(dClass, newSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        //如果添加失败：则说明方法已经有实现 直接将连个方法实现交换
        method_exchangeImplementations(originalMethod, newMethod);
    }
    
}

@end

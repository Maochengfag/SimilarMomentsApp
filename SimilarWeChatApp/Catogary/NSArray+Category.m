//
//  NSArray+Category.m
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/3.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import "NSArray+Category.h"

@implementation NSArray (Category)
- (void)my_enumerateObjectsUsingBlock:(enumeration_block_t)block {
    // your code here
    for (int i =0; i<2; i++) {
        NSObject *object = [self objectAtIndex:i];
        BOOL flag;
        block(object, i,&flag);
    }

}
@end

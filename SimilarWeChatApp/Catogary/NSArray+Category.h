//
//  NSArray+Category.h
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/3.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^enumeration_block_t)(id obj, NSUInteger idx, BOOL *stop);


@interface NSArray (Category)
- (void)my_enumerateObjectsUsingBlock:(enumeration_block_t)block;
@end

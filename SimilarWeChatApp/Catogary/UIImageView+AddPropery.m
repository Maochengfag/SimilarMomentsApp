//
//  UIImageView+AddPropery.m
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/2.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import "UIImageView+AddPropery.h"
#import <objc/runtime.h>

static const char *KDownUrlProperyKey = "KDownUrlProperyKey";

@implementation UIImageView (AddPropery)

- (void)setDownUrl:(NSString *)downUrl{
    objc_setAssociatedObject(self, KDownUrlProperyKey, downUrl, OBJC_ASSOCIATION_COPY);
}

- (NSString *)downUrl{
    return objc_getAssociatedObject(self, KDownUrlProperyKey);
}



@end

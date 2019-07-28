//
//  ProfileTopView.h
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/12.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
typedef void(^login)(void);

@protocol ProfileTopViewDelagate
- (void)skipToLoginVC:(login)login;
@end

@interface ProfileTopView : UIView
- (void)doFillProfile:(UserModel *)model;

@property (nonatomic, weak) id<ProfileTopViewDelagate>delegate;

@end

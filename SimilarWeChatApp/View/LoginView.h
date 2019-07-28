//
//  LoginView.h
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/12.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewDelegate

- (void)loginAction;

@end

typedef void(^Login)(BOOL res);

@interface LoginView : UIView

@property (nonatomic, weak) id<LoginViewDelegate> delegate;

@end

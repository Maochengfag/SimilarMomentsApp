//
//  FoundationTool.h
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/12.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface FoundationTool : NSObject
- (BOOL)isMobileNumber:(NSString *)mobileNum;
- (void)showHUDWithView:(UIView *)showView title:(NSString *)string;

@end

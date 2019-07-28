//
//  FoundationTool.m
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/12.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import "FoundationTool.h"
#import "MBProgressHUD.h"

@implementation FoundationTool

- (BOOL)isMobileNumber:(NSString *)mobileNum{
    NSString *mobile = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
    NSPredicate *regextestMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobile];
    return [regextestMobile evaluateWithObject:mobileNum];
}

- (void)showHUDWithView:(UIView *)showView title:(NSString *)string{
    MBProgressHUD *hud = [MBProgressHUD  showHUDAddedTo:showView animated:YES];
    // Set the text mode to show only text.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = string;
    [hud hideAnimated:YES afterDelay:2.f];
}

@end

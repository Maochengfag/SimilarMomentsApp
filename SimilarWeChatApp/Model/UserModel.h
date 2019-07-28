//
//  UserModel.h
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/7.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic, assign) NSInteger pkid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *phoneName;
@property (nonatomic, strong) NSData   *phoneData;
@property (nonatomic, assign) BOOL     sex;

@end

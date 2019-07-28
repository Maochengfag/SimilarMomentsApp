//
//  SourceTool.h
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/1.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void(^callback)(NSArray *array);
typedef void(^framecallback)(NSArray *array);
typedef void(^profilelist)(NSArray *array);
typedef void(^info)(NSArray *array);

@interface SourceTool : NSObject

- (void)listDataWithCall:(callback) callback;
- (void)listFrameWithCall:(framecallback) callback;
- (void)profilListWithCall:(profilelist)callback;
- (void)infoListWitchCall:(info)callback;
//随机发布
- (void)publishDataWithData:(NSArray *)array andCall:(callback)callback;
//在发布页面发布内容
- (void)publishDataWithDictionary:(NSDictionary *)dic withList:(NSArray *)array addCallBack:(callback)callback;

- (void)doSaveUserID:(NSString *)value;
- (NSString *)doGetUserID;

@end

//
//  DataModel.h
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/1.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property (nonatomic, strong) NSArray* images;
@property (nonatomic, strong) NSArray* imagesFrame;
@property (nonatomic, copy) NSString* text;
@property (nonatomic, assign) NSInteger height;

- (id)initWithDictionary:(NSDictionary *)dic;

@end

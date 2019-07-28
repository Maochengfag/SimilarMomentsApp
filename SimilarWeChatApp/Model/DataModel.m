//
//  DataModel.m
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/1.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

- (id)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        NSArray *array = [NSArray arrayWithArray:[dic objectForKey:@"images"]];
        self.images = [NSArray arrayWithArray:array];
        NSString *string = [NSString stringWithFormat:@"%@",[dic objectForKey:@"text"]];
        self.text = [NSString stringWithString:string];
    }
    return self;
}


@end

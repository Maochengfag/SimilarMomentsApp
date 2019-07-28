//
//  EditInfoTVDataSource.m
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/14.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import "EditInfoTVDataSource.h"
#import "InfoViewCell.h"

@implementation EditInfoTVDataSource

- (id)init{
    self = [super init];
    if (self) {
        _array = [NSArray array];
    }
  return  self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InfoViewCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"infoCell"];
    if (infoCell == nil) {
        infoCell = [[InfoViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"infoCell"];
    }
    
    NSDictionary *dic = [_array objectAtIndex:indexPath.row];
    [infoCell doFillContent:dic andIndex:indexPath.row];
    return infoCell;
}

@end

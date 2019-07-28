//
//  ProfileTVDataSource.m
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/12.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import "ProfileTVDataSource.h"
#import "ProfileViewCell.h"

@implementation ProfileTVDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProfileViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileViewCell"];
    if (cell == nil) {
        cell = [[ProfileViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProfileViewCell"];
    }    
    NSDictionary *dic = [_dataArray objectAtIndex:indexPath.row];
    NSString *imageName = [dic objectForKey:@"imageName"];
    NSString *title = [dic objectForKey:@"title"];
    
    [cell doSetImage:imageName title:title];
    
    return cell;
}

@end

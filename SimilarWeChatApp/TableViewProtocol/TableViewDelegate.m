//
//  TableViewDelegate.m
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/2.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import "TableViewDelegate.h"
#import "DataModel.h"

@implementation TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DataModel *model = [_array objectAtIndex:indexPath.row];
    return model.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DataModel *model = [_array objectAtIndex:indexPath.row];
    
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:model.text delegate:nil cancelButtonTitle:@"sure" otherButtonTitles:nil, nil];
        [alert show];
}

@end

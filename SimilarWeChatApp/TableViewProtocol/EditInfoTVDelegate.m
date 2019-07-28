//
//  EditInfoTVDelegate.m
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/14.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import "EditInfoTVDelegate.h"

@implementation EditInfoTVDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==0) {
        return 80;
    }
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
            [self doEditIcon];
            break;
            
        default:
            break;
    }
}

- (void)doEditIcon{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showPicker" object:nil];
}

@end

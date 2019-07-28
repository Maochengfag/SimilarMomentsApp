//
//  ListViewCell.h
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/1.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

@interface ListViewCell : UITableViewCell
@property (nonatomic,strong) UILabel *titleLabel;

- (void)fillCellWithModel:(DataModel *)model;

@end

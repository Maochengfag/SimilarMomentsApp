//
//  InfoViewCell.m
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/14.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import "InfoViewCell.h"

@interface InfoViewCell()

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *line;

@end

@implementation InfoViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self buildSubViews];
        [self.contentView addSubview:_title];
        [self.contentView addSubview:_content];
        [self.contentView addSubview:_line];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)doFillContent:(NSDictionary *)dic andIndex:(NSInteger)index{
    self.title.text = [dic objectForKey:@"title"];
    if (index ==0) {
        _line.frame = CGRectMake(10, 84, KWidth, 0.4);
        _title.frame = CGRectMake(10, 0, 50, 85);
        [self.contentView addSubview:_iconView];
        [_iconView setImage:[UIImage imageNamed:@"bg.jpeg"]];
    }else{
        [_iconView removeFromSuperview];
        self.content.text = [dic objectForKey:@"text"];
        
    }
}

- (void)buildSubViews{
   
    _title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 50, 55)];
    
    [_title setFont:[UIFont systemFontOfSize:15]];
    [_title setTextAlignment:NSTextAlignmentLeft];
    [_title setTextColor:[UIColor darkGrayColor]];
    
    _content = [[UILabel alloc] initWithFrame:CGRectMake(KWidth-60, 0, 50, 55)];
    [_content setFont:[UIFont systemFontOfSize:15]];
    [_content setTextAlignment:NSTextAlignmentRight];
    [_content setTextColor:[UIColor blackColor]];
    
    _line = [[UILabel alloc] initWithFrame:CGRectMake(10, 54, KWidth, 0.4)];
    [_line setBackgroundColor:[UIColor grayColor]];
    
    _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth-90, 0, 80, 80)];
    [_iconView setContentMode:UIViewContentModeScaleAspectFit];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

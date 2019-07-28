//
//  ListViewCell.m
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/1.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import "ListViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

@implementation ListViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
    }
    
    return self;
}

- (void)fillCellWithModel:(DataModel *)model{
    [self cleanSubViews];
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(KImageInternal, 0, 300, KTextHeight)];
    [_titleLabel setTextColor:[UIColor redColor]];
    [_titleLabel setNumberOfLines:3];
    [_titleLabel setTextAlignment:NSTextAlignmentLeft];
    [_titleLabel setFont:[UIFont systemFontOfSize:13]];
    [self.contentView  addSubview:_titleLabel];
    [_titleLabel setText:model.text];
    NSArray *imageUrl = model.images;
    NSArray *imageFrame = model.imagesFrame;
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    unsigned long count = MIN(imageUrl.count, imageFrame.count);
    
    for (unsigned long i =0; i<count; i++) {
        NSURL *url;
        UIImageView *imageView = imageFrame[i];
        if ([imageUrl[i] isKindOfClass:[NSString class]]) {
             url = [[NSURL alloc] initWithString:imageUrl[i]];
            [imageView sd_setImageWithURL:url];
        }else if ([imageUrl[i] isKindOfClass:[UIImage class]]){
            [imageView setImage:imageUrl[i]];
        }
        [self.contentView addSubview:imageView];
    }
}

- (void)cleanSubViews{
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

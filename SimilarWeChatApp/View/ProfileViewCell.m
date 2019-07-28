//
//  ProfileViewCell.m
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/12.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import "ProfileViewCell.h"

@interface ProfileViewCell()

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *tileLabel;
@property (nonatomic, strong) UILabel *line;
@end

@implementation ProfileViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self clear];
        
        [self buildSubView];
        [self.contentView addSubview:_tileLabel];
        [self.contentView addSubview:_iconImage];
        [self.contentView addSubview:_line];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)buildSubView{
   
        _tileLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 100, 50)];
        [_tileLabel setFont:[UIFont systemFontOfSize:15]];
        [_tileLabel setTextColor:[UIColor blackColor]];
        [_tileLabel setContentMode:UIViewContentModeScaleToFill];
    
        _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(KImageInternal, 0, 50, 50)];
        [_iconImage setContentMode: UIViewContentModeScaleToFill];
    
        _line = [[UILabel alloc] initWithFrame:CGRectMake(KImageInternal, 49, KWidth-2*KImageInternal, 0.3)];
        [_line setBackgroundColor:[UIColor grayColor]];
}

- (void)doSetImage:(NSString *)imageName title:(NSString *)title{
    [self.iconImage setImage:[UIImage imageNamed:imageName]];
    [self.tileLabel setText:title];
}

- (void)clear{
    [_line removeFromSuperview];
    [_iconImage removeFromSuperview];
    [_tileLabel removeFromSuperview];
    _iconImage = nil;
    _tileLabel = nil;
    _line      = nil;
}

//- (UILabel *)getTileLabel{
//    if (!_tileLabel) {
//        _tileLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 100, 50)];
//        [_tileLabel setFont:[UIFont systemFontOfSize:15]];
//        [_tileLabel setTextColor:[UIColor blackColor]];
//        [_tileLabel setContentMode:UIViewContentModeScaleToFill];
//    }
//
//    return _tileLabel;
//}
//
//
//- (UIImageView *)getIconImage{
//    if (!_iconImage) {
//        _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(KImageInternal, 0, 50, 50)];
//        [_iconImage setContentMode: UIViewContentModeScaleToFill];
//    }
//    return _iconImage;
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

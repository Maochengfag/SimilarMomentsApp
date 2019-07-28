//
//  ProfileTopView.m
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/12.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import "ProfileTopView.h"
#import "Masonry.h"

@interface ProfileTopView()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UIImageView *sexIcon;
@property (nonatomic, strong) UIButton *nextBtn;
@end

@implementation ProfileTopView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildSubViews];
        
        [_nameLab setText:@"OLiver"];
        [_iconView setImage:[UIImage imageNamed:@"bg.jpeg"]];
        [_sexIcon setImage:[UIImage imageNamed:@"male"]];
    }
    
    return self;
}

- (void)buildSubViews{
    _iconView = [[UIImageView alloc] init];
//    _iconView.frame = CGRectMake(0, 0, 60, 60);
    [self addSubview:_iconView];
    [_iconView setContentMode:UIViewContentModeScaleAspectFit];
    
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.mas_equalTo(0);
        make.topMargin.mas_equalTo(0);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
    }];
    
    _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 200, 30)];
    [_nameLab setTextColor:[UIColor blackColor]];
    [_nameLab setFont:[UIFont systemFontOfSize:30]];
    [_nameLab setTextAlignment:NSTextAlignmentLeft];

    [self addSubview:_nameLab];

    _sexIcon = [[UIImageView alloc] initWithFrame:CGRectMake(70, 35, 30, 30 )];
    [self addSubview:_sexIcon];
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _nextBtn.frame = CGRectMake(KWidth-80, 5, 50, 50);
    [_nextBtn setContentMode:UIViewContentModeScaleAspectFit];
    [_nextBtn setImage:[UIImage imageNamed:@"right_btn"] forState:UIControlStateNormal];
    [_nextBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    [_nextBtn addTarget:self action:@selector(gotoLogin) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_nextBtn];
}

- (void)doFillProfile:(UserModel *)model{
    NSData *imageData = [[NSData alloc] initWithData:model.phoneData];
    UIImage *image  = [UIImage imageWithData:imageData];
    [_iconView setImage:image];
    [_nameLab setText:model.name];
    if (model.sex) {
        [_sexIcon setImage:[UIImage imageNamed:@"female"]];
    }else{
        [_sexIcon setImage:[UIImage imageNamed:@"male"]];
    }
}

- (void)gotoLogin{
    if (_delegate) {
        
        [_delegate skipToLoginVC:^{
            
        }];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

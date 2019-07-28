//
//  ImageFrameTool.m
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/1.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import "ImageFrameTool.h"
#import <UIKit/UIKit.h>
#import "UIImageView+AddPropery.h"

@implementation ImageFrameTool

- (NSArray *)oneImgFrame{
    UIImageView *oneImage = [[UIImageView alloc] initWithFrame:CGRectMake(KImageInternal, KTextHeight+KImageInternal, KImageWidth, KImageWidth)];
    oneImage.downUrl = @"";
    [oneImage setContentMode:UIViewContentModeScaleToFill];
    return @[oneImage];
}
- (NSArray *)twoImgsFrame{
    UIImageView *oneImage = [[UIImageView alloc] initWithFrame:CGRectMake(KImageInternal, KTextHeight+KImageInternal, KImageWidth, KImageWidth)];
    [oneImage setContentMode:UIViewContentModeScaleToFill];
    
    UIImageView *twoImage = [[UIImageView alloc] initWithFrame:CGRectMake([self getViewX:oneImage] + KImageInternal, oneImage.frame.origin.y, KImageWidth, KImageWidth)];
    [twoImage setContentMode:UIViewContentModeScaleToFill];
    return @[oneImage,twoImage];
}
- (NSArray *)threeImgsFrame{
    /**
     OOO
     */
    UIImageView *oneImage = [[UIImageView alloc] initWithFrame:CGRectMake(KImageInternal, KTextHeight+KImageInternal, KImageWidth, KImageWidth)];
    [oneImage setContentMode:UIViewContentModeScaleToFill];
    
    UIImageView *twoImage = [[UIImageView alloc] initWithFrame:CGRectMake([self getViewX:oneImage] + KImageInternal, oneImage.frame.origin.y, KImageWidth, KImageWidth)];
    [twoImage setContentMode:UIViewContentModeScaleToFill];
    
    UIImageView *threeImage = [[UIImageView alloc] initWithFrame:CGRectMake([self getViewX:twoImage]+KImageInternal, oneImage.frame.origin.y + KImageInternal, KImageWidth, KImageWidth)];
    [threeImage setContentMode:UIViewContentModeScaleToFill];
    return @[oneImage,twoImage,threeImage];
}
- (NSArray *)fourImgsFrame{
    /**
     OO
     OO
     */
    UIImageView *oneImage = [[UIImageView alloc] initWithFrame:CGRectMake(KImageInternal, KTextHeight+KImageInternal, KImageWidth, KImageWidth)];
    
    [oneImage setContentMode:UIViewContentModeScaleToFill];
    
    UIImageView *twoImage = [[UIImageView alloc] initWithFrame:CGRectMake([self getViewX:oneImage] + KImageInternal, oneImage.frame.origin.y, KImageWidth, KImageWidth)];
    [twoImage setContentMode:UIViewContentModeScaleToFill];
    
    UIImageView *threeImage = [[UIImageView alloc] initWithFrame:CGRectMake(KImageInternal, [self getViewY:oneImage] + KImageInternal, KImageWidth, KImageWidth)];
    [threeImage setContentMode:UIViewContentModeScaleToFill];
    
    UIImageView *fourImage = [[UIImageView alloc] initWithFrame:CGRectMake([self getViewX:threeImage] + KImageInternal, threeImage.frame.origin.y, KImageWidth, KImageWidth)];
    [fourImage setContentMode:UIViewContentModeScaleToFill];
    
    return @[oneImage,twoImage,threeImage,fourImage];
}
- (NSArray *)fiveImgsFrame{
    /**
     OOO
     OO
     */
    UIImageView *oneImage = [[UIImageView alloc] initWithFrame:CGRectMake(KImageInternal, KTextHeight+KImageInternal, KImageWidth, KImageWidth)];
    [oneImage setContentMode:UIViewContentModeScaleToFill];
    
    UIImageView *twoImage = [[UIImageView alloc] initWithFrame:CGRectMake([self getViewX:oneImage] + KImageInternal, oneImage.frame.origin.y, KImageWidth, KImageWidth)];
    [twoImage setContentMode:UIViewContentModeScaleToFill];
    
    UIImageView *threeImage = [[UIImageView alloc] initWithFrame:CGRectMake([self getViewX:twoImage]+KImageInternal, oneImage.frame.origin.y + KImageInternal, KImageWidth, KImageWidth)];
    [threeImage setContentMode:UIViewContentModeScaleToFill];
    
    UIImageView *fourImage = [[UIImageView alloc] initWithFrame:CGRectMake(KImageInternal, [self getViewY:oneImage]+KImageInternal, KImageWidth, KImageWidth)];
    [fourImage setContentMode:UIViewContentModeScaleToFill];
    
    UIImageView *fiveImage = [[UIImageView alloc] initWithFrame:CGRectMake([self getViewX:fourImage] + KImageInternal, fourImage.frame.origin.y, KImageWidth, KImageWidth)];
    [fiveImage setContentMode:UIViewContentModeScaleToFill];
    
    return @[oneImage,twoImage,threeImage,fourImage,fiveImage];
}
- (NSArray *)sixImgsFrame{
    /**
     OOO
     OOO
     */
    UIImageView *oneImage = [[UIImageView alloc] initWithFrame:CGRectMake(KImageInternal, KTextHeight+KImageInternal, KImageWidth, KImageWidth)];
    [oneImage setContentMode:UIViewContentModeScaleToFill];
    
    UIImageView *twoImage = [[UIImageView alloc] initWithFrame:CGRectMake([self getViewX:oneImage] + KImageInternal, oneImage.frame.origin.y, KImageWidth, KImageWidth)];
    [twoImage setContentMode:UIViewContentModeScaleToFill];
    
    UIImageView *threeImage = [[UIImageView alloc] initWithFrame:CGRectMake([self getViewX:twoImage]+KImageInternal, oneImage.frame.origin.y + KImageInternal, KImageWidth, KImageWidth)];
    [twoImage setContentMode:UIViewContentModeScaleToFill];
    
    UIImageView *fourImage = [[UIImageView alloc] initWithFrame:CGRectMake(KImageInternal, [self getViewY:oneImage]+KImageInternal, KImageWidth, KImageWidth)];
    [twoImage setContentMode:UIViewContentModeScaleToFill];
    
    UIImageView *fiveImage = [[UIImageView alloc] initWithFrame:CGRectMake([self getViewX:fourImage] + KImageInternal, fourImage.frame.origin.y, KImageWidth, KImageWidth)];
    [fiveImage setContentMode:UIViewContentModeScaleToFill];
    
    UIImageView *sixImage = [[UIImageView alloc] initWithFrame:CGRectMake([self getViewX:fiveImage] + KImageInternal, fourImage.frame.origin.y, KImageWidth, KImageWidth)];
    [sixImage setContentMode:UIViewContentModeScaleToFill];
    
    return @[oneImage,twoImage,threeImage,fourImage,fiveImage,sixImage];
}
- (NSArray *)sevenImageFrame{
    /**
     OOO
     OOO
     O
     */
    UIImageView *oneImage = [[UIImageView alloc] initWithFrame:CGRectMake(KImageInternal, KTextHeight+KImageInternal, KImageWidth, KImageWidth)];
    [oneImage setContentMode:UIViewContentModeScaleToFill];
    
    UIImageView *twoImage = [[UIImageView alloc] initWithFrame:CGRectMake([self getViewX:oneImage] + KImageInternal, oneImage.frame.origin.y, KImageWidth, KImageWidth)];
    [twoImage setContentMode:UIViewContentModeScaleToFill];
    
    UIImageView *threeImage = [[UIImageView alloc] initWithFrame:CGRectMake([self getViewX:twoImage]+KImageInternal, oneImage.frame.origin.y + KImageInternal, KImageWidth, KImageWidth)];
    [threeImage setContentMode:UIViewContentModeScaleToFill];
    
    UIImageView *fourImage = [[UIImageView alloc] initWithFrame:CGRectMake(KImageInternal, [self getViewY:oneImage]+KImageInternal, KImageWidth, KImageWidth)];
    [fourImage setContentMode:UIViewContentModeScaleToFill];
    
    UIImageView *fiveImage = [[UIImageView alloc] initWithFrame:CGRectMake([self getViewX:fourImage] + KImageInternal, fourImage.frame.origin.y, KImageWidth, KImageWidth)];
    [fiveImage setContentMode:UIViewContentModeScaleToFill];
    
    UIImageView *sixImage = [[UIImageView alloc] initWithFrame:CGRectMake([self getViewX:fiveImage] + KImageInternal, fourImage.frame.origin.y, KImageWidth, KImageWidth)];
    [sixImage setContentMode:UIViewContentModeScaleToFill];
    
    UIImageView *sevenImage = [[UIImageView alloc] initWithFrame:CGRectMake(KImageInternal, [self getViewY:fourImage] +KImageInternal, KImageWidth, KImageWidth)];
    [sevenImage setContentMode:UIViewContentModeScaleToFill];
    
    return @[oneImage,twoImage,threeImage,fourImage,fiveImage,sixImage,sevenImage];
}
- (NSArray *)eightImageFrame{
    /**
     OOO
     OOO
     OO
     */
    UIImageView *oneImage = [[UIImageView alloc] initWithFrame:CGRectMake(KImageInternal, KTextHeight+KImageInternal, KImageWidth, KImageWidth)];
    [oneImage setContentMode:UIViewContentModeScaleToFill];
    
    UIImageView *twoImage = [[UIImageView alloc] initWithFrame:CGRectMake([self getViewX:oneImage] + KImageInternal, oneImage.frame.origin.y, KImageWidth, KImageWidth)];
    [twoImage setContentMode:UIViewContentModeScaleToFill];
    
    UIImageView *threeImage = [[UIImageView alloc] initWithFrame:CGRectMake([self getViewX:twoImage]+KImageInternal, oneImage.frame.origin.y + KImageInternal, KImageWidth, KImageWidth)];
    [threeImage setContentMode:UIViewContentModeScaleToFill];
    
    UIImageView *fourImage = [[UIImageView alloc] initWithFrame:CGRectMake(KImageInternal, [self getViewY:oneImage]+KImageInternal, KImageWidth, KImageWidth)];
    [fourImage setContentMode:UIViewContentModeScaleToFill];
    
    UIImageView *fiveImage = [[UIImageView alloc] initWithFrame:CGRectMake([self getViewX:fourImage] + KImageInternal, fourImage.frame.origin.y, KImageWidth, KImageWidth)];
    [fiveImage setContentMode:UIViewContentModeScaleToFill];
    
    UIImageView *sixImage = [[UIImageView alloc] initWithFrame:CGRectMake([self getViewX:fiveImage] + KImageInternal, fourImage.frame.origin.y, KImageWidth, KImageWidth)];
    [sixImage setContentMode:UIViewContentModeScaleToFill];
    
    UIImageView *sevenImage = [[UIImageView alloc] initWithFrame:CGRectMake(KImageInternal, [self getViewY:fourImage] +KImageInternal, KImageWidth, KImageWidth)];
    [sevenImage setContentMode:UIViewContentModeScaleToFill];
    
    UIImageView *eightImage = [[UIImageView alloc] initWithFrame:CGRectMake([self getViewX:sevenImage] + KImageInternal, sevenImage.frame.origin.y, KImageWidth, KImageWidth)];
    [eightImage setContentMode:UIViewContentModeScaleToFill];
    
    return @[oneImage,twoImage,threeImage,fourImage,fiveImage,sixImage,sevenImage,eightImage];
}
- (NSArray *)nineImageFrame{
    UIImageView *oneImage = [[UIImageView alloc] initWithFrame:CGRectMake(KImageInternal, KTextHeight+KImageInternal, KImageWidth, KImageWidth)];
    [oneImage setContentMode:UIViewContentModeScaleToFill];
    
    UIImageView *twoImage = [[UIImageView alloc] initWithFrame:CGRectMake([self getViewX:oneImage] + KImageInternal, oneImage.frame.origin.y, KImageWidth, KImageWidth)];
    [twoImage setContentMode:UIViewContentModeScaleToFill];
    
    UIImageView *threeImage = [[UIImageView alloc] initWithFrame:CGRectMake([self getViewX:twoImage]+KImageInternal, oneImage.frame.origin.y + KImageInternal, KImageWidth, KImageWidth)];
    [twoImage setContentMode:UIViewContentModeScaleToFill];
    
    UIImageView *fourImage = [[UIImageView alloc] initWithFrame:CGRectMake(KImageInternal, [self getViewY:oneImage]+KImageInternal, KImageWidth, KImageWidth)];
    [fourImage setContentMode:UIViewContentModeScaleToFill];
    
    UIImageView *fiveImage = [[UIImageView alloc] initWithFrame:CGRectMake([self getViewX:fourImage] + KImageInternal, fourImage.frame.origin.y, KImageWidth, KImageWidth)];
    [fiveImage setContentMode:UIViewContentModeScaleToFill];
    
    UIImageView *sixImage = [[UIImageView alloc] initWithFrame:CGRectMake([self getViewX:fiveImage] + KImageInternal, fourImage.frame.origin.y, KImageWidth, KImageWidth)];
    [sixImage setContentMode:UIViewContentModeScaleToFill];
    
    UIImageView *sevenImage = [[UIImageView alloc] initWithFrame:CGRectMake(KImageInternal, [self getViewY:fourImage] +KImageInternal, KImageWidth, KImageWidth)];
    [sevenImage setContentMode:UIViewContentModeScaleToFill];
    
    UIImageView *eightImage = [[UIImageView alloc] initWithFrame:CGRectMake([self getViewX:sevenImage] + KImageInternal, sevenImage.frame.origin.y, KImageWidth, KImageWidth)];
    [eightImage setContentMode:UIViewContentModeScaleToFill];
    
    UIImageView *nineImage = [[UIImageView  alloc] initWithFrame:CGRectMake([self getViewX:eightImage] + KImageInternal, sevenImage.frame.origin.y, KImageWidth, KImageWidth)];
    [nineImage setContentMode:UIViewContentModeScaleToFill];
    
    return @[oneImage,twoImage,threeImage,fourImage,fiveImage,sixImage,sevenImage,eightImage,nineImage];
}

- (CGFloat)getViewX:(UIView *)view{
    return view.frame.origin.x+view.frame.size.width;
}

- (CGFloat)getViewY:(UIView *)view{
    return view.frame.origin.y+view.frame.size.height;
}


@end

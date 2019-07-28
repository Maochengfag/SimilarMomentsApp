//
//  SourceTool.m
//  SimilarWeChatApp
//
//  Created by Mac on 2019/7/1.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import "SourceTool.h"
#import "DataModel.h"
#import "ImageFrameTool.h"
#import "ThreadSafeMutableArray.h"

@interface SourceTool()
@property (nonatomic, strong) NSMutableArray* imageArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *frameArray;
@property (nonatomic, strong) ImageFrameTool *imageTool;
@end


@implementation SourceTool
- (id) init{
    self = [super init];
    if (self) {
        _imageTool = [[ImageFrameTool alloc] init];
        
        for (int i =0; i<50; i++) {
            //随机产生图片数量
            int imageCount =  arc4random() %8 +1;
            NSArray *showImage = [self.imageArray subarrayWithRange:NSMakeRange(0, imageCount)];
            NSDictionary *dictionary = @{
                                         @"images":showImage,
                                         @"text":@"风景 美女风景 美女风景 美女风景 美女风景 美女风景 美女风景 美女风景 美女风景 美女风景 美女风景 美女风景 美女",
                                         };
            DataModel *model = [[DataModel alloc] initWithDictionary:dictionary];
            [self.dataArray addObject:model];
        }
        [self caculateImageFrames];
    }
    return self;
}

- (NSMutableArray *)imageArray{
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
        //将网络图片存放在数组中
        [_imageArray addObjectsFromArray:@[@"http://img5.imgtn.bdimg.com/it/u=1402367109,4157195964&fm=26&gp=0.jpg",@"http://pic.rmb.bdstatic.com/f54083119edfb83c4cfe9ce2eeebc076.jpeg",@"http://img4.imgtn.bdimg.com/it/u=128411889,1466934580&fm=214&gp=0.jpg",@"http://photocdn.sohu.com/20130416/Img372885486.jpg",@"https://cdn.duitang.com/uploads/blog/201404/22/20140422142715_8GtUk.thumb.600_0.jpeg",@"http://pic.rmb.bdstatic.com/fcd9555bd33f379035bcc05e71be30d2.jpeg",@"https://b-ssl.duitang.com/uploads/item/201502/11/20150211184128_kce43.jpeg",@"http://pic65.nipic.com/file/20150429/9448607_115306003000_2.jpg",@"https://b-ssl.duitang.com/uploads/item/201210/26/20121026223347_Pe4d8.jpeg"]];
    }
    return _imageArray;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
       _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

//回调函数
- (void)listDataWithCall:(callback)callback{
    callback(self.dataArray);
}

- (void)listFrameWithCall:(callback)callback{
//    callback([self caculateImageFrames]);
}

- (void)publishDataWithData:(NSArray *)array andCall:(callback)callback{

    [self doCreatPublish:array];
    callback(self.dataArray);
}

- (void)publishDataWithDictionary:(NSDictionary *)dic withList:(NSArray *)array addCallBack:(callback)callback
{
    DataModel *model = [[DataModel alloc] initWithDictionary:dic];
    NSArray *image = model.images;
    model.height = [self getCellHeight:image] +20;
    NSArray *resultArray = [self getImageFrame:image];
    model.imagesFrame = resultArray;
    if (self.dataArray.count >0) {
        [self.dataArray removeAllObjects];
    }
    [self.dataArray addObjectsFromArray:array];
    [self.dataArray insertObject:model atIndex:0];
    callback(self.dataArray);
}

- (void)doCreatPublish:(NSArray *)array{
    
    int imageCount =  arc4random() %8 +1;
    NSArray *showImage = [self.imageArray subarrayWithRange:NSMakeRange(0, imageCount)];
    NSDictionary *dictionary = @{
                                 @"images":showImage,
                                 @"text":@"新的一条动态 新的一条动态 新的一条动态 新的一条动态 新的一条动态 新的一条动态 新的一条动态 新的一条动态 新的一条动态 新的一条动态 新的一条动态",
                                 };
    DataModel *model = [[DataModel alloc] initWithDictionary:dictionary];
    NSArray *image = model.images;
    model.height = [self getCellHeight:image] +20;
    NSArray *resultArray = [self getImageFrame:image];
    model.imagesFrame = resultArray;
    if (self.dataArray.count >0) {
        [self.dataArray removeAllObjects];
    }
    [self.dataArray addObjectsFromArray:array];
    [self.dataArray insertObject:model atIndex:0];
}


- (void)caculateImageFrames{
    
    if (self.dataArray.count ==0) {
        return;
    }
    
    NSMutableArray *imageFames = [NSMutableArray arrayWithCapacity:self.dataArray.count];
    
    for (int i=0; i<self.dataArray.count; i++) {
        DataModel *model = [self.dataArray objectAtIndex:i];
        NSArray *image = model.images;
        model.height = [self getCellHeight:image] +20;
        NSArray *resultArray = [self getImageFrame:image];
        model.imagesFrame = resultArray;
        [imageFames addObject:resultArray];
    }
    
}

- (NSInteger) getCellHeight:(NSArray *)array{
    switch (array.count) {
        case 1:
        case 2:
        case 3:
            return KTextHeight+2*KImageInternal+KImageWidth;
            break;
        case 4:
        case 5:
        case 6:
            return KTextHeight+3*KImageInternal+2*KImageWidth;
            break;
        case 7:
        case 8:
        case 9:
            return KTextHeight+4*KImageInternal+3*KImageWidth;
            break;
    }
    
    return 0;
}

- (NSArray *)getImageFrame:(NSArray *)array{
    
    NSArray *res;
    
    switch (array.count) {
        case 1:
            res = [_imageTool oneImgFrame];
            break;
        case 2:
            res = [_imageTool twoImgsFrame];
            break;
        case 3:
            res = [_imageTool threeImgsFrame];
            break;
        case 4:
            res = [_imageTool fourImgsFrame];
            break;
        case 5:
            res = [_imageTool fiveImgsFrame];
            break;
        case 6:
            res = [_imageTool sixImgsFrame];
            break;
        case 7:
            res = [_imageTool sevenImageFrame];
            break;
        case 8:
            res = [_imageTool eightImageFrame];
            break;
        case 9:
            res = [_imageTool nineImageFrame];
            break;
    }
    
    if (!res) {
        return @[];
    }
    return res;
    
}

- (void)profilListWithCall:(profilelist)callback{
    
  NSArray *profileList = @[ @{@"imageName":@"collect",@"title":@"收藏"},
    @{@"imageName":@"albums",@"title":@"相册"},
      @{@"imageName":@"setting",@"title":@"设置"}];
    
    callback(profileList);
}

- (void)infoListWitchCall:(info)callback{
    NSArray *infoList = @[@{@"title":@"头像",@"image":[UIImage new]}.mutableCopy,@{@"title":@"名字",@"text":@"oliver"}.mutableCopy,@{@"title":@"性别",@"text":@"1"}.mutableCopy];
    
    callback(infoList);
}

- (void)doSaveUserID:(NSString *)value{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"KuserID"];
}
- (NSString *)doGetUserID{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"KuserID"];
}

@end

//
//  AKImageScrollView.h
//  SALocalAlbum
//
//  Created by WangXiaoXiang on 3/12/15.
//  Copyright (c) 2015 WangXiaoXiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface AKImageScrollView : UIScrollView

@property(nonatomic,strong) ALAsset* asset;

@property(nonatomic,assign) NSUInteger index;

+(NSUInteger)imageCount;

@end

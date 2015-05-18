//
//  SAAssetsViewController.h
//  SALocalAlbum
//
//  Created by WangXiaoXiang on 2/5/15.
//  Copyright (c) 2015 WangXiaoXiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>


typedef NS_OPTIONS(NSUInteger, SAAssetsOption) {
    SAAssetsOptionVideo = 1 << 0,
    SAAssetsOptionPicture = 1 << 1,
    SAAssetsOptionAll = 0x3,
};


@interface AKAssetsCollectionController : UIViewController

/**
 *  资源组
 */
@property(nonatomic,strong) ALAssetsGroup* assetsGroup;

@end

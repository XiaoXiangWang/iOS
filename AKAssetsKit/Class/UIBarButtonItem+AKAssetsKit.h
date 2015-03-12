//
//  UIBarButtonItem+AKAssetsKit.h
//  SALocalAlbum
//
//  Created by WangXiaoXiang on 3/11/15.
//  Copyright (c) 2015 WangXiaoXiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (AKAssetsKit)

+(UIBarButtonItem*)AK_cancelButtonItem:(id)target action:(SEL)sel;

+(UIBarButtonItem*)AK_confirmButtonItem:(id)target action:(SEL)sel;

+(UIBarButtonItem*)AK_overviewButtonItem:(id)target action:(SEL)sel;

+(UIBarButtonItem*)AK_flexibleSpaceButtonItem;

@end

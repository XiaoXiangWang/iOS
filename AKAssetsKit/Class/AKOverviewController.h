//
//  AKOverviewController.h
//  SALocalAlbum
//
//  Created by WangXiaoXiang on 3/12/15.
//  Copyright (c) 2015 WangXiaoXiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKOverviewController : UIPageViewController
@property(nonatomic,strong) NSArray* assets;

@property(nonatomic,assign) NSUInteger currentIndex;

@end

//
//  UIXPullUpControl.h
//  UIXTest
//
//  Created by WangXiaoXiang on 14/10/29.
//  Copyright (c) 2014年 WangXiaoXiang. All rights reserved.
//
#import "IRefreshView.h"

@protocol CTPullUpControlDelegate <NSObject>

@required
-(NSUInteger)numberOfMaxPagesInPullUpControl;

-(NSUInteger)numberOfCurrentPageInPullUpControl;

@end

@interface CTPullUpControl : UIControl<IRefreshView>

/**
 *  指定的初始化方法
 *
 *  @param scrollView
 *  @param delegate
 *
 *  @return
 */
-(instancetype)initWithscrollView:(UIScrollView *)scrollView delegate:(id<CTPullUpControlDelegate>)delegate;

/**
 *  代理
 */
@property(nonatomic,weak) id<CTPullUpControlDelegate> delegate ;

@end

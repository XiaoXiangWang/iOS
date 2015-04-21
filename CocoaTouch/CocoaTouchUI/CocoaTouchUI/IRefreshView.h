//
//  IRefreshView.h
//  QDate
//
//  Created by WangXiaoXiang on 15/1/12.
//  Copyright (c) 2015年 Sang HsiuJane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*刷新状态*/
typedef NS_ENUM(NSUInteger, UIXRefreshState) {
    /*状态-无*/
    UIXRefreshStateNormal = 0,
    /*状态-下拉中*/
    UIXRefreshStatePulling,
    /*状态-准备刷新*/
    UIXRefreshStateReadyToRefresh,
    /*状态-刷新中*/
    UIXRefreshStateRefreshing,
};

@protocol IRefreshView <NSObject>
/**
 *  刷新状态
 */
@property(nonatomic,assign) UIXRefreshState state;

// Tells the control that a refresh operation was started programmatically
- (void)beginRefreshing;

// Tells the control the refresh operation has ended
- (void)endRefreshing;
@end

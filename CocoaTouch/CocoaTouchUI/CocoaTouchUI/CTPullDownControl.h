//
//  UIXPullDownControl.h
//  UIXTest
//
//  Created by WangXiaoXiang on 14/10/29.
//  Copyright (c) 2014年 WangXiaoXiang. All rights reserved.
//
#import "IRefreshView.h"

@interface CTPullDownControl : UIControl<IRefreshView>

-(instancetype)initInScrollView:(UIScrollView *)scrollView;

@end

//
//  NSArray+AKOverview.h
//  AssetsKit
//
//  Created by 汪潇翔 on 15/5/15.
//  Copyright (c) 2015年 wangxiaoxiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (AKOverview)

-(id)AK_beforeObjectFromCurentIndex:(NSUInteger)curentIndex index:(NSUInteger*)index;

-(id)AK_afterObjectFromCurentIndex:(NSUInteger)curentIndex index:(NSUInteger*)index;

@end

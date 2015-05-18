//
//  NSArray+AKOverview.m
//  AssetsKit
//
//  Created by 汪潇翔 on 15/5/15.
//  Copyright (c) 2015年 wangxiaoxiang. All rights reserved.
//

#import "NSArray+AKOverview.h"

@implementation NSArray (AKOverview)

-(id)AK_afterObjectFromCurentIndex:(NSUInteger)curentIndex index:(NSUInteger *)index{
    
    if (curentIndex == (self.count -1)) {
        *index = 0;
    }else{
        *index = curentIndex + 1;
    }
    NSLog(@"After:old:%zi,new:%zi",curentIndex,*index);
    return self[*index];
}

-(id)AK_beforeObjectFromCurentIndex:(NSUInteger)curentIndex index:(NSUInteger *)index{
    if (curentIndex == 0) {
        *index = self.count - 1;
    }else{
        *index = curentIndex - 1;
    }
    NSLog(@"Before:old:%zi,new:%zi",curentIndex,*index);
    return self[*index];
}

@end

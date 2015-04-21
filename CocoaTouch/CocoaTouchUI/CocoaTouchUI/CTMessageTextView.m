//
//  UIXMessageTextView.m
//  Chat
//
//  Created by WangXiaoXiang on 14/12/5.
//  Copyright (c) 2014年 WangXiaoXiang. All rights reserved.
//

#import "CTMessageTextView.h"

@implementation CTMessageTextView
@dynamic delegate;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 5;
        self.font = [UIFont systemFontOfSize:13];
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}

-(void)setContentSize:(CGSize)contentSize{
    CGSize oldSize = self.contentSize;
    [super setContentSize:contentSize];
    if(CGSizeEqualToSize(oldSize, self.contentSize) == NO){
         if([self.delegate respondsToSelector:@selector(textView:changeContentSize:)]){
             [self.delegate textView:self changeContentSize:contentSize];
         }
    }
}

-(void)dealloc{
    self.delegate = nil;
}
@end

//
//  UIXMessageTextView.h
//  Chat
//
//  Created by WangXiaoXiang on 14/12/5.
//  Copyright (c) 2014年 WangXiaoXiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CTMessageTextView;

@protocol UIXMessageTextViewDelegate <UITextViewDelegate>

- (void)textView:(CTMessageTextView *)textView changeContentSize:(CGSize)newSize;

@end


@interface CTMessageTextView : UITextView

@property (weak, nonatomic) id<UIXMessageTextViewDelegate> delegate;

@end

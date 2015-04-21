//
//  UIInputMessageBar.h
//  QDate
//
//  Created by WangXiaoXiang on 14/12/3.
//  Copyright (c) 2014年 Sang HsiuJane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTMessageTextView.h"

UIKIT_EXTERN CGFloat const UIXMessageInputViewMaxHeight;

UIKIT_EXTERN CGFloat const UIXMessageInputViewMinHeight;

typedef void(^UIMAction)(id sender);


@class UIXMessageInputView;
@protocol UIXMessageInputViewDelegate <NSObject>
@optional

-(void)messageInputView:(UIXMessageInputView *)inputMessageView didChangeMessage:(id)message;

-(void)messageInputView:(UIXMessageInputView*)inputMessageView beginInputMessage:(CTMessageTextView*)messageView;

-(void)messageInputView:(UIXMessageInputView *)inputMessageView endInputMessage:(CTMessageTextView *)messageView;

-(void)messageInputView:(UIXMessageInputView *)inputMessageView didChangeMessageTextViewContentSize:(CGSize)newSize;

@end


@interface UIXMessageInputView : UIView

/*
 * 消息输入框
 */
@property (weak, nonatomic) CTMessageTextView *messageTextView;

/**
 *  表情按钮
 */
@property (weak,nonatomic,readonly) UIButton* emojiButton;
/**
 *  添加多媒体按钮
 */
@property (weak,nonatomic,readonly) UIButton* mediaButton;
/**
 *  发送按钮
 */
@property (weak,nonatomic,readonly) UIButton* sendButton;

@property (weak,nonatomic) UIImageView* backgroundView;

@property(weak,nonatomic) id<UIXMessageInputViewDelegate> delegate;

/**
 *  当消息不是用户在输入框中输入的时，强制改变
 */
-(void)messageTextChanged;

/**
 *  表情按钮点击
 */
@property(nonatomic,copy) UIMAction emojiAction;

/**
 *  添加其他媒体按钮被点击
 */
@property(nonatomic,copy) UIMAction mediaAction;

/**
 *  发送按钮被点击
 */
@property(nonatomic,copy) UIMAction sendAction;

@end

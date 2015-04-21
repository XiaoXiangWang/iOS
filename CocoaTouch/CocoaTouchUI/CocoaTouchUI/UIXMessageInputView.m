//
//  UIInputMessageBar.m
//  QDate
//
//  Created by WangXiaoXiang on 14/12/3.
//  Copyright (c) 2014年 Sang HsiuJane. All rights reserved.
//

#import "UIXMessageInputView.h"

CGFloat const UIXMessageInputViewMaxHeight = 100;
CGFloat const UIXMessageInputViewMinHeight = 40;
//LeadingToTrailing
#define UIMNewlineCharacter @"\n"
#define UIMEmojiLeading 5
#define UIMEmojiTrailing 10
#define UIMEmojiH_W 27

#define UIMSendLeading 10
#define UIMSendTrailing 5
#define UIMSendH_W 27

#define UIMMediaLeading 10
#define UIMMediaTrailing 5
#define UIMMediaH_W 27

#define UIMWidthEmojiAndMeida UIMEmojiLeading+UIMEmojiH_W+UIMEmojiTrailing+UIMMediaLeading+UIMMediaH_W+UIMMediaTrailing

UIKIT_STATIC_INLINE BOOL isValidString(NSString* string){
    if (string && string.length>0) {
        return YES;
    }else{
        return NO;
    }
}

@interface UIXMessageInputView ()<UITextViewDelegate,UIXMessageTextViewDelegate>
@property (weak,nonatomic,readwrite) UIButton* emojiButton;

@property (weak,nonatomic,readwrite) UIButton* mediaButton;

@property (weak,nonatomic,readwrite) UIButton* sendButton;

/**
 *  如果输入的文本信息的话显示发送按钮
 */
@property (assign,nonatomic,getter=isInputTextMessage) BOOL inputTextMessage;
@end

@implementation UIXMessageInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initSubViews];
    }
    return self;
}

-(void)setInputTextMessage:(BOOL)inputTextMessage{
    _inputTextMessage = inputTextMessage;
    if (inputTextMessage) {
        self.sendButton.hidden = NO;
        self.mediaButton.hidden = YES;
    }else{
        self.sendButton.hidden = YES;
        self.mediaButton.hidden = NO;
    }
}
-(void)_initSubViews{
    self.backgroundColor = [UIColor whiteColor];
    UIImageView* backgroundView = [UIImageView new];
    [self addSubview:backgroundView];
    self.backgroundView = backgroundView;
    //表情按钮
    UIButton* emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    emojiButton.frame = CGRectMake(0, 0, 27, 27);
    //添加按钮
    UIButton* mediaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mediaButton.frame = CGRectMake(0, 0, 27, 27);
    //发送按钮
    UIButton* sendBuuton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBuuton.frame = CGRectMake(0, 0, 27, 27);
    //输入框
    CTMessageTextView* textView = [[CTMessageTextView alloc] initWithFrame:CGRectZero];
    textView.delegate = self;
    //ButtonAction
    [emojiButton addTarget:self
                    action:@selector(emojiButtonClick:)
          forControlEvents:UIControlEventTouchUpInside];
    
    [mediaButton addTarget:self
                    action:@selector(mediaButtonClick:)
          forControlEvents:UIControlEventTouchUpInside];
    
    [sendBuuton addTarget:self
                   action:@selector(sendButtonClick:)
         forControlEvents:UIControlEventTouchUpInside];
    //添加到父视图中
    [self addSubview:emojiButton];
    [self addSubview:mediaButton];
    [self addSubview:sendBuuton];
    [self addSubview:textView];
    
    //类属性指针
    self.emojiButton = emojiButton;
    self.mediaButton = mediaButton;
    self.sendButton = sendBuuton;
    self.messageTextView = textView;
    

    //布局
    emojiButton.translatesAutoresizingMaskIntoConstraints = NO;
    mediaButton.translatesAutoresizingMaskIntoConstraints = NO;
    sendBuuton.translatesAutoresizingMaskIntoConstraints = NO;
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    //背景
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[backgroundView]-0-|"
                                                                 options:0/*default*/
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(backgroundView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[backgroundView]-0-|"
                                                                 options:0/*default*/
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(backgroundView)]];
    //表情按钮
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[emojiButton(50)]"
                                                                 options:0/*default*/
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(emojiButton)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[emojiButton(30)]-5-|"
                                                                 options:0/*default*/
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(emojiButton)]];
    //添加按钮
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[mediaButton(50)]-0-|"
                                                                 options:0/*default*/
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(mediaButton)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[mediaButton(30)]-5-|"
                                                                 options:0/*default*/
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(mediaButton)]];
    //发送按钮
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[sendBuuton(50)]-0-|"
                                                                 options:0/*default*/
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(sendBuuton)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[sendBuuton(30)]-5-|"
                                                                 options:0/*default*/
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(sendBuuton)]];
    //输入框
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[emojiButton]-0-[textView]-0-[mediaButton]"
                                                                 options:0/*default*/
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(emojiButton,textView,mediaButton)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[textView]-5-|"
                                                                 options:0/*default*/
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(textView)]];
    
#if 0
    emojiButton.backgroundColor = [UIColor redColor];
    mediaButton.backgroundColor = [UIColor yellowColor];
    sendBuuton.backgroundColor = [UIColor purpleColor];
    self.backgroundColor = [UIColor grayColor];
#endif
    
    //开始时隐藏发送按钮，如果用户输入文字时才会显示
    self.inputTextMessage = NO;
}

-(void)messageTextChanged{
    [self textViewDidChange:self.messageTextView];
}

- (void)emojiButtonClick:(id)sender {
    if (self.emojiAction) {
        self.emojiAction(sender);
    }
}

- (void)mediaButtonClick:(id)sender {
    if (self.mediaAction) {
        self.mediaAction(sender);
    }
}

- (void)sendButtonClick:(id)sender{
    if (self.sendAction) {
        self.sendAction(sender);
    }
}


#pragma mark - UITextView delegate
#if 0
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:UIMNewlineCharacter]) {
//        NSLog(@"newline");
    }
    return YES;
}
#endif

-(void)textView:(CTMessageTextView *)textView changeContentSize:(CGSize)newSize{
    if ([self.delegate respondsToSelector:@selector(messageInputView:didChangeMessageTextViewContentSize:)]) {
        [self.delegate messageInputView:self didChangeMessageTextViewContentSize:newSize];
    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([self.delegate respondsToSelector:@selector(messageInputView:beginInputMessage:)]) {
        [self.delegate messageInputView:self
                      beginInputMessage:self.messageTextView];
    }
}
-(void)textViewDidChange:(UITextView *)textView{
    //是否输入了有效的字符串
    self.inputTextMessage = isValidString(textView.text);
    //调用文本改变的代理
    if ([self.delegate respondsToSelector:@selector(messageInputView:didChangeMessage:)]) {
        [self.delegate messageInputView:self
                        didChangeMessage:self.messageTextView.text];
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([self.delegate respondsToSelector:@selector(messageInputView:endInputMessage:)]) {
        [self.delegate messageInputView:self
                      endInputMessage:self.messageTextView];
    }
}


- (void)dealloc {
    self.mediaAction = nil;
    self.emojiAction = nil;
    self.sendAction = nil;
    self.messageTextView = nil;
//    QD_RELEASE(_textView);
//    QD_SUPER_DEALLOC;
}
@end

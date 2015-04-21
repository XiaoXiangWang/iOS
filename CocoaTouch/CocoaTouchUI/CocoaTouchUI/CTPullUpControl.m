//
//  UIXPullUpControl.m
//  UIXTest
//
//  Created by WangXiaoXiang on 14/10/29.
//  Copyright (c) 2014年 WangXiaoXiang. All rights reserved.
//

#import "CTPullUpControl.h"
#import "UIXKitDefines.h"

static const CGFloat UIXPullUpControlHeight = 150.0f;
static const CGFloat UIXPullUpContentHeight = 50.0f;
static const CGFloat UIXPullUpHeight = 40.0f;

/*还有一些*/
#define UIXHasSomePages 1
/*没有更多了*/
#define UIXBeenNoPages -1

#define UIXPullUpControlFrame(scrollView) CGRectMake(0,(scrollView).contentSize.height,CGRectGetWidth((scrollView).bounds),UIXPullUpControlHeight)

#pragma mark - UIXPullUpView interface
@interface UIXPullUpView : UIView

@property(nonatomic,weak) UIActivityIndicatorView * activityIndicatorView;

@property(nonatomic,weak) UILabel* textLabel;

@end

#pragma mark - UIXPullUpView implementation
@implementation UIXPullUpView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setup];
    }
    return self;
}

-(void)_setup{
    self.backgroundColor = [UIColor whiteColor];
    
    //标题
    UILabel* textLabel = [UILabel new];
//    textLabel.text = @"NeXT";
    textLabel.font = [UIFont systemFontOfSize:15];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:textLabel];
    self.textLabel = textLabel;
    
    textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[textLabel(200)]"
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(textLabel)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[textLabel(15)]"
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(textLabel)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:textLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:textLabel
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1
                                                      constant:0]];
    
    //指示器
    UIActivityIndicatorView * activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:activityIndicatorView];
    self.activityIndicatorView = activityIndicatorView;
    
    activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[activityIndicatorView(25)]-10-[textLabel]"
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(activityIndicatorView,textLabel)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[activityIndicatorView(25)]"
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(activityIndicatorView)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicatorView
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1
                                                      constant:0]];
    
}

@end


#pragma mark - UIXPullUpView interface

@interface CTPullUpControl ()

/**
 *  主视图
 */
@property (nonatomic,weak) UIXPullUpView* pullUpView;

@property (nonatomic,assign,getter=isBadSize) BOOL badSize;

@property (nonatomic,assign) UIScrollView* scrollView;
/**
 *  忽略ScrollView的contentInset
 */
@property(nonatomic,assign) BOOL ignoreInset;

@property(nonatomic,assign) UIEdgeInsets originalInset;


@end

#pragma mark - UIXPullUpControl implementation
@implementation CTPullUpControl
@synthesize state = _state;

#pragma mark - Override func
-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview) {
        [self _dismissObserver];
    }
}

-(void)dealloc{
    [self _dismissObserver];
}


-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context
{
    if ([keyPath isEqualToString:@"contentInset"]) {
        [self _scrollViewChangedContentInset:self.scrollView.contentInset];
    }else if([keyPath isEqualToString:@"contentSize"]){
        [self _scrollViewChangedContentSize:self.scrollView.contentSize];
    }
    [self _scrollViewChangedContentOffset:self.scrollView.contentOffset];
}

#pragma mark - KVO
-(void)_registerObserver{
//    [self.scrollView addObserver:self
//                      forKeyPath:@"contentInset"
//                         options:NSKeyValueObservingOptionNew
//                         context:nil];
    [self.scrollView addObserver:self
                      forKeyPath:@"contentOffset"
                         options:NSKeyValueObservingOptionNew
                         context:nil];
    [self.scrollView addObserver:self
                      forKeyPath:@"contentSize"
                         options:NSKeyValueObservingOptionNew
                         context:nil];
}

-(void)_dismissObserver{
//    [self.scrollView removeObserver:self
//                         forKeyPath:@"contentInset"
//                            context:nil];
    [self.scrollView removeObserver:self
                         forKeyPath:@"contentOffset"
                            context:nil];
    [self.scrollView removeObserver:self
                         forKeyPath:@"contentSize"
                            context:nil];
    self.scrollView = nil;
}

#pragma mark - init
-(instancetype)initWithscrollView:(UIScrollView *)scrollView delegate:(id<CTPullUpControlDelegate>)delegate{
    NSParameterAssert(delegate);
    NSParameterAssert(scrollView);
    NSAssert1([delegate respondsToSelector:@selector(numberOfCurrentPageInPullUpControl)] && [delegate respondsToSelector:@selector(numberOfMaxPagesInPullUpControl)], @"这个类的代理必须实现numberOfMaxPagesInPullUpControl和numberOfCurrentPageInPullUpControl方法,ClassName:%@",[delegate class]);
    self = [super initWithFrame:UIXPullUpControlFrame(scrollView)];
    if (self) {
        self.delegate = delegate;
        [self _setupSubViews];
        self.ignoreInset = NO;
        //关联view的设置
        self.scrollView = scrollView;
        self.originalInset = scrollView.contentInset;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [scrollView addSubview:self];
        //注册KVO
        [self _registerObserver];
        self.state = UIXRefreshStateNormal;
    }
    return self;
}

-(void)_setupSubViews{
    self.backgroundColor = [UIColor whiteColor];
    self.badSize = YES;
    
    UIXPullUpView* pullUpView = [UIXPullUpView new];
    [self addSubview:pullUpView];
    self.pullUpView = pullUpView;
    pullUpView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[pullUpView]-0-|"
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(pullUpView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[pullUpView(50)]"
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(pullUpView)]];
    
}


#pragma mark - setter
-(void)setBadSize:(BOOL)badSize{
    if (badSize != _badSize) {
        _badSize = badSize;
        self.hidden = badSize;
    }
}

-(void)setState:(UIXRefreshState)state{
    if (self.isBadSize) {
        return;
    }
    self.hidden = NO;
    switch (state) {
        case UIXRefreshStateNormal:
            self.pullUpView.textLabel.text = UIXKitLocalizedString(@"Pullup to load more");
            break;
        case UIXRefreshStatePulling:
            self.pullUpView.textLabel.text = UIXKitLocalizedString(@"Pullup to load more");
            break;
        case UIXRefreshStateReadyToRefresh:
            self.pullUpView.textLabel.text = UIXKitLocalizedString(@"Release to load more");
            break;
        case UIXRefreshStateRefreshing:
            self.pullUpView.textLabel.text = UIXKitLocalizedString(@"Loading...");
            [self sendActionsForControlEvents:UIControlEventValueChanged];
            break;
    }
    _state = state;
}

-(void)_scrollViewChangedContentInset:(UIEdgeInsets)newContentInset{
    if (self.ignoreInset) {
        self.ignoreInset = NO;
    }else{
        self.originalInset = newContentInset;
    }
}

-(void)_scrollViewChangedContentOffset:(CGPoint)newContentOffset{
    if(self.state == UIXRefreshStateRefreshing || self.isBadSize || [self _verifyPageNumber] == UIXBeenNoPages) return;//如果正在刷新直接返回。
    if (self.scrollView.isDragging){
        CGFloat startOffSetY = MAX(self.scrollView.contentSize.height - CGRectGetHeight(self.scrollView.bounds)+self.scrollView.contentInset.top, 0.0f);
        CGFloat currentOffsetY = self.scrollView.contentOffset.y;
        if (currentOffsetY >= startOffSetY ) {
            CGFloat progess = (currentOffsetY - startOffSetY)/ UIXPullUpHeight;
            if (progess == 0) { //Normal
                self.state = UIXRefreshStateNormal;
            }else if(progess > 0 && progess < 1){ // pulling
                self.state = UIXRefreshStatePulling;
            }else{ //ready
                self.state = UIXRefreshStateReadyToRefresh;
            }
        }
    }else{
        if (self.state == UIXRefreshStateReadyToRefresh) {
            [self beginRefreshing];
        }
    }
}
-(void)_scrollViewChangedContentSize:(CGSize)contentSize{
    self.frame = UIXPullUpControlFrame(self.scrollView);
    self.badSize = NO;
    if ( self.scrollView.contentSize.height <= (CGRectGetHeight(self.scrollView.bounds)-self.scrollView.contentInset.top - self.scrollView.contentInset.bottom)) {
        self.badSize = YES;
    }
}

-(void)beginRefreshing{
    if (self.state != UIXRefreshStateRefreshing) {
        self.state = UIXRefreshStateRefreshing;
        [self.pullUpView.activityIndicatorView startAnimating];
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3f
                         animations:^{
                             UIEdgeInsets originalInset = weakSelf.scrollView.contentInset;
                             originalInset.bottom += UIXPullUpContentHeight;
                             self.scrollView.contentInset = originalInset;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }
}

-(void)endRefreshing{
    if(self.state == UIXRefreshStateRefreshing){
         self.state = UIXRefreshStateNormal;
        __weak typeof(self) weakSelf = self;
        self.scrollView.userInteractionEnabled = NO;
        [self.pullUpView.activityIndicatorView stopAnimating];
        [UIView animateWithDuration:0.3f
                         animations:^{
                             UIEdgeInsets originalInset = weakSelf.scrollView.contentInset;
                             originalInset.bottom -= UIXPullUpContentHeight;
                             self.scrollView.contentInset = originalInset;
                         }
                         completion:^(BOOL finished) {
                             weakSelf.scrollView.userInteractionEnabled = YES;
                         }];
    }
}

#pragma mark - delegate
-(NSInteger)_verifyPageNumber{
    NSInteger num = [self _currentPage] < [self _maxPages]? UIXHasSomePages:UIXBeenNoPages;
//    NSLog(@"%ld",num);
    if (num == UIXBeenNoPages) {
        self.pullUpView.textLabel.text = UIXKitLocalizedString(@"Without");
    }
    return num;
}

-(NSUInteger)_maxPages{
    return [self.delegate numberOfMaxPagesInPullUpControl];
}

-(NSUInteger)_currentPage{
    return [self.delegate numberOfCurrentPageInPullUpControl];
}
@end

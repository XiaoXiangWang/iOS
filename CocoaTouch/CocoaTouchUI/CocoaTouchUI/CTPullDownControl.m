//
//  UIXPullDownControl.m
//  UIXTest
//
//  Created by WangXiaoXiang on 14/10/29.
//  Copyright (c) 2014年 WangXiaoXiang. All rights reserved.
//

#import "CTPullDownControl.h"
#import "UIXRefreshCircleProgressView.h"

#if !__has_feature(objc_arc)
#error UIXPullDownView must be built with ARC.
// You can turn on ARC for files by adding -fobjc-arc to the build phase for each of its files.
#endif

static const Float32 UIXPullDownControlHeight = 300.0f;
static const Float32 UIXPullDownControlTriggerStartOffsetY = 5.0f;
static const Float32 UIXPullDownControlTriggerEndOffsetY = 65;
static const Float32 UIXPullDownContentHeight = 50.0f;


#define UIXPullDownControlFrame CGRectMake(0,-(UIXPullDownControlHeight),CGRectGetWidth(scrollView.bounds),UIXPullDownControlHeight)
#pragma mark - UIXPullDownView interface
@interface UIXPullDownView : UIView

@property (nonatomic,weak) UIXRefreshCircleProgressView* progressView;

@property (nonatomic,strong) UILabel* textLabel;

@property (nonatomic,strong) UILabel* timeLabel;

@end

#pragma mark - UIXPullDownView implementation
@implementation UIXPullDownView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self _setupSubViews];
    }
    return self;
    
}

-(void)_setupSubViews{
    self.backgroundColor = [UIColor whiteColor];
    
    UIXRefreshCircleProgressView* progressView = [[UIXRefreshCircleProgressView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    progressView.baseNumber = 0.95f;
    [self addSubview:progressView];
    self.progressView = progressView;
    
    UILabel* textLabel = [UILabel new];
    textLabel.font = [UIFont systemFontOfSize:15];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:textLabel];
    self.textLabel = textLabel;
    
    UILabel* timeLabel = [UILabel new];
    timeLabel.font = [UIFont systemFontOfSize:10];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:timeLabel];
    self.timeLabel = timeLabel;
    textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    progressView.translatesAutoresizingMaskIntoConstraints = NO;
    //AutoLayout
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[textLabel(width)]"
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:@{@"width":@(140)}
                                                                   views:NSDictionaryOfVariableBindings(textLabel)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[timeLabel(width)]"
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:@{@"width":@(140)}
                                                                   views:NSDictionaryOfVariableBindings(timeLabel)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-13-[textLabel]-5-[timeLabel]-8-|"
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(textLabel,timeLabel)]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:textLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:timeLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[progressView(20)]-8-[textLabel]"
                                                                options:NSLayoutFormatDirectionLeadingToTrailing
                                                                metrics:nil
                                                                  views:NSDictionaryOfVariableBindings(progressView,textLabel)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[progressView(20)]"
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(progressView)]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:progressView
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1
                                                      constant:0]];
    
}

@end
#pragma mark - UIXPullDownControl interface

@interface CTPullDownControl ()

/**
 *  下拉刷新的主视图
 */
@property(nonatomic,weak) UIXPullDownView* pullDownView;

/**
 *  忽略ScrollView的contentInset
 */
@property(nonatomic,assign) BOOL ignoreInset;

@property(nonatomic,assign) UIEdgeInsets originalInset;

@property(nonatomic,assign) UIScrollView* scrollView;

@end


#pragma mark - UIXPullDownControl implementation
@implementation CTPullDownControl
@synthesize state = _state;

#pragma mark - Override func
- (void)willMoveToSuperview:(UIView *)newSuperview
{
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
    [self _scrollViewChangedContentOffset:self.scrollView.contentOffset];
}
#pragma mark - Init func
-(instancetype)initInScrollView:(UIScrollView *)scrollView{
    self = [super initWithFrame:UIXPullDownControlFrame];
    if (self) {
        self.ignoreInset = NO;
        //关联view的设置
        self.scrollView = scrollView;
        self.originalInset = scrollView.contentInset;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [scrollView addSubview:self];
        //注册KVO
        [self _setupSubViews];
        [self _registerObserver];
        self.state = UIXRefreshStateNormal;
    }
    return self;
}


-(void)_setupSubViews{
    self.backgroundColor = [UIColor whiteColor];
    UIXPullDownView* pullDownView = [UIXPullDownView new];
    [self addSubview:pullDownView];
    self.pullDownView = pullDownView;
    pullDownView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leading-[pullDownView]-trailing-|"
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:@{@"leading":@(0),@"trailing":@(0)}
                                                                   views:NSDictionaryOfVariableBindings(pullDownView)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[pullDownView(height)]-trailing-|"
                                                                 options:NSLayoutFormatDirectionLeadingToTrailing
                                                                 metrics:@{@"trailing":@(0),@"height":@(UIXPullDownContentHeight)}
                                                                   views:NSDictionaryOfVariableBindings(pullDownView)]];
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
}

-(void)_dismissObserver{
//    [self.scrollView removeObserver:self
//                         forKeyPath:@"contentInset"
//                            context:nil];
    [self.scrollView removeObserver:self
                         forKeyPath:@"contentOffset"
                            context:nil];
    self.scrollView = nil;
}
#pragma mark - setter
-(void)setState:(UIXRefreshState)state{
    self.hidden = NO;
    switch (state) {
        case UIXRefreshStateNormal:
            self.hidden = YES;
            self.pullDownView.textLabel.text = UIXKitLocalizedString(@"Pull to refresh");
            break;
        case UIXRefreshStatePulling:
            self.pullDownView.textLabel.text = UIXKitLocalizedString(@"Pull to refresh");
            break;
        case UIXRefreshStateReadyToRefresh:
            self.pullDownView.textLabel.text = UIXKitLocalizedString(@"Release to refresh");
            break;
        case UIXRefreshStateRefreshing:
            self.pullDownView.textLabel.text = UIXKitLocalizedString(@"Refreshing...");
            [self sendActionsForControlEvents:UIControlEventValueChanged];
            break;
    }
    _state = state;
}

-(void)_scrollViewChangedContentOffset:(CGPoint)newContentOffset{
    if (self.state == UIXRefreshStateRefreshing) {
        return;
    }
    if (self.scrollView.isDragging){//用户正在拖拽
        CGFloat offset = self.scrollView.contentOffset.y + self.scrollView.contentInset.top;
        if (offset <= 0) {
            Float32 progress =(fabs(offset)-UIXPullDownControlTriggerStartOffsetY) / UIXPullDownControlTriggerEndOffsetY;
            progress = MAX(MIN(progress, UIXCircleProgressMaxValue), UIXCircleProgressMinValue);
            self.pullDownView.progressView.progress = progress;
            if (progress == 0) {
                self.state = UIXRefreshStateNormal;
            }else if(progress>0 && progress < 1.0){
                self.state = UIXRefreshStatePulling;
            }else if(progress == 1.0){
                self.state = UIXRefreshStateReadyToRefresh;
            }
        }
    }else{//用户结束拖拽
        if (self.state == UIXRefreshStateReadyToRefresh) {
            [self beginRefreshing];
        }
    }
}

-(void)beginRefreshing{
    if (self.state != UIXRefreshStateRefreshing) {
//        DLog(@"beginRefreshing");
        self.state = UIXRefreshStateRefreshing;
        [self.pullDownView.progressView beginRotatingAnimation];
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3f
                         animations:^{
            UIEdgeInsets originalInset = weakSelf.scrollView.contentInset;
            originalInset.top += UIXPullDownContentHeight;
            weakSelf.scrollView.contentInset = originalInset;
        }];
        
    }
}
-(void)endRefreshing{
    if (self.state == UIXRefreshStateRefreshing) {
//        DLog(@"endRefreshing");
        [self.pullDownView.progressView endRotatingAnimation];
        __weak typeof(self) weakSelf = self;
        self.scrollView.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.3f
                         animations:^{
                             UIEdgeInsets originalInset = weakSelf.scrollView.contentInset;
                             originalInset.top -= UIXPullDownContentHeight;
                             weakSelf.scrollView.contentInset = originalInset;
                         }
                         completion:^(BOOL finished) {
                             weakSelf.scrollView.userInteractionEnabled = YES;
                             weakSelf.state = UIXRefreshStateNormal;
                         }];
    }
}

@end

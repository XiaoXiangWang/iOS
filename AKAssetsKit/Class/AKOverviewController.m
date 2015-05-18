//
//  AKOverviewController.m
//  SALocalAlbum
//
//  Created by WangXiaoXiang on 3/12/15.
//  Copyright (c) 2015 WangXiaoXiang. All rights reserved.
//

#import "AKOverviewController.h"
#import "AKPhotoViewController.h"
#import "NSArray+AKOverview.h"

@interface AKOverviewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@end

@implementation AKOverviewController

-(instancetype)init{
    if (self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                        navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                      options:@{UIPageViewControllerOptionInterPageSpacingKey:@(12)}]) {
        self.dataSource = self;
        self.delegate = self;
        self.currentIndex = 0;
    }
    return self;
}

-(void)loadView{
    [super loadView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer* __tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                             action:@selector(_tapGestureRecognizer:)];
    [self.view addGestureRecognizer:__tapGestureRecognizer];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    AKPhotoViewController*  _photoViewController= [[AKPhotoViewController alloc] init];
    _photoViewController.asset = self.assets[self.currentIndex];
    [self setViewControllers:@[_photoViewController]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:YES
                  completion:nil];
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealloc{
}

-(void)setCurrentIndex:(NSUInteger)currentIndex{
    _currentIndex = currentIndex;
    self.navigationItem.title = [NSString stringWithFormat:@"%zi/%zi",self.currentIndex+1,self.assets.count];
}

-(void)_tapGestureRecognizer:(UITapGestureRecognizer*)sender{
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden
                                             animated:YES];
    [UIView animateWithDuration:0.25 animations:^{
        if (self.navigationController.navigationBarHidden) {
            self.view.backgroundColor = [UIColor blackColor];
        }else{
            self.view.backgroundColor = [UIColor whiteColor];
        }
    }];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    AKPhotoViewController*  _photoViewController= [[AKPhotoViewController alloc] init];
    NSUInteger __currentIndex = 0;
    _photoViewController.asset = [self.assets AK_beforeObjectFromCurentIndex:self.currentIndex
                                                                       index:&__currentIndex];
    self.currentIndex = __currentIndex;
    return _photoViewController;
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    AKPhotoViewController*  _photoViewController= [[AKPhotoViewController alloc] init];
    NSUInteger __currentIndex = 0;
    _photoViewController.asset = [self.assets AK_afterObjectFromCurentIndex:self.currentIndex
                                                                      index:&__currentIndex];
    self.currentIndex = __currentIndex;
    
    return _photoViewController;
}

@end

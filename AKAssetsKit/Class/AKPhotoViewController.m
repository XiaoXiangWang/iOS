//
//  AKPhotoViewController.m
//  SALocalAlbum
//
//  Created by WangXiaoXiang on 3/12/15.
//  Copyright (c) 2015 WangXiaoXiang. All rights reserved.
//

#import "AKPhotoViewController.h"
#import "AKImageScrollView.h"

@interface AKPhotoViewController ()

@property(nonatomic,weak) AKImageScrollView* imageScrollView;

@end

@implementation AKPhotoViewController


-(void)loadView{
    [super loadView];
    AKImageScrollView* imageScrollView = [[AKImageScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:imageScrollView];
    self.imageScrollView = imageScrollView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    ALAssetRepresentation *assetRepresentation = [self.asset defaultRepresentation];
    [self.imageScrollView displayImage:[UIImage imageWithCGImage:[assetRepresentation fullScreenImage]
                                                           scale:assetRepresentation.scale
                                                     orientation:UIImageOrientationUp]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

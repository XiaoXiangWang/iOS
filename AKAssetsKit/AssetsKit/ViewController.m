//
//  ViewController.m
//  AssetsKit
//
//  Created by wangxiaoxiang on 15/3/12.
//  Copyright (c) 2015年 wangxiaoxiang. All rights reserved.
//

#import "ViewController.h"
#import "AKAssetsPickerController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)assets:(id)sender {
    AKAssetsPickerController*  assetsPickerController = [[AKAssetsPickerController alloc] init];
    [self presentViewController:assetsPickerController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

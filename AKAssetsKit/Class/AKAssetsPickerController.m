//
//  AKAssetsPickerController.m
//  SALocalAlbum
//
//  Created by WangXiaoXiang on 3/11/15.
//  Copyright (c) 2015 WangXiaoXiang. All rights reserved.
//

#import "AKAssetsPickerController.h"
#import "AKAssetsGroupController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface AKAssetsPickerController ()

@property(nonatomic,copy) NSString* message;

@end

@implementation AKAssetsPickerController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        //判断是否授权，如果用户已经否决。展示否决页面。
        ALAuthorizationStatus stauts = [ALAssetsLibrary authorizationStatus];
        switch (stauts) {
            case ALAuthorizationStatusNotDetermined:
                //用户尚未作出选择，为此应用。
                break;
            case ALAuthorizationStatusRestricted:
                //用户无法更改此应用程序的状态，可能是由于如家长控制中主动限制。
                self.message = @"This application is not authorized to access photo data.The user cannot change this application’s status, possibly due to active restrictions such as parental controls being in place.";
                break;
            case ALAuthorizationStatusDenied:
                //用户已明确否认了应用访问照片数据。
                self.message = @"User has explicitly denied this application access to photos data.";
                break;
            case ALAuthorizationStatusAuthorized:
                //用户授权该应用程序访问的照片数据。
                break;
            default:
                //未知状态
                self.message = @"Unkown stauts";
                break;
        }
        NSLog(@"[Message]:%@",self.message);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIViewController* viewController = nil;
    if (self.message) {
        
    }else{
        AKAssetsGroupController* groupController = [[AKAssetsGroupController alloc] initWithStyle:UITableViewStylePlain];
        viewController = groupController;
    }
    [self pushViewController:viewController animated:NO];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

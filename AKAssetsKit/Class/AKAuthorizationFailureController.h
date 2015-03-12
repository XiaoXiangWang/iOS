//
//  AKAuthorizationFailureController.h
//  SALocalAlbum
//
//  Created by WangXiaoXiang on 3/12/15.
//  Copyright (c) 2015 WangXiaoXiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AKAuthorizationFailureController;
@protocol AKAuthorizationFailureControllerDelegate <NSObject>

-(void)AK_authorizationFailureController:(AKAuthorizationFailureController*)viewController
                         reauthorization:(void *)context;

@end

/**
 *  授权失败
 */
@interface AKAuthorizationFailureController : UIViewController

@property(nonatomic,copy) NSString* authorizationMessage;

@property(nonatomic,copy) NSString* tipMessage;

@end

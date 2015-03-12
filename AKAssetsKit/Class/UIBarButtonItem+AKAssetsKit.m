//
//  UIBarButtonItem+AKAssetsKit.m
//  SALocalAlbum
//
//  Created by WangXiaoXiang on 3/11/15.
//  Copyright (c) 2015 WangXiaoXiang. All rights reserved.
//

#import "UIBarButtonItem+AKAssetsKit.h"

@implementation UIBarButtonItem (AKAssetsKit)
+(UIBarButtonItem *)AK_cancelButtonItem:(id)target action:(SEL)sel{
    UIBarButtonItem* item  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                           target:target
                                                                           action:sel];
    return item;
}

+(UIBarButtonItem *)AK_confirmButtonItem:(id)target action:(SEL)sel{
    NSString* title = NSLocalizedStringFromTable(@"Confirm", @"AKAssetsKit", nil);
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:title
                                                             style:UIBarButtonItemStylePlain
                                                            target:target
                                                            action:sel];
    return item;
}

+(UIBarButtonItem *)AK_overviewButtonItem:(id)target action:(SEL)sel{
    NSString* title = NSLocalizedStringFromTable(@"Overview", @"AKAssetsKit", nil);
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:title
                                                             style:UIBarButtonItemStylePlain
                                                            target:target
                                                            action:sel];
    return item;
}

+(UIBarButtonItem *)AK_flexibleSpaceButtonItem{
    UIBarButtonItem* item  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil
                                                                           action:nil];
    return item;
}
@end

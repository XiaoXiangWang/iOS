//
//  SAAssetsCell.m
//  SALocalAlbum
//
//  Created by WangXiaoXiang on 2/5/15.
//  Copyright (c) 2015 WangXiaoXiang. All rights reserved.
//

#import "AKAssetsCell.h"


#if !__has_feature(objc_arc)
#error SAAssetsCell must be built with ARC.
// You can turn on ARC for files by adding -fobjc-arc to the build phase for each of its files.
#endif

@interface AKAssetsCell ()

@property(nonatomic,weak) IBOutlet UIView* maskView;

@end

@implementation AKAssetsCell

- (void)awakeFromNib {
    // Initialization code
    [self.checkMark setImage:[UIImage imageNamed:@"AssetsPickerCheakSelected"]
                    forState:UIControlStateSelected];
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    self.checkMark.selected = selected;
    self.maskView.hidden = !selected;
}


@end

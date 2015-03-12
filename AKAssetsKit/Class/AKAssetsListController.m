//
//  SAAssetsViewController.m
//  SALocalAlbum
//
//  Created by WangXiaoXiang on 2/5/15.
//  Copyright (c) 2015 WangXiaoXiang. All rights reserved.
//

#import "AKAssetsListController.h"
#import "AKAssetsCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIBarButtonItem+AKAssetsKit.h"

#if !__has_feature(objc_arc)
#error SAAssetsViewController must be built with ARC.
// You can turn on ARC for files by adding -fobjc-arc to the build phase for each of its files.
#endif

#define SAAssetsCellIdentifier @"SAAssetsCellIdentifier"

@interface AKAssetsListController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/**
 *  资源数组
 */
@property (nonatomic, strong) NSMutableArray* assets;

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@property (nonatomic, weak) IBOutlet UIToolbar* toolBar;

@property (nonatomic, strong) ALAssetsFilter*  assetsFilter;

@end

@implementation AKAssetsListController


#pragma mark - Override function
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //标题
    self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    //注册Cell
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([AKAssetsCell class])
                                                    bundle:[NSBundle mainBundle]]
          forCellWithReuseIdentifier:SAAssetsCellIdentifier];
    //是否允许多选
    self.collectionView.allowsMultipleSelection = YES;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem AK_cancelButtonItem:self
                                                                           action:@selector(_deselectAssets:)];
    UIBarButtonItem* _overviewButtonItem = [UIBarButtonItem AK_overviewButtonItem:self
                                                                          action:@selector(_overviewAssets:)];
    UIBarButtonItem* _confirmButtonItem = [UIBarButtonItem AK_confirmButtonItem:self
                                                                         action:@selector(_confirmAssets:)];
    UIBarButtonItem* _flexibleSpaceButtonItem = [UIBarButtonItem AK_flexibleSpaceButtonItem];
    [self.toolBar setItems:@[_overviewButtonItem,_flexibleSpaceButtonItem,_confirmButtonItem]
                  animated:NO];
    //获取数据
    [self _fetchAssets];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    UICollectionViewFlowLayout* layout = [UICollectionViewFlowLayout new];
    CGFloat width = 0;
    if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)) {
        width = (CGRectGetWidth(self.view.bounds)-2*3)/4;
        layout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
    }else if(UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)){
        width = (CGRectGetWidth(self.view.bounds)-2*8)/7;
        layout.sectionInset = UIEdgeInsetsMake(10, 2, 10, 2);
    }
    layout.itemSize = CGSizeMake(width, width);
    layout.minimumInteritemSpacing = 2.0f;
    layout.minimumLineSpacing = 2.0f;
    self.collectionView.collectionViewLayout = layout;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Fetch assets
-(void)_fetchAssets{
    if (!self.assets) {
        _assets = [[NSMutableArray alloc] init];
    } else {
        [self.assets removeAllObjects];
    }
    
    ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        if (result) {
            [self.assets addObject:result];
        }else{
            [self.collectionView performSelectorOnMainThread:@selector(reloadData)
                                                  withObject:nil
                                               waitUntilDone:NO];
        }
    };
    
    ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
    [self.assetsGroup setAssetsFilter:onlyPhotosFilter];
    [self.assetsGroup enumerateAssetsUsingBlock:assetsEnumerationBlock];
}

#pragma mark - UICollectionView data source
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section{
    return self.assets.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView
                cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AKAssetsCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:SAAssetsCellIdentifier
                                                                   forIndexPath:indexPath];
    ALAsset* asset = self.assets[indexPath.row];
    cell.thumbnailView.image = [UIImage imageWithCGImage:asset.thumbnail];
    return cell;
}

#pragma mark - Actions
-(void)_deselectAssets:(UIBarButtonItem*)sender{

}
-(void)_overviewAssets:(UIBarButtonItem*)sender{
    
}
-(void)_confirmAssets:(UIBarButtonItem*)sender{
    
}

@end

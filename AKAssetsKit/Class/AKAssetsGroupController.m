//
//  SAAssetssGroupViewController.m
//  SALocalAlbum
//
//  Created by WangXiaoXiang on 3/9/15.
//  Copyright (c) 2015 WangXiaoXiang. All rights reserved.
//

#import "AKAssetsGroupController.h"
#import "AKAssetsGroupViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIBarButtonItem+AKAssetsKit.h"
#import "AKAssetsListController.h"

@interface AKAssetsGroupController ()

/**
 *  相册
 */
@property(nonatomic,strong) NSMutableArray* groups;

@property(nonatomic,strong) ALAssetsLibrary* assetsLibrary;

@end

@implementation AKAssetsGroupController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = NSLocalizedString(@"照片", nil);
        if (self.assetsLibrary == nil) {
            _assetsLibrary = [[ALAssetsLibrary alloc] init];
        }
        if (self.groups == nil) {
            self.groups = [[NSMutableArray alloc] init];
        } else {
            [self.groups removeAllObjects];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AKAssetsGroupViewCell class])
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"SAAssetssGroupViewCell"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem AK_cancelButtonItem:self
                                                                           action:@selector(_deselectAssets:)];
    
    //获取用户相册
    [self _fetchAssetsGroups];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - fetch assets groups
-(void)_fetchAssetsGroups{
    __weak typeof(self) weakSelf = self;
    // setup our failure view controller in case enumerateGroupsWithTypes fails
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        NSString *errorMessage = nil;
        switch ([error code]) {
            case ALAssetsLibraryAccessUserDeniedError:
            case ALAssetsLibraryAccessGloballyDeniedError:
                errorMessage = @"The user has declined access to it.";
                break;
            default:
                errorMessage = @"Reason unknown.";
                break;
        }
    };
    // emumerate through our groups and only add groups that contain photos
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop/*如果你把stop指针设置为Yes,枚举将结束*/){
        ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
        [group setAssetsFilter:onlyPhotosFilter];
        if ([group numberOfAssets] > 0){
            [weakSelf.groups addObject:group];
        }else{
            [weakSelf.tableView performSelectorOnMainThread:@selector(reloadData)
                                                 withObject:nil
                                              waitUntilDone:NO];
        }
    };
    // enumerate only photos
    NSUInteger groupTypes = ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces | ALAssetsGroupSavedPhotos;
    [_assetsLibrary enumerateGroupsWithTypes:groupTypes
                                  usingBlock:listGroupBlock
                                failureBlock:failureBlock];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AKAssetsGroupViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SAAssetssGroupViewCell"
                                                            forIndexPath:indexPath];
    
    // Configure the cell...
    ALAssetsGroup* group = self.groups[indexPath.row];
    cell.textLabel.text = [group valueForProperty:ALAssetsGroupPropertyName];
    cell.imageView.image = [UIImage imageWithCGImage:group.posterImage];
    cell.detailTextLabel.text = @(group.numberOfAssets).stringValue;
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    AKAssetsListController *detailViewController = [[AKAssetsListController alloc] init];
    detailViewController.assetsGroup = self.groups[indexPath.row];
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
#pragma mark - Action
-(void)_deselectAssets:(UIBarButtonItem*)buttonItem{

};

@end

//
//  DownloadView.m
//  ChuyenMotTrang
//
//  Created by Lê Đình Phúc on 2/18/16.
//  Copyright © 2016 Lê Đình Phúc. All rights reserved.
//

#import "DownloadView.h"
#import "CollectionViewCell.h"
#import "FileManager.h"
#import "ZoomImageViewController.h"
#import "ZCPhotoLibrary.h"
#import "MBProgressHUD.h"
#import "UIImageView+MHFacebookImageViewer.h"

@implementation DownloadView
{
    NSMutableArray *listImage;
    BOOL isDeleteCell;
    FileManager *fileManager;
    UIBarButtonItem *buttomEdit;
    NSMutableArray *listChoise;
}


-(void) viewDidLoad{
    [super viewDidLoad];
    
    _saveButton.layer.cornerRadius = _saveButton.frame.size.height/2;
    _saveButton.layer.masksToBounds = YES;
    _deleteButton.layer.cornerRadius = _deleteButton.frame.size.height/2;
    _deleteButton.layer.masksToBounds = YES;
    _saveButton.hidden = YES;
    _deleteButton.hidden = YES;
    
    [_deleteButton addTarget:self action:@selector(deleteTouchUpInSide:) forControlEvents:UIControlEventTouchUpInside];
    [_saveButton addTarget:self action:@selector(btDownloadTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    
    listChoise = [[NSMutableArray alloc] init];
    
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    fileManager = [[FileManager alloc] init];
    isDeleteCell = NO;
    listImage = [[NSMutableArray alloc] init];
    
    [self insertDataToList];
    [self.collectionView reloadData];
    
    
    buttomEdit = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:NO target:self action:@selector(editButtomTouchUpInside:)];
    [buttomEdit setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = buttomEdit;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

-(void)viewWillAppear:(BOOL)animated{
    
    buttomEdit.title = @"Edit";
    [listChoise removeAllObjects];
    _saveButton.hidden = _deleteButton.hidden = YES;
    isDeleteCell = NO;
    
    
    [super viewWillAppear:animated];
    [listImage removeAllObjects];
    [self insertDataToList];
    [self.collectionView reloadData];
}

-(void)insertDataToList{
    NSArray *dataFromUserDefault = [[NSArray alloc] init];
    dataFromUserDefault = [[NSUserDefaults standardUserDefaults] objectForKey:@"listImage"];
    listImage =[NSMutableArray arrayWithArray: dataFromUserDefault];
}

-(void)saveListImageToUserDefault:(NSMutableArray*) data{
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"listImage"];
}

#pragma mark - Collection View.
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell1" forIndexPath:indexPath];
    // Get paths of image.
    NSString *nameImage = [[NSString alloc]init];
    nameImage = [listImage objectAtIndex:indexPath.item];
    
    
    NSArray *paths = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsURL = [paths lastObject];
    documentsURL = [documentsURL URLByAppendingPathComponent:[nameImage stringByAppendingString:@".png"]];
    cell.imageView.imageURL = documentsURL;
    cell.isChoice = NO;
    cell.buttonDelete.hidden = YES;
    cell.alphaView.hidden = YES;

    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (isDeleteCell == YES) {
        CollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        if (cell.isChoice == YES) {
            cell.buttonDelete.hidden = YES;
            cell.alphaView.hidden = YES;
            cell.isChoice = NO;
            [listChoise removeObject:[listImage objectAtIndex:indexPath.item]];
            return;
        }
        cell.buttonDelete.hidden = NO;
        cell.alphaView.hidden = NO;
        cell.isChoice = YES;
        [listChoise addObject:[listImage objectAtIndex:indexPath.item]];
    }
    else{
        NSString *nameImage = [listImage objectAtIndex:indexPath.item];
        ZoomImageViewController *zoomView = [[ZoomImageViewController alloc] initWithNibName:@"ZoomImageViewController" bundle:nil];
        UIImage *imageFull = [fileManager readImage:[nameImage stringByAppendingString:@"full.png"]];
        NSData *imageData = UIImagePNGRepresentation(imageFull);
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        zoomView.data = imageData;
        [self.navigationController pushViewController:zoomView animated:YES];
    }
}


-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [listImage count];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80, 80);
}

#pragma mark - Action
-(void)deleteTouchUpInSide:(UIButton*)sender{
    if ([listChoise count] < 1) {
        UIAlertView* view = [[UIAlertView alloc]initWithTitle:@"Truyện Một Trang" message:@"Please select images before!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [view show];
        return;
    }
    for (int i=0; i<[listChoise count]; i++) {
        NSString *nameImage = [listChoise objectAtIndex:i];
        [fileManager deleteFileWithName: [nameImage stringByAppendingString:@".png"]];
        [fileManager deleteFileWithName: [nameImage stringByAppendingString:@"full.png"]];
        for (int j=0; j<[listImage count]; j++) {
            if ([[listImage objectAtIndex:j] isEqualToString:nameImage]) {
                [listImage removeObjectAtIndex:j];
                break;
            }
        }
        [[NSUserDefaults standardUserDefaults] setObject:listImage forKey:@"listImage"];
    }
    [self.collectionView reloadData];
    [listChoise removeAllObjects];
}

-(void)btDownloadTouchUpInside:(UIButton*)sender{
    if ([listChoise count] < 1) {
        UIAlertView* view = [[UIAlertView alloc]initWithTitle:@"Truyện Một Trang" message:@"Please select images before!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [view show];
        return;
    }
    UIView *proget = [[UIView alloc] initWithFrame:self.view.frame];
    proget.backgroundColor = [UIColor blackColor];
    [proget setAlpha:0.6f];
    [self.view addSubview:proget];
    [MBProgressHUD showHUDAddedTo:proget animated:YES];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<[listChoise count]; i++) {
        NSString *nameImage = [listChoise objectAtIndex:i];
        UIImage *image2 = [fileManager readImage:[nameImage stringByAppendingString:@"full.png"]];
        NSData *imageData = UIImagePNGRepresentation(image2);
        [array addObject:imageData];
    }
    [[ZCPhotoLibrary sharedInstance]saveImageDatas:array toAlbum:@"Truyện Một Trang" withCompletionBlock:^(NSError* error){
        if (error) {
            [self showAlertViewWithMessage:@"Can't save photo!"];
        }
        else {
            [self showAlertViewWithMessage:@"Save successfully!"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:proget animated:YES];
            [proget removeFromSuperview];
            [self.collectionView reloadData];
        });
    }];
    [listChoise removeAllObjects];
}

- (void)editButtomTouchUpInside:(id*)sender{
    if (isDeleteCell == NO) {
        isDeleteCell = YES;
        buttomEdit.title = @"Done";
        _saveButton.hidden = NO;
        _deleteButton.hidden = NO;
    }
    else{
        isDeleteCell = NO;
        buttomEdit.title = @"Edit";
        _deleteButton.hidden = YES;
        _saveButton.hidden = YES;
        [self.collectionView reloadData];
        [listChoise removeAllObjects];
    }
}

- (void)showAlertViewWithMessage:(NSString*)message
{
    void (^showBlock)() = ^(){
        UIAlertView* view = [[UIAlertView alloc]initWithTitle:@"Truyện Một Trang" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [view show];
    };
    if ([NSThread isMainThread]) {
        showBlock();
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            showBlock();
        });
    }
}

@end

//
//  DownloadView.h
//  ChuyenMotTrang
//
//  Created by Lê Đình Phúc on 2/18/16.
//  Copyright © 2016 Lê Đình Phúc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadView : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

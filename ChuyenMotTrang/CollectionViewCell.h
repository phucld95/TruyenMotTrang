//
//  CollectionViewCell.h
//  MyContact
//
//  Created by Lê Đình Phúc on 1/12/16.
//  Copyright © 2016 Lê Đình Phúc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *buttonDelete;
@property (weak, nonatomic) IBOutlet UIView *alphaView;

@property (nonatomic) BOOL isChoice;

@end

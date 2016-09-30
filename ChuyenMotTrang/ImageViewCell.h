//
//  ImageViewCell.h
//  ChuyenMotTrang
//
//  Created by Lê Đình Phúc on 2/3/16.
//  Copyright © 2016 Lê Đình Phúc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadImage;

@end

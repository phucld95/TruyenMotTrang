//
//  ImageViewCell.m
//  ChuyenMotTrang
//
//  Created by Lê Đình Phúc on 2/3/16.
//  Copyright © 2016 Lê Đình Phúc. All rights reserved.
//

#import "ImageViewCell.h"

@implementation ImageViewCell

- (void)awakeFromNib {
    // Initialization code
    self.imgImageView.backgroundColor = [UIColor blueColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
//
//  InfomationCell.m
//  ChuyenMotTrang
//
//  Created by Lê Đình Phúc on 2/3/16.
//  Copyright © 2016 Lê Đình Phúc. All rights reserved.
//

#import "InfomationCell.h"

@implementation InfomationCell

- (void)awakeFromNib {
    // Initialization code
    //self.imgAvata.layer.masksToBounds = YES;
    self.imgAvata.layer.cornerRadius = self.imgAvata.bounds.size.width / 2.0;
    self.imgAvata.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

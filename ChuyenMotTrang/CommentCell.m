//
//  CommentCell.m
//  ChuyenMotTrang
//
//  Created by Le Phuc on 3/2/16.
//  Copyright © 2016 Lê Đình Phúc. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

- (void)awakeFromNib {
    // Initialization code
    
    self.avataUser.layer.cornerRadius = self.avataUser.bounds.size.width / 2.0;
    self.avataUser.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

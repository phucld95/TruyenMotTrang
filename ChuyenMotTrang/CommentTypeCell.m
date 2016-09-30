//
//  CommentTypeCell.m
//  ChuyenMotTrang
//
//  Created by Le Phuc on 3/2/16.
//  Copyright © 2016 Lê Đình Phúc. All rights reserved.
//

#import "CommentTypeCell.h"

@implementation CommentTypeCell

- (void)awakeFromNib {
    // Initialization code
    self.btPost.layer.cornerRadius = self.btPost.bounds.size.width / 2.0;
    self.btPost.layer.masksToBounds = YES;
    self.avataUser.layer.cornerRadius = self.btPost.bounds.size.width / 2.0;
    self.avataUser.layer.masksToBounds = YES;
    self.tfComment.layer.cornerRadius = 5.0f;
    self.tfComment.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

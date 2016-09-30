//
//  CommentTypeCell.h
//  ChuyenMotTrang
//
//  Created by Le Phuc on 3/2/16.
//  Copyright © 2016 Lê Đình Phúc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTypeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avataUser;
@property (weak, nonatomic) IBOutlet UILabel *lbAccount;
@property (weak, nonatomic) IBOutlet UITextView *tfComment;
@property (weak, nonatomic) IBOutlet UIButton *btPost;

@end

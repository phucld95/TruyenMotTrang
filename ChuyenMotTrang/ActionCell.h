//
//  ActionCell.h
//  ChuyenMotTrang
//
//  Created by Lê Đình Phúc on 2/3/16.
//  Copyright © 2016 Lê Đình Phúc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btLike;
@property (weak, nonatomic) IBOutlet UIButton *btComment;
@property (weak, nonatomic) IBOutlet UIButton *btShare;
@property (weak, nonatomic) IBOutlet UIButton *btDownload;
@property (weak, nonatomic) IBOutlet UILabel *likeNumber;
@property (weak, nonatomic) IBOutlet UILabel *commentNumber;

@end

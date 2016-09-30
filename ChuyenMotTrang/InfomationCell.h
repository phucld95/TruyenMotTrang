//
//  InfomationCell.h
//  ChuyenMotTrang
//
//  Created by Lê Đình Phúc on 2/3/16.
//  Copyright © 2016 Lê Đình Phúc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfomationCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgAvata;
@property (weak, nonatomic) IBOutlet UILabel *lbFanpageName;
@property (weak, nonatomic) IBOutlet UILabel *lbTime;
@property (weak, nonatomic) IBOutlet UIButton *btRepost;

@end

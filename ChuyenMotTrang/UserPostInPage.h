//
//  UserPostInPage.h
//  ChuyenMotTrang
//
//  Created by Lê Đình Phúc on 2/23/16.
//  Copyright © 2016 Lê Đình Phúc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserPostInPage : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbvUserPost;
@property (weak, nonatomic) IBOutlet UIButton *refressButton;

@end

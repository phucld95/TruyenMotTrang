//
//  AllStoriesViewController.h
//  ChuyenMotTrang
//
//  Created by Lê Đình Phúc on 2/11/16.
//  Copyright © 2016 Lê Đình Phúc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllStoriesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *refressButton;
@property (weak, nonatomic) IBOutlet UIButton *btPin;


@end

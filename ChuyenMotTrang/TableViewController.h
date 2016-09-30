//
//  TableViewController.h
//  ChuyenMotTrang
//
//  Created by Lê Đình Phúc on 2/2/16.
//  Copyright © 2016 Lê Đình Phúc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) CGFloat previousScrollViewYOffset;

@property (weak, nonatomic) IBOutlet UIView *viewLoadData;
@property (weak, nonatomic) IBOutlet UILabel *lbLoad;

@end

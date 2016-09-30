//
//  CollectionViewCell.m
//  MyContact
//
//  Created by Lê Đình Phúc on 1/12/16.
//  Copyright © 2016 Lê Đình Phúc. All rights reserved.
//

#import "CollectionViewCell.h"
#import "FileManager.h"

@implementation CollectionViewCell
- (void)awakeFromNib {
    _alphaView.hidden = YES;
    _isChoice = NO;
    
    self.backgroundColor = [UIColor whiteColor];
    self.buttonDelete.layer.cornerRadius = self.buttonDelete.frame.size.height/2;
    self.buttonDelete.layer.masksToBounds = YES;
    self.buttonDelete.hidden = YES;
    
    self.buttonDelete.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.buttonDelete.layer.shadowOffset = CGSizeMake(0, 0);
    self.buttonDelete.layer.shadowOpacity = 1;
    self.buttonDelete.layer.shadowRadius = 5;
    self.buttonDelete.clipsToBounds = NO;
    // Initialization code
    
}


@end

//
//  UserViewController.h
//  ChuyenMotTrang
//
//  Created by Lê Đình Phúc on 2/16/16.
//  Copyright © 2016 Lê Đình Phúc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface UserViewController : UIViewController <UIImagePickerControllerDelegate, UITextViewDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btAlbum;
@property (weak, nonatomic) IBOutlet UIButton *btCamera;
@property (weak, nonatomic) IBOutlet UIImageView *imgCover;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvata;
@property (weak, nonatomic) IBOutlet UILabel *lbAccount;
@property (weak, nonatomic) IBOutlet UIImageView *imgChoce;
@property (weak, nonatomic) IBOutlet UIButton *btPost;
@property (weak, nonatomic) IBOutlet UITextView *tfCaption;

@end

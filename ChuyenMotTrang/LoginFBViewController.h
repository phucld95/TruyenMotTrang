//
//  ViewController.h
//  testFbSDK
//
//  Created by Lê Đình Phúc on 2/16/16.
//  Copyright © 2016 Lê Đình Phúc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface LoginFBViewController : UIViewController <FBSDKLoginButtonDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avaraImg;
@property (weak, nonatomic) IBOutlet UIImageView *coverImg;
@property (weak, nonatomic) IBOutlet UIButton *btLogin;

@property (weak, nonatomic) IBOutlet UIView *privacyView;

@property (weak, nonatomic) IBOutlet UIButton *btClose;
@property (weak, nonatomic) IBOutlet UIButton *btAccept;
@property (weak, nonatomic) IBOutlet UIButton *btShowPrivacy;

@property (nonatomic) BOOL isAccept;

@end


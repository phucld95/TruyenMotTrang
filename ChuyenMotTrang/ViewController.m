//
//  ViewController.m
//  ChuyenMotTrang
//
//  Created by Lê Đình Phúc on 1/29/16.
//  Copyright © 2016 Lê Đình Phúc. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    //loginButton.center = self.view.center;
    //[self.view addSubview:loginButton];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    
    //Check and break if has key @"story"
//    if ([postInfo objectForKey:@"story"] != nil) {
//        break;
//    }
//    else{
//        NSString *idPost = [postInfo objectForKey:@"id"];
//        
//        // request photo from fanpage.
//        NSDictionary *params2 = @{@"access_token":@"999156186812985|F7aEPMfm1WMspyRqYmgmzfeQS2s",
//                                  @"fields":@"full_picture,picture,message,actions"};
//        FBSDKGraphRequest *request2 = [[FBSDKGraphRequest alloc]
//                                       initWithGraphPath: [NSString stringWithFormat:@"/%@/post",idPost]
//                                       parameters:params2
//                                       HTTPMethod:@"GET"];
//        [request2 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
//                                               id result,
//                                               NSError *error) {
//            
//            if ([postInfo objectForKey:@"full_picture"] != [NSNull null]) {
//                DataImage *dataImage = [[DataImage alloc] init];
//                dataImage.avataName = @"avata.png";
//                dataImage.fanpage = @"Truyện một trang";
//                dataImage.likeNumber = @"0";
//                dataImage.commentNumber = @"0";
//                NSString *urlImageStr = [postInfo objectForKey:@"full_picture"];
//                NSURL *urlImage = [NSURL URLWithString:urlImageStr];
//                [listURLImage addObject:urlImage];
//                NSString *urlImageThumnalStr = [postInfo objectForKey:@"picture"];
//                NSURL *urlThumnal = [NSURL URLWithString:urlImageThumnalStr];
//                [listURLThmbnail addObject:urlThumnal];
//                dataImage.idImage = idPost;
//                [listImage addObject:dataImage];
//                
//                //Get likes number and comments number.
//                NSDictionary *paramsGetLike = @{@"access_token":accessToken,
//                                                @"summary":@"true",
//                                                };
//                FBSDKGraphRequest *request3 = [[FBSDKGraphRequest alloc]
//                                               initWithGraphPath:[NSString stringWithFormat:@"/%@/likes",idPost]
//                                               parameters:paramsGetLike
//                                               HTTPMethod:@"GET"];
//                [request3 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
//                                                       id result,
//                                                       NSError *error) {
//                    if (!error && result){
//                        NSDictionary *summary = [result objectForKey:@"summary"];
//                        dataImage.likeNumber = [summary objectForKey:@"total_count"];
//                        dataImage.userLiked = [summary objectForKey:@"has_liked"];
//                    }
//                }];
//                
//                //Get comments number.
//                NSDictionary *paramsGetComment = @{@"access_token":@"999156186812985|F7aEPMfm1WMspyRqYmgmzfeQS2s",
//                                                   @"summary":@"true",
//                                                   };
//                FBSDKGraphRequest *request4 = [[FBSDKGraphRequest alloc]
//                                               initWithGraphPath:[NSString stringWithFormat:@"/%@/comments",idPost]
//                                               parameters:paramsGetComment
//                                               HTTPMethod:@"GET"];
//                [request4 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
//                                                       id result,
//                                                       NSError *error) {
//                    if (!error && result){
//                        NSDictionary *summary = [result objectForKey:@"summary"];
//                        dataImage.commentNumber = [summary objectForKey:@"total_count"];
//                    }
//                }];
//                NSLog(@"%lu",(unsigned long)[listImage count]);
//            }
//        }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

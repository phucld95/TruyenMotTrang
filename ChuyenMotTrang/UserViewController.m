//
//  UserViewController.m
//  ChuyenMotTrang
//
//  Created by Lê Đình Phúc on 2/16/16.
//  Copyright © 2016 Lê Đình Phúc. All rights reserved.
//

#import "UserViewController.h"
#import "QuartzCore/CALayer.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "MBProgressHUD.h"

@implementation UserViewController
{
    UIImagePickerController *pickerFromGallery;
    UIImagePickerController *pickerFromCamera;
    UISwipeGestureRecognizer *swipeDown;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

    
    
    self.tfCaption.delegate = self;
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [self.btAlbum addTarget:self action:@selector(chooseImage) forControlEvents:UIControlEventTouchUpInside];
    [self.btCamera addTarget:self action:@selector(takeImageFromCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.btPost addTarget:self action:@selector(postToPage) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    pickerFromGallery = [[UIImagePickerController alloc]init];
    pickerFromGallery.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerFromGallery.delegate = self;
//    pickerFromCamera = [[UIImagePickerController alloc]init];
//    pickerFromCamera.sourceType = UIImagePickerControllerSourceTypeCamera;
//    pickerFromCamera.delegate = self;
//    
    
    // Set shadow image avata.
    self.imgAvata.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.imgAvata.layer.shadowOffset = CGSizeMake(0, 0);
    self.imgAvata.layer.shadowOpacity = 1;
    self.imgAvata.layer.shadowRadius = 5;
    self.imgAvata.clipsToBounds = NO;
    
    
    // Action.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    
    swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(upToDownSwipeGesture:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDown];

    
    // Insert data.
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{ @"fields" : @"id,name,picture.width(1000).height(1000),cover"}]startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSString *nameOfLoginUser = [result valueForKey:@"name"];
            NSString *imageStringOfLoginUser = [[[result objectForKey:@"picture"] objectForKey: @"data"] objectForKey:@"url"];
            self.lbAccount.text = nameOfLoginUser;
            NSURL *url = [[NSURL alloc] initWithString:imageStringOfLoginUser];
            self.imgAvata.imageURL = url;
            NSURL *url2 = [[NSURL alloc] initWithString:[[result objectForKey:@"cover"] objectForKey:@"source"]];
            self.imgCover.imageURL = url2;
        }
    }];
    
    self.btPost.layer.cornerRadius = self.btPost.bounds.size.width / 2.0;
    self.btPost.layer.masksToBounds = YES;
    
    self.btAlbum.layer.cornerRadius = 5;
    self.btAlbum.layer.masksToBounds = YES;
    
    self.tfCaption.layer.cornerRadius = 5;
    self.tfCaption.layer.masksToBounds = YES;
    
    self.imgChoce.layer.cornerRadius = 5;
    self.imgChoce.layer.masksToBounds = YES;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

}

#pragma mark - Action.
-(void)upToDownSwipeGesture:(UISwipeGestureRecognizer *) sender
{
    //Gesture detect - swipe down , can't be recognized direction
    
    [self dismissKeyboard];
}

-(void) postToPage{
    [self dismissKeyboard];
    UIView *proget = [[UIView alloc] initWithFrame:self.view.frame];
    proget.backgroundColor = [UIColor blackColor];
    [proget setAlpha:0.6f];
    [self.view addSubview:proget];
    [MBProgressHUD showHUDAddedTo:proget animated:YES];
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable){
        //connection unavailable
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                        message:@"You must be connected to the internet to used app."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    else{
        NSString *mes = self.tfCaption.text;
        UIImage *imgSource = self.imgChoce.image;
        if (mes == nil || [mes length] < 10) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Caution!"
                                                            message:@"You must to write something longer."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [proget removeFromSuperview];
            return;
        }
        if (imgSource == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Caution!"
                                                            message:@"You must attach 1 photo!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [proget removeFromSuperview];
            return;
        }
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath: @"/TruyenMotTrang/photos"
                                      parameters:@{
                                          @"message":mes,
                                          @"picture":imgSource,
                                      }
                                      HTTPMethod:@"POST"];
        
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                              id result,
                                              NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [proget removeFromSuperview];
            if (!error) {
                if ([result objectForKey:@"id"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations!"
                                                                    message:@"Your story has been posted successfully"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    self.tfCaption.text = @"";
                    self.imgChoce.image = nil;
                }
            }
        
        }];
    }
}


#pragma mark - Setup keyboard

-(BOOL) textViewShouldReturn:(UITextField *)textField{
    [self dismissKeyboard];
    return NO;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    textView.text = @"";
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = CGRectMake(0, -150, self.view.frame.size.width, self.view.frame.size.height);
    }];
    return YES;
}



-(void)dismissKeyboard{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
    //[self.view setFrame:CGRectMake(0,0,320,460)];

    [self.tfCaption resignFirstResponder];
}

#pragma mark - Pick photo
-(void)chooseImage{
    [self presentViewController:pickerFromGallery animated:YES completion:nil];
}

-(void)takeImageFromCamera{
    [self presentViewController:pickerFromCamera animated:YES completion:nil];
}

// This method is called when an image has been chosen from the library or taken from the camera.
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary<NSString *,id> *)editingInfo{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    //notImageDefault = YES;
    self.imgChoce.image = image;
    [self.imgChoce setContentMode:UIViewContentModeScaleAspectFit];
    [self.imgChoce setBackgroundColor:[UIColor whiteColor]];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

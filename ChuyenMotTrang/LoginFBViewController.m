//
//  ViewController.m
//  testFbSDK
//
//  Created by Lê Đình Phúc on 2/16/16.
//  Copyright © 2016 Lê Đình Phúc. All rights reserved.
//

#import "LoginFBViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "TabBarController.h"
#import "Fanpage.h"
#import "TutorialViewController.h"
#import "UIColor+flat.h"

@implementation LoginFBViewController
{
    NSMutableArray *listFanpage;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _isAccept = NO;
    _privacyView.hidden = YES;
    _btLogin.userInteractionEnabled = NO;
    _btLogin.backgroundColor = [UIColor grayColor];
    _privacyView.layer.cornerRadius = 5;
    _privacyView.layer.masksToBounds = YES;
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    self.btLogin.layer.cornerRadius = self.btLogin.bounds.size.height / 5.0;
    self.btLogin.layer.masksToBounds = YES;
    [self.btLogin addTarget:self action:@selector(btLoginTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [_btAccept addTarget:self action:@selector(btAcceptTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [_btShowPrivacy addTarget:self action:@selector(btShowPrivacyTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [_btClose addTarget:self action:@selector(btClosePrivacyTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    if ([FBSDKAccessToken currentAccessToken]) {
        [self requestPermission];
        
    }
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)btClosePrivacyTouchUpInside{
    [_privacyView setAlpha:0.8f];
    [UIView animateWithDuration:0.5f animations:^{
        [_privacyView setAlpha:0];
    } completion:^(BOOL finished) {
        _privacyView.hidden = YES;
    }];
}

-(void)btShowPrivacyTouchUpInside{
    [_privacyView setAlpha:0];
    _privacyView.hidden = NO;
    [UIView animateWithDuration:0.5f animations:^{
        [_privacyView setAlpha:0.8f];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)btAcceptTouchUpInside{
    if (_isAccept == NO) {
        _isAccept = YES;
        _btLogin.userInteractionEnabled = YES;
        _btLogin.backgroundColor = [UIColor colorWithHexCode:@"#3754A7"];
        [_btAccept setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
    }
    else{
        _isAccept = NO;
        _btLogin.userInteractionEnabled = NO;
        _btLogin.backgroundColor = [UIColor grayColor];
        [_btAccept setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
    }
}


-(void)btLoginTouchUpInside{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
             [self requestPermission];
         }
     }];
    [self setFanpageGetPhotto];
}

-(void) setFanpageGetPhotto{
    listFanpage = [[NSMutableArray alloc] init];
    Fanpage *thoBayMau = [[Fanpage alloc] init];
    thoBayMau.nameFanpage = @"Thỏ Bảy Màu";
    thoBayMau.idFanpage = @"932969840046994";
    thoBayMau.linkNext = @"0";
    [listFanpage addObject:thoBayMau];
    
    Fanpage *chuyenVatCuaMuc = [[Fanpage alloc] init];
    chuyenVatCuaMuc.nameFanpage = @"Chuyện vặt của Múc";
    chuyenVatCuaMuc.idFanpage = @"912837245474246";
    chuyenVatCuaMuc.linkNext = @"0";
    [listFanpage addObject:chuyenVatCuaMuc];
    
    Fanpage *hoiBua = [[Fanpage alloc] init];
    hoiBua.nameFanpage = @"Hội Bựa";
    hoiBua.idFanpage = @"204953912944086";
    hoiBua.linkNext = @"0";
    [listFanpage addObject:hoiBua];
    
    Fanpage *tumLumChuyen = [[Fanpage alloc] init];
    tumLumChuyen.nameFanpage = @"Mèo Mộng Mị";
    tumLumChuyen.idFanpage = @"1634227816854653";
    tumLumChuyen.linkNext = @"0";
    [listFanpage addObject:tumLumChuyen];
    
    Fanpage *meoMongMi = [[Fanpage alloc] init];
    meoMongMi.nameFanpage = @"Tùm Lum Chuyện TimeLine";
    meoMongMi.idFanpage = @"1009283469122772";
    meoMongMi.linkNext = @"0";
    [listFanpage addObject:meoMongMi];
    
    Fanpage *tumLumChuyen2 = [[Fanpage alloc] init];
    tumLumChuyen2.nameFanpage = @"Tùm Lum Chuyện Mobile";
    tumLumChuyen2.idFanpage = @"1008373329213786";
    tumLumChuyen2.linkNext = @"0";
    [listFanpage addObject:tumLumChuyen2];
    
    Fanpage *tukiVietNam = [[Fanpage alloc] init];
    tukiVietNam.nameFanpage = @"TuKi Việt Nam";
    tukiVietNam.idFanpage = @"1606527596293567";
    tukiVietNam.linkNext = @"0";
    [listFanpage addObject:tukiVietNam];
    
    Fanpage *gauAka = [[Fanpage alloc] init];
    gauAka.nameFanpage = @"Gấu Aka";
    gauAka.idFanpage = @"898304036889070";
    gauAka.linkNext = @"0";
    [listFanpage addObject:gauAka];
    
    Fanpage *baGiaKeuCa = [[Fanpage alloc] init];
    baGiaKeuCa.nameFanpage = @"Bà Già Kêu Ca";
    baGiaKeuCa.idFanpage = @"1681972035415737";
    baGiaKeuCa.linkNext = @"0";
    [listFanpage addObject:baGiaKeuCa];
    
    Fanpage *jokohama = [[Fanpage alloc] init];
    jokohama.nameFanpage = @"Jocohama";
    jokohama.idFanpage = @"791282507608127";
    jokohama.linkNext = @"0";
    [listFanpage addObject:jokohama];
    
    Fanpage *drawForFun = [[Fanpage alloc] init];
    drawForFun.nameFanpage = @"Draw For Fun1";
    drawForFun.idFanpage = @"887263907956567";
    drawForFun.linkNext = @"0";
    [listFanpage addObject:drawForFun];
    
    Fanpage *drawForFun2 = [[Fanpage alloc] init];
    drawForFun2.nameFanpage = @"Draw For Fun2";
    drawForFun2.idFanpage = @"907779802571644";
    drawForFun2.linkNext = @"0";
    [listFanpage addObject:drawForFun2];
    
    Fanpage *drawForFun3 = [[Fanpage alloc] init];
    drawForFun3.nameFanpage = @"Draw For Fun3";
    drawForFun3.idFanpage = @"887251841291107";
    drawForFun3.linkNext = @"0";
    [listFanpage addObject:drawForFun3];
    for (int i = 0; i<[listFanpage count]; i++) {
        Fanpage *fanpage = [listFanpage objectAtIndex:i];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:fanpage.nameFanpage];
    }
}

-(void) requestPermission{
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TabBarController *tabBar = [storyboard instantiateViewControllerWithIdentifier:@"tabBar"];
        [self.navigationController presentViewController:tabBar animated:YES completion:nil];
    } else {
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logInWithPublishPermissions:@[@"publish_actions"]
                               fromViewController:self
                                          handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                              UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                              TutorialViewController *tutorial = [storyboard instantiateViewControllerWithIdentifier:@"tutor"];
                                              [self.navigationController pushViewController:tutorial animated:YES];
                                          }];
    }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    
}

- (void)  loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                error:(NSError *)error{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

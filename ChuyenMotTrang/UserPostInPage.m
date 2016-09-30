//
//  UserPostInPage.m
//  ChuyenMotTrang
//
//  Created by Lê Đình Phúc on 2/23/16.
//  Copyright © 2016 Lê Đình Phúc. All rights reserved.
//

#import "UserPostInPage.h"
#import "ZoomImageViewController.h"
#import "FileManager.h"
#import "ZCPhotoLibrary.h"
#import "TLYShyNavBarManager.h"
#import "Fanpage.h"
#import "MBProgressHUD.h"
#import "UIImageView+MHFacebookImageViewer.h"


@implementation UserPostInPage
{
    NSMutableArray *listImage;
    NSMutableArray *listURLImage;
    NSMutableArray *listURLThmbnail;
    FileManager *fileManager;
    NSMutableArray *listImageDownload;
    BOOL isEnd;
    NSString *until;
    NSString *__paging_token;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    fileManager = [[FileManager alloc] init];
    _tbvUserPost.delegate = self;
    _tbvUserPost.dataSource = self;
    listImage = [[NSMutableArray alloc] init];
    listURLImage = [[NSMutableArray alloc] init];
    listURLThmbnail = [[NSMutableArray alloc] init];
    isEnd = NO;
    until = @"";
    __paging_token = @"";
    
    
    
    //NavigationBar.
    self.shyNavBarManager.scrollView = self.tbvUserPost;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.refressButton addTarget:self action:@selector(refressButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *listImageSaved = [defaults objectForKey: @"listImage"];
    if (listImageSaved == nil) {
        listImageSaved = [[NSArray alloc] init];
    }
    listImageDownload = [NSMutableArray arrayWithArray:listImageSaved];
    
    //Register Nib Cell.
    [self.tbvUserPost registerNib:[UINib nibWithNibName:@"ImageCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    [self.tbvUserPost registerNib:[UINib nibWithNibName:@"InfomationCell" bundle:nil] forCellReuseIdentifier:@"InfomationCell"];
    [self.tbvUserPost registerNib:[UINib nibWithNibName:@"CaptionCell" bundle:nil] forCellReuseIdentifier:@"CaptionCell"];
    [self.tbvUserPost registerNib:[UINib nibWithNibName:@"ImageViewCell" bundle:nil] forCellReuseIdentifier:@"ImageViewCell"];
    [self.tbvUserPost registerNib:[UINib nibWithNibName:@"ActionCell" bundle:nil] forCellReuseIdentifier:@"ActionCell"];
    
    //Setup table view.
    self.tbvUserPost.separatorColor = [UIColor clearColor];
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable){
        //connection unavailable
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                        message:@"You must be connected to the internet and click refess."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else{
        //Get post from fanpage TruyenMotTrang.
        [self getDataFromFacebook];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tbvUserPost reloadData];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *listImageSaved = [defaults objectForKey: @"listImage"];
    if (listImageSaved == nil) {
        listImageSaved = [[NSArray alloc] init];
    }
    listImageDownload = [NSMutableArray arrayWithArray:listImageSaved];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Get data from Facebook.

-(void) getDataFromFacebook{
    if (isEnd == YES) {
        return;
    }
    
    
    // request photo from fanpage.
    NSDictionary *params = @{
                             @"pretty":@"1",
                             @"limit":@"25",
                             @"until":until,
                             @"__paging_token":__paging_token};
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath: @"/TruyenMotTrang/feed"
                                  parameters:params
                                  HTTPMethod:@"GET"];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        if (!error && result){
            NSArray *postsData = [result objectForKey:@"data"];
            
            if ([postsData count] > 0)
            {
                if ([postsData count] < 25) {
                    isEnd = true;
                }
                for (NSDictionary *postInfo in postsData)
                {
                    if ([postInfo objectForKey:@"story"] != nil) {
                        continue;
                    }
                    else{
                        NSString *idPost = [postInfo objectForKey:@"id"];
                        
                        // request photo from fanpage.
                        NSDictionary *params2 = @{@"fields":@"full_picture,picture,message,actions,from"};
                        FBSDKGraphRequest *request2 = [[FBSDKGraphRequest alloc]
                                                        initWithGraphPath: [NSString stringWithFormat:@"/%@",idPost]
                                                        parameters:params2
                                                        HTTPMethod:@"GET"];
                        [request2 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                                       id result,
                                                                        NSError *error) {
                            if ([result objectForKey:@"full_picture"] != [NSNull null]){                                                DataImage *dataImage = [[DataImage alloc] init];
                                dataImage.userCommneted = [NSString stringWithFormat:@"/%@",[[result objectForKey:@"from"] objectForKey:@"id"]];
                                
                                dataImage.fanpage = [[result objectForKey:@"from"] objectForKey:@"name"];
                                dataImage.likeNumber = @"0";
                                dataImage.commentNumber = @"0";
                                dataImage.caption = [result objectForKey:@"message"];
                                dataImage.timePost = [self catTime:(NSString *)[postInfo objectForKey:@"created_time"]];
                                NSString *urlImageStr = [result objectForKey:@"full_picture"];
                                NSURL *urlImage = [NSURL URLWithString:urlImageStr];
                                [listURLImage addObject:urlImage];
                                NSString *urlImageThumnalStr = [result objectForKey:@"picture"];
                                NSURL *urlThumnal = [NSURL URLWithString:urlImageThumnalStr];
                                [listURLThmbnail addObject:urlThumnal];
                                dataImage.idImage = idPost;
                                [listImage addObject:dataImage];
                                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                                    dataImage.imageThumbnail = [NSData dataWithContentsOfURL:urlThumnal];

                                    //Update table view when load thumbnail image completed
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self.tbvUserPost reloadData];

                                    });
                                });
                                
                                
                                //Get likes number and comments number.
                                NSDictionary *paramsGetLike = @{
                                                                @"summary":@"true",
                                                                };
                                FBSDKGraphRequest *request3 = [[FBSDKGraphRequest alloc]
                                                               initWithGraphPath:[NSString stringWithFormat:@"/%@/likes",idPost]
                                                                parameters:paramsGetLike
                                                                HTTPMethod:@"GET"];
                                [request3 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                                id result,
                                                                NSError *error) {
                                    if (!error && result){
                                        NSDictionary *summary = [result objectForKey:@"summary"];
                                        dataImage.likeNumber = [summary objectForKey:@"total_count"];
                                        dataImage.userLiked = [summary objectForKey:@"has_liked"];
                                        }
                                }];
                                
                                //Get comments number.
                                NSDictionary *paramsGetComment = @{
                                                                @"summary":@"true",
                                                                };
                                FBSDKGraphRequest *request4 = [[FBSDKGraphRequest alloc]
                                                                initWithGraphPath:[NSString stringWithFormat:@"/%@/comments",idPost]
                                                                parameters:paramsGetComment
                                                                HTTPMethod:@"GET"];
                                [request4 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                                id result,
                                                                NSError *error) {
                                    if (!error && result){
                                        NSDictionary *summary = [result objectForKey:@"summary"];
                                        dataImage.commentNumber = [summary objectForKey:@"total_count"];
                                        }
                                }];
                            }
                        }];
                    }
                }
            }
            NSDictionary *paging =[result objectForKey:@"paging"];
            if ([paging objectForKey:@"next"] == [NSNull null]) {
                isEnd = YES;
                NSLog(@"\n\n\nXin thông báo 1 cháu hết!");
            }
            else{
                NSString *linkNextPhotos = [paging objectForKey:@"next"];
                NSArray *nextPageParamater = [linkNextPhotos componentsSeparatedByString: @"&"];
                NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                NSString *tempPara = [[NSString alloc] init];
                for (int i=0; i<[nextPageParamater count]; i++) {
                    tempPara = [nextPageParamater objectAtIndex:i];
                    if ([tempPara rangeOfString:@"until"].location != NSNotFound) {
                        tempArray = [NSMutableArray arrayWithArray: [tempPara componentsSeparatedByString:@"="]];
                        until = [tempArray objectAtIndex:1];
                    }
                    if ([tempPara rangeOfString:@"__paging_token"].location != NSNotFound) {
                        tempArray = [NSMutableArray arrayWithArray: [tempPara componentsSeparatedByString:@"="]];
                        __paging_token = [tempArray objectAtIndex:1];
                    }
                }
            }
        }
        else{
    
        }
    }];
}

-(NSString*) catTime:(NSString*) time{
    NSArray *subStrings = [time componentsSeparatedByString:@"T"];
    NSArray *day =  [(NSString*)[subStrings objectAtIndex:0] componentsSeparatedByString:@"-"];
    NSString *strPrint = (NSString*)[day objectAtIndex:2];
    strPrint = [strPrint stringByAppendingString:@"-"];
    strPrint = [strPrint stringByAppendingString:(NSString*)[day objectAtIndex:1]];
    strPrint = [strPrint stringByAppendingString:@"-"];
    strPrint = [strPrint stringByAppendingString:(NSString*)[day objectAtIndex:0]];
    day =  [(NSString*)[subStrings objectAtIndex:1] componentsSeparatedByString:@":"];
    strPrint = [strPrint stringByAppendingString:@" | "];
    strPrint = [strPrint stringByAppendingString:(NSString*)[day objectAtIndex:0]];
    strPrint = [strPrint stringByAppendingString:@":"];
    strPrint = [strPrint stringByAppendingString:(NSString*)[day objectAtIndex:1]];
    
    
    
    return strPrint;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [listImage count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CommentViewControler *commentSC = [storyboard instantiateViewControllerWithIdentifier:@"CommentViewControler"];
        commentSC.dataPost = [listImage objectAtIndex:indexPath.section];
        commentSC.imageURL = [listURLImage objectAtIndex:indexPath.section];
        [self.navigationController pushViewController:commentSC animated:YES];
    }
//    if (indexPath.row == 2) {
//        ImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageViewCell"];
//        cell = [tableView cellForRowAtIndexPath:indexPath];
//        ZoomImageViewController *zoomView = [[ZoomImageViewController alloc]
//                                             initWithNibName:@"ZoomImageViewController" bundle:nil];
//        NSData *imageData = UIImagePNGRepresentation(cell.imgImageView.image);
//        zoomView.data = imageData;
//        
//        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//        [self.navigationController pushViewController:zoomView animated:YES];
//    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DataImage *temp = [listImage objectAtIndex:indexPath.section];
    
    if (indexPath.row == 0) {
        InfomationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfomationCell"];
        FBSDKGraphRequest *requestAvata = [[FBSDKGraphRequest alloc]
                                           initWithGraphPath: temp.userCommneted
                                           parameters:@{
                                                        @"fields":@"picture.width(200).height(200)"
                                                        }
                                           HTTPMethod:@"GET"];
        [requestAvata startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,id result,NSError *error) {
            cell.imgAvata.imageURL = [NSURL URLWithString: [[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]];
        }];
        cell.lbFanpageName.text = temp.fanpage;
        cell.lbTime.text = temp.timePost;
        cell.userInteractionEnabled = YES;
        [cell.btRepost addTarget:self action:@selector(btRepostTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        return cell;
    }
    else if (indexPath.row == 1){
        CaptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CaptionCell"];
        cell.lbCaption.text = temp.caption;
//        cell.userInteractionEnabled = NO;
        //TODO: Create scene show full caption.
        return cell;
    }
    else if (indexPath.row == 2){
        DataImage *temp = [listImage objectAtIndex:indexPath.section];
        ImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageViewCell"];
        if (temp.imageThumbnail != nil){
            cell.imgImageView.image = [UIImage imageWithData:temp.imageThumbnail];
            [cell.loadImage setHidden:YES];
        }
        cell.imgImageView.imageURL = [listURLImage objectAtIndex:indexPath.section];
        [cell.imgImageView setupImageViewer];
        return cell;
        
    }
    else{
        ActionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActionCell"];
        DataImage *temp = [listImage objectAtIndex:indexPath.section];
        float likeNumber = [temp.likeNumber floatValue];
        if (likeNumber > 1000) {
            likeNumber = likeNumber/1000;
            cell.likeNumber.text = [NSString stringWithFormat:@"%.01fK Likes",likeNumber];
        }
        else{
            cell.likeNumber.text = [NSString stringWithFormat:@"%@ Likes",temp.likeNumber];
        }
        
        float commentNumber = [temp.commentNumber floatValue];
        if (commentNumber > 1000) {
            commentNumber = commentNumber/1000;
            cell.commentNumber.text = [NSString stringWithFormat:@"%.01fK Comments",commentNumber];
        }
        else{
            cell.commentNumber.text = [NSString stringWithFormat:@"%@ Comments",temp.commentNumber];
        }
        
        if ([temp.userLiked integerValue] == 1) {
            [cell.btLike setImage:[UIImage imageNamed:@"Thumb Up Filled-30@3x.png"] forState:UIControlStateNormal];
        }
        else{
            [cell.btLike setImage:[UIImage imageNamed:@"Thumb Up-30@3x.png"] forState:UIControlStateNormal];
            
        }
        [cell.btDownload setImage:[UIImage imageNamed:@"Down 2-30@3x.png"] forState:UIControlStateNormal];
        
        cell.btLike.tag = cell.btComment.tag = cell.btShare.tag = cell.btDownload.tag = indexPath.section;
        [cell.btLike addTarget:self action:@selector(btLikeTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btComment addTarget:self action:@selector(btCommentTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btDownload addTarget:self action:@selector(btDownloadTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btShare addTarget:self action:@selector(btShareTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == ([listImage count] - 15)) {
            [self getDataFromFacebook];
        }
        return cell;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 60;
    }
    else if (indexPath.row == 1){
        DataImage *temp = [listImage objectAtIndex:indexPath.section];
        if (temp.caption == nil) {
            return 0;
        }
        else{
            NSString *caption = temp.caption;
            if ([caption length] == 0 ) {
                return 0;
            }
            
        }
        
        return 63;
    }
    else if (indexPath.row == 2){
        DataImage *temp = [listImage objectAtIndex:indexPath.section];
        UIImage *imageT = [UIImage imageWithData:temp.imageThumbnail];
        if (imageT == nil) {
            imageT = [UIImage imageNamed:@"full_placeholder.png"];
        }
        return (imageT.size.height * [[UIScreen mainScreen] bounds].size.width / imageT.size.width);
    }
    else{
        return 75;
    }
}
#pragma mark - Action.
-(void) btRepostTouchUpInside:(UIButton*) sender{
    [listImage removeObjectAtIndex:sender.tag];
    [listURLThmbnail removeObjectAtIndex:sender.tag];
    [listURLImage removeObjectAtIndex:sender.tag];
    [_tbvUserPost reloadData];
    
}


-(void)refressButtonTouchUpInside{
    [self refressData];
}

-(void) refressData{
    [self.tbvUserPost scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    [listImage removeAllObjects];
    [listURLImage removeAllObjects];
    [listURLThmbnail removeAllObjects];
    isEnd = NO;
    until = @"";
    __paging_token = @"";
    [self getDataFromFacebook];
    [_tbvUserPost reloadData];
}

-(void)btLikeTouchUpInside:(UIButton*) sender{
    DataImage *tempData = [listImage objectAtIndex: sender.tag];
    NSString *idImage = tempData.idImage;
    int likeNumber = [tempData.likeNumber intValue];
    
    
    if ([tempData.userLiked intValue] == 0) {
        [sender setImage:[UIImage imageNamed:@"Thumb Up Filled-30@3x.png"] forState:UIControlStateNormal];
        likeNumber ++;
        tempData.userLiked = @"1";
        tempData.likeNumber = [NSString stringWithFormat:@"%d",likeNumber];
        
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath: [NSString stringWithFormat: @"/%@/likes",idImage]
                                      parameters:@{
                                                   }
                                      HTTPMethod:@"POST"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                              id result,
                                              NSError *error) {
            if (error){
                NSLog(@"%@", error);
            }
            if (!error && result){
                NSLog(@"Had like: %@",[result objectForKey:@"success"]);
            }
        }];
        [self.tbvUserPost reloadData];
    }
    else{
        [sender setImage:[UIImage imageNamed:@"Thumb Up-30@3x.png"] forState:UIControlStateNormal];
        likeNumber --;
        tempData.likeNumber = [NSString stringWithFormat:@"%d",likeNumber];
        tempData.userLiked = @"0";
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath: [NSString stringWithFormat: @"/%@/likes",idImage]
                                      parameters:@{
                                                   }
                                      HTTPMethod:@"DELETE"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                              id result,
                                              NSError *error) {
            if (error){
                NSLog(@"%@", error);
            }
            if (!error && result){
                NSLog(@"Had like: %@",[result objectForKey:@"success"]);
            }
        }];
        [self.tbvUserPost reloadData];
    }
    
}

-(void)btCommentTouchUpInside:(UIButton*)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CommentViewControler *commentSC = [storyboard instantiateViewControllerWithIdentifier:@"CommentViewControler"];
    commentSC.dataPost = [listImage objectAtIndex:sender.tag];
    commentSC.imageURL = [listURLImage objectAtIndex:sender.tag];
    [self.navigationController pushViewController:commentSC animated:YES];
}

-(void)btShareTouchUpInside{
    
}

-(void)btDownloadTouchUpInside:(UIButton*)sender{
    UIView *proget = [[UIView alloc] initWithFrame:self.view.frame];
    proget.backgroundColor = [UIColor blackColor];
    [proget setAlpha:0.6f];
    [self.view bringSubviewToFront:proget];
    [self.view addSubview:proget];
    [MBProgressHUD showHUDAddedTo:proget animated:YES];

    NSData *imageData = [NSData dataWithContentsOfURL:[listURLImage objectAtIndex:sender.tag]];
    UIImage *imageThumbnail = [self imageThumbnail:imageData];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:imageData];
    DataImage *tempImage = [listImage objectAtIndex:sender.tag];
    NSString *nameImage = tempImage.idImage;
    
    for (int i=0; i< [listImageDownload count]; i++) {
        if ([[listImageDownload objectAtIndex:i] isEqualToString:nameImage]) {
            [self showAlertViewWithMessage:@"Photo is existing!"];
            [MBProgressHUD hideHUDForView:proget animated:YES];
            [proget removeFromSuperview];
            return;
        }
    }
    
    [listImageDownload addObject:nameImage];
    [fileManager writeImage:imageThumbnail toFile:[nameImage stringByAppendingString:@".png"]];
    [fileManager writeImage:[UIImage imageWithData:imageData] toFile:[nameImage stringByAppendingString:@"full.png"]];
    [[NSUserDefaults standardUserDefaults] setObject:listImageDownload forKey:@"listImage"];
    [self showAlertViewWithMessage:@"Save successfully!"];
    [MBProgressHUD hideHUDForView:proget animated:YES];
    [proget removeFromSuperview];
}

- (UIImage *)imageThumbnail:(NSData*)imageData{
    UIImage *image = [UIImage imageWithData: imageData];
    CGSize size;
    size.height = size.width = 80;
    CGFloat scale = MAX(size.width/image.size.width, size.height/image.size.height);
    CGFloat width = image.size.width * scale;
    CGFloat height = image.size.height * scale;
    CGRect imageRect = CGRectMake((size.width - width)/2.0f,
                                  (size.height - height)/2.0f,
                                  width,
                                  height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [image drawInRect:imageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)showAlertViewWithMessage:(NSString*)message
{
    void (^showBlock)() = ^(){
        UIAlertView* view = [[UIAlertView alloc]initWithTitle:@"Truyện Một Trang" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [view show];
    };
    if ([NSThread isMainThread]) {
        showBlock();
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            showBlock();
        });
    }
}




@end

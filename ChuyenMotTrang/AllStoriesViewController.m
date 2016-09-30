//
//  AllStoriesViewController.m
//  ChuyenMotTrang
//
//  Created by Lê Đình Phúc on 2/11/16.
//  Copyright © 2016 Lê Đình Phúc. All rights reserved.
//

#import "AllStoriesViewController.h"
#import "ZoomImageViewController.h"
#import "FileManager.h"
#import "ZCPhotoLibrary.h"
#import "TLYShyNavBarManager.h"
#import "Fanpage.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "UIImageView+MHFacebookImageViewer.h"


@interface AllStoriesViewController ()

@end

@implementation AllStoriesViewController
{
    NSMutableArray *listImage;
    NSMutableArray *listURLImage;
    NSMutableArray *listURLThmbnail;
    CGRect frameNavigationDefault;
    FileManager *fileManager;
    NSMutableArray *listImageDownload;
    NSMutableArray *listFanpage;
    NSString *saveLinkNext;
    BOOL isFirstLoad;
    BOOL isReload;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _btPin.layer.cornerRadius = _btPin.layer.frame.size.width/2;
    _btPin.layer.masksToBounds = YES;
    
    fileManager = [[FileManager alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    frameNavigationDefault = self.navigationController.navigationBar.frame;
    listImage = [[NSMutableArray alloc] init];
    listURLImage = [[NSMutableArray alloc] init];
    listURLThmbnail = [[NSMutableArray alloc] init];
    listFanpage = [[NSMutableArray alloc] init];
    isFirstLoad = YES;
    isReload = NO;
    
    //NavigationBar.
    self.shyNavBarManager.scrollView = self.tableView;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self.refressButton addTarget:self action:@selector(refressButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btPin addTarget:self action:@selector(pinImage) forControlEvents:UIControlEventTouchUpInside];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *listImageSaved = [defaults objectForKey: @"listImage"];
    if (listImageSaved == nil) {
        listImageSaved = [[NSArray alloc] init];
    }
    listImageDownload = [NSMutableArray arrayWithArray:listImageSaved];
    
    //Register Nib Cell.
    [self.tableView registerNib:[UINib nibWithNibName:@"ImageCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    [self.tableView registerNib:[UINib nibWithNibName:@"InfomationCell" bundle:nil] forCellReuseIdentifier:@"InfomationCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CaptionCell" bundle:nil] forCellReuseIdentifier:@"CaptionCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ImageViewCell" bundle:nil] forCellReuseIdentifier:@"ImageViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ActionCell" bundle:nil] forCellReuseIdentifier:@"ActionCell"];
    
    //Setup table view.
    self.tableView.separatorColor = [UIColor clearColor];
    
    
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
        //Set list fanpage.
        [self setFanpageGetPhotto];
        [self load25PictureNext];
    }

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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

-(void) setFanpageGetPhotto{
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
        fanpage.linkNext = [[NSUserDefaults standardUserDefaults] objectForKey:fanpage.nameFanpage];
    }
}


-(void) refressData{
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable){
        //connection unavailable
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                        message:@"You must be connected to the internet and click refess."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    [listImage removeAllObjects];
    [listURLImage removeAllObjects];
    [listURLThmbnail removeAllObjects];
    for (int i=0; i<[listFanpage count]; i++) {
        Fanpage *fanpage = [listFanpage objectAtIndex:i];
        fanpage.linkNext = @"0";
    }
    [self loadDataFirst];
    [_tableView reloadData];
}


-(void) loadDataFirst{
    for (int i=0; i<[listFanpage count]; i++) {
        Fanpage *temp = [listFanpage objectAtIndex:i];
        if ([temp.linkNext length] == 1) {
            temp.linkNext = @"";
        }
        NSDictionary *params = @{
                                 @"pretty":@"1",
                                 @"limit":@"1",
                                 @"after":temp.linkNext};

        
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath: [NSString stringWithFormat:@"/%@/photos",temp.idFanpage]
                                      parameters:params
                                      HTTPMethod:@"GET"];
        
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                              id result,
                                              NSError *error) {
//            if (!error && result){
//                temp.lastUpdate = [[[result objectForKey:@"paging"]
//                                    objectForKey:@"cursors"]
//                                   objectForKey:@"before"];
//            }
        }];
        [self getDataFromFanpage:temp :@"3" ];
    }
    isFirstLoad = NO;
}

-(void) getDataFromFanpage: (Fanpage*) page : (NSString*) limit{
    
    NSString *from = page.linkNext;
    
    NSDictionary *params = @{
                             @"pretty":@"1",
                             @"limit":limit,
                             @"after":from};
    
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath: [NSString stringWithFormat:@"/%@/photos",page.idFanpage]
                                  parameters:params
                                  HTTPMethod:@"GET"];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        if (!error && result)
        {
            NSArray *postsData = [result objectForKey:@"data"];
            
            if ([postsData count] > 0)
            {
                for (NSDictionary *postInfo in postsData)
                {
                    DataImage *dataImage = [[DataImage alloc] init];
                    dataImage.avataName = @"avata.png";
                    dataImage.fanpage = @"Truyện một trang";
                    dataImage.likeNumber = @"0";
                    dataImage.commentNumber = @"0";
                    NSString *idImage = [postInfo objectForKey:@"id"];
                    dataImage.idImage = idImage;
                    dataImage.timePost = [self catTime:(NSString *)[postInfo objectForKey:@"created_time"]];
                    dataImage.caption = @"";
                    dataImage.userLiked = @"0";
                    dataImage.userCommneted = @"0";
                    if ([postInfo objectForKey:@"name"]) {
                        dataImage.caption = [postInfo objectForKey:@"name"];
                    }
                    
                    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture",idImage]];
                    NSURL *urlThumbnail = [NSURL URLWithString: [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=thumbnail",idImage]];
                    [listURLImage addObject:url];
                    [listURLThmbnail addObject: urlThumbnail];
                    [listImage addObject:dataImage];
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                        NSData *data = [NSData dataWithContentsOfURL:urlThumbnail];
                        
                        //Update table view when load thumbnail image completed
                        dispatch_async(dispatch_get_main_queue(), ^{
                            dataImage.imageThumbnail = data;
                            [self.tableView reloadData];
                            
                        });
                    });

                    
                    
                    
                    
                    
                    //Get likes number and comments number.
                    NSDictionary *paramsGetLike = @{
                                                    @"summary":@"true",
                                                    };
                    FBSDKGraphRequest *request2 = [[FBSDKGraphRequest alloc]
                                                   initWithGraphPath:[NSString stringWithFormat:@"/%@/likes",idImage]
                                                   parameters:paramsGetLike
                                                   HTTPMethod:@"GET"];
                    [request2 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
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
                    FBSDKGraphRequest *request3 = [[FBSDKGraphRequest alloc]
                                                   initWithGraphPath:[NSString stringWithFormat:@"/%@/comments",idImage]
                                                   parameters:paramsGetComment
                                                   HTTPMethod:@"GET"];
                    [request3 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                           id result,
                                                           NSError *error) {
                        if (!error && result){
                            NSDictionary *summary = [result objectForKey:@"summary"];
                            dataImage.commentNumber = [summary objectForKey:@"total_count"];
                        }
                    }];
                    NSLog(@"%lu",(unsigned long)[listImage count]);
                }
            }
            [self.tableView reloadData];
            NSDictionary *temp2 =[result objectForKey:@"paging"];
            if ([temp2 objectForKey:@"next"] == [NSNull null]) {
                page.linkNext = @"22";
                saveLinkNext = page.linkNext;
                NSLog(@"\n\n\nXin thông báo 1 cháu hết!");
            }
            else{
                NSString *linkNextPhotos = [temp2 objectForKey:@"next"];
                NSArray *tempArray = [linkNextPhotos componentsSeparatedByString: @"after="];
                page.linkNext = [tempArray objectAtIndex:1];
                NSLog(@"Tempname = %@",page.nameFanpage);
                [self addNextImage:page.nameFanpage withLink:page.linkNext];
                saveLinkNext = page.linkNext;
                NSLog(@"Temp Link next = %@",page.linkNext);
            }
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

-(void) load25PictureNext{
    if (isFirstLoad == YES) {
        [self loadDataFirst];
        return;
    }
    long a;
    int b;
    Fanpage *temp;
    NSString *from;
    do {
        a = [listFanpage count];
        b = arc4random_uniform((int)a);
        NSLog(@"a = %ld, b = %d",a,b);
        
        temp = [listFanpage objectAtIndex:b];
    } while ([temp.linkNext length] == 2);
    
    
    NSLog(@"Name fanpage: %@",temp.nameFanpage);
    NSLog(@"Link next fanpage: %@",temp.linkNext);
    NSLog(@"From = %@",from);
    // request photo from fanpage.
    [self getDataFromFanpage:temp:@"25"];
}


-(void) addNextImage:(NSString*) nameFanPage withLink:(NSString*) link{
    for (int i=0; i<[listFanpage count]; i++) {
        Fanpage *temp123 = [listFanpage objectAtIndex:i];
        if ([temp123.nameFanpage isEqualToString:nameFanPage]) {
            NSString *linkNext = [[NSString alloc] initWithString:link];
            dispatch_async(dispatch_get_main_queue(), ^{
                temp123.linkNext = linkNext;
            });

            
            return;
        }
    }
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
        cell.imgAvata.image = [UIImage imageNamed:temp.avataName];
        cell.lbFanpageName.text = temp.fanpage;
        cell.lbTime.text = temp.timePost;
        cell.userInteractionEnabled = YES;
        [cell.btRepost addTarget:self action:@selector(btRepostTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
    else if (indexPath.row == 1){
        CaptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CaptionCell"];
        cell.lbCaption.text = temp.caption;
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
        if (indexPath.section == ([listImage count] - 20)) {
            [self load25PictureNext];
        }
//        if (indexPath.section > ([listImage count] - 8)) {
//            [self getDataFromFacebook];
//        }
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
    [_tableView reloadData];
    
}

-(void)pinImage{
    for (int i=0; i<[listFanpage count]; i++) {
        Fanpage *fanpage = [listFanpage objectAtIndex:i];
        [[NSUserDefaults standardUserDefaults] setObject:fanpage.linkNext forKey:fanpage.nameFanpage];
    }
    [self showAlertViewWithMessage:@"Image section has been marked"];
}

-(void)refressButtonTouchUpInside{
    isReload = YES;
    [self refressData];
    for (int i=0; i<[listFanpage count]; i++) {
        Fanpage *fanpage = [listFanpage objectAtIndex:i];
        [[NSUserDefaults standardUserDefaults] setObject:fanpage.nameFanpage forKey:@"0"];
    }
    [self showAlertViewWithMessage:@"Image section has been unmarked"];
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
        [self.tableView reloadData];
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
        [self.tableView reloadData];
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
    
    UIView *view = [[UIView alloc]initWithFrame:self.view.frame];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.6f;
    [self.view bringSubviewToFront:view];
    [self.view addSubview:view];
    [MBProgressHUD showHUDAddedTo:view animated:YES];
    NSData *imageData = [NSData dataWithContentsOfURL:[listURLImage objectAtIndex:sender.tag]];
    UIImage *imageThumbnail = [self imageThumbnail:imageData];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:imageData];
    DataImage *tempImage = [listImage objectAtIndex:sender.tag];
    NSString *nameImage = tempImage.idImage;

    for (int i=0; i< [listImageDownload count]; i++) {
        if ([[listImageDownload objectAtIndex:i] isEqualToString:nameImage]) {
            [self showAlertViewWithMessage:@"Photo is existing!"];
            [MBProgressHUD hideHUDForView:view animated:YES];
            [view removeFromSuperview];
            
            return;
        }
    }
    [listImageDownload addObject:nameImage];
    [fileManager writeImage:imageThumbnail toFile:[nameImage stringByAppendingString:@".png"]];
    [fileManager writeImage:[UIImage imageWithData:imageData] toFile:[nameImage stringByAppendingString:@"full.png"]];
    [[NSUserDefaults standardUserDefaults] setObject:listImageDownload forKey:@"listImage"];
    [self showAlertViewWithMessage:@"Save successfully!"];
    [MBProgressHUD hideHUDForView:view animated:YES];
    [view removeFromSuperview];
    //[proget removeFromSuperview];
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

//
//  CommentViewControler.m
//  ChuyenMotTrang
//
//  Created by Le Phuc on 3/2/16.
//  Copyright © 2016 Lê Đình Phúc. All rights reserved.
//

#import "CommentViewControler.h"
#import "CommentData.h"
#import "CommentTypeCell.h"
#import "CommentCell.h"
#import "MBProgressHUD.h"

@interface CommentViewControler ()

@end
@implementation CommentViewControler
{
    NSString *nextComment;
    NSMutableArray *listComment;
    UISwipeGestureRecognizer *swipeDown;
    BOOL isEnd;
    NSString *textCommnent;
    UITextView *commentTextView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    nextComment = @"";
    textCommnent = @"";
    listComment = [[NSMutableArray alloc] init];
    isEnd = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //Register Nib Cell.
    [self.tableView registerNib:[UINib nibWithNibName:@"ImageCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    [self.tableView registerNib:[UINib nibWithNibName:@"InfomationCell" bundle:nil] forCellReuseIdentifier:@"InfomationCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CaptionCell" bundle:nil] forCellReuseIdentifier:@"CaptionCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ImageViewCell" bundle:nil] forCellReuseIdentifier:@"ImageViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ActionCell" bundle:nil] forCellReuseIdentifier:@"ActionCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentTypeCell" bundle:nil] forCellReuseIdentifier:@"CommentTypeCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:@"CommentCell"];
    
    // Action.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.tableView addGestureRecognizer:tap];
    
    
    swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(upToDownSwipeGesture:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.tableView addGestureRecognizer:swipeDown];
    
    
    //Setup table view.
    self.tableView.separatorColor = [UIColor clearColor];
    
    [self getCommentPost];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) getCommentPost{
    
    if (isEnd == YES) {
        return;
    }

    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:[NSString stringWithFormat:@"/%@/comments",self.dataPost.idImage]
                                  parameters:@{
                                               @"pretty":@"0",
                                               @"limit":@"25",
                                               @"after":nextComment,
                                               @"fields":@"from,can_like,like_count,message"
                                               }
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        if (!error) {
            NSArray *commentPost = [result objectForKey:@"data"];
            for (int i=0; i<[commentPost count]; i++) {
                NSDictionary *comment = [commentPost objectAtIndex:i];
                
                CommentData *commentData = [[CommentData alloc] init];
                commentData.idComment = [comment objectForKey:@"id"];
                commentData.canLike = @"1";
                commentData.idAccount = [[comment objectForKey:@"from"]objectForKey:@"id"];
                commentData.name = [[comment objectForKey:@"from"]objectForKey:@"name"];
                commentData.likeCount = (NSString*)[comment objectForKey:@"like_count"];
                commentData.comments = [comment objectForKey:@"message"];
                FBSDKGraphRequest *request2 = [[FBSDKGraphRequest alloc]
                                              initWithGraphPath:[NSString stringWithFormat:@"/%@",commentData.idAccount]
                                              parameters:@{
                                                           @"fields":@"picture.width(100).height(100),name"
                                                           }
                                              HTTPMethod:@"GET"];
                [request2 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                      id result,
                                                      NSError *error) {
                    if (!error) {
                        NSURL *urlImage = [NSURL URLWithString:[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]];
                        commentData.avata = urlImage;
                        [listComment addObject:commentData];
                        [self.tableView reloadData];
                    }
                }];
            }
            nextComment = [[[result objectForKey:@"paging"] objectForKey:@"cursors"] objectForKey:@"after"];
            if ([commentPost count] <25) {
                isEnd = YES;
            }
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < 4) {
        return 1;
    }
    else{
        return [listComment count];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        InfomationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfomationCell"];
        if (self.dataPost.avataName != nil) {
            cell.imgAvata.image = [UIImage imageNamed:self.dataPost.avataName];
        }
        else{
            FBSDKGraphRequest *requestAvata = [[FBSDKGraphRequest alloc]
                                               initWithGraphPath: self.dataPost.userCommneted
                                               parameters:@{
                                                            @"fields":@"picture.width(200).height(200)"
                                                            }
                                               HTTPMethod:@"GET"];
            [requestAvata startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,id result,NSError *error) {
                cell.imgAvata.imageURL = [NSURL URLWithString: [[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]];
            }];
        }
        cell.lbFanpageName.text = self.dataPost.fanpage;
        cell.userInteractionEnabled = NO;
        return cell;
    }
    else if (indexPath.section == 1){
        CaptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CaptionCell"];
        cell.lbCaption.text = self.dataPost.caption;
        cell.userInteractionEnabled = NO;
        return cell;
    }
    else if (indexPath.section == 2){
        ImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageViewCell"];
        cell.imgImageView.imageURL = self.imageURL;
        [cell.loadImage setHidden:YES];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section == 3){
        NSLog(@"IndexPath: %@",indexPath);
        CommentTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentTypeCell"];
        // Insert data.
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{ @"fields" : @"id,name,picture.width(200).height(200)"}]startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                NSString *nameOfLoginUser = [result valueForKey:@"name"];
                cell.lbAccount.text = nameOfLoginUser;
                NSString *imageStringOfLoginUser = [[[result objectForKey:@"picture"] objectForKey: @"data"] objectForKey:@"url"];
                NSURL *url = [[NSURL alloc] initWithString:imageStringOfLoginUser];
                cell.avataUser.imageURL = url;
            }
        }];
        cell.tfComment.delegate = self;
        cell.tfComment.editable = YES;
        [cell.btPost addTarget:self action:@selector(btPostTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        CommentData *tempCom = [listComment objectAtIndex:indexPath.row];
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
        cell.avataUser.imageURL = tempCom.avata;
        cell.lbAccount.text = tempCom.name;
        cell.lbComment.text = tempCom.comments;
        long numbLike = [tempCom.likeCount integerValue];
        if (numbLike > 1000) {
            numbLike = numbLike/1000;
            cell.likeCount.text = [[NSString stringWithFormat:@"%ld",numbLike] stringByAppendingString:@"K Likes"];
        }
        else{
            cell.likeCount.text = [[NSString stringWithFormat:@"%@",tempCom.likeCount] stringByAppendingString:@" Likes"];
        }
        if ([tempCom.canLike integerValue] == 1) {
            [cell.btLike setImage:[UIImage imageNamed:@"Thumb Up-30@3x.png"] forState:UIControlStateNormal];

        }
        else{
            [cell.btLike setImage:[UIImage imageNamed:@"Thumb Up Filled-30@3x.png"] forState:UIControlStateNormal];
        }
        cell.btLike.tag = indexPath.row;
        [cell.btLike addTarget:self action:@selector(btLikeTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == [listComment count] - 10) {
            [self getCommentPost];
        }
        return cell;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 60;
    }
    else if (indexPath.section == 1){
        if (self.dataPost.caption == nil) {
            return 0;
        }
        else{
            CGFloat height=[self.dataPost.caption sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(500, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height + 20;
        
            return height;
            
        }
    }
    else if (indexPath.section == 2){
        UIImage *imageT = [UIImage imageWithData:self.dataPost.imageThumbnail];
        if (imageT == nil) {
            imageT = [UIImage imageNamed:@"full_placeholder.png"];
        }
        return (imageT.size.height * [[UIScreen mainScreen] bounds].size.width / imageT.size.width);
    }
    else if (indexPath.section == 3){
        return 125;
    }
    else{
        return 146;
    }
}

#pragma mark - Action + keyboard.

-(void)btLikeTouchUpInside:(UIButton*) sender{
    CommentData *tempData = [listComment objectAtIndex: sender.tag];
    int likeNumber = [tempData.likeCount intValue];
    
    
    if ([tempData.canLike integerValue] == 1) {
        likeNumber ++;
        tempData.canLike = @"0";
        tempData.likeCount = [NSString stringWithFormat:@"%d",likeNumber];
    
        [self.tableView reloadData];
    }
    else{
        likeNumber --;
        tempData.likeCount = [NSString stringWithFormat:@"%d",likeNumber];
        tempData.canLike = @"1";
        
        [self.tableView reloadData];
    }
    
}


-(void) btPostTouchUpInside{
    [self dismissKeyboard];
    UIView *proget = [[UIView alloc] initWithFrame:self.view.frame];
    proget.backgroundColor = [UIColor blackColor];
    [proget setAlpha:0.6f];
    [self.view addSubview:proget];
    [MBProgressHUD showHUDAddedTo:proget animated:YES];
    NSLog(@"%@",textCommnent);
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:[NSString stringWithFormat:@"/%@/comments",self.dataPost.idImage]
                                  parameters:@{
                                               @"message": textCommnent,
                                               }
                                  HTTPMethod:@"POST"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [proget removeFromSuperview];
        [self dismissKeyboard];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations!"
                                                        message:@"Comment has been completed!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }];

}


-(void)upToDownSwipeGesture:(UISwipeGestureRecognizer *) sender
{
    //Gesture detect - swipe down , can't be recognized direction
    [self dismissKeyboard];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    textCommnent = textView.text;
    return YES;
}



- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([listComment count] < 2) {
        [UIView animateWithDuration:0.25 animations:^{
            self.view.frame = CGRectMake(0, -150, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
    textView.text = @"";
    commentTextView = textView;
    return YES;
}

-(void)dismissKeyboard{
//    if (touch out of text view)
//    {
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
    //self.tableView.editing = NO;
//    CommentTypeCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
//    cell.tfComment.editable = NO;
//    [cell.tfComment resignFirstResponder];
//    }
//    else
//    {
//        cell.tfComment.editable = YES;
//        [cell.tfComent acceptFirstResponsder];
//    }
    [commentTextView resignFirstResponder];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

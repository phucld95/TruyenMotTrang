//
//  TableViewController.m
//  ChuyenMotTrang
//
//  Created by Lê Đình Phúc on 2/2/16.
//  Copyright © 2016 Lê Đình Phúc. All rights reserved.
//

#import "TableViewController.h"
#import "InfomationCell.h"
#import "CaptionCell.h"
#import "ImageViewCell.h"
#import "ActionCell.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKMessengerShareKit/FBSDKMessengerShareKit.h>
#import <FBAudienceNetwork/FBAudienceNetwork.h>
#import <FBSDKCoreKit/FBSDKGraphRequest.h>
#import "Reachability.h"

@interface TableViewController ()

@end

@implementation TableViewController
{
    NSMutableArray *listImageNomal;
    NSMutableArray *listURLImage;
    NSString *nextPhotos;
    int numberOfRow;
    NSTimer *time;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    listImageNomal = [[NSMutableArray alloc] init];
    listURLImage = [[NSMutableArray alloc] init];
    nextPhotos = [[NSString alloc] init];
    //[self.view addSubview:loadView];
//    time = [NSTimer scheduledTimerWithTimeInterval: 5 target:self selector:@selector(checkingNetwork) userInfo:nil repeats:NO];
    
    
    [self getDataFromFacebook: nextPhotos];
    [self.tableView registerNib:[UINib nibWithNibName:@"ImageCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    [self.tableView registerNib:[UINib nibWithNibName:@"InfomationCell" bundle:nil] forCellReuseIdentifier:@"InfomationCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CaptionCell" bundle:nil] forCellReuseIdentifier:@"CaptionCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ImageViewCell" bundle:nil] forCellReuseIdentifier:@"ImageViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ActionCell" bundle:nil] forCellReuseIdentifier:@"ActionCell"];
    self.tableView.separatorColor = [UIColor clearColor];
    
}

//-(void) checkingNetwork{
//    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable){
//        //connection unavailable
//    }
//    else{
//        //connection available
//        self.lbLoad.text = @"Đợi lấy dữ liệu xíu 😍😍😍!.....";
//        if ([listImage count] > 15) {
//            DataImage *temp = [listImage objectAtIndex:15];
//            if (temp.imageData != nil) {
//                self.viewLoadData.hidden = YES;
//                [time invalidate];
//            }
//        }
//    }
//}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

-(void) getDataFromFacebook:(NSString*) from{
    NSDictionary *params = @{@"access_token":@"999156186812985|F7aEPMfm1WMspyRqYmgmzfeQS2s",
                             @"pretty":@"1",
                             @"limit":@"25",
                             @"after":from};
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/932969840046994/photos"
                                  parameters:params
                                  HTTPMethod:@"GET"];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        NSLog(@"%@",result);
        
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
                    NSString *idImage = [postInfo objectForKey:@"id"];
                    dataImage.caption = @"";
                    if ([postInfo objectForKey:@"name"]) {
                        dataImage.caption = [postInfo objectForKey:@"name"];
                    }

                    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture",idImage]];
                    [listURLImage addObject:url];
                    [listImageNomal addObject:dataImage];
                    NSLog(@"%lu",(unsigned long)[listImageNomal count]);
                }
            }
            [self.tableView reloadData];
            NSString *linkNextPhotos = [[result objectForKey:@"paging"] objectForKey:@"next"];
            NSArray *tempArray = [linkNextPhotos componentsSeparatedByString: @"after="];
            nextPhotos = [tempArray objectAtIndex:1];
        }
        
        else{
            NSLog(@"Error get album: %@",error);
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            //Do EXTREME PROCESSING!!!
            long i;
            for (i = [listImageNomal count] -25; i<[listURLImage count]; i++) {
                DataImage *tempImage = [listImageNomal objectAtIndex:i];
                NSData *imagaData = [NSData dataWithContentsOfURL:(NSURL*)[listURLImage objectAtIndex:i]];
                tempImage.imageData = imagaData;
//                if (i == ([listURLImage count] -15)) {
//                    numberOfRow = [listImage count];
//                }
            }
        });
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if ([listImage count] <=10) {
//        return 0;
//    }
//    DataImage *tempData = [listImage objectAtIndex:[listImage count] -15];
//    if (tempData.imageData != nil) {
//        return [listImage count];
//    }
//    return [listImage count] - 15;
    return [listImageNomal count];
    //return numberOfRow;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 10; // you can have your own choice, of course
//}


//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[UIView alloc] init];
//    headerView.backgroundColor = [UIColor grayColor];
//    return headerView;
//}
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
//        [cell setPreservesSuperviewLayoutMargins:NO];
//    }
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DataImage *temp = [listImageNomal objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        InfomationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfomationCell"];
        cell.imgAvata.image = [UIImage imageNamed:temp.avataName];
        cell.lbFanpageName.text = temp.fanpage;
        cell.userInteractionEnabled = NO;
        return cell;
    }
    else if (indexPath.row == 1){
        CaptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CaptionCell"];
        cell.lbCaption.text = temp.caption;
        cell.userInteractionEnabled = NO;
        return cell;
    }
    else if (indexPath.row == 2){
        DataImage *temp = [listImageNomal objectAtIndex:indexPath.section];
        ImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageViewCell"];
        if (temp.imageData == nil) {
            //UIImageView *tempView = [[UIImageView alloc] init];
            //tempView.imageURL = [listURLImage objectAtIndex:indexPath.section];
            //NSData *imagaData = [NSData dataWithContentsOfURL:(NSURL*)[listURLImage objectAtIndex:indexPath.section]];
            //temp.imageData = imagaData;
            cell.imgImageView.imageURL = [listURLImage objectAtIndex:indexPath.section];
            [cell.loadImage setHidden:YES];
            [self.tableView reloadData];
        }
        else{
            cell.imgImageView.image = [UIImage imageWithData:temp.imageData];
            [cell.loadImage setHidden: YES];
        }
            //cell.imgImageView.imageURL = (NSURL*)[listURLImage objectAtIndex:indexPath.section];

        return cell;
    }
    else{
        ActionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActionCell"];
//        [cell.btLike addTarget:self action:@selector(btLikeAction) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == ([listImageNomal count] - 20)) {
            [self getDataFromFacebook:nextPhotos ];
        }
        return cell;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 60;
    }
    else if (indexPath.row == 1){
        return 63;
    }
    else if (indexPath.row == 2){
        DataImage *temp = [listImageNomal objectAtIndex:indexPath.section];
//        UIImageView *imageT = [[UIImageView alloc] init];
        UIImage *imageT = [UIImage imageWithData:temp.imageData];
        //imageT.imageURL = (NSURL*)[listURLImage objectAtIndex:indexPath.section];
        if (imageT == nil) {
            imageT = [UIImage imageNamed:@"full_placeholder.png"];
        }
        return (imageT.size.height * [[UIScreen mainScreen] bounds].size.width / imageT.size.width);
    }
    else{
        return 68;
    }
}






#pragma mark - Setup hide and show navigationBar when scroll.

// Setup scrollView in tableView.
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect frame = self.navigationController.navigationBar.frame;
    CGFloat size = frame.size.height - 21;
    CGFloat framePercentageHidden = ((20 - frame.origin.y) / (frame.size.height - 1));
    CGFloat scrollOffset = scrollView.contentOffset.y;
    CGFloat scrollDiff = scrollOffset - self.previousScrollViewYOffset;
    CGFloat scrollHeight = scrollView.frame.size.height;
    CGFloat scrollContentSizeHeight = scrollView.contentSize.height + scrollView.contentInset.bottom;
    
    if (scrollOffset <= -scrollView.contentInset.top) {
        frame.origin.y = 20;
    } else if ((scrollOffset + scrollHeight) >= scrollContentSizeHeight) {
        frame.origin.y = -size;
    } else {
        frame.origin.y = MIN(20, MAX(-size, frame.origin.y - scrollDiff));
    }
    
    [self.navigationController.navigationBar setFrame:frame];
    [self updateBarButtonItems:(1 - framePercentageHidden)];
    self.previousScrollViewYOffset = scrollOffset;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self stoppedScrolling];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self stoppedScrolling];
    }
}

- (void)stoppedScrolling
{
    CGRect frame = self.navigationController.navigationBar.frame;
    if (frame.origin.y < 20) {
        [self animateNavBarTo:-(frame.size.height - 21)];
    }
}

- (void)updateBarButtonItems:(CGFloat)alpha
{
    [self.navigationItem.leftBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem* item, NSUInteger i, BOOL *stop) {
        item.customView.alpha = alpha;
    }];
    [self.navigationItem.rightBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem* item, NSUInteger i, BOOL *stop) {
        item.customView.alpha = alpha;
    }];
    self.navigationItem.titleView.alpha = alpha;
    self.navigationController.navigationBar.tintColor = [self.navigationController.navigationBar.tintColor colorWithAlphaComponent:alpha];
}

- (void)animateNavBarTo:(CGFloat)y
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.navigationController.navigationBar.frame;
        CGFloat alpha = (frame.origin.y >= y ? 0 : 1);
        frame.origin.y = y;
        [self.navigationController.navigationBar setFrame:frame];
        [self updateBarButtonItems:alpha];
    }];
}
- (void)btLikeAction{
    NSLog(@"clicked bt Like");
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

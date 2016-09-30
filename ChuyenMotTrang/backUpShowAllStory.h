//
//  backUpShowAllStory.h
//  ChuyenMotTrang
//
//  Created by Lê Đình Phúc on 2/15/16.
//  Copyright © 2016 Lê Đình Phúc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol backUpShowAllStory <NSObject>

//
//[listImage removeAllObjects];
//[listURLImage removeAllObjects];
//[listURLThmbnail removeAllObjects];
//
//[self.tableView reloadData];
//for (int i=0; i<[listFanpage count]; i++) {
//    Fanpage *temp = [listFanpage objectAtIndex:i];
//    temp.linkNext = @"";
//    NSDictionary *params = @{@"access_token":@"999156186812985|F7aEPMfm1WMspyRqYmgmzfeQS2s",
//                             @"pretty":@"1",
//                             @"limit":@"1",
//                             @"after":temp.linkNext};
//    
//    
//    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
//                                  initWithGraphPath: [NSString stringWithFormat:@"/%@/photos",temp.idFanpage]
//                                  parameters:params
//                                  HTTPMethod:@"GET"];
//    
//    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
//                                          id result,
//                                          NSError *error) {
//        if (!error && result){
//            temp.lastUpdate = [[[result objectForKey:@"paging"]
//                                objectForKey:@"cursors"]
//                               objectForKey:@"before"];
//        }
//    }];
//    [self getDataFromFanpage:temp :@"5" ];
//}
//isReload = NO;


// Load image manua;
//        if (temp.imageData == nil) {
//            if (temp.imageThumbnail != nil){
//                cell.imgImageView.image = [UIImage imageWithData:temp.imageThumbnail];
//                [cell.loadImage setHidden:YES];
//            }
//            else{
//                cell.imgImageView.image = [UIImage imageNamed:@"full_placeholder.png"];
//                [cell.loadImage setHidden:NO];
//            }
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//                NSData *imagaDataFromURL = [NSData dataWithContentsOfURL:(NSURL*)[listURLImage objectAtIndex:indexPath.section]];
//                temp.imageData = imagaDataFromURL;
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    cell.imgImageView.image = [UIImage imageWithData:imagaDataFromURL];
//                    [cell.loadImage setHidden:YES];
//                    [self.tableView reloadData];
//                });
//            });
//        }
//        else{
//            cell.imgImageView.image = [UIImage imageWithData:temp.imageData];
//            [cell.loadImage setHidden: YES];
//        }

// Thread load image.
//            for (i = [listImage count] -25; i<[listURLImage count]; i++) {
//                DataImage *tempImage = [listImage objectAtIndex:i];
//                if (tempImage.imageData == nil) {
//                    NSData *imagaData = [NSData dataWithContentsOfURL:(NSURL*)[listURLThmbnail objectAtIndex:i]];
//                    tempImage.imageData = imagaData;
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self.tableView reloadData];
//                    });
//                }
//            }


// Get image - image add tag.
//-(void) getDataFromFacebook:(NSString*) from{
//
//
//    // request photo from Tho bay mau.
//    NSDictionary *params = @{@"access_token":@"999156186812985|F7aEPMfm1WMspyRqYmgmzfeQS2s",
//                             @"pretty":@"1",
//                             @"limit":@"25",
//                             @"after":from};
//    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
//                                  initWithGraphPath:@"/932969840046994/photos"
//                                  parameters:params
//                                  HTTPMethod:@"GET"];
//
//    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
//                                          id result,
//                                          NSError *error) {
//        NSLog(@"%@",result);
//
//        if (!error && result)
//        {
//            NSArray *postsData = [result objectForKey:@"data"];
//
//            if ([postsData count] > 0)
//            {
//                NSDictionary *params2 = @{@"access_token":@"999156186812985|F7aEPMfm1WMspyRqYmgmzfeQS2s",
//                                         };
//                int i;
//                for (i=0; i < [postsData count]; i++){
//                    NSDictionary *postInfo = [postsData objectAtIndex:i];
//                    NSString *idImage = [postInfo objectForKey:@"id"];
//
//                    // Get tag of image. If tag == Le Phuc. This image has break.≥
//                    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
//                                                  initWithGraphPath: [NSString stringWithFormat:@"/%@/tags",idImage]
//                                                  parameters:params2
//                                                  HTTPMethod:@"GET"];
//                    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
//                                                          id result,
//                                                          NSError *error) {
//                        if (!error && result) {
//                            NSArray *tagData = [result objectForKey:@"data"];
//                            BOOL isBreak = NO;
//                            if ([tagData count] > 0) {
//                                for (NSDictionary *tags in tagData) {
//                                    NSString *name = [tags objectForKey:@"name"];
//                                    // Check tag for break image.
//                                    if ([name isEqualToString:@"Lê Phúc"] ) {
//                                        isBreak = YES;
//                                        break;
//                                    }
//                                }
//                                if (isBreak == NO) {
//                                    DataImage *dataImage = [[DataImage alloc] init];
//                                    dataImage.avataName = @"avata.png";
//                                    dataImage.fanpage = @"Truyện một trang";
//                                    dataImage.caption = @"";
//                                    if ([postInfo objectForKey:@"name"]) {
//                                        dataImage.caption = [postInfo objectForKey:@"name"];
//                                    }
//
//                                    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture",idImage]];
//                                    NSURL *urlThumbnail = [NSURL URLWithString: [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=thumbnail",idImage]];
//                                    [listURLImage addObject:url];
//                                    [listURLThmbnail addObject: urlThumbnail];
//                                    [listImage addObject:dataImage];
//                                    NSLog(@"%lu",(unsigned long)[listImage count]);
//                                }
//                                if (i == ([postsData count]-1)) {
//                                    // Create background thread and load image with size thumbnail.
//                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//                                        //Do EXTREME PROCESSING!!!
//                                        long i;
//                                        for (i = [listImage count] -25; i<[listURLThmbnail count]; i++) {
//
//                                            DataImage *tempImage = [listImage objectAtIndex:i];
//                                            if (tempImage.imageThumbnail == nil) {
//                                                NSData *imagaData = [NSData dataWithContentsOfURL:(NSURL*)[listURLThmbnail objectAtIndex:i]];
//                                                tempImage.imageThumbnail = imagaData;
//                                            }
//
//                                        }
//                                        //Update table view when load thumbnail image completed.
//
//                                        dispatch_async(dispatch_get_main_queue(), ^{
//                                            [self.tableView reloadData];
//                                        });
//                                        for (i = [listImage count] -25; i<[listURLImage count]; i++) {
//                                            DataImage *tempImage = [listImage objectAtIndex:i];
//                                            if (tempImage.imageData == nil) {
//                                                NSData *imagaData = [NSData dataWithContentsOfURL:(NSURL*)[listURLThmbnail objectAtIndex:i]];
//                                                tempImage.imageData = imagaData;
//                                                dispatch_async(dispatch_get_main_queue(), ^{
//                                                    [self.tableView reloadData];
//                                                });
//                                            }
//                                        }
//                                    });
//                                }
//                            }
//                        }
//                    }];
//                }
//            }
//            // Get id next photo (the first photo in 25 next photo).
//            NSString *linkNextPhotos = [[result objectForKey:@"paging"] objectForKey:@"next"];
//            NSArray *tempArray = [linkNextPhotos componentsSeparatedByString: @"after="];
//            nextPhotos = [tempArray objectAtIndex:1];
//        }
//
//        else{
//            NSLog(@"Error get album: %@",error);
//        }
//    }];
//}


@end

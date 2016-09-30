//
//  DataImage.h
//  ChuyenMotTrang
//
//  Created by Lê Đình Phúc on 2/2/16.
//  Copyright © 2016 Lê Đình Phúc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataImage : NSObject

@property (nonatomic, strong) NSString *avataName;
@property (nonatomic, strong) NSString *avataUrl;
@property (nonatomic, strong) NSString *timePost;
@property (nonatomic, strong) NSString *fanpage;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSString *idImage;
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, strong) NSData *imageThumbnail;



@property (nonatomic, strong) NSString *likeNumber;
@property (nonatomic, strong) NSString *commentNumber;
@property (nonatomic, strong) NSString *userLiked;
@property (nonatomic, strong) NSString *userCommneted;

@end

//
//  FileManager.h
//  ContactWithCode
//
//  Created by Lê Đình Phúc on 1/22/16.
//  Copyright © 2016 Lê Đình Phúc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface FileManager : NSObject

- (void)listAllLocalFiles;
- (BOOL)createFileWithName:(NSString *)fileName;
- (BOOL)deleteFileWithName:(NSString *)fileName;
- (BOOL)renameFileWithName:(NSString *)srcName toName:(NSString *)dstName;
- (BOOL)writeString:(NSString *)content toFile:(NSString *)fileName;
- (BOOL)writeImage:(UIImage *)content toFile:(NSString *)fileName;
- (UIImage *)readImage:(NSString*) fileName;
- (NSString*)readString:(NSString *)fileName;

@end

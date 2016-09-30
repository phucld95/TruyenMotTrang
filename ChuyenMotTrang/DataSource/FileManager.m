//
//  FileManager.m
//  ContactWithCode
//
//  Created by Lê Đình Phúc on 1/22/16.
//  Copyright © 2016 Lê Đình Phúc. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager


- (void)listAllLocalFiles{
    // Fetch directory path of document for local application.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    // NSFileManager is the manager organize all the files on device.
    NSFileManager *manager = [NSFileManager defaultManager];
    // This function will return all of the files' Name as an array of NSString.
    NSArray *files = [manager contentsOfDirectoryAtPath:documentsDirectory error:nil];
    // Log the Path of document directory.
    NSLog(@"Directory: %@", documentsDirectory);
    // For each file, log the name of it.
    for (NSString *file in files) {
        NSLog(@"File at: %@", file);
    }
}

- (BOOL)createFileWithName:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    // 1st, This funcion could allow you to create a file with initial contents.
    // 2nd, You could specify the attributes of values for the owner, group, and permissions.
    // Here we use nil, which means we use default values for these attibutes.
    // 3rd, it will return YES if NSFileManager create it successfully or it exists already.
    if ([manager createFileAtPath:filePath contents:nil attributes:nil]) {
        NSLog(@"Created the File Successfully.");
        return YES;
    } else {
        NSLog(@"Failed to Create the File");
        return NO;
    }
}


- (BOOL)deleteFileWithName:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    // Have the absolute path of file named fileName by joining the document path with fileName, separated by path separator.
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    // Need to check if the to be deleted file exists.
    if ([manager fileExistsAtPath:filePath]) {
        NSError *error = nil;
        // This function also returnsYES if the item was removed successfully or if path was nil.
        // Returns NO if an error occurred.
        [manager removeItemAtPath:filePath error:&error];
        if (error) {
            NSLog(@"There is an Error: %@", error);
            return NO;
        }
        return YES;
    } else {
        NSLog(@"File %@ doesn't exists", fileName);
        return YES;
    }
}

- (BOOL)renameFileWithName:(NSString *)srcName toName:(NSString *)dstName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePathSrc = [documentsDirectory stringByAppendingPathComponent:srcName];
    NSString *filePathDst = [documentsDirectory stringByAppendingPathComponent:dstName];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePathSrc]) {
        NSError *error = nil;
        [manager moveItemAtPath:filePathSrc toPath:filePathDst error:&error];
        if (error) {
            NSLog(@"There is an Error: %@", error);
            return NO;
        }
        return YES;
    } else {
        NSLog(@"File %@ doesn't exists", srcName);
        return NO;
    }
}


/* This function read content from the file named fileName.
 */
- (NSString*)readString:(NSString *)fileName
{
    // Fetch directory path of document for local application.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    // Have the absolute path of file named fileName by joining the document path with fileName, separated by path separator.
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    // NSFileManager is the manager organize all the files on device.
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        // Start to Read.
        NSError *error = nil;
        NSString *content = [[NSString alloc]init];
        content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
        NSLog(@"File Content: %@", content);
        if (error) {
            NSLog(@"There is an Error: %@", error);
            return nil;
        }
        return content;
    } else {
        NSLog(@"File %@ doesn't exists", fileName);
        return nil;
    }
}

/* This function Write "content" to the file named fileName.
 */
- (BOOL)writeString:(NSString *)content toFile:(NSString *)fileName
{
    // Fetch directory path of document for local application.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    // Have the absolute path of file named fileName by joining the document path with fileName, separated by path separator.
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    // NSFileManager is the manager organize all the files on device.
    NSFileManager *manager = [NSFileManager defaultManager];
    // Check if the file named fileName exists.
    if ([manager fileExistsAtPath:filePath]) {
        NSError *error = nil;
        // Since [writeToFile: atomically: encoding: error:] will overwrite all the existing contents in the file, you could keep the content temperatorily, then append content to it, and assign it back to content.
        // To use it, simply uncomment it.
        //        NSString *tmp = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:NSStringEncodingConversionAllowLossy error:nil];
        //        if (tmp) {
        //            content = [tmp stringByAppendingString:content];
        //        }
        // Write NSString content to the file.
        [content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        // If error happens, log it.
        if (error) {
            NSLog(@"There is an Error: %@", error);
            return NO;
        }
        return YES;
    } else {
        // If the file doesn't exists, log it.
        NSLog(@"File %@ doesn't exists", fileName);
        return NO;
    }
    
    // This function could also be written without NSFileManager checking on the existence of file,
    // since the system will atomatically create it for you if it doesn't exist.
}

- (BOOL)writeImage:(UIImage *)content toFile:(NSString *)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    // Have the absolute path of file named fileName by joining the document path with fileName, separated by path separator.
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    // Convert and save image in document file (save such as file not .png).
    NSData *imageData = UIImagePNGRepresentation(content);
    [imageData writeToFile:filePath atomically:YES];
    return YES;
}


- (UIImage *)readImage:(NSString*) fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    // Have the absolute path of file named fileName by joining the document path with fileName, separated by path separator.
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    // read image from data file.
    NSData *pngData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [UIImage imageWithData:pngData];
    return image;
}








@end

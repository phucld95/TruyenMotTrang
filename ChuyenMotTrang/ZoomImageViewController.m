//
//  ViewController.m
//  image
//
//  Created by Admin on 2/17/16.
//  Copyright © 2016 BeetSoft. All rights reserved.
//

#import "ZoomImageViewController.h"
#import "AppDelegate.h"

@interface ZoomImageViewController ()

@property (strong, nonatomic) UIScrollView *scrollImage;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation ZoomImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollImage.delegate = self;
    // Do any additional setup after loading the view, typically from a nib.

    self.navigationController.navigationItem.backBarButtonItem.title = @"More Story";
    [self.navigationController.navigationItem.backBarButtonItem setTintColor:[UIColor clearColor]];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!_scrollImage) {
        _scrollImage = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 40)];
        _scrollImage.delegate = self;
        [self.view addSubview:_scrollImage];
        UIImage *image = [UIImage imageWithData:self.data];
        _imageView = [[UIImageView alloc] initWithImage:image];
        //    _imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        _imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        [_scrollImage addSubview:_imageView];
        _imageView.frame = CGRectMake(0, (_scrollImage.frame.size.height - _imageView.frame.size.height)/2, _imageView.frame.size.width, _imageView.frame.size.height);
        _scrollImage.contentSize = image.size;
        
        UITapGestureRecognizer *towFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomingImageView:)];
        towFingerTap.numberOfTapsRequired = 1;
        towFingerTap.numberOfTouchesRequired = 2;
        
        [_scrollImage addGestureRecognizer:towFingerTap];
        CGRect scrollViewFrame = self.scrollImage.frame;
        CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollImage.contentSize.width;
        CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollImage.contentSize.height;
        CGFloat minScale = MIN(scaleWidth, scaleHeight);
        
        self.scrollImage.minimumZoomScale = minScale;
        self.scrollImage.maximumZoomScale = 1.0f;
        self.scrollImage.zoomScale = minScale;
        
        [self centerScrollViewContents];
    }
    
}
- (void)centerringImage {
    CGSize boundsSize = self.scrollImage.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    _scrollImage.contentSize = _scrollImage.frame.size;
    
    // center of image to center of scrollview.
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.imageView.frame = contentsFrame;
}

- (void)centerScrollViewContents {
    CGSize boundsSize = self.scrollImage.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    // center of image to center of scrollview.
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.imageView.frame = contentsFrame;
}


- (void)zoomingImageView:(UITapGestureRecognizer *)recognizer{
    
    CGFloat newZoomScale = self.scrollImage.zoomScale / 1.5f;
    newZoomScale = newZoomScale;
    [self.scrollImage setZoomScale:newZoomScale];
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so we need to re-center the contents
    [self centerScrollViewContents];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Return the view that we want to zoom
    return self.imageView;
}
@end

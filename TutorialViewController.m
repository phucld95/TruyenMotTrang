//
//  TutorialViewController.m
//  ChuyenMotTrang
//
//  Created by Le Phuc on 3/14/16.
//  Copyright © 2016 Lê Đình Phúc. All rights reserved.
//

#import "TutorialViewController.h"
#import "TabBarController.h"

@interface TutorialViewController ()<UIScrollViewDelegate>{
    NSArray *arrImage;
}
@property (weak, nonatomic) IBOutlet UIScrollView *tutorialScroll;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *btStart;

@end

@implementation TutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.btStart addTarget:self action:@selector(startApp) forControlEvents:UIControlEventTouchUpInside];
    _btStart.layer.cornerRadius = 10;
    _btStart.layer.masksToBounds = YES;
    
    arrImage = @[@"ShowAllStory.jpg",@"ShowAllStory2.jpg",@"Comment.jpg",@"Comment2.jpg",@"Download.jpg",@"Post.jpg"];
    CGRect frame = CGRectMake(0, 0, 0, 0);
    self.tutorialScroll.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.tutorialScroll.delegate = self;
    self.tutorialScroll.showsHorizontalScrollIndicator = NO;
//    self.tutorialScroll.showsVerticalScrollIndicator = NO;
    for (int i = 0; i < arrImage.count; i++)
    {
        frame.origin.x = self.view.frame.size.width* i +20;
        frame.origin.y = 0;
        frame.size = self.tutorialScroll.frame.size;
        self.tutorialScroll.pagingEnabled = YES;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
        imageView.image = [UIImage imageNamed:arrImage[i]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.tutorialScroll.clipsToBounds = YES;
        [self.tutorialScroll addSubview:imageView];
    }
    
    self.tutorialScroll.contentSize =  CGSizeMake(self.tutorialScroll.frame.size.width * arrImage.count, 0);
}

-(void)startApp{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TabBarController *tabBar = [storyboard instantiateViewControllerWithIdentifier:@"tabBar"];
    [self.navigationController presentViewController:tabBar animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = self.tutorialScroll.frame.size.width;
    int page = floor((self.tutorialScroll.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.tutorialScroll.frame.size.width;
    int page = floor((self.tutorialScroll.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (page == 5) {
        [UIView animateWithDuration:1.0 animations:^{
            self.btStart.alpha = 1.0;
        }];
    }
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

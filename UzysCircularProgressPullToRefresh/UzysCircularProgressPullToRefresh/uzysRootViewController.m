//
//  uzysRootViewController.m
//  UzysRadialProgressActivityIndicator
//
//  Created by Uzysjung on 13. 10. 22..
//  Copyright (c) 2013년 Uzysjung. All rights reserved.
//

#import "uzysRootViewController.h"
#import "UzysRadialProgressActivityIndicator.h"
#import "UIScrollView+UzysCircularProgressPullToRefresh.h"
@interface uzysRootViewController ()
@property (nonatomic,strong) UzysRadialProgressActivityIndicator *radialIndicator;
@property (nonatomic,strong) UIScrollView *scrollView;
@end

@implementation uzysRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.title = @"UzysCircularProgressPullToRefresh";
    
//    if([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    
    
    //scrollView에 사진 넣고 PulltoRefresh 테스트.
    UIScrollView *scrollView =[[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    scrollView.backgroundColor = [UIColor grayColor];
    scrollView.contentSize = CGSizeMake(320, 1500);
    scrollView.clipsToBounds = YES;

    self.scrollView = scrollView;
    UIView *test = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1500)];
    test.backgroundColor = [UIColor darkGrayColor];
    [scrollView addSubview:test];
    

//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    btn.frame = CGRectMake(100, 100, 50, 50);
//    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
//    btn.backgroundColor = [UIColor redColor];
//    [self.view addSubview:btn];
    
    NSLog(@"scrollView contentInset %@",NSStringFromUIEdgeInsets(self.scrollView.contentInset));

    
}
- (void)btnAction:(id)sender
{
    [self.scrollView triggerPullToRefresh];
}
- (void)actionEndIndicator
{
    [self.scrollView.pullToRefreshView stopIndicatorAnimation];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    __weak typeof(self) weakSelf =self;
    [_scrollView addPullToRefreshActionHandler:^{
        [weakSelf performSelector:@selector(actionEndIndicator) withObject:nil afterDelay:2];
    }];
    NSLog(@"scrollView contentInset %@",NSStringFromUIEdgeInsets(self.scrollView.contentInset));

}
@end

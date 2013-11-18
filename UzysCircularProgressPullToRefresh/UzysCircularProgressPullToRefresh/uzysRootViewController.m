//
//  uzysRootViewController.m
//  UzysRadialProgressActivityIndicator
//
//  Created by Uzysjung on 13. 10. 22..
//  Copyright (c) 2013년 Uzysjung. All rights reserved.
//

#import "uzysRootViewController.h"
#import "UIScrollView+UzysCircularProgressPullToRefresh.h"
@interface uzysRootViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UzysRadialProgressActivityIndicator *radialIndicator;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *pData;
@end
#define CELLIDENTIFIER @"CELL"
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
    [self setupDataSource];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.title = @"UzysCircularProgressPullToRefresh";
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELLIDENTIFIER];
    [self.view addSubview:self.tableView];
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

    //Because of self.automaticallyAdjustsScrollViewInsets you must add code below in viewWillApper
    [_tableView addPullToRefreshActionHandler:^{
        [weakSelf insertRowAtTop];
    }];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //manually triggered pulltorefresh
    [_tableView triggerPullToRefresh];
}

#pragma mark UITableView DataManagement
- (void)setupDataSource {
    self.pData = [NSMutableArray array];
    for(int i=0; i<20; i++)
        [self.pData addObject:[NSDate dateWithTimeIntervalSinceNow:-(i*100)]];
}

- (void)insertRowAtTop {
    __weak typeof(self) weakSelf = self;
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.tableView beginUpdates];
        [weakSelf.pData insertObject:[NSDate date] atIndex:0];
        [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        [weakSelf.tableView endUpdates];

        //Stop PullToRefresh Activity Animation
        [weakSelf.tableView stopRefreshAnimation];
    });
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER];
    
    NSDate *date = [self.pData objectAtIndex:indexPath.row];
    cell.contentView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    cell.textLabel.textColor = [UIColor grayColor];
    cell.textLabel.text = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterMediumStyle];
    return cell;
}


@end

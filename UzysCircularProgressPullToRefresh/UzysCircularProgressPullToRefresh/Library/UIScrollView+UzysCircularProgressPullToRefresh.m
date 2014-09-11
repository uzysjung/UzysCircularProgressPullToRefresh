//
//  UIScrollView+UzysInteractiveIndicator.m
//  UzysRadialProgressActivityIndicator
//
//  Created by Uzysjung on 2013. 11. 12..
//  Copyright (c) 2013년 Uzysjung. All rights reserved.
//

#import "UIScrollView+UzysCircularProgressPullToRefresh.h"
#import <objc/runtime.h>
static char UIScrollViewPullToRefreshView;

@implementation UIScrollView (UzysCircularProgressPullToRefresh)
@dynamic pullToRefreshView, showPullToRefresh;

- (void)addPullToRefreshActionHandler:(actionHandler)handler
{
    if(self.pullToRefreshView == nil)
    {
        UzysRadialProgressActivityIndicator *view = [[UzysRadialProgressActivityIndicator alloc] initWithImage:[UIImage imageNamed:@"centerIcon"]];
        view.pullToRefreshHandler = handler;
        view.scrollView = self;
        view.frame = CGRectMake((self.bounds.size.width - view.bounds.size.width)/2,
                                -view.bounds.size.height, view.bounds.size.width, view.bounds.size.height);
        view.originalTopInset = self.contentInset.top;
        if(self.contentInset.top <64.001 && self.contentInset.top > 63.999)
        {
            view.portraitTopInset = 64.0;
            view.landscapeTopInset = 52.0;
        }
        [self addSubview:view];
        [self sendSubviewToBack:view];
        self.pullToRefreshView = view;
        self.showPullToRefresh = YES;
    }
}
- (void)addPullToRefreshActionHandler:(actionHandler)handler portraitContentInsetTop:(CGFloat)pInsetTop landscapeInsetTop:(CGFloat)lInsetTop
{
    if(self.pullToRefreshView == nil)
    {
        UzysRadialProgressActivityIndicator *view = [[UzysRadialProgressActivityIndicator alloc] initWithImage:[UIImage imageNamed:@"centerIcon"]];
        view.pullToRefreshHandler = handler;
        view.scrollView = self;
        view.frame = CGRectMake((self.bounds.size.width - view.bounds.size.width)/2,
                                -view.bounds.size.height, view.bounds.size.width, view.bounds.size.height);
        view.originalTopInset = self.contentInset.top;
        view.portraitTopInset = pInsetTop;
        view.landscapeTopInset = lInsetTop;
        [self addSubview:view];
        [self sendSubviewToBack:view];
        self.pullToRefreshView = view;
        self.showPullToRefresh = YES;
    }
}

- (void)triggerPullToRefresh
{
    [self.pullToRefreshView manuallyTriggered];
}
- (void)stopRefreshAnimation
{
    [self.pullToRefreshView stopIndicatorAnimation];
}
#pragma mark - property
- (void)setPullToRefreshView:(UzysRadialProgressActivityIndicator *)pullToRefreshView
{
    [self willChangeValueForKey:@"UzysRadialProgressActivityIndicator"];
    objc_setAssociatedObject(self, &UIScrollViewPullToRefreshView, pullToRefreshView, OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"UzysRadialProgressActivityIndicator"];
}
- (UzysRadialProgressActivityIndicator *)pullToRefreshView
{
    return objc_getAssociatedObject(self, &UIScrollViewPullToRefreshView);
}

- (void)setShowPullToRefresh:(BOOL)showPullToRefresh {
    self.pullToRefreshView.hidden = !showPullToRefresh;
    
    if(showPullToRefresh)
    {
        if(!self.pullToRefreshView.isObserving)
        {
//            [self addObserver:self.pullToRefreshView forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.pullToRefreshView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.pullToRefreshView forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.pullToRefreshView forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
            [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];

            self.pullToRefreshView.isObserving = YES;
        }
    }
    else
    {
        if(self.pullToRefreshView.isObserving)
        {
//            [self removeObserver:self.pullToRefreshView forKeyPath:@"contentInset"];
            [self removeObserver:self.pullToRefreshView forKeyPath:@"contentOffset"];
            [self removeObserver:self.pullToRefreshView forKeyPath:@"contentSize"];
            [self removeObserver:self.pullToRefreshView forKeyPath:@"frame"];
            [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];

            self.pullToRefreshView.isObserving = NO;
        }
    }
}

- (BOOL)showPullToRefresh
{
    return !self.pullToRefreshView.hidden;
}

- (void) orientationChanged:(NSNotification *)note
{
    UIDevice * device = note.object;
    dispatch_async(dispatch_get_main_queue(), ^{
        if(UIDeviceOrientationIsLandscape(device.orientation))
        {
            if(self.pullToRefreshView.landscapeTopInset> 0.0)
                self.pullToRefreshView.originalTopInset = self.pullToRefreshView.landscapeTopInset;
        }
        else
        {
            if(self.pullToRefreshView.portraitTopInset> 0.0)
                self.pullToRefreshView.originalTopInset = self.pullToRefreshView.portraitTopInset;
        }
        [self.pullToRefreshView setSize:self.pullToRefreshView.frame.size];
     });
}

@end

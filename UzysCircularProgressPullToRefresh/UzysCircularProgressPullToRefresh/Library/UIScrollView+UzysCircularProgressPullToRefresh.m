//
//  UIScrollView+UzysInteractiveIndicator.m
//  UzysRadialProgressActivityIndicator
//
//  Created by Uzysjung on 2013. 11. 12..
//  Copyright (c) 2013년 Uzysjung. All rights reserved.
//

#import "UIScrollView+UZYSCircularProgressPullToRefresh.h"
#import <objc/runtime.h>


@implementation UIScrollView (UZYSInteractiveIndicator)

- (UZYSCircularProgressActivityIndicator *)pullToRefreshView
{
    UZYSCircularProgressActivityIndicator *pullToRefreshView = objc_getAssociatedObject(self, @selector(pullToRefreshView));
	
	if(!pullToRefreshView)
	{
		pullToRefreshView = [[UZYSCircularProgressActivityIndicator alloc] initWithScrollView:self];
		self.pullToRefreshView = pullToRefreshView;
	}
	
	return pullToRefreshView;
}

- (void)setPullToRefreshView:(UZYSCircularProgressActivityIndicator *)pullToRefreshView
{
    objc_setAssociatedObject(self, @selector(pullToRefreshView), pullToRefreshView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)showsPullToRefreshView
{
	return [objc_getAssociatedObject(self, @selector(showsPullToRefreshView)) boolValue];
}

- (void)setShowsPullToRefreshView:(BOOL)showsPullToRefreshView
{
	objc_setAssociatedObject(self, @selector(showsPullToRefreshView), @(showsPullToRefreshView), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)addPullToRefreshActionHandler:(UZYSCircularProgressPullToRefreshActionHandler)handler
{
    if(!self.showsPullToRefreshView)
    {
        self.pullToRefreshView.pullToRefreshHandler = handler;
		
        [self addSubview:self.pullToRefreshView];
        [self sendSubviewToBack:self.pullToRefreshView];
        
        self.showsPullToRefreshView = YES;
    }
}

- (void)removePullToRefreshView
{
	if(self.showsPullToRefreshView)
	{
		[self.pullToRefreshView removeFromSuperview];
		self.pullToRefreshView = nil;
		
		self.showsPullToRefreshView = NO;
	}
}

- (void)triggerPullToRefresh
{
    [self.pullToRefreshView manuallyTriggered];
}

- (void)stopPullToRefreshAnimation
{
    [self.pullToRefreshView stopIndicatorAnimation];
}

@end

//
//  UIScrollView+UzysInteractiveIndicator.h
//  UzysRadialProgressActivityIndicator
//
//  Created by Uzysjung on 2013. 11. 12..
//  Copyright (c) 2013년 Uzysjung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UZYSCircularProgressActivityIndicator.h"

@interface UIScrollView (UZYSInteractiveIndicator)

@property (assign, nonatomic) BOOL showsPullToRefreshView;
@property (strong, nonatomic) UZYSCircularProgressActivityIndicator *pullToRefreshView;

- (void)addPullToRefreshActionHandler:(UZYSCircularProgressPullToRefreshActionHandler)handler;
- (void)removePullToRefreshView;
- (void)triggerPullToRefresh;
- (void)stopPullToRefreshAnimation;

@end

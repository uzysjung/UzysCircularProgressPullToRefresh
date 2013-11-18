//
//  UIScrollView+UzysInteractiveIndicator.h
//  UzysRadialProgressActivityIndicator
//
//  Created by Uzysjung on 2013. 11. 12..
//  Copyright (c) 2013년 Uzysjung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UzysRadialProgressActivityIndicator.h"

@interface UIScrollView (UzysInteractiveIndicator)
@property (nonatomic,assign) BOOL showPullToRefresh;
@property (nonatomic,strong,readonly) UzysRadialProgressActivityIndicator *pullToRefreshView;

- (void)addPullToRefreshActionHandler:(actionHandler)handler;
- (void)triggerPullToRefresh;
- (void)stopRefreshAnimation;
@end

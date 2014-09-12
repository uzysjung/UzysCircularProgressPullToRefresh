//
//  UIScrollView+UzysInteractiveIndicator.h
//  UzysRadialProgressActivityIndicator
//
//  Created by Uzysjung on 2013. 11. 12..
//  Copyright (c) 2013년 Uzysjung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UzysRadialProgressActivityIndicator.h"

@interface UIScrollView (UzysCircularProgressPullToRefresh)
@property (nonatomic,assign) BOOL showPullToRefresh;
@property (nonatomic,strong,readonly) UzysRadialProgressActivityIndicator *pullToRefreshView;

- (void)addPullToRefreshActionHandler:(actionHandler)handler;
- (void)addPullToRefreshActionHandler:(actionHandler)handler portraitContentInsetTop:(CGFloat)pInsetTop landscapeInsetTop:(CGFloat)lInsetTop;

//For Orientation Changed
- (void)addTopInsetInPortrait:(CGFloat)pInset TopInsetInLandscape:(CGFloat)lInset; // Should have called after addPullToRefreshActionHandler

- (void)triggerPullToRefresh;
- (void)stopRefreshAnimation;
@end

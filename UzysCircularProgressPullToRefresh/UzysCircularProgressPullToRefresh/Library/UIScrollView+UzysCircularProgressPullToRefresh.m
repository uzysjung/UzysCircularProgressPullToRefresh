//
//  UIScrollView+UzysInteractiveIndicator.m
//  UzysRadialProgressActivityIndicator
//
//  Created by Uzysjung on 2013. 11. 12..
//  Copyright (c) 2013년 Uzysjung. All rights reserved.
//

#import "UIScrollView+UzysCircularProgressPullToRefresh.h"
#import <objc/runtime.h>
#define IS_IOS7 (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1 && floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1)
#define IS_IOS8  ([[[UIDevice currentDevice] systemVersion] compare:@"8" options:NSNumericSearch] != NSOrderedAscending)
#define IS_IPHONE6PLUS ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && [[UIScreen mainScreen] nativeScale] == 3.0f)

#define cDefaultFloatComparisonEpsilon    0.001
#define cEqualFloats(f1, f2, epsilon)    ( fabs( (f1) - (f2) ) < epsilon )
#define cNotEqualFloats(f1, f2, epsilon)    ( !cEqualFloats(f1, f2, epsilon) )

static char UIScrollViewPullToRefreshView;

@implementation UIScrollView (UzysCircularProgressPullToRefresh)
@dynamic uzysPullToRefreshView, showUzysPullToRefresh;

- (void)addUzysPullToRefreshActionHandler:(actionHandler)handler
{
    if(self.uzysPullToRefreshView == nil)
    {
        [self addUzysPullToRefreshActionHandler:handler portraitContentInsetTop:CGFLOAT_MAX landscapeInsetTop:CGFLOAT_MAX];
    }
}
- (void)addUzysPullToRefreshActionHandler:(actionHandler)handler portraitContentInsetTop:(CGFloat)pInsetTop landscapeInsetTop:(CGFloat)lInsetTop
{
    if(self.uzysPullToRefreshView == nil)
    {
        UzysRadialProgressActivityIndicator *view = [[UzysRadialProgressActivityIndicator alloc] initWithImage:[UIImage imageNamed:@"centerIcon"]];
        view.pullToRefreshHandler = handler;
        view.scrollView = self;
        view.frame = CGRectMake((self.bounds.size.width - view.bounds.size.width)/2,
                                -view.bounds.size.height, view.bounds.size.width, view.bounds.size.height);
        view.originalTopInset = self.contentInset.top;
        
        if(cEqualFloats(pInsetTop, CGFLOAT_MAX, cDefaultFloatComparisonEpsilon) && cEqualFloats(lInsetTop, CGFLOAT_MAX, cDefaultFloatComparisonEpsilon)) //NOT DEFINE LANDSCAPE , PORTRAIT INSET
        {
            if(IS_IOS7)
            {
                if(cEqualFloats(self.contentInset.top, 64.00, cDefaultFloatComparisonEpsilon) && cEqualFloats(self.frame.origin.y, 0.0, cDefaultFloatComparisonEpsilon))
                {
                    view.portraitTopInset = 64.0;
                    view.landscapeTopInset = 52.0;
                }
            }
            else if(IS_IOS8)
            {
                if(cEqualFloats(self.contentInset.top, 0.00, cDefaultFloatComparisonEpsilon) &&cEqualFloats(self.frame.origin.y, 0.0, cDefaultFloatComparisonEpsilon))
                {
                    view.originalTopInset = view.portraitTopInset = 64.0;
                    
                    if(IS_IPHONE6PLUS)
                        view.landscapeTopInset = 44.0;
                    else
                        view.landscapeTopInset = 32.0;
                    
                }
            }
        }
        else //DEFINE LANDSCAPE PORTRAIT INSET
        {
            view.portraitTopInset = pInsetTop;
            view.landscapeTopInset = lInsetTop;
        }
        
        [self addSubview:view];
        [self sendSubviewToBack:view];
        self.uzysPullToRefreshView = view;
        self.showUzysPullToRefresh = YES;
    }
}

- (void)triggerUzysPullToRefresh
{
    [self.uzysPullToRefreshView manuallyTriggered];
}
- (void)stopUzysRefreshAnimation
{
    [self.uzysPullToRefreshView stopIndicatorAnimation];
}
#pragma mark - property
- (void)addTopInsetInPortrait:(CGFloat)pInset TopInsetInLandscape:(CGFloat)lInset
{
    self.uzysPullToRefreshView.portraitTopInset = pInset;
    self.uzysPullToRefreshView.landscapeTopInset = lInset;
}
- (void)setUzysPullToRefreshView:(UzysRadialProgressActivityIndicator *)pullToRefreshView
{
    [self willChangeValueForKey:@"UzysRadialProgressActivityIndicator"];
    objc_setAssociatedObject(self, &UIScrollViewPullToRefreshView, pullToRefreshView, OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"UzysRadialProgressActivityIndicator"];
}
- (UzysRadialProgressActivityIndicator *)uzysPullToRefreshView
{
    return objc_getAssociatedObject(self, &UIScrollViewPullToRefreshView);
}

- (void)setShowUzysPullToRefresh:(BOOL)showPullToRefresh {
    self.uzysPullToRefreshView.hidden = !showPullToRefresh;
    
    if(showPullToRefresh)
    {
        if(!self.uzysPullToRefreshView.isObserving)
        {
            [self addObserver:self.uzysPullToRefreshView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.uzysPullToRefreshView forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.uzysPullToRefreshView forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
            [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];

            self.uzysPullToRefreshView.isObserving = YES;
        }
    }
    else
    {
        if(self.uzysPullToRefreshView.isObserving)
        {
            [self removeObserver:self.uzysPullToRefreshView forKeyPath:@"contentOffset"];
            [self removeObserver:self.uzysPullToRefreshView forKeyPath:@"contentSize"];
            [self removeObserver:self.uzysPullToRefreshView forKeyPath:@"frame"];
            [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];

            self.uzysPullToRefreshView.isObserving = NO;
        }
    }
}

- (BOOL)showUzysPullToRefresh
{
    return !self.uzysPullToRefreshView.hidden;
}

- (void) orientationChanged:(NSNotification *)note
{
    UIDevice * device = note.object;
    dispatch_async(dispatch_get_main_queue(), ^{
        if(UIDeviceOrientationIsLandscape(device.orientation))
        {
            if(cNotEqualFloats( self.uzysPullToRefreshView.landscapeTopInset , 0.0 , cDefaultFloatComparisonEpsilon))
                self.uzysPullToRefreshView.originalTopInset = self.uzysPullToRefreshView.landscapeTopInset;
        }
        else
        {
            if(cNotEqualFloats( self.uzysPullToRefreshView.portraitTopInset , 0.0 , cDefaultFloatComparisonEpsilon))
                self.uzysPullToRefreshView.originalTopInset = self.uzysPullToRefreshView.portraitTopInset;
        }
        [self.uzysPullToRefreshView setSize:self.uzysPullToRefreshView.frame.size];
     });
}

@end

//
//  uzysRadialProgressActivityIndicator.h
//  UzysRadialProgressActivityIndicator
//
//  Created by Uzysjung on 13. 10. 22..
//  Copyright (c) 2013년 Uzysjung. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^actionHandler)(void);
typedef NS_ENUM(NSUInteger, UZYSPullToRefreshState) {
    UZYSPullToRefreshStateNone =0,
    UZYSPullToRefreshStateStopped,
    UZYSPullToRefreshStateTriggering,
    UZYSPullToRefreshStateTriggered,
    UZYSPullToRefreshStateLoading,
    UZYSPullToRefreshStateCanFinish,
};


@interface UzysRadialProgressActivityIndicator : UIView

@property (nonatomic,assign) BOOL isObserving;

@property (nonatomic,assign) CGFloat originalTopInset;
@property (nonatomic,assign) CGFloat landscapeTopInset;
@property (nonatomic,assign) CGFloat portraitTopInset;

@property (nonatomic,assign) UZYSPullToRefreshState state;
@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic,copy) actionHandler pullToRefreshHandler;

@property (nonatomic,strong) UIImage *imageIcon;
@property (nonatomic,strong) UIColor *borderColor;
@property (nonatomic,assign) CGFloat borderWidth;
@property (nonatomic,assign) CGFloat progressThreshold;

- (void)stopIndicatorAnimation;
- (void)manuallyTriggered;

- (id)initWithImage:(UIImage *)image;
- (void)setSize:(CGSize) size;
@end

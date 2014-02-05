//
//  uzysRadialProgressActivityIndicator.h
//  UzysRadialProgressActivityIndicator
//
//  Created by Uzysjung on 13. 10. 22..
//  Copyright (c) 2013년 Uzysjung. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ UZYSCircularProgressPullToRefreshActionHandler)(void);

typedef NS_ENUM(NSUInteger, UZYSPullToRefreshState)
{
    UZYSPullToRefreshStateNone = 0,
    UZYSPullToRefreshStateStopped,
    UZYSPullToRefreshStateTriggering,
    UZYSPullToRefreshStateTriggered,
    UZYSPullToRefreshStateLoading,
};


@interface UZYSCircularProgressActivityIndicator : UIView

@property (assign, nonatomic) CGFloat currentTopInset;
@property (assign, nonatomic) CGPoint positionOffset;
@property (assign, nonatomic) UZYSPullToRefreshState state;
@property (weak, nonatomic) UIScrollView *scrollView;
@property (copy, nonatomic) UZYSCircularProgressPullToRefreshActionHandler pullToRefreshHandler;

@property (strong, nonatomic) UIImage *imageIcon;
@property (strong, nonatomic) UIColor *borderColor;
@property (assign, nonatomic) CGFloat borderWidth;

- (id)initWithScrollView:(UIScrollView *)scrollView;

- (void)stopIndicatorAnimation;
- (void)manuallyTriggered;

- (void)setSize:(CGSize)size;

@end

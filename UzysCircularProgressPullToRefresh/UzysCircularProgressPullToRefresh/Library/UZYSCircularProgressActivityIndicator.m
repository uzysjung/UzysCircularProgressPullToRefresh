//
//  uzysRadialProgressActivityIndicator.m
//  UzysRadialProgressActivityIndicator
//
//  Created by Uzysjung on 13. 10. 22..
//  Copyright (c) 2013년 Uzysjung. All rights reserved.
//

#import "UZYSCircularProgressActivityIndicator.h"
#import "UIScrollView+UZYSCircularProgressPullToRefresh.h"

#define DEGREES_TO_RADIANS(x) (x) / 180.0 * M_PI
#define RADIANS_TO_DEGREES(x) (x) / M_PI * 180.0
#define PullToRefreshThreshold 80.0


static int KVOUZYSRadialProgressActivityIndicatorObserving;


@interface UZYSRadialProgressActivityIndicatorBackgroundLayer : CALayer

@property (assign, nonatomic) CGFloat outlineWidth;

- (id)initWithBorderWidth:(CGFloat)width;

@end


@implementation UZYSRadialProgressActivityIndicatorBackgroundLayer

- (id)init
{
    self = [self initWithBorderWidth:3.0];
    return self;
}

- (id)initWithBorderWidth:(CGFloat)width
{
    if(self = [super init])
	{
        self.outlineWidth = width;
        self.contentsScale = [UIScreen mainScreen].scale;
    }
	
    return self;
}

- (void)drawInContext:(CGContextRef)ctx
{
    //Draw white circle
    CGContextSetFillColor(ctx, CGColorGetComponents([UIColor colorWithWhite:1.0 alpha:0.8].CGColor));
    CGContextFillEllipseInRect(ctx,CGRectInset(self.bounds, self.outlineWidth, self.outlineWidth));

    //Draw circle outline
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithWhite:0.4 alpha:0.9].CGColor);
    CGContextSetLineWidth(ctx, self.outlineWidth);
    CGContextStrokeEllipseInRect(ctx, CGRectInset(self.bounds, self.outlineWidth , self.outlineWidth ));
}

- (void)setOutlineWidth:(CGFloat)outlineWidth
{
	CGFloat oldOutlineWidth = _outlineWidth;
    _outlineWidth = outlineWidth;
	
	if(oldOutlineWidth != self.outlineWidth)
	{
		[self setNeedsDisplay];
	}
}

@end


@interface UZYSCircularProgressActivityIndicator ()

@property (assign, nonatomic) BOOL updatingScrollViewInsets, updatingScrollViewOffset;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) UZYSRadialProgressActivityIndicatorBackgroundLayer *backgroundLayer;
@property (strong, nonatomic) CAShapeLayer *shapeLayer;
@property (strong, nonatomic) CALayer *imageLayer;
@property (assign, nonatomic) CGFloat progress;

@end

@implementation UZYSCircularProgressActivityIndicator

- (void)initStuff_UZYSRadialProgressActivityIndicator
{
	[self updateCurrentTopInset];
	
	self.contentMode = UIViewContentModeRedraw;
	self.backgroundColor = [UIColor clearColor];
	
	self.alpha = 0.0;
	
    self.borderColor = [UIColor colorWithRed:203.0 / 255.0 green:32.0 / 255.0 blue:39.0 / 255.0 alpha:1.0];
    self.borderWidth = 3.0;
    self.state = UZYSPullToRefreshStateNone;
	
    [self addSubview:self.activityIndicatorView];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    
	[self updateAllLayerFrames];
	
    [self.layer addSublayer:self.backgroundLayer];
    [self.layer addSublayer:self.imageLayer];
    [self.layer addSublayer:self.shapeLayer];
	
	[self addObservers];
}

- (id)initWithScrollView:(UIScrollView *)scrollView
{
	if(self = [super initWithFrame:CGRectMake(0.0, -PullToRefreshThreshold, 30.0, 30.0)])
	{
		self.scrollView = scrollView;
		[self initStuff_UZYSRadialProgressActivityIndicator];
	}
	
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithScrollView:nil];
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
	
	[self updateShapeLayerFrame];
    [self updateShapeLayerPath];
}

- (void)setPositionOffset:(CGPoint)positionOffset
{
	CGPoint oldPositionOffset = _positionOffset;
	_positionOffset = positionOffset;
	
	if(!CGPointEqualToPoint(oldPositionOffset, self.positionOffset))
	{
		[self updateFrame];
	}
}

- (UIActivityIndicatorView *)activityIndicatorView
{
	if(!_activityIndicatorView)
	{
		UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		activityIndicatorView.hidesWhenStopped = YES;
		activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
		
		self.activityIndicatorView = activityIndicatorView;
		
		[self toggleActivityIndicator:NO];
	}
	
	return _activityIndicatorView;
}

- (void)setImageIcon:(UIImage *)imageIcon
{
	UIImage *oldImageIcon = _imageIcon;
	_imageIcon = imageIcon;
	
	if(oldImageIcon != self.imageIcon)
	{
		self.imageLayer.contents = (id)self.imageIcon.CGImage;
		[self setSize:self.imageIcon.size];
	}
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
	CGFloat oldBorderWidth = _borderWidth;
	_borderWidth = borderWidth;
	
	if(oldBorderWidth != self.borderWidth)
	{
		self.backgroundLayer.outlineWidth = self.borderWidth;
		
		self.shapeLayer.lineWidth = self.borderWidth;
		[self updateShapeLayerPath];
		
		[self updateImageLayerFrame];
	}
}

- (void)setBorderColor:(UIColor *)borderColor
{
	UIColor *oldBorderColor = _borderColor;
	_borderColor = borderColor;
	
	if(oldBorderColor != self.borderColor)
	{
		self.shapeLayer.strokeColor = self.borderColor.CGColor;
	}
}

- (UZYSRadialProgressActivityIndicatorBackgroundLayer *)backgroundLayer
{
	if(!_backgroundLayer)
	{
		UZYSRadialProgressActivityIndicatorBackgroundLayer *layer = [[UZYSRadialProgressActivityIndicatorBackgroundLayer alloc] initWithBorderWidth:self.borderWidth];
		
		self.backgroundLayer = layer;
	}
	
	return _backgroundLayer;
}

- (CAShapeLayer *)shapeLayer
{
	if(!_shapeLayer)
	{
		CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
		shapeLayer.fillColor = nil;
		shapeLayer.strokeColor = self.borderColor.CGColor;
		shapeLayer.strokeEnd = 0.0;
		shapeLayer.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.8].CGColor;
		shapeLayer.shadowOpacity = 0.7;
		shapeLayer.shadowRadius = 20.0;
		shapeLayer.contentsScale = [[UIScreen mainScreen] scale];
		shapeLayer.lineWidth = self.borderWidth;
		shapeLayer.lineCap = kCALineCapRound;
		
		self.shapeLayer = shapeLayer;
	}
	
	return _shapeLayer;
}

- (CALayer *)imageLayer
{
	if(!_imageLayer)
	{
		CALayer *imageLayer = [CALayer layer];
		imageLayer.contentsScale = [[UIScreen mainScreen] scale];
		
		self.imageLayer = imageLayer;
	}
	
	return _imageLayer;
}

- (void)setSize:(CGSize)size
{
	[self updateFrameWithSize:size];
	
    [self updateAllLayerFrames];
	
    [self.backgroundLayer setNeedsDisplay];
}

- (void)setProgress:(CGFloat)progress
{
	CGFloat oldProgress = _progress;
    _progress = MAX(0.0, MIN(1.0, progress));
	
	if(oldProgress != self.progress)
	{
		//to prevent showing in some circumstances (updating contentOffset)
		if(self.scrollView.isDragging || self.scrollView.isDecelerating || self.updatingScrollViewOffset || oldProgress > self.progress)
		{
			self.alpha = self.progress;
			
			//rotation Animation
			CABasicAnimation *animationImage = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
			animationImage.fromValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(180.0 - 180.0 * oldProgress)];
			animationImage.toValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(180.0 - 180.0 * self.progress)];
			animationImage.duration = 0.0;
			animationImage.removedOnCompletion = NO;
			animationImage.fillMode = kCAFillModeForwards;
			
			//strokeAnimation
			CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
			animation.fromValue = [NSNumber numberWithFloat:((CAShapeLayer *)self.shapeLayer.presentationLayer).strokeEnd];
			animation.toValue = [NSNumber numberWithFloat:self.progress];
			animation.duration = 0.35 + 0.25 * (fabs([animation.fromValue doubleValue] - [animation.toValue doubleValue]));
			animation.removedOnCompletion = NO;
			animation.fillMode = kCAFillModeForwards;
			animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
			
			[self.imageLayer addAnimation:animationImage forKey:@"animation"];
			[self.shapeLayer addAnimation:animation forKey:@"animation"];
		}
	}
}

- (void)setLayersOpacity:(CGFloat)opacity
{
    self.imageLayer.opacity = opacity;
    self.backgroundLayer.opacity = opacity;
    self.shapeLayer.opacity = opacity;
}

- (void)setLayersHidden:(BOOL)hidden
{
    self.imageLayer.hidden = hidden;
    self.shapeLayer.hidden = hidden;
    self.backgroundLayer.hidden = hidden;
}

- (void)updateAllLayerFrames
{
	[self updateBackgroundLayerFrame];
	[self updateShapeLayerFrame];
	[self updateImageLayerFrame];
}

- (void)updateBackgroundLayerFrame
{
	self.backgroundLayer.frame = self.bounds;
}

- (void)updateShapeLayerFrame
{
	self.shapeLayer.frame = self.bounds;
}

- (void)updateImageLayerFrame
{
	self.imageLayer.frame = CGRectInset(self.bounds, self.borderWidth, self.borderWidth);
}

- (void)updateShapeLayerPath
{
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:center radius:(self.bounds.size.width / 2.0 - self.borderWidth) startAngle:(M_PI - DEGREES_TO_RADIANS(-90.0)) endAngle:(M_PI - DEGREES_TO_RADIANS(360.0 - 90.0)) clockwise:NO];
	
    self.shapeLayer.path = bezierPath.CGPath;
}

- (void)updateFrame
{
	[self updateFrameWithSize:self.frame.size];
}

- (void)updateFrameWithSize:(CGSize)newSize
{
	CGRect newFrame = CGRectMake(self.scrollView.bounds.size.width / 2.0 - newSize.width / 2.0 + self.positionOffset.x, (self.scrollView.contentOffset.y + self.currentTopInset) / 2.0 - newSize.height / 2.0 + self.positionOffset.y, newSize.width, newSize.height);
	
	self.frame = newFrame;
}

- (void)updateCurrentTopInset
{
	self.currentTopInset = self.scrollView.contentInset.top;
}

- (CGFloat)topOffsetForLoadingIndicator
{
	return self.currentTopInset + self.bounds.size.height + 20.0;
}

- (void)setupScrollViewContentInsetForLoadingIndicator:(UZYSCircularProgressPullToRefreshActionHandler)handler
{
    CGFloat offset = MAX(-self.scrollView.contentOffset.y, 0.0);
    CGFloat newInsetTop = MIN(offset, [self topOffsetForLoadingIndicator]);
	
    [self setScrollViewContentInsetTop:newInsetTop handler:handler];
}

- (void)resetScrollViewContentInset:(UZYSCircularProgressPullToRefreshActionHandler)handler
{
    [self setScrollViewContentInsetTop:self.currentTopInset handler:handler];
}

- (void)setScrollViewContentInsetTop:(CGFloat)insetTop handler:(UZYSCircularProgressPullToRefreshActionHandler)handler
{
	[UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState animations:^
	{
		UIEdgeInsets newInset = self.scrollView.contentInset;
		newInset.top = insetTop;
		
		self.updatingScrollViewInsets = YES;
		self.scrollView.contentInset = newInset;
		self.updatingScrollViewInsets = NO;
	}
    completion:^(BOOL finished)
	{
		if(handler)
		{
			handler();
		}
    }];
}

- (void)setupScrollViewContentOffsetForLoadingIndicator:(UZYSCircularProgressPullToRefreshActionHandler)handler
{
	CGFloat newContentOffsetY = -[self topOffsetForLoadingIndicator];
	
    [self setScrollViewContentOffsetY:newContentOffsetY handler:handler];
}

- (void)setScrollViewContentOffsetY:(CGFloat)offsetY handler:(UZYSCircularProgressPullToRefreshActionHandler)handler
{
	[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState animations:^
	 {
		 CGPoint newOffset = self.scrollView.contentOffset;
		 newOffset.y = offsetY;
		 
		 self.updatingScrollViewOffset = YES;
		 self.scrollView.contentOffset = newOffset;
		 self.updatingScrollViewOffset = NO;
	 }
	 completion:^(BOOL finished)
	 {
		 if(handler)
		 {
			 handler(); 
		 }
	 }];
}

- (void)toggleActivityIndicator:(BOOL)toggle
{
	self.activityIndicatorView.alpha = (CGFloat)toggle;
	self.activityIndicatorView.transform = toggle ? CGAffineTransformIdentity : CGAffineTransformMakeScale(0.1, 0.1);
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset
{
	CGFloat oldProgress = self.progress;
	
    CGFloat yOffset = contentOffset.y;
    self.progress = ((yOffset + self.currentTopInset) / -PullToRefreshThreshold);
    
	[self updateFrame];
	
    switch(self.state)
	{
        case UZYSPullToRefreshStateStopped:
		{
            break;
		}
        case UZYSPullToRefreshStateNone:
        {
            if(self.scrollView.isDragging && yOffset < 0.0)
            {
                self.state = UZYSPullToRefreshStateTriggering;
            }
			
			break;
        }
        case UZYSPullToRefreshStateTriggering:
        {
			if(self.progress >= 1.0)
			{
				self.state = UZYSPullToRefreshStateTriggered;
			}
			
			break;
        }
        case UZYSPullToRefreshStateTriggered:
		{
            if(self.scrollView.dragging == NO && oldProgress > 0.99)
            {
                [self actionTriggeredState];
            }
			
			break;
		}
        case UZYSPullToRefreshStateLoading:
		{
            break;
		}
        default:
		{
            break;
		}
    }
}

- (void)actionStopState
{
    self.state = UZYSPullToRefreshStateNone;
	
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:^
	{
		[self toggleActivityIndicator:NO];
    }
	completion:^(BOOL finished)
	{
        [self.activityIndicatorView stopAnimating];
		
        [self resetScrollViewContentInset:^
		{
            [self setLayersHidden:NO];
            [self setLayersOpacity:1.0];
        }];
    }];
}

- (void)actionTriggeredState
{
    self.state = UZYSPullToRefreshStateLoading;
	
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:^
	{
        [self setLayersOpacity:0.0];
		[self toggleActivityIndicator:YES];
    }
	completion:^(BOOL finished)
	{
        [self setLayersHidden:YES];
    }];
	
    [self.activityIndicatorView startAnimating];
    [self setupScrollViewContentInsetForLoadingIndicator:nil];
	
    if(self.pullToRefreshHandler)
	{
        self.pullToRefreshHandler();
	}
}

- (void)stopIndicatorAnimation
{
    [self actionStopState];
}

- (void)manuallyTriggered
{
	[self setLayersHidden:YES];
	
	[self setupScrollViewContentOffsetForLoadingIndicator:^
	{
		[self actionTriggeredState];
	}];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
	[super willMoveToSuperview:newSuperview];
	
    if(self.superview && newSuperview == nil)
	{
        if(self.scrollView.showsPullToRefreshView)
		{
			self.scrollView.pullToRefreshView = nil;
        }
    }
}

- (void)addObservers
{
	[self.scrollView addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:&KVOUZYSRadialProgressActivityIndicatorObserving];
	[self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:&KVOUZYSRadialProgressActivityIndicatorObserving];
	[self.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:&KVOUZYSRadialProgressActivityIndicatorObserving];
	[self.scrollView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:&KVOUZYSRadialProgressActivityIndicatorObserving];
}

- (void)removeObservers
{
	[self.scrollView removeObserver:self forKeyPath:@"contentInset" context:&KVOUZYSRadialProgressActivityIndicatorObserving];
	[self.scrollView removeObserver:self forKeyPath:@"contentOffset" context:&KVOUZYSRadialProgressActivityIndicatorObserving];
	[self.scrollView removeObserver:self forKeyPath:@"contentSize" context:&KVOUZYSRadialProgressActivityIndicatorObserving];
	[self.scrollView removeObserver:self forKeyPath:@"frame" context:&KVOUZYSRadialProgressActivityIndicatorObserving];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if(context == &KVOUZYSRadialProgressActivityIndicatorObserving)
	{
		if([keyPath isEqualToString:@"contentInset"])
		{
			if(!self.updatingScrollViewInsets)
			{
				[self updateCurrentTopInset];
			}
		}
		else if([keyPath isEqualToString:@"contentOffset"])
		{
			CGPoint newPoint = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
			[self scrollViewDidScroll:newPoint];
		}
		else if([keyPath isEqualToString:@"contentSize"] || [keyPath isEqualToString:@"frame"])
		{
			[self setNeedsLayout];
			[self setNeedsDisplay];
		}
	}
	else
	{
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

- (void)dealloc
{
	[self removeObservers];
}

@end
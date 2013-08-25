//
//  ZYPopoverView.m
//  ZYPopoverView
//
//  Created by Xinling Zhang on 8/25/13.
//  Copyright (c) 2013 Xinling Zhang. All rights reserved.
//

#import "ZYPopoverView.h"
#import <QuartzCore/QuartzCore.h>


const CGFloat KArrowWidth = 15;
const CGFloat KcontentLeftMagin = 10;
const CGFloat KcontentRightMagin = 10;
const CGFloat KcontentBottomMagin = 10;
const CGFloat KcontentTopMagin = 10;
@interface ZYPopoverView ()
@property (nonatomic, retain) UIView *backgroundView;


/**
 *	点击手势事件
 *
 *	@param	tap	点击手势
 */
- (void)tapped:(UITapGestureRecognizer *)tap;

/**
 *	绘制背景图片
 *
 *	@param	point	三角顶顶位置
 *	@param	width	图片宽度
 *
 *	@return	图片
 */
- (UIImage *)backgroundImageAtPoint:(CGPoint)point width:(CGFloat)width color:(UIColor *)color;

/**
 *	重置背景视图
 *
 *	@param	point	三角顶顶位置
 *	@param	width	宽度
 */
- (UIView *)backgroundViewAtPoint:(CGPoint)point width:(CGFloat)width;
@end

@implementation ZYPopoverView

+ (ZYPopoverView *)showPopoverAtView:(UIView *)touchView
                     withContentView:(UIView *)content
                            delegate:(id<ZYPopoverViewDelegate>)delegate
{
    CGPoint point = CGPointMake(CGRectGetMidX(touchView.frame), CGRectGetMaxY(touchView.frame));
    CGPoint topPoint = [[UIApplication sharedApplication].keyWindow convertPoint:point fromView:[touchView superview]];
    return  [self showPopoverAtPoint:topPoint
                              inView:[UIApplication sharedApplication].keyWindow
                     withContentView:content delegate:delegate];
}

+ (ZYPopoverView *)showPopoverAtPoint:(CGPoint)point
                      withContentView:(UIView *)content
                             delegate:(id<ZYPopoverViewDelegate>)delegate
{
    return [ZYPopoverView showPopoverAtPoint:point
                                      inView:[UIApplication sharedApplication].keyWindow
                             withContentView:content
                                    delegate:delegate];
}

+ (ZYPopoverView *)showPopoverAtPoint:(CGPoint)point
                               inView:(UIView *)view
                      withContentView:(UIView *)contentView
                             delegate:(id<ZYPopoverViewDelegate>)delegate
{
    ZYPopoverView* popoverView = [[ZYPopoverView alloc] initWithFrame:[view bounds]];
    [popoverView showPopoverAtPoint:point
                             inView:view
                    withContentView:contentView];
    popoverView.delegate = delegate;
    return [popoverView autorelease];
}

- (void)showPopoverAtPoint:(CGPoint)point
                    inView:(UIView *)view
           withContentView:(UIView *)contentView
{
    
    [view addSubview:self];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:tap];
    [tap release];
    
    [self.backgroundView removeFromSuperview];
    self.backgroundView = [self backgroundViewAtPoint:point width:view.bounds.size.width];
    self.backgroundView.alpha = 0.9;
    self.backgroundView.clipsToBounds = YES;
    [self addSubview:self.backgroundView];
    
    __block CGRect newframe = self.backgroundView.frame;
    newframe.origin.x = (CGRectGetWidth(newframe) - CGRectGetWidth(contentView.bounds)) * 0.5;
    newframe.origin.y = KArrowWidth + KcontentTopMagin;
    newframe.size.width = contentView.bounds.size.width;
    newframe.size.height = MIN(view.bounds.size.height - point.y - (KArrowWidth + KcontentTopMagin + KcontentBottomMagin) ,
                               contentView.bounds.size.height);
    contentView.frame = newframe;
    [self.backgroundView addSubview:contentView];

    newframe.origin = self.backgroundView.frame.origin;
    newframe.size.width += KcontentLeftMagin + KcontentRightMagin;
    newframe.size.height += (KArrowWidth + KcontentTopMagin + KcontentBottomMagin);
    
    [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backgroundView.frame = newframe;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect newframe = self.backgroundView.frame;
        newframe.size.height = 0;
        self.backgroundView.frame = newframe;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(popoverViewDidDismiss:)]) {
            [self.delegate popoverViewDidDismiss:self];
        }
        
    }];
}

#pragma mark -- private
- (void)tapped:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:self.backgroundView];
    if ( !CGRectContainsPoint(self.backgroundView.bounds, point) )
    {
        [self dismiss];
    }
}


- (UIImage *)backgroundImageAtPoint:(CGPoint)point width:(CGFloat)width color:(UIColor *)color
{
    UIGraphicsBeginImageContext(CGSizeMake(width, KArrowWidth + KcontentBottomMagin + KcontentTopMagin));
    CGContextRef     context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextMoveToPoint(context, 0, KArrowWidth);
    CGContextAddLineToPoint(context, point.x - KArrowWidth, KArrowWidth);
    CGContextAddLineToPoint(context, point.x, 0);
    CGContextAddLineToPoint(context, point.x + KArrowWidth, KArrowWidth);
    CGContextAddLineToPoint(context, width, KArrowWidth);
    CGContextAddLineToPoint(context, width, KArrowWidth + KcontentBottomMagin + KcontentTopMagin);
    CGContextAddLineToPoint(context, 0, KArrowWidth + KcontentBottomMagin + KcontentTopMagin);
    CGContextDrawPath(context, kCGPathFill);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIView *)backgroundViewAtPoint:(CGPoint)point width:(CGFloat)width
{
    UIImage* image = [self backgroundImageAtPoint:point width:width color:[UIColor colorWithWhite:0.9 alpha:1]];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(KArrowWidth * KcontentTopMagin * 0.5, 0, 10, KcontentBottomMagin * 0.5)
                                  resizingMode:UIImageResizingModeStretch];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    UIView* backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, point.y, width, 0)];
    [backgroundView addSubview:imageView];
    imageView.frame = backgroundView.bounds;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    [imageView release];
    return [backgroundView autorelease];
}


@end

//
//  ZYPopoverView.h
//  ZYPopoverView
//
//  Created by Xinling Zhang on 8/25/13.
//  Copyright (c) 2013 Xinling Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZYPopoverView;

@protocol ZYPopoverViewDelegate <NSObject>

@optional

//Delegate receives this call once the popover has begun the dismissal animation
- (void)popoverViewDidDismiss:(ZYPopoverView *)popoverView;

@end


@interface ZYPopoverView : UIView

/**
 *	代理
 */
@property (nonatomic, assign) id<ZYPopoverViewDelegate> delegate;

/**
 *	显示popover view
 *
 *	@param	touchView	触发popover view 显示的view
 *	@param	content	显示内容
 *	@param	delegate	代理
 *
 *	@return	ZYPopoverView 实例
 */
+ (ZYPopoverView *)showPopoverAtView:(UIView *)touchView
                     withContentView:(UIView *)content
                            delegate:(id<ZYPopoverViewDelegate>)delegate;

/**
 *	显示popover view
 *
 *	@param	point	起点位置
 *	@param	content	显示内容
 *	@param	delegate	代理
 *
 *	@return	ZYPopoverView 实例
 */
+ (ZYPopoverView *)showPopoverAtPoint:(CGPoint)point
                      withContentView:(UIView *)content
                             delegate:(id<ZYPopoverViewDelegate>)delegate;


/**
 *	显示popover view
 *
 *	@param	point	起点位置
 *	@param	view	poppver显示的view
 *	@param	content	显示内容
 *	@param	delegate	代理
 *
 *	@return	ZYPopoverView 实例
 */
+ (ZYPopoverView *)showPopoverAtPoint:(CGPoint)point
                               inView:(UIView *)view
                      withContentView:(UIView *)content
                             delegate:(id<ZYPopoverViewDelegate>)delegate;

/**
 *	显示popover view
 *
 *	@param	point	起点位置
 *	@param	view	poppver显示的view
 *	@param	content	显示内容
 */
- (void)showPopoverAtPoint:(CGPoint)point
                    inView:(UIView *)view
           withContentView:(UIView *)contentView;

/**
 *	消失
 */
- (void)dismiss;


@end

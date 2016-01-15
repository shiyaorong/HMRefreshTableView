//
//  UIView+HMFrame.h
//  HMRefreshTableView
//
//  Created by mac on 16/1/15.
//  Copyright © 2016年 leiliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HMFrame)

/// 上、左、下、右
@property (nonatomic, assign) CGFloat top;

@property (nonatomic, assign) CGFloat left;

@property (nonatomic, assign) CGFloat bottom;

@property (nonatomic, assign) CGFloat right;

/// 中心点 x、y
@property (nonatomic, assign) CGFloat centerX;

@property (nonatomic, assign) CGFloat centerY;

/// 宽、高
@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;

/// origin
@property (nonatomic, assign) CGPoint origin;

/// size
@property (nonatomic, assign) CGSize size;

@end

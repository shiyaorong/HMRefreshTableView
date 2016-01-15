//
//  UIScrollView+HMExtension.h
//  HMRefreshTableView
//
//  Created by mac on 16/1/15.
//  Copyright © 2016年 leiliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (HMExtension)

/// 边距
@property (nonatomic, assign) CGFloat edgeTop;

@property (nonatomic, assign) CGFloat edgeLeft;

@property (nonatomic, assign) CGFloat edgeBottom;

@property (nonatomic, assign) CGFloat edgeRight;

/// 滚动范围
@property (nonatomic, assign) CGFloat contentSizeWidth;

@property (nonatomic, assign) CGFloat contentSizeHeight;

/// 偏移量
@property (nonatomic, assign) CGFloat offsetX;

@property (nonatomic, assign) CGFloat offsetY;

@end

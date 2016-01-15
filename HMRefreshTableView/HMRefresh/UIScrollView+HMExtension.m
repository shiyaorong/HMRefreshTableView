//
//  UIScrollView+HMExtension.m
//  HMRefreshTableView
//
//  Created by mac on 16/1/15.
//  Copyright © 2016年 leiliang. All rights reserved.
//

#import "UIScrollView+HMExtension.h"

@implementation UIScrollView (HMExtension)

/// 边距
- (CGFloat)edgeTop {
    return self.contentInset.top;
}

- (void)setEdgeTop:(CGFloat)edgeTop {
    UIEdgeInsets contentInset = self.contentInset;
    contentInset.top = edgeTop;
    self.contentInset = contentInset;
}

- (CGFloat)edgeLeft {
    return self.contentInset.left;
}

- (void)setEdgeLeft:(CGFloat)edgeLeft {
    UIEdgeInsets contentInset = self.contentInset;
    contentInset.left = edgeLeft;
    self.contentInset = contentInset;
}

- (CGFloat)edgeBottom {
    return self.contentInset.bottom;
}

- (void)setEdgeBottom:(CGFloat)edgeBottom {
    UIEdgeInsets contentInset = self.contentInset;
    contentInset.bottom = edgeBottom;
    self.contentInset = contentInset;
}

- (CGFloat)edgeRight {
    return self.contentInset.right;
}

- (void)setEdgeRight:(CGFloat)edgeRight {
    UIEdgeInsets contentInset = self.contentInset;
    contentInset.right = edgeRight;
    self.contentInset = contentInset;
}

/// 滚动范围
- (CGFloat)contentSizeWidth {
    return self.contentSize.width;
}

- (void)setContentSizeWidth:(CGFloat)contentSizeWidth {
    CGSize contentSize = self.contentSize;
    contentSize.width = contentSizeWidth;
    self.contentSize = contentSize;
}

- (CGFloat)contentSizeHeight {
    return self.contentSize.height;
}

- (void)setContentSizeHeight:(CGFloat)contentSizeHeight {
    CGSize contentSize = self.contentSize;
    contentSize.height = contentSizeHeight;
    self.contentSize = contentSize;
}

/// 偏移量
- (CGFloat)offsetX {
    return self.contentOffset.x;
}

- (void)setOffsetX:(CGFloat)offsetX {
    CGPoint contentOffset = self.contentOffset;
    contentOffset.x = offsetX;
    self.contentOffset = contentOffset;
}

- (CGFloat)offsetY {
    return self.contentOffset.y;
}

- (void)setOffsetY:(CGFloat)offsetY {
    CGPoint contentOffset = self.contentOffset;
    contentOffset.y = offsetY;
    self.contentOffset = contentOffset;
}

@end

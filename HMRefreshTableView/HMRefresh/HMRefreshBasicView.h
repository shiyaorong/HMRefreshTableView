//
//  HMRefreshBasicView.h
//  HMRefreshTableView
//
//  Created by mac on 16/1/15.
//  Copyright © 2016年 leiliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"



/// arrow image
@interface HMImageView : UIImageView

@property (nonatomic, assign, readonly) ARROW_DIRECTION direction;

- (void)changeDirection:(ARROW_DIRECTION)direction;

@end

@interface HMRefreshBasicView : UIView

@property (nonatomic, strong) UILabel *statuSLabel;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@property (nonatomic, strong) HMImageView *arrowImageView;


/// dragging state
- (void)draggingBegan:(UIScrollView *)scrollView;

- (void)draggingChanged:(UIScrollView *)scrollView;

- (void)draggingEnded:(UIScrollView *)scrollView;

- (void)refreshFinishi;

@end

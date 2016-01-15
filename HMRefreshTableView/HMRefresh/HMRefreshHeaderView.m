//
//  HMRefreshHeaderView.m
//  HMRefreshTableView
//
//  Created by mac on 16/1/15.
//  Copyright © 2016年 leiliang. All rights reserved.
//

#import "HMRefreshHeaderView.h"

static NSString *REFRESH_START_DRAGGING_STRING = @"下拉可以刷新...";
static NSString *CAN_REFRESH_STRING            = @"松开即可刷新...";
static NSString *REFRESH_END_DRAGGING_STRING   = @"正在为您刷新...";
static NSString *REFRESH_SUCCESS_STRING        = @"刷新成功...";

@implementation HMRefreshHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.arrowImageView.hidden = NO;
        self.activityView.hidden = YES;
        self.statuSLabel.text = REFRESH_START_DRAGGING_STRING;
        [self.arrowImageView changeDirection:ARROW_DIRECTION_DOWN];
    }
    return self;
}

- (void)draggingBegan:(UIScrollView *)scrollView {
    self.arrowImageView.hidden = NO;
    self.activityView.hidden = YES;
    self.statuSLabel.text = REFRESH_START_DRAGGING_STRING;
    [self.arrowImageView changeDirection:ARROW_DIRECTION_DOWN];
}

- (void)draggingChanged:(UIScrollView *)scrollView {
    if (-scrollView.contentOffset.y <= self.height) {
        /// 拖拽距离小于等于headerView
        [UIView animateWithDuration:0.3 animations:^{
            self.statuSLabel.text = REFRESH_START_DRAGGING_STRING;
            if (self.arrowImageView.direction != ARROW_DIRECTION_DOWN) {
                [self.arrowImageView changeDirection:ARROW_DIRECTION_DOWN];
            }
        }];
    } else if (-scrollView.contentOffset.y > self.height) {
        /// 拖拽距离大于headerView
        [UIView animateWithDuration:0.3 animations:^{
            self.statuSLabel.text = CAN_REFRESH_STRING;
            if (self.arrowImageView.direction != ARROW_DIRECTION_UP) {
                [self.arrowImageView changeDirection:ARROW_DIRECTION_UP];
            }
        }];
    }
}

- (void)draggingEnded:(UIScrollView *)scrollView {
    if (-scrollView.contentOffset.y <= self.height) {
        /// 拖拽距离小于等于headerView
        [UIView animateWithDuration:0.3 animations:^{
            self.statuSLabel.text = REFRESH_START_DRAGGING_STRING;
            if (self.arrowImageView.direction != ARROW_DIRECTION_DOWN) {
                [self.arrowImageView changeDirection:ARROW_DIRECTION_DOWN];
            }
        }];
    } else if (-scrollView.contentOffset.y > self.height) {
        /// 拖拽距离大于headerView
        self.statuSLabel.text = REFRESH_END_DRAGGING_STRING;
        self.arrowImageView.hidden = YES;
        self.activityView.hidden = NO;
        [self.activityView startAnimating];
    }
}

- (void)refreshFinishi {
    self.statuSLabel.text = REFRESH_SUCCESS_STRING;
    
    self.arrowImageView.hidden = YES;
    self.activityView.hidden = YES;
    [self.activityView stopAnimating];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

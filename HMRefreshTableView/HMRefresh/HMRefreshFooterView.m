//
//  HMRefreshFooterView.m
//  HMRefreshTableView
//
//  Created by mac on 16/1/15.
//  Copyright © 2016年 leiliang. All rights reserved.
//

#import "HMRefreshFooterView.h"
#import <objc/message.h>

static NSString *REFRESH_START_DRAGGING_STRING = @"上拉可以加载...";
static NSString *CAN_REFRESH_STRING            = @"松开即可加载...";
static NSString *REFRESH_END_DRAGGING_STRING   = @"正在为您加载...";
static NSString *REFRESH_SUCCESS_STRING        = @"加载成功...";
static NSString *CLICKED_LABEL_STRING          = @"点击为您加载";

@interface HMRefreshFooterView ()

@property (nonatomic, strong) UILabel *clickedLabel;

@property (nonatomic, copy) CompletionNullBlock completionNullBlock;

@end

@implementation HMRefreshFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.arrowImageView.hidden = NO;
        self.activityView.hidden = YES;
        self.statuSLabel.text = REFRESH_START_DRAGGING_STRING;
        [self.arrowImageView changeDirection:ARROW_DIRECTION_UP];
    }
    return self;
}

- (void)dealloc {
    self.completionNullBlock = nil;
}

- (void)draggingBegan:(UIScrollView *)scrollView {
    self.arrowImageView.hidden = NO;
    self.activityView.hidden = YES;
    
    self.statuSLabel.text = REFRESH_START_DRAGGING_STRING;
    [self.arrowImageView changeDirection:ARROW_DIRECTION_UP];
}

- (void)draggingChanged:(UIScrollView *)scrollView {
    /// 注意: 列表内容不够一页的情况下 return
    if (scrollView.height > scrollView.contentSizeHeight) {
        return;
    }
    
    if (scrollView.offsetY + scrollView.height >= scrollView.contentSizeHeight && scrollView.offsetY + scrollView.height <= scrollView.contentSizeHeight + self.height) {
        /// 拖拽距离小于等于footerView
        [UIView animateWithDuration:0.3 animations:^{
            self.statuSLabel.text = REFRESH_START_DRAGGING_STRING;
            if (self.arrowImageView.direction != ARROW_DIRECTION_UP) {
                [self.arrowImageView changeDirection:ARROW_DIRECTION_UP];
            }
        }];
    } else if (scrollView.offsetY + scrollView.height >= scrollView.contentSizeHeight + self.height) {
        /// 拖拽距离大于footerView
        [UIView animateWithDuration:0.3 animations:^{
            self.statuSLabel.text = CAN_REFRESH_STRING;
            if (self.arrowImageView.direction != ARROW_DIRECTION_DOWN) {
                [self.arrowImageView changeDirection:ARROW_DIRECTION_DOWN];
            }
        }];
    }
}

- (void)draggingEnded:(UIScrollView *)scrollView {
    /// 注意: 列表内容不够一页的情况下 return
    if (scrollView.height > scrollView.contentSizeHeight) {
        return;
    }
    
    if (scrollView.offsetY + scrollView.height >= scrollView.contentSizeHeight && scrollView.offsetY + scrollView.height < scrollView.contentSizeHeight + self.height) {
        /// 拖拽距离小于等于footerView
        [UIView animateWithDuration:0.3 animations:^{
            self.statuSLabel.text = REFRESH_START_DRAGGING_STRING;
            if (self.arrowImageView.direction != ARROW_DIRECTION_UP) {
                [self.arrowImageView changeDirection:ARROW_DIRECTION_UP];
            }
        }];
    } if (scrollView.offsetY + scrollView.height >= scrollView.contentSizeHeight + self.height) {
        /// 拖拽距离大于footerView
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

- (void)setRefreshFooterStyle:(UIScrollView *)scrollView {
    /// 注意: 列表内容不够一页的情况下 创建label
    if (scrollView.contentSizeHeight < scrollView.height) {
        [self buildClickedLabel];
    }
}

- (void)buildClickedLabel {
    if (!self.clickedLabel) {
        self.clickedLabel = [[UILabel alloc] init];
        self.clickedLabel.backgroundColor = self.backgroundColor;
        self.clickedLabel.font = [UIFont systemFontOfSize:12.f];
        self.clickedLabel.text = CLICKED_LABEL_STRING;
        self.clickedLabel.textColor = self.statuSLabel.textColor;
        self.clickedLabel.userInteractionEnabled = YES;
        self.clickedLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.clickedLabel];
        
        /// layout
        self.clickedLabel.sd_layout
        .leftEqualToView(self)
        .topEqualToView(self)
        .bottomEqualToView(self)
        .rightEqualToView(self);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedLabelAction:)];
        tap.numberOfTapsRequired = 1;
        [self.clickedLabel addGestureRecognizer:tap];
    }
    self.clickedLabel.hidden = NO;
}

- (void)clickedLabelAction:(UITapGestureRecognizer *)sender {
    self.clickedLabel.hidden = YES;
    self.statuSLabel.text = REFRESH_END_DRAGGING_STRING;
    self.arrowImageView.hidden = YES;
    self.activityView.hidden = NO;
    [self.activityView startAnimating];
    
    if (self.completionNullBlock) {
        self.completionNullBlock();
    }
}

- (void)HMRefreshFooterViewClickedLabelActionCompletion:(CompletionNullBlock)completionNullBlock {
    self.completionNullBlock = completionNullBlock;
}

/// NOT NEED DRAGGING
- (void)refreshWithScrollView:(UIScrollView *)scrollView {
    self.clickedLabel.hidden = YES;
    self.statuSLabel.text = REFRESH_END_DRAGGING_STRING;
    self.arrowImageView.hidden = YES;
    self.activityView.hidden = NO;
    [self.activityView startAnimating];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

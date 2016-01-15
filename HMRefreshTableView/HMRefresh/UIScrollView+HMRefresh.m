//
//  UIScrollView+HMRefresh.m
//  HMRefreshTableView
//
//  Created by mac on 16/1/15.
//  Copyright © 2016年 leiliang. All rights reserved.
//

#import "UIScrollView+HMRefresh.h"
#import <objc/runtime.h>
#import "HMRefreshHeaderView.h"
#import "HMRefreshFooterView.h"

static const char *refreshHeaderKey;
static const char *refreshFooterKey;
static const char *headerCompletionKey;
static const char *footerCompletionKey;
static const char *AddedRefreshObserverKey;
static const char *AddedRefreshFooterObserverKey;
static const char *AddedContentOffsetObserverKey;
static const char *REFRESH_STATUS_KEY;
static const char *refreshTypeKey;

/// KEYPATH
static NSString *PANSTATE_KEYPATH = @"panGestureRecognizer.state";
static NSString *CONTENTSIZE_KEYPATH = @"contentSize";
static NSString *CONTENTOFFSET_KEYPATH = @"contentOffset";

@interface UIScrollView () <UIScrollViewDelegate>

/// REFRESH CONTROL
@property (nonatomic, strong) HMRefreshHeaderView *refreshHeaderView;

@property (nonatomic, strong) HMRefreshFooterView *refreshFooterView;

/// TEMP BLOCK VALUE
@property (nonatomic, copy) CompletionNullBlock headerCompletion;

@property (nonatomic, copy) CompletionNullBlock footerCompletion;

@property (nonatomic, assign, readonly) CGFloat refreshControlHeight;

@property (nonatomic, assign) BOOL AddedRefreshObserver;

@property (nonatomic, assign) BOOL AddedRefreshFooterObserver;

@property (nonatomic, assign) BOOL AddedContentOffsetObserver;

@property (nonatomic, assign) REFRESH_STATUS refreshStatus;

@property (nonatomic, assign) REFRESH_CONTROL_TYPE refreshType;

@end

@implementation UIScrollView (HMRefresh)

/// Variable Set And Get Method
- (HMRefreshHeaderView *)refreshHeaderView {
    return objc_getAssociatedObject(self, &refreshHeaderKey);
}

- (void)setRefreshHeaderView:(HMRefreshHeaderView *)refreshHeaderView {
    objc_setAssociatedObject(self, &refreshHeaderKey, refreshHeaderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HMRefreshFooterView *)refreshFooterView {
    return objc_getAssociatedObject(self, &refreshFooterKey);
}

- (void)setRefreshFooterView:(HMRefreshFooterView *)refreshFooterView {
    objc_setAssociatedObject(self, &refreshFooterKey, refreshFooterView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CompletionNullBlock)headerCompletion {
    return objc_getAssociatedObject(self, &headerCompletionKey);
}

- (void)setHeaderCompletion:(CompletionNullBlock)headerCompletion {
    objc_setAssociatedObject(self, &headerCompletionKey, headerCompletion, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CompletionNullBlock)footerCompletion {
    return objc_getAssociatedObject(self, &footerCompletionKey);
}

- (void)setFooterCompletion:(CompletionNullBlock)footerCompletion {
    objc_setAssociatedObject(self, &footerCompletionKey, footerCompletion, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)AddedRefreshObserver {
    return [objc_getAssociatedObject(self, &AddedRefreshObserverKey) boolValue];
}

- (void)setAddedRefreshObserver:(BOOL)AddedRefreshObserver {
    objc_setAssociatedObject(self, &AddedRefreshObserverKey, @(AddedRefreshObserver), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)AddedRefreshFooterObserver {
    return [objc_getAssociatedObject(self, &AddedRefreshFooterObserverKey) boolValue];
}

- (void)setAddedRefreshFooterObserver:(BOOL)AddedRefreshFooterObserver {
    objc_setAssociatedObject(self, &AddedRefreshFooterObserverKey, @(AddedRefreshFooterObserver), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)AddedContentOffsetObserver {
    return [objc_getAssociatedObject(self, &AddedContentOffsetObserverKey) boolValue];
}

- (void)setAddedContentOffsetObserver:(BOOL)AddedContentOffsetObserver {
    objc_setAssociatedObject(self, &AddedContentOffsetObserverKey, @(AddedContentOffsetObserver), OBJC_ASSOCIATION_ASSIGN);
}

- (REFRESH_STATUS)refreshStatus {
    return [objc_getAssociatedObject(self, &REFRESH_STATUS_KEY) integerValue];
}

- (void)setRefreshStatus:(REFRESH_STATUS)refreshStatus {
    objc_setAssociatedObject(self, &REFRESH_STATUS_KEY, @(refreshStatus), OBJC_ASSOCIATION_ASSIGN);
}

- (REFRESH_CONTROL_TYPE)refreshType {
    return [objc_getAssociatedObject(self, &refreshTypeKey) integerValue];
}

- (void)setRefreshType:(REFRESH_CONTROL_TYPE)refreshType {
    objc_setAssociatedObject(self, &refreshTypeKey, @(refreshType), OBJC_ASSOCIATION_ASSIGN);
}

/// Add Refresh Control
- (void)AddRefreshHeaderControlCompletion:(CompletionNullBlock)completionNullBlock {
    self.headerCompletion = completionNullBlock;
    [self buildingRefreshHeader];
    /// Add Observer
    [self addRefreshObserver];
}

- (void)AddRefreshFooterControlCompletion:(CompletionNullBlock)completionNullBlock {
    self.refreshType = REFRESH_CONTROL_LOADING_NOT_NEED_DRAGGING;
    self.footerCompletion = completionNullBlock;
    [self buildingRefreshFooter];
    /// Add Observer
    [self addRefreshObserver];
    [self addRefreshFooterObserver];
}

- (void)AddRefreshFooterControlWithType:(REFRESH_CONTROL_TYPE)refreshControlType Completion:(CompletionNullBlock)completionNullBlock {
    self.refreshType = refreshControlType;
    self.footerCompletion = completionNullBlock;
    [self buildingRefreshFooter];
    /// Add Obverser
    [self addRefreshObserver];
    [self addRefreshFooterObserver];
}

- (void)dealloc {
    self.headerCompletion = nil;
    self.footerCompletion = nil;
    if (self.AddedRefreshObserver) {
        [self removeObserver:self forKeyPath:PANSTATE_KEYPATH];
    }
    if (self.AddedRefreshFooterObserver) {
        [self removeObserver:self forKeyPath:CONTENTSIZE_KEYPATH];
    }
    if (self.AddedContentOffsetObserver) {
        [self removeObserver:self forKeyPath:CONTENTOFFSET_KEYPATH];
    }
    if (self.refreshHeaderView) {
        self.refreshHeaderView = nil;
    }
    if (self.refreshFooterView) {
        self.refreshFooterView = nil;
    }
}

/// build UI
- (void)buildingRefreshHeader {
    self.refreshHeaderView = [[HMRefreshHeaderView alloc] initWithFrame:CGRectMake(0, -self.refreshControlHeight, [UIScreen mainScreen].bounds.size.width, self.refreshControlHeight)];
    [self addSubview:self.refreshHeaderView];
}

- (void)buildingRefreshFooter {
    self.refreshFooterView = [[HMRefreshFooterView alloc] initWithFrame:CGRectMake(0, self.contentSize.height, [UIScreen mainScreen].bounds.size.width, self.refreshControlHeight)];
    __weak __typeof(self) weakSelf = self;
    [self.refreshFooterView HMRefreshFooterViewClickedLabelActionCompletion:^{
        [weakSelf refreshFooterHandle];
    }];;
    [self addSubview:self.refreshFooterView];
}

/// Add Observer
- (void)addRefreshObserver {
    if (!self.AddedRefreshObserver) {
        [self addObserver:self forKeyPath:PANSTATE_KEYPATH options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
        self.AddedRefreshObserver = YES;
    }
    if (!self.AddedContentOffsetObserver) {
        [self addObserver:self forKeyPath:CONTENTOFFSET_KEYPATH options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        self.AddedContentOffsetObserver = YES;
    }
}

- (void)addRefreshFooterObserver {
    if (!self.AddedRefreshFooterObserver) {
        [self addObserver:self forKeyPath:CONTENTSIZE_KEYPATH options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        self.AddedRefreshFooterObserver = YES;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    [self SwitchValueWithDragging:^{
        if ([keyPath isEqualToString:PANSTATE_KEYPATH]) {
            if (self.contentOffset.y <= 0 && self.refreshHeaderView) { /// 下拉刷新
                [self dealWithHeaderControl];
            } else if (self.contentOffset.y > 0 && self.refreshFooterView) { /// 上拉加载
                if (self.contentSizeHeight < self.height) { return; }
                [self dealWithFooterControl];
            }
        } else if ([keyPath isEqualToString:CONTENTSIZE_KEYPATH]) {
            /// Content Size
            if (self.refreshFooterView) {
                [self.refreshFooterView setRefreshFooterStyle:self];
                self.refreshFooterView.top = self.contentSize.height;
            }
        } else if ([keyPath isEqualToString:CONTENTOFFSET_KEYPATH]) {
            if (self.contentOffset.y <= 0 && self.refreshHeaderView) {
                /// 下拉刷新
                [self dealWithHeaderControl];
            } else if (self.contentOffset.y > 0 && self.refreshFooterView) {
                /// 上拉加载
                if (self.contentSizeHeight < self.height) { return; }
                [self dealWithFooterControl];
            }
        }
    } NotNeedDragging:^{
        if ([keyPath isEqualToString:PANSTATE_KEYPATH]) {
            if (self.contentOffset.y <= 0 && self.refreshHeaderView) { /// 下拉刷新
                [self dealWithHeaderControl];
            }
        } else if ([keyPath isEqualToString:CONTENTSIZE_KEYPATH]) {
            /// Content Size
            if (self.refreshFooterView) {
                [self.refreshFooterView setRefreshFooterStyle:self];
                self.refreshFooterView.top = self.contentSize.height;
                self.edgeBottom = [self refreshControlHeight];
            }
        } else if ([keyPath isEqualToString:CONTENTOFFSET_KEYPATH]) {
            if (self.contentOffset.y <= 0) {
                if (self.panGestureRecognizer.state == UIGestureRecognizerStateChanged && self.refreshHeaderView) {
                    /// 下拉刷新
                    [self dealWithHeaderControl];
                }
            } else {
                if (self.refreshStatus == REFRESH_STATUS_POSSIBLE) {
                    if (self.offsetY + self.height >= self.contentSizeHeight) {
                        self.refreshStatus = REFRESH_STATUS_FOOTER_OCCURRENT;
                        if (self.footerCompletion) {
                            self.footerCompletion();
                        }
                        [self.refreshFooterView refreshWithScrollView:self];
                    }
                }
            }
        }
    }];
    
}

/// Refresh Handle
- (void)dealWithHeaderControl {
    if (self.refreshStatus != REFRESH_STATUS_HEADER_OCCURRENT) {
        [self SwitchValueWithBegan:^{
            [self.refreshHeaderView draggingBegan:self];
        } changedState:^{
            [self.refreshHeaderView draggingChanged:self];
        } endedState:^{
            [self.refreshHeaderView draggingEnded:self];
            [self refreshHeaderHandle];
        }];
    }
}

- (void)dealWithFooterControl {
    [self SwitchValueWithDragging:^{
        if (self.refreshStatus != REFRESH_STATUS_FOOTER_OCCURRENT) {
            [self SwitchValueWithBegan:^{
                [self.refreshFooterView draggingBegan:self];
            } changedState:^{
                [self.refreshFooterView draggingChanged:self];
            } endedState:^{
                [self.refreshFooterView draggingEnded:self];
                [self refreshFooterHandle];
            }];
        }
    } NotNeedDragging:^{
        
    }];
}

- (void)refreshHeaderHandle {
    if (-self.offsetY > self.refreshControlHeight) {
        /// Refresh Status
        self.refreshStatus = REFRESH_STATUS_HEADER_OCCURRENT;
        
        if (self.headerCompletion) {
            self.headerCompletion();
        }
        [UIView animateWithDuration:0.5f animations:^{
            self.edgeTop = self.refreshControlHeight;
        }];
    }
}

- (void)refreshFooterHandle {
    /**
     * scrollView一开始并不存在偏移量,但是会设定contentSize的大小
     * 所以contentSize.height永远都会比contentOffset.y高一个手机屏幕的高度
     * 上拉加载的效果就是每次滑动到底部时, 再往上拉的时候请求更多
     * 那个时候产生的偏移量, 就能让contentOffset.y + 手机屏幕尺寸高大于这个滚动视图的contentSize.height
     */
    /// 注意: 列表内容不够一页的情况下
    if (self.height > self.contentSizeHeight) {
        self.refreshStatus = REFRESH_STATUS_FOOTER_OCCURRENT;
        if (self.footerCompletion) {
            self.footerCompletion();
        }
        return;
    }
    
    if (self.offsetY + self.height > self.contentSizeHeight + self.refreshControlHeight) {
        /// Refresh Status
        self.refreshStatus = REFRESH_STATUS_FOOTER_OCCURRENT;
        if (self.footerCompletion) {
            self.footerCompletion();
        }
        [UIView animateWithDuration:0.5f animations:^{
            self.edgeBottom = [self refreshControlHeight];
        }];
    }
}

- (void)refreshFinish {
    /// Refresh Status
    if (self.refreshStatus == REFRESH_STATUS_HEADER_OCCURRENT) {
        [self.refreshHeaderView refreshFinishi];
    }
    if (self.refreshStatus == REFRESH_STATUS_FOOTER_OCCURRENT) {
        [self.refreshFooterView refreshFinishi];
    }
    self.refreshStatus = REFRESH_STATUS_POSSIBLE;
    
    /// Footer Finish
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5f animations:^{
            self.edgeBottom = 0;
        } completion:^(BOOL finished) {
        }];
        /// Header Finish
        [UIView animateWithDuration:0.5f animations:^{
            self.edgeTop = 0;
        }];
    });
}

- (CGFloat)refreshControlHeight {
    return 44.f;
}

/// Switch Block
- (void)SwitchValueWithBegan:(CompletionNullBlock)beganState
                changedState:(CompletionNullBlock)changedState
                  endedState:(CompletionNullBlock)endedState {
    if (self.panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        beganState();
    } else if (self.panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        changedState();
    } else if (self.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        endedState();
    }
}

- (void)SwitchValueWithDragging:(CompletionNullBlock)Dragging
                NotNeedDragging:(CompletionNullBlock)NotNeedDragging {
    if (self.refreshType == REFRESH_CONTROL_LOADING_NEED_DRAGGING) {
        Dragging();
    } else {
        NotNeedDragging();
    }
}

@end

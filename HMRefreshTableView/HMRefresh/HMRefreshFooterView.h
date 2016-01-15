//
//  HMRefreshFooterView.h
//  HMRefreshTableView
//
//  Created by mac on 16/1/15.
//  Copyright © 2016年 leiliang. All rights reserved.
//

#import "HMRefreshBasicView.h"

@interface HMRefreshFooterView : HMRefreshBasicView

- (void)HMRefreshFooterViewClickedLabelActionCompletion:(CompletionNullBlock)completionNullBlock;

- (void)setRefreshFooterStyle:(UIScrollView *)scrollView;

/// not need dragging
- (void)refreshWithScrollView:(UIScrollView *)scrollView;

@end

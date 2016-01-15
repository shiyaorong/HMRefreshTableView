//
//  UIScrollView+HMRefresh.h
//  HMRefreshTableView
//
//  Created by mac on 16/1/15.
//  Copyright © 2016年 leiliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"

@interface UIScrollView (HMRefresh)

/// Add Refresh Header Control
- (void)AddRefreshHeaderControlCompletion:(CompletionNullBlock)completionNullBlock;

/// Add Refresh Footer Control
- (void)AddRefreshFooterControlCompletion:(CompletionNullBlock)completionNullBlock;

/// Add Refresh Footer Control With Type
- (void)AddRefreshFooterControlWithType:(REFRESH_CONTROL_TYPE)refreshControlType Completion:(CompletionNullBlock)completionNullBlock;

/// Refresh Finished
- (void)refreshFinish;

@end

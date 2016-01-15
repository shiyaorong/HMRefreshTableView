//
//  Config.h
//  HMRefreshTableView
//
//  Created by mac on 16/1/15.
//  Copyright © 2016年 leiliang. All rights reserved.
//


//#ifndef Config_h
//#define Config_h
//
//
//#endif /* Config_h */

#import "UIColor+HMExtension.h"
#import "UIScrollView+HMExtension.h"
#import "UIView+HMFrame.h"
#import "UIView+SDAutoLayout.h"

typedef void(^CompletionNullBlock)();

/// Refresh Arrow Direction
typedef NS_ENUM(NSUInteger, ARROW_DIRECTION) {
    ARROW_DIRECTION_UP = -1,
    ARROW_DIRECTION_DOWN = 1
};

/// Refresh Status
typedef NS_ENUM(NSUInteger, REFRESH_STATUS) {
    REFRESH_STATUS_POSSIBLE,         // 默认状态，刷新完成或等待刷新
    REFRESH_STATUS_HEADER_OCCURRENT, // 正在刷新
    REFRESH_STATUS_FOOTER_OCCURRENT, // 正在加载
};

/// Loading Dragging Type
typedef NS_ENUM(NSUInteger, REFRESH_CONTROL_TYPE) {
    REFRESH_CONTROL_LOADING_NEED_DRAGGING     = 0, /// 加载需要拖拽
    REFRESH_CONTROL_LOADING_NOT_NEED_DRAGGING = 1, /// 加载不需拖拽
};
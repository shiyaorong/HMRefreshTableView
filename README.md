# HMRefreshTableView
一个滚动视图的类目，实现类似MJRefresh的功能，支持tableView、colle
ctionView及其他scrollView子类视图,两行代码集成分页刷新加载功能，简单快捷，方便实用

    __weak __typeof(self) weakSelf = self;
    [self.tableView AddRefreshHeaderControlCompletion:^{
        /// 刷新操作
        [weakSelf refreshData];
    }];
    
    [self.tableView AddRefreshFooterControlCompletion:^{
        /// 加载操作
        [weakSelf loadData];
    }];

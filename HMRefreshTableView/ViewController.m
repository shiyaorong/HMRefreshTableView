//
//  ViewController.m
//  HMRefreshTableView
//
//  Created by mac on 16/1/15.
//  Copyright © 2016年 leiliang. All rights reserved.
//

#import "ViewController.h"
#import "HMRefresh.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.dataArray = [NSMutableArray array];
    for (int i = 0; i < 10; i ++) {
        [self.dataArray addObject:@(i)];
    }
    
    __weak __typeof(self) weakSelf = self;
    [self.tableView AddRefreshHeaderControlCompletion:^{
        [weakSelf refreshData];
    }];
    
    [self.tableView AddRefreshFooterControlCompletion:^{
        [weakSelf loadData];
    }];

    
//    [self.tableView AddRefreshFooterControlWithType:REFRESH_CONTROL_LOADING_NEED_DRAGGING Completion:^{
//        [weakSelf loadData];
//    }];
}

- (void)refreshData {
    NSLog(@"%s", __FUNCTION__);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.dataArray removeAllObjects];
        for (int i = 0; i < 10; i ++) {
            [self.dataArray addObject:@(i)];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.tableView refreshFinish];
        });
    });
}

- (void)loadData {
    NSLog(@"%s", __FUNCTION__);
    for (int i = 0; i < 10; i ++) {
        [self.dataArray addObject:@(i)];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView refreshFinish];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reUse"];
    cell.textLabel.text = [NSString stringWithFormat:@"%zd", indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *viewController = [storyborad instantiateViewControllerWithIdentifier:@"ViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

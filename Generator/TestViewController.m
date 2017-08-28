//
//  TestViewController.m
//
//  Created by Drinking on 24/08/2017.
//  Copyright (c) 2017 Drinking. All rights reserved.
//

#import "TestViewController.h"
#import <DKViewModel/DKTableViewModel.h>
#import <LJRefresh/LJRefresh.h>

@interface TestViewController () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) DKTableViewModel *tableViewModel;
@end

@implementation TestViewController {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableViewModel = [DKTableViewModel instanceWithRequestBlock:^(DKTableViewModel *instance,
                                                                   id <RACSubscriber> subscriber, NSInteger pageOffset) {
        //TODO replace real data request
        // page number: (1 + pageOffset/instance.perPage)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableArray *array = [@[] mutableCopy];
            for (int i = 0 ; i<instance.perPage; i++) {
                [array addObject:@(i+pageOffset)];
            }
            BOOL hasMore = pageOffset < 60;
            [subscriber sendNext:RACTuplePack(array, @(hasMore))];
        });
    }];
    _tableView = [UITableView new];
    _tableView.frame = self.view.bounds;
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self bindView:self.tableView withViewModel:self.tableViewModel];
    [self.tableView.mj_header beginRefreshing];
}

- (void)bindView:(UITableView *)tableView withViewModel:(DKTableViewModel *)viewModel {
    @weakify(self)
    [viewModel.statusChangedSignal subscribeNext:^(RACTuple *tuple) {
        @strongify(self)
        DKRequestStatus status = (DKRequestStatus) [tuple.first unsignedIntegerValue];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        switch (status) {
            case DKRNotStarted:
                break;
            case DKRDataLoaded:
                self.tableView.tableFooterView.frame = CGRectZero;
                [self.tableView reloadData];
                break;
            case DKRNoData:
                break;
            case DKRNoMoreData:
                [self.tableView reloadData];
                [self.tableView.mj_footer resetNoMoreData];
                break;
            case DKRError:
                break;
        }
    }];
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self.tableViewModel refresh];
//    }];
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [self.tableViewModel nextPage];
//    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableViewModel.listData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO replace with your own cells
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifier"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.tableViewModel.listData[indexPath.row]];
    return cell;
}

@end

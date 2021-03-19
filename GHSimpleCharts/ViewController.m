//
//  ViewController.m
//  GHSimpleCharts
//
//  Created by LGH on 2021/2/18.
//  Copyright © 2021 LGH. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+GHSimpleCharts.h"
#import "GHConfigs.h"
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (copy, nonatomic) NSArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.navigationItem.title = @"GHSimpleChartsDemo";
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.tableFooterView = UIView.new;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];

    CGRect rect = UIScreen.mainScreen.bounds;
    rect.origin.y = GHConfigs.frameStartTop + 44;
    rect.size.height -= rect.origin.y;
    tableView.frame = rect;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.dataArray[indexPath.row][@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = self.dataArray[indexPath.row];
    UIViewController *vc = [[NSClassFromString(dict[@"class"]) alloc] init];
    vc.navigationItem.title = dict[@"title"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[
            @{@"title": @"LineChartDemo", @"class": @"LineViewController"},
            @{@"title": @"BarChartDemo", @"class": @"BarViewController"},
            @{@"title": @"PieChartDemo", @"class": @"PieViewController"},
            @{@"title": @"RadarChartDemo", @"class": @"RadarViewController"},
            @{@"title": @"ProgressChartDemo", @"class": @"ProgressViewController"},
        ];
    }
    return _dataArray;
};

@end

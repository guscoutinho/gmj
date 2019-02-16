//
//  HomeViewController.m
//  gmj
//
//  Created by Gustavo  Coutinho on 2/16/19.
//  Copyright © 2019 Gustavo  Coutinho. All rights reserved.
//

#import "HomeViewController.h"
#import "CallTableViewCell.h"


@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewWillAppear:YES];
    [self tableViewSetup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableViewSetup {
    self.tableView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

//- (void)refreshControlSetup {
//    // initialization
//    self.refreshControl = [[UIRefreshControl alloc] init];
//
//    // Programagtic view of dragging and dropping in code
//    [self.refreshControl addTarget:self action:@selector(fetchUserActs) forControlEvents:UIControlEventValueChanged];
//
//    // Nests views into subviews
//    [self.tableView insertSubview:self.refreshControl atIndex:0];
//    [self.tableView sendSubviewToBack:self.refreshControl];
//}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    CallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CallTableViewCell"];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

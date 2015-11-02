//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpBusiness.h"
#import "BusinessCell.h"
#import "FiltersViewController.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate>

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Yelp";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessCell"
                                                         bundle:nil]
                   forCellReuseIdentifier:@"BusinessCell"];
    
    [self fetchBusinessesWithQuery:@"Restaurants" params:nil];
    
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self customizeLeftNavBarButtons];
}

- (void)customizeLeftNavBarButtons {
    UIBarButtonItem *barButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Filters"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(onFilterButton)];
    
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void) fetchBusinessesWithQuery:(NSString *) query params:(NSDictionary *)params {
    [YelpBusiness searchWithTerm:@"Restaurants"
                        params:params
                      completion:^(NSArray *businesses, NSError *error) {
                          
                          self.businesses = businesses;
                          
                          for (YelpBusiness *business in businesses) {
                              NSLog(@"%@", business);
                          }
                          
                          [self.tableView reloadData];
                      }];

}

# pragma mark - TableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

# pragma mark - TableView DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.businesses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"BusinessCell";
    BusinessCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.business = self.businesses[indexPath.row];
    
    return cell;
}

# pragma mark - Filters Delegate Methods

- (void) filtersViewController:(FiltersViewController *)filtersViewController didChangeFilters:(NSDictionary *)filters {
    // TODO save the filters here
    
    [self fetchBusinessesWithQuery:@"Restaurants" params:filters];
}

# pragma mark - Private Methods

- (void) onFilterButton {
    FiltersViewController *filterVC = [[FiltersViewController alloc] init];
    filterVC.delege = self;
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:filterVC];
    
    [self presentViewController:nvc animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

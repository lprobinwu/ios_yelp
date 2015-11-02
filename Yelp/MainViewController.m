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

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self customizeLeftNavBarButtons];
        [self customizeNavBarTitleView];
        
        self.title = @"Yelp";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessCell"
                                                         bundle:nil]
                   forCellReuseIdentifier:@"BusinessCell"];
    
    if (self.term == nil) {
        self.term = @"Restaurants";
    }
    
    [self fetchBusinessesWithQuery:self.term params:nil];
    
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)customizeLeftNavBarButtons {
    UIBarButtonItem *barButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Filters"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(onFilterButton)];
    
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)customizeNavBarTitleView {
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal | UISearchBarStyleDefault;
    
    for (UIView *subView in self.searchBar.subviews) {
        for (UIView *secondLevelSubview in subView.subviews) {
            if ([secondLevelSubview isKindOfClass:[UITextField class]]) {
                UITextField *searchBarTextField = (UITextField *)secondLevelSubview;
                
                //set font color here
                searchBarTextField.textColor = [UIColor whiteColor];
                
                break;
            }
        }
    }
}

- (void) fetchBusinessesWithQuery:(NSString *) query params:(NSDictionary *)params {
    [YelpBusiness searchWithTerm:query
                        params:params
                      completion:^(NSArray *businesses, NSError *error) {
                          
                          self.businesses = businesses;
                          
                          for (YelpBusiness *business in businesses) {
                              NSLog(@"%@", business);
                          }
                          
                          [self.tableView reloadData];
                      }];

}

# pragma mark - UISearchBar Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"searchBarSearchButtonClicked %@", searchBar.text);
    
    self.term = searchBar.text;
    
    [searchBar resignFirstResponder];
    
    [self fetchBusinessesWithQuery:self.term params:self.filters];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    CGRect r=self.view.frame;
    r.origin.y=-44;
    r.size.height+=44;
    
    self.view.frame=r;
    
    [searchBar setShowsCancelButton:YES animated:YES];
}


-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
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
    self.filters = filters;
    
    [self fetchBusinessesWithQuery:self.term params:filters];
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

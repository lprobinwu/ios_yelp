//
//  FilterViewController.h
//  Yelp
//
//  Created by Robin Wu on 10/31/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FiltersViewController;

@protocol FiltersViewControllerDelegate <NSObject>

- (void) filtersViewController: (FiltersViewController *)filtersViewController
              didChangeFilters: (NSDictionary *) filters;

@end

@interface FiltersViewController : UIViewController

@property (nonatomic, weak) id<FiltersViewControllerDelegate> delege;

@property (nonatomic, readonly) NSDictionary *filters;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic, strong) NSArray *categories;

@property(nonatomic, strong) NSArray *distances;

@property(nonatomic, strong) NSArray *sortings;

@property(nonatomic, strong) NSIndexPath *lastSelectedDistance;

@property(nonatomic, strong) NSIndexPath *lastSelectedSorting;

@end

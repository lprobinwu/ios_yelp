//
//  MainViewController.h
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *businesses;

@property (nonatomic, strong) NSDictionary *filters;

@property (nonatomic, strong) NSString *term;

- (void) fetchBusinessesWithQuery:(NSString *) query params:(NSDictionary *)params;

@end
